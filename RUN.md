# FrontEnd 실행 방법

## 사전 준비사항

1. **Flutter 설치 확인**
   ```bash
   flutter --version
   ```

2. **Flutter 설치 (미설치 시)**
   ```bash
   # Homebrew 사용 (권장)
   brew install --cask flutter
   
   # 또는 공식 사이트에서 다운로드
   # https://flutter.dev/docs/get-started/install/macos
   ```

3. **Flutter Doctor 실행 (환경 확인)**
   ```bash
   flutter doctor
   ```
   - 필요한 도구들이 설치되어 있는지 확인합니다.

## 실행 방법

### 1. 의존성 설치
```bash
cd FrontEnd
flutter pub get
```

### 2. 앱 실행

#### iOS 시뮬레이터에서 실행 (macOS)
```bash
flutter run
```
또는
```bash
flutter run -d ios
```

#### Android 에뮬레이터에서 실행
```bash
flutter run -d android
```

#### 웹 브라우저에서 실행
```bash
flutter run -d chrome
```

#### macOS 데스크톱 앱으로 실행
```bash
flutter run -d macos
```

### 3. 사용 가능한 디바이스 확인
```bash
flutter devices
```

## 추가 명령어

### 핫 리로드
- 앱 실행 중 `r` 키를 누르면 핫 리로드
- `R` 키를 누르면 핫 리스타트

### 빌드
```bash
# iOS 빌드
flutter build ios

# Android 빌드
flutter build apk

# 웹 빌드
flutter build web

# macOS 빌드
flutter build macos
```

## 문제 해결

### Flutter가 설치되지 않은 경우
1. Homebrew가 설치되어 있는지 확인: `brew --version`
2. Homebrew가 없다면 설치: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Flutter 설치: `brew install --cask flutter`

### 의존성 문제가 있는 경우
```bash
flutter clean
flutter pub get
```

### iOS 시뮬레이터가 없는 경우
```bash
open -a Simulator
```

### Android 에뮬레이터가 없는 경우
Android Studio를 설치하고 AVD Manager에서 에뮬레이터를 생성해야 합니다.
