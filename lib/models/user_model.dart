class User {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String profileImage;
  final DateTime joinDate;
  final DateTime lastActive;
  final String avatarUrl;
  final List<String> favoriteCategories;
  final List<String> bookmarkedArticles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.joinDate,
    required this.lastActive,
    required this.avatarUrl,
    required this.favoriteCategories,
    required this.bookmarkedArticles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? 'https://via.placeholder.com/150',
      joinDate: DateTime.parse(json['joinDate']),
      lastActive: DateTime.parse(json['lastActive']),
      avatarUrl: json['avatarUrl'] ?? '',
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      bookmarkedArticles: List<String>.from(json['bookmarkedArticles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'joinDate': joinDate.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'avatarUrl': avatarUrl,
      'favoriteCategories': favoriteCategories,
      'bookmarkedArticles': bookmarkedArticles,
    };
  }

  // 샘플 사용자 데이터 - API 연동 전 테스트용
  static User get sampleUser => User(
        id: 'user123',
        name: '홍길동',
        email: 'user@example.com',
        bio: '안녕하세요! 홍길동입니다.',
        profileImage: 'https://source.unsplash.com/random/200x200/?person',
        joinDate: DateTime.now().subtract(const Duration(days: 180)),
        lastActive: DateTime.now(),
        avatarUrl: 'https://source.unsplash.com/random/200x200/?person',
        favoriteCategories: ['기술', '과학', '경제'],
        bookmarkedArticles: ['news1', 'news2', 'news3'],
      );
} 