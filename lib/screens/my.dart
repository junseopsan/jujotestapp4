import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';
import 'package:animations/animations.dart';
import '../widgets/skeleton_loading.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  User? _user;
  List<NewsArticle> _bookmarkedArticles = [];
  bool _isLoading = true;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // 사용자 정보 로드
      final user = await _apiService.getUserProfile();
      
      // 북마크된 뉴스 로드
      final bookmarkedNews = await Future.wait(
        user.bookmarkedArticles.map((id) => _apiService.getNewsArticle(id)),
      ).then((articles) => articles.cast<NewsArticle>());
      
      if (mounted) {
        setState(() {
          _user = user;
          _bookmarkedArticles = bookmarkedNews;
          _isLoading = false;
          
          // 컨트롤러 초기화
          _nameController.text = user.name;
          _emailController.text = user.email;
          _bioController.text = user.bio;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('사용자 정보를 불러오는 중 오류가 발생했습니다.');
      }
    }
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = User(
        id: _user!.id,
        name: _nameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        profileImage: _user!.profileImage,
        joinDate: _user!.joinDate,
        lastActive: DateTime.now(),
        avatarUrl: _user!.avatarUrl,
        favoriteCategories: _user!.favoriteCategories,
        bookmarkedArticles: _user!.bookmarkedArticles,
      );

      await _apiService.updateUserProfile(updatedUser);
      
      if (mounted) {
        setState(() {
          _user = updatedUser;
          _isLoading = false;
          _isEditMode = false;
        });
        _showSuccessSnackBar('프로필이 성공적으로 업데이트되었습니다.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('프로필 업데이트 중 오류가 발생했습니다.');
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '프로필'),
            Tab(text: '북마크'),
          ],
        ),
        actions: [
          if (!_isLoading && _user != null && !_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: '프로필 편집',
              onPressed: _toggleEditMode,
            ),
          if (!_isLoading && _user != null && _isEditMode)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: '편집 취소',
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _user == null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _isEditMode
                        ? _buildEditForm()
                        : _buildProfileTab(),
                    _buildBookmarksTab(),
                  ],
                ),
      floatingActionButton: !_isLoading && _user != null && _isEditMode
          ? FloatingActionButton(
              onPressed: _updateUserData,
              tooltip: '변경사항 저장',
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'profile_image',
                  child: Material(
                    color: Colors.transparent,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.5 + (0.5 * value),
                          child: child,
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(_user!.profileImage),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _user!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '자기소개',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user!.bio,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        icon: Icons.calendar_today,
                        title: '가입일',
                        value: _formatDate(_user!.joinDate),
                      ),
                      _buildInfoItem(
                        icon: Icons.access_time,
                        title: '최근 활동',
                        value: _formatDate(_user!.lastActive),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '관심 카테고리',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildActivitySection(),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '활동 내역',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              icon: Icons.article,
              title: '저장한 뉴스',
              value: '${_user!.bookmarkedArticles.length}개',
              onTap: () {
                _tabController.animateTo(1);
              },
            ),
            const Divider(),
            _buildActivityItem(
              icon: Icons.location_on,
              title: '관심 지역',
              value: '3개',
              onTap: () {
                // 관심 지역 화면으로 이동
              },
            ),
            const Divider(),
            _buildActivityItem(
              icon: Icons.notifications,
              title: '알림 설정',
              value: '켜짐',
              onTap: () {
                // 알림 설정 화면으로 이동
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const Center(
          child: Text('준비 중입니다.'),
        ),
      ),
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(),
      closedColor: Colors.transparent,
      closedBuilder: (context, openContainer) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: title == '저장한 뉴스' ? onTap : openContainer,
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
              '저장한 뉴스가 없습니다.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // 뉴스 화면으로 이동
              },
              icon: const Icon(Icons.article),
              label: const Text('뉴스 보러가기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _bookmarkedArticles.length,
      itemBuilder: (context, index) {
        final article = _bookmarkedArticles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: NewsCard(
            article: article,
            onTap: () {
              // 뉴스 상세 화면으로 이동
            },
          ),
        );
      },
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(_user!.profileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // 이미지 변경 기능 (미구현)
                          _showErrorSnackBar('이미지 변경 기능은 아직 구현되지 않았습니다.');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요.';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return '유효한 이메일 주소를 입력해주세요.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: '자기소개',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '자기소개를 입력해주세요.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: ProfileSkeleton(),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLoading(
                    width: 100,
                    height: 24,
                  ),
                  const SizedBox(height: 16),
                  const SkeletonLoading(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  const SkeletonLoading(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  const SkeletonLoading(
                    width: 200,
                    height: 16,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLoading(
                            width: 80,
                            height: 16,
                          ),
                          const SizedBox(height: 8),
                          const SkeletonLoading(
                            width: 120,
                            height: 20,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLoading(
                            width: 80,
                            height: 16,
                          ),
                          const SizedBox(height: 8),
                          const SkeletonLoading(
                            width: 120,
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLoading(
                    width: 100,
                    height: 24,
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const SkeletonLoading(
                          width: 24,
                          height: 24,
                          borderRadius: 12,
                        ),
                        title: const SkeletonLoading(
                          width: 120,
                          height: 16,
                        ),
                        trailing: const SkeletonLoading(
                          width: 60,
                          height: 16,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
            '프로필 정보를 불러올 수 없습니다.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadUserData,
            icon: const Icon(Icons.refresh),
            label: const Text('새로고침'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 날짜 포맷
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
} 