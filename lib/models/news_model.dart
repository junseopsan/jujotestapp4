class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final String category;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : DateTime.now(),
      category: json['category'] ?? '',
    );
  }

  // 샘플 데이터 생성 메서드 - API 연동 전 테스트용
  static List<NewsArticle> getSampleNews() {
    return [
      NewsArticle(
        id: '1',
        title: '플러터 3.0 출시, 웹 및 데스크톱 안정화 버전 포함',
        summary: '구글이 플러터 3.0을 정식 출시했습니다. 이번 버전에서는 웹과 데스크톱 지원이 안정화 단계에 접어들었습니다.',
        content: '구글이 플러터 3.0을 정식 출시했습니다. 이번 버전에서는 웹과 데스크톱 지원이 안정화 단계에 접어들었으며, 메테리얼 디자인 3이 기본 지원됩니다. 또한 캐스케이딩 메뉴, 검색 바와 같은 새로운 위젯이 추가되었습니다.',
        imageUrl: 'https://source.unsplash.com/random/800x600/?flutter',
        author: '구글 개발자 팀',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: '기술',
      ),
      NewsArticle(
        id: '2',
        title: '인공지능, 의료 분야 혁신 이끌어',
        summary: '인공지능 기술이 의료 진단 정확도를 높이고 새로운 치료법 개발에 기여하고 있습니다.',
        content: '최근 발표된 연구에 따르면, 딥러닝 기반 인공지능이 의료 영상 분석에서 전문의와 동등한 수준의 정확도를 보여주고 있습니다. 특히 X-레이, MRI, CT 스캔 등에서 종양이나 질병을 식별하는 능력이 크게 향상되었으며, 이를 통해 조기 진단율이 높아지고 있습니다.',
        imageUrl: 'https://source.unsplash.com/random/800x600/?ai,medical',
        author: '의학저널',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: '의학',
      ),
      NewsArticle(
        id: '3',
        title: '기후 변화, 해수면 상승 가속화',
        summary: '최근 연구에 따르면 극지방 빙하 용해로 인한 해수면 상승이 예상보다 빠르게 진행되고 있습니다.',
        content: '과학자들에 따르면 남극과 그린란드의 빙하가 예상보다 빠르게 녹고 있으며, 이로 인해 해수면 상승 속도가 가속화되고 있습니다. 이대로라면 2100년까지 해수면이 1미터 이상 상승할 수 있다는 전망입니다. 연안 도시들은 이에 대비한 적응 계획을 서둘러 마련해야 합니다.',
        imageUrl: 'https://source.unsplash.com/random/800x600/?climate,ice',
        author: '기후과학연구소',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: '환경',
      ),
      NewsArticle(
        id: '4',
        title: '양자 컴퓨팅, 상용화 한 걸음 더 가까이',
        summary: '새로운 양자 프로세서 개발로 양자 컴퓨팅 상용화가 앞당겨질 전망입니다.',
        content: '연구진이 상온에서도 안정적으로 작동하는 새로운 양자 프로세서를 개발했습니다. 이전 모델들이 극저온 환경에서만 작동했던 것에 비해 큰 진전입니다. 이번 발전으로 금융, 물류, 신약 개발 등 다양한 분야에서 양자 컴퓨팅 활용이 빨라질 것으로 기대됩니다.',
        imageUrl: 'https://source.unsplash.com/random/800x600/?quantum,computer',
        author: '퀀텀테크',
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        category: '과학',
      ),
      NewsArticle(
        id: '5',
        title: '세계 경제, 디지털 전환 가속화',
        summary: '코로나19 이후 디지털 경제로의 전환이 가속화되며 새로운 비즈니스 모델이 부상하고 있습니다.',
        content: '팬데믹 이후 온라인 쇼핑, 원격 근무, 디지털 금융 서비스 등이 크게 성장했습니다. 이러한 변화는 단순한 일시적 현상이 아닌 구조적 전환으로 자리잡고 있으며, 기업들은 디지털 역량 강화에 대규모 투자를 진행하고 있습니다.',
        imageUrl: 'https://source.unsplash.com/random/800x600/?digital,economy',
        author: '글로벌경제연구소',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: '경제',
      ),
    ];
  }
} 