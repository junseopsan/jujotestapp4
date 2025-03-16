import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  User? _user;
  List<NewsArticle> _bookmarkedArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 사용자 정보 로드
      final user = await _apiService.getUserInfo('user123');
      
      // 북마크된 뉴스 로드
      final allNews = await _apiService.getNews();
      final bookmarkedNews = allNews
          .where((article) => user.bookmarkedArticles.contains(article.id))
          .toList();
      
      setState(() {
        _user = user;
        _bookmarkedArticles = bookmarkedNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('사용자 정보를 불러오는 중 오류가 발생했습니다.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '프로필'),
            Tab(text: '북마크'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(),
                    _buildBookmarksTab(),
                  ],
                ),
    );
  }

  Widget _buildProfileTab() {
    if (_user == null) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 프로필 헤더
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(_user!.avatarUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  _user!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _user!.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 관심 카테고리
          _buildSection(
            title: '관심 카테고리',
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _user!.favoriteCategories.map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 알림 설정
          _buildSection(
            title: '알림 설정',
            child: Column(
              children: [
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: '뉴스 알림',
                  subtitle: '새로운 뉴스가 등록되면 알림을 받습니다.',
                  value: true,
                  onChanged: (value) {},
                ),
                const Divider(),
                _buildSettingItem(
                  icon: Icons.wb_sunny,
                  title: '날씨 알림',
                  subtitle: '날씨 변화가 있을 때 알림을 받습니다.',
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 앱 정보
          _buildSection(
            title: '앱 정보',
            child: Column(
              children: [
                _buildInfoItem(
                  icon: Icons.info,
                  title: '버전',
                  value: '1.0.0',
                ),
                const Divider(),
                _buildInfoItem(
                  icon: Icons.security,
                  title: '개인정보 처리방침',
                  value: '',
                  isNavigable: true,
                ),
                const Divider(),
                _buildInfoItem(
                  icon: Icons.description,
                  title: '이용약관',
                  value: '',
                  isNavigable: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: 로그아웃 기능 구현
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃 되었습니다.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('로그아웃'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksTab() {
    if (_bookmarkedArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              '저장된 뉴스가 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '관심있는 뉴스를 북마크해보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _bookmarkedArticles.length,
      itemBuilder: (context, index) {
        return NewsCard(
          article: _bookmarkedArticles[index],
          onTap: () {
            // TODO: 뉴스 상세 화면으로 이동
          },
        );
      },
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    bool isNavigable = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: isNavigable
          ? const Icon(Icons.chevron_right)
          : Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
      onTap: isNavigable
          ? () {
              // TODO: 해당 페이지로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title 페이지로 이동합니다.')),
              );
            }
          : null,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            '사용자 정보를 불러올 수 없습니다.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserData,
            child: const Text('새로고침'),
          ),
        ],
      ),
    );
  }
} 