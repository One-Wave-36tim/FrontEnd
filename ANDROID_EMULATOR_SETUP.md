# Android 에뮬레이터 설정 가이드 - Pixel 8a

## 방법 1: Android Studio GUI 사용 (가장 쉬움)

### 1. Android Studio 실행
```bash
open -a "Android Studio"
```

### 2. Device Manager 열기
- 상단 메뉴: **Tools** → **Device Manager**
- 또는 오른쪽 사이드바의 **Device Manager** 탭 클릭

### 3. 새 디바이스 생성
1. **Create Device** 버튼 클릭
2. **Phone** 카테고리 선택
3. **Pixel 8a** 선택 (없으면 **Pixel 7a** 또는 **Pixel 6a** 선택 후 나중에 Edit 가능)
4. **Next** 클릭

### 4. 시스템 이미지 다운로드
1. **Release Name**에서 원하는 Android 버전 선택 (예: **Android 14 (API 34)**)
2. **ABI**는 **arm64-v8a** 선택 (Apple Silicon Mac용)
3. 시스템 이미지가 없다면 **Download** 버튼 클릭하여 다운로드
4. 다운로드 완료 후 **Next** 클릭

### 5. 에뮬레이터 설정 확인
- **AVD Name**: 원하는 이름 설정 (예: `Pixel_8a_API_34`)
- **Startup orientation**: Portrait 또는 Landscape 선택
- **Finish** 클릭

### 6. 에뮬레이터 실행
- Device Manager에서 생성된 에뮬레이터 옆의 **▶️** 버튼 클릭

## 방법 2: 명령줄 사용 (고급)

### 1. Command Line Tools 설치 확인
```bash
# cmdline-tools가 없다면 Android Studio에서 설치 필요
# Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK
# → SDK Tools 탭 → Android SDK Command-line Tools (latest) 체크 → Apply
```

### 2. 시스템 이미지 목록 확인
```bash
$HOME/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager --list | grep "system-images"
```

### 3. Pixel 8a용 시스템 이미지 설치
```bash
# Android 14 (API 34) arm64-v8a 예시
$HOME/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager "system-images;android-34;google_apis;arm64-v8a"
```

### 4. AVD 생성
```bash
# avdmanager를 사용하여 에뮬레이터 생성
$HOME/Library/Android/sdk/cmdline-tools/latest/bin/avdmanager create avd \
  -n Pixel_8a_API_34 \
  -k "system-images;android-34;google_apis;arm64-v8a" \
  -d "pixel_8a"
```

### 5. 에뮬레이터 실행
```bash
$HOME/Library/Android/sdk/emulator/emulator -avd Pixel_8a_API_34
```

## 방법 3: Flutter에서 직접 확인

### 사용 가능한 에뮬레이터 확인
```bash
flutter emulators
```

### 특정 에뮬레이터 실행
```bash
flutter emulators --launch <emulator_id>
```

## Pixel 8a 사양 정보
- 화면 크기: 6.1인치
- 해상도: 1080 x 2400 (FHD+)
- DPI: 420
- RAM: 8GB (에뮬레이터에서는 설정 가능)

## 문제 해결

### 시스템 이미지가 다운로드되지 않는 경우
1. Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK
2. SDK Platforms 탭에서 필요한 API 레벨 체크
3. SDK Tools 탭에서 필요한 도구들 체크
4. Apply 클릭하여 다운로드

### 에뮬레이터가 느린 경우
- AVD 설정에서 Graphics를 **Hardware - GLES 2.0**으로 변경
- RAM 크기 조정 (권장: 2048MB 이상)
- VM heap 크기 조정 (권장: 512MB)

### Apple Silicon Mac에서 x86 이미지가 필요한 경우
- Rosetta 2를 통해 실행 가능하지만 느릴 수 있음
- 가능하면 **arm64-v8a** 이미지 사용 권장
