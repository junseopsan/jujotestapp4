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
## Phase 1: 기본 구조 설정
- [x] 프로젝트 초기 설정 및 구조 검토
- [ ] 필요한 디렉토리 구조 생성 (screens, widgets, services, models)
- [ ] 필요한 패키지 추가 (http, cached_network_image 등)
- [ ] 메인 앱 구조 및 네비게이션 설정

## Phase 2: 핵심 기능 구현
- [ ] 뉴스 피드 화면 구현
- [ ] 날씨 화면 구현
- [ ] MY 프로필 화면 구현
- [ ] 검색 기능 구현

## Phase 3: API 연동 및 데이터 관리
- [ ] Unsplash API 서비스 구현
- [ ] 뉴스 데이터 모델 정의
- [ ] 날씨 데이터 모델 정의

## Phase 4: UI 개선 및 최적화
- [ ] 성능 최적화
- [ ] UI/UX 개선
- [ ] 에러 처리 및 로딩 상태 관리

---

# Current Progress (현재 진행 상황)
현재 프로젝트 구조를 검토하고 구현 계획을 세웠습니다. 이제 기본 디렉토리 구조를 생성하고 필요한 패키지를 추가하겠습니다.

최종 목표:
- 뉴스, 날씨, MY 탭이 있는 직관적인 뉴스 앱 구현
- Unsplash API를 활용한 뉴스 이미지 제공
- 사용자 친화적인 UI/UX 제공

다음 단계:
- 필요한 디렉토리 구조 생성
- 필요한 패키지 추가
- 메인 앱 구조 및 네비게이션 설정