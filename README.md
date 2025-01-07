# 스마트 냉장고 관리 앱 (iOS/Android)

## 프로젝트 구조
```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart      # 앱 전체 테마 및 반응형 디자인 시스템
│   │   ├── app_colors.dart     # 공통 색상 정의
│   │   ├── app_typography.dart # 플랫폼별 타이포그래피
│   │   └── app_spacing.dart    # 공통 간격 정의
│   └── utils/
│       ├── platform_check.dart # 플랫폼 체크 유틸리티
│       └── image_storage_util.dart # 이미지 저장 유틸리티
├── features/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   └── domain/
│   │       └── models/
│   ├── shopping/
│   ├── product_register/
│   ├── recipe/
│   └── product_info/
├── shared/
│   └── widgets/
│       ├── navigation/
│       │   ├── bottom_nav_bar.dart
│       │   └── nav_bar_item.dart
│       └── common/
└── main.dart
```

## 디자인 시스템

### 1. 반응형 디자인
- 기준 디바이스: iPhone 8 (375pt)
- 반응형 계산식: (현재화면너비 / 375) * 기준값
```dart
// 사용 예시
double radius = Adaptive.radius(context); // 자동으로 화면 크기에 맞는 radius 계산
```

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
4. 상품 관리 기능
   - 상품 등록/수정/삭제
   - 이미지 첨부 및 저장
   - 카테고리 분류
   - 유통기한 관리
5. 로컬 데이터 저장
   - Hive를 사용한 영구 저장소
   - 이미지 파일 로컬 저장
6. 스플래시 스크린
   - 앱 시작 시 로딩 화면

## 사용된 주요 패키지
```yaml
dependencies:
  provider: ^6.1.1        # 상태 관리
  hive: ^2.2.3           # 로컬 데이터베이스
  hive_flutter: ^1.1.0   # Hive Flutter 통합
  image_picker: ^1.0.7   # 이미지 선택
  path_provider: ^2.1.2  # 파일 경로 관리
  flutter_native_splash: ^2.3.13  # 스플래시 스크린
```

## 설치 및 실행 방법
1. Flutter 설치 및 환경 설정
2. 프로젝트 클론
   ```bash
   git clone [repository-url]
   ```
3. 의존성 패키지 설치
   ```bash
   flutter pub get
   ```
4. Hive 모델 생성
   ```bash
   flutter pub run build_runner build
   ```
5. 스플래시 스크린 생성
   ```bash
   flutter pub run flutter_native_splash:create
   ```
6. 앱 실행
   ```bash
   flutter run
   ```

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

### 4. 이미지 저장 가이드라인
- 이미지는 앱의 Documents 디렉토리 내 저장
- 상대 경로 사용 (iOS 샌드박스 정책 대응)
- ImageStorageUtil 클래스 사용

## 개발 모드 안내
- Debug 모드: 개발용, Hot Reload 지원
  - Hot Reload (코드 수정 즉시 반영): ⌘+S (Mac) / Ctrl+S (Windows)
  - Hot Restart (앱 재시작): ⌘+Shift+S (Mac) / Ctrl+Shift+S (Windows)
- Profile 모드: 성능 테스트용
- Release 모드: 배포용

## 주의사항
- Hot Reload 시 const 생성자 관련 이슈 발생 가능
  - 해결: Hot Restart 실행
  - VSCode: Ctrl/Cmd + F5
  - Android Studio: Shift + F10 (Win) / Control + R (Mac)
- iOS 빌드 시 이미지 경로 관련 주의
  - 상대 경로 사용 필요
  - 앱 Documents 디렉토리 활용
- Hive 데이터베이스 사용 시
  - 모델 변경 후 build_runner 실행 필요
  - 앱 재설치 시 데이터 초기화됨

## 다음 단계
1. 각 탭별 페이지 구현
2. 상태 관리 시스템 도입 ✅
3. API 연동
4. 테스트 코드 작성
5. 사용자 설정 기능 추가
6. 알림 시스템 구현
7. 데이터 백업/복원 기능