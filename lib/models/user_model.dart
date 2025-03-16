class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final List<String> favoriteCategories;
  final List<String> bookmarkedArticles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.favoriteCategories,
    required this.bookmarkedArticles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      bookmarkedArticles: List<String>.from(json['bookmarkedArticles'] ?? []),
    );
  }

  // 샘플 사용자 데이터 - API 연동 전 테스트용
  static User getSampleUser() {
    return User(
      id: 'user123',
      name: '홍길동',
      email: 'user@example.com',
      avatarUrl: 'https://source.unsplash.com/random/200x200/?person',
      favoriteCategories: ['기술', '과학', '경제'],
      bookmarkedArticles: ['1', '3', '4'],
    );
  }
} 