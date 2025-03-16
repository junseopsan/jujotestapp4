# Project Overview (프로젝트 개요)
이 프로젝트는 홈 피드 중심의 뉴스 앱의 프론트엔드 개발을 목표로 합니다.
Flutter를 활용하여 뉴스, 날씨, MY 탭이 포함된 직관적인 UI를 구축하며, Unsplash API를 활용하여 뉴스 관련 이미지를 제공합니다.

---

# Feature Requirements (기능 요구사항)

## 1. 홈 피드
- 최신 뉴스 및 관심사 콘텐츠 피드 제공
- Unsplash API를 활용한 뉴스 이미지 표시
- 스크롤 가능한 리스트 UI 구현
- 각 뉴스 카드는 이미지 + 제목 + 요약 정보 포함

## 2. 검색창
- 상단 고정형 검색창 배치
- 검색창 클릭 시 검색 UI 활성화
- 입력된 키워드에 따라 뉴스 필터링

## 3. 탭 메뉴 (뉴스, 날씨, MY)
- 하단 네비게이션 바 추가
- 각 탭에 해당하는 아이콘 적용
- `뉴스`: 뉴스 리스트 화면
- `날씨`: 실시간 날씨 정보 표시
- `MY`: 사용자 맞춤형 콘텐츠 제공

---

# Relevant Codes (관련 코드)

### 1. 메인 화면 (main.dart)
```dart
void main() {
  runApp(MyApp());
}
```

### 2. 홈 피드 (home_feed.dart)
```dart
class HomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Feed')),
      body: NewsList(),
    );
  }
}
```

### 3. 탭 네비게이션 (bottom_nav.dart)
```dart
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.article), label: '뉴스'),
        BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: '날씨'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
      ],
    );
  }
}
```

---

# Current File Instruction (현재 파일 구조)
```plaintext
/project-root
│── lib/
│   ├── main.dart          # 앱 진입점
│   ├── screens/
│   │   ├── home_feed.dart  # 홈 피드 화면
│   │   ├── search.dart     # 검색 UI
│   │   ├── news.dart       # 뉴스 탭 화면
│   │   ├── weather.dart    # 날씨 탭 화면
│   │   ├── my.dart         # MY 탭 화면
│   │   ├── home_feed.dart  # 홈 피드 화면
│   │   ├── search.dart     # 검색 UI
│   │   ├── news.dart       # 뉴스 탭 화면
│   │   ├── weather.dart    # 날씨 탭 화면
│   │   ├── my.dart         # MY 탭 화면
│   │   ├── home_feed.dart  # 홈 피드 화면
│   │   ├── search.dart     # 검색 UI
│   │   ├── news.dart       # 뉴스 탭 화면
│   │   ├── weather.dart    # 날씨 탭 화면
│   │   ├── my.dart         # MY 탭 화면
│   │   ├── home_feed.dart  # 홈 피드 화면
│   │   ├── search.dart     # 검색 UI
│   │   ├── news.dart       # 뉴스 탭 화면
│   │   ├── weather.dart    # 날씨 탭 화면
│   │   ├── my.dart         # MY 탭 화면
│   ├── widgets/
│   │   ├── bottom_nav.dart # 하단 탭 UI
│   │   ├── search_bar.dart # 검색창 UI
│   ├── services/
│   │   ├── api_service.dart # API 호출 관련 코드
│── assets/
│   ├── images/            # 로컬 이미지 저장 폴더
│── pubspec.yaml           # 프로젝트 설정 및 패키지 관리
```

---

# Rules (규칙)
- 코드 스타일: Dart의 `Effective Dart` 스타일 가이드 준수
- UI 구조: `StatelessWidget` & `StatefulWidget` 적절하게 활용
- API 호출: `Dio` 또는 `http` 패키지 사용
- 에러 핸들링: API 요청 시 `try-catch` 문을 활용한 예외 처리
- 버전 관리: `Git`을 활용한 브랜치 관리 (feature, develop, main 브랜치 운영)

---

# Implementation Plan (구현 계획)
## 플러터 뉴스 앱 구현 계획

### 1단계: 프로젝트 구조 설정
- [x] Flutter 프로젝트 생성
- [x] 필요한 패키지 추가 (http, provider, cached_network_image 등)
- [x] 기본 디렉토리 구조 설정 (models, screens, widgets, services)

### 2단계: 핵심 기능 구현
- [x] 모델 클래스 구현 (뉴스, 날씨, 사용자)
- [x] API 서비스 구현 (뉴스, 날씨, 사용자 정보 가져오기)
- [x] 뉴스 피드 화면 구현
- [x] 날씨 화면 구현
- [x] MY 프로필 화면 구현
- [x] 메인 앱 구조 및 네비게이션 설정

### 3단계: 성능 최적화 및 UI/UX 개선
- [x] 이미지 캐싱 및 최적화
- [x] 다크 모드 지원
- [x] 스켈레톤 로딩 화면 구현
- [x] 애니메이션 및 전환 효과 추가
- [x] 오류 처리 및 사용자 피드백 개선

### 4단계: 테스트 및 배포 준비
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 작성
- [ ] 성능 테스트 및 최적화
- [ ] 릴리스 준비 (앱 아이콘, 스플래시 화면 등)

## 현재 진행 상황

앱의 기본 기능이 모두 구현되었으며, 성능 최적화 및 UI/UX 개선 작업이 완료되었습니다.

### 완료된 작업:
1. 프로젝트 구조 설정 및 필요한 패키지 추가
2. 모델 클래스 및 API 서비스 구현
3. 뉴스 피드, 날씨, MY 프로필 화면 구현
4. 메인 앱 구조 및 네비게이션 설정
5. 다크 모드 지원 및 테마 관리 구현
6. 스켈레톤 로딩 화면 구현으로 로딩 경험 개선
7. 애니메이션 및 전환 효과 추가로 사용자 경험 향상
8. 오류 처리 및 사용자 피드백 개선

### 다음 단계:
1. 단위 테스트 및 통합 테스트 작성
2. 성능 테스트 및 추가 최적화
3. 릴리스 준비 (앱 아이콘, 스플래시 화면 등)

## 기술 스택
- Flutter 및 Dart
- Provider 패턴을 사용한 상태 관리
- HTTP 패키지를 사용한 API 통신
- 캐싱 및 이미지 최적화
- 애니메이션 및 전환 효과