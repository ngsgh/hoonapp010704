# 스마트 냉장고 관리 앱 (iOS/Android)

lib/
├── core/
│ ├── theme/
│ │ ├── app_theme.dart # 앱 전체 테마 및 반응형 디자인 시스템
│ │ ├── app_colors.dart # 공통 색상 정의
│ │ ├── app_typography.dart # 플랫폼별 타이포그래피
│ │ └── app_spacing.dart # 공통 간격 정의
│ └── constants/
│ └── platform_check.dart # 플랫폼 체크 유틸리티
├── features/
│ ├── home/
│ │ ├── presentation/
│ │ │ ├── pages/
│ │ │ └── widgets/
│ │ └── domain/
│ ├── shopping/
│ ├── product_register/
│ ├── recipe/
│ └── product_info/
├── shared/
│ └── widgets/
│ ├── navigation/
│ │ ├── bottom_nav_bar.dart
│ │ └── nav_bar_item.dart
│ └── common/
└── main.dart
## 프로젝트 구조

## 디자인 시스템

### 1. 반응형 디자인
- 기준 디바이스: iPhone 8 (375pt)
- 반응형 계산식: (현재화면너비 / 375) * 기준값

dart
// 사용 예시
double radius = Adaptive.radius(context); // 자동으로 화면 크기에 맞는 radius 계산

### 2. 네비게이션 바 스펙
```dart
// 색상
borderColor: Color(0xFFF2F2F2)     // 상단 테두리
activeIconColor: Color(0xFF7E8186)  // 활성화된 아이콘
inactiveIconColor: Color(0xFFD4D7DC)// 비활성화된 아이콘
activeTextColor: Color(0xFF7E8186)  // 활성화된 텍스트
inactiveTextColor: Color(0xFFD4D7DC)// 비활성화된 텍스트

// 크기
borderWidth: 0.5                    // 테두리 두께
iconSize: 24.0                      // 아이콘 크기
textSize: 12.0                      // 텍스트 크기
itemSpacing: 4.0                    // 아이콘과 텍스트 사이 간격
```

### 3. 반응형 radius 적용
- 상단 모서리 radius: 화면 너비의 5.3% (20pt @ 375pt)
```dart
// 사용 예시
borderRadius: BorderRadius.only(
  topLeft: Radius.circular(Adaptive.radius(context)),
  topRight: Radius.circular(Adaptive.radius(context)),
)
```

## 구현된 기능
1. 크로스 플랫폼 대응 (iOS/Android)
2. 반응형 디자인 시스템
3. 하단 네비게이션 바
   - 5개 탭 (홈, 쇼핑, 등록, 레시피, 상품정보)
   - 플랫폼별 네이티브 느낌 유지
   - 심플한 디자인과 인터랙션

## 개발 가이드라인

### 1. 테마 시스템 사용
```dart
// 색상 사용
color: AppNavigationBarTheme.activeIconColor

// 반응형 값 사용
radius: Adaptive.radius(context)
```

### 2. 위젯 모듈화
- 재사용 가능한 위젯은 shared/widgets 폴더에 배치
- 특정 기능에 종속된 위젯은 해당 feature 폴더 내 위치

### 3. 파일 구조
- 기능별로 features 폴더 내 구분
- 공통 요소는 core 또는 shared 폴더에 배치
- presentation/domain/data 레이어 분리

## 다음 단계
1. 각 탭별 페이지 구현
2. 상태 관리 시스템 도입
3. API 연동
4. 테스트 코드 작성

## 주의사항
- Hot Reload 시 const 생성자 관련 이슈 발생 가능
  - 해결: Hot Restart 실행
  - VSCode: Ctrl/Cmd + F5
  - Android Studio: Shift + F10 (Win) / Control + R (Mac)