#!/bin/bash

# 에러 발생 시 즉시 중단
set -e

echo -e "🚀 Onboarding Start\n"

# 0. 실행 경로 고정 (프로젝트 루트)
cd "$(dirname "$0")/.."

# ---------------------------------------------------------
# 1. PrivateFile 레포지토리를 통한 보안 파일 자동 세팅
# ---------------------------------------------------------
PRIVATE_REPO_URL="https://github.com/ChoiAnYong/fastlane-match.git"
TEMP_DIR="temp_private_configs"

echo "🔐 보안 설정 파일을 가져오는 중 (PrivateFile 레포지토리)..."

# 기존에 폴더가 있다면 삭제 후 새로 클론
rm -rf "$TEMP_DIR"
git clone "$PRIVATE_REPO_URL" "$TEMP_DIR"

# 레포지토리 내 PrivateFile 폴더가 있는지 확인 후 경로 설정
SOURCE_PATH="$TEMP_DIR/PrivateFile"
if [ ! -d "$SOURCE_PATH" ]; then
    SOURCE_PATH="$TEMP_DIR"
fi

echo "📁 설정 파일 배치 중..."
mkdir -p xcconfigs
mkdir -p fastlane

cp "$SOURCE_PATH/Debug.xcconfig" xcconfigs/ 2>/dev/null || echo "⚠️ Debug.xcconfig missing"
cp "$SOURCE_PATH/Release.xcconfig" xcconfigs/ 2>/dev/null || echo "⚠️ Release.xcconfig missing"
cp "$SOURCE_PATH/.env.default" fastlane/ 2>/dev/null || echo "⚠️ .env.default missing"
# entitlements 파일이 있다면 추가 (필요시 주석 해제)
# cp "$SOURCE_PATH/NDGL.entitlements" xcconfigs/ 2>/dev/null || echo "⚠️ NDGL.entitlements missing"

# 임시 폴더 삭제
rm -rf "$TEMP_DIR"

# ---------------------------------------------------------
# 2. 필수 설정 파일 검증
# ---------------------------------------------------------
REQUIRED_FILES=(
  "fastlane/.env.default"
  "xcconfigs/Debug.xcconfig"
  "xcconfigs/Release.xcconfig"
)

echo "🔍 가져온 파일 검증 중..."
MISSING_FILES=()

for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    MISSING_FILES+=("$FILE")
  fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
  echo -e "\n❌ [Error] 아래 필수 파일이 누락되었습니다:"
  for MISSING in "${MISSING_FILES[@]}"; do
    echo "  - $MISSING"
  done
  exit 1
fi

echo -e "✅ 모든 설정 파일이 정상적으로 배치되었습니다.\n"

# ---------------------------------------------------------
# 3. 환경 변수 로드
# ---------------------------------------------------------
export $(grep -v '^#' fastlane/.env.default | xargs)

# ---------------------------------------------------------
# 4. mise 설치 및 활성화 (Bash 버전)
# ---------------------------------------------------------
if ! command -v mise &> /dev/null; then
  echo -e "[mise] Installing mise..."
  brew install mise
fi
# 중요: zsh가 아닌 bash로 활성화
eval "$(mise activate bash)"

# 5. 도구 설치
if [ -f .mise.toml ]; then
  echo -e "[mise] Installing tools from .mise.toml..."
  mise install
fi

# ---------------------------------------------------------
# 6. rbenv 및 Ruby 설정 (Bash 버전)
# ---------------------------------------------------------
if ! command -v rbenv &> /dev/null; then
  echo -e "[rbenv] Installing rbenv..."
  brew install rbenv
fi
export PATH="$HOME/.rbenv/bin:$PATH"
# 중요: bash로 초기화
eval "$(rbenv init - bash)"

RUBY_VERSION=$(cat .ruby-version 2>/dev/null || echo "3.2.2")
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo -e "[rbenv] Installing Ruby $RUBY_VERSION..."
  rbenv install "$RUBY_VERSION"
fi
rbenv local "$RUBY_VERSION"
rbenv rehash

# ---------------------------------------------------------
# 7. Bundler 및 의존성 설치
# ---------------------------------------------------------
echo -e "[Bundler] Installing gems..."
gem install bundler --no-document
bundle install

# ---------------------------------------------------------
# 8. Tuist 설정
# ---------------------------------------------------------
echo -e "\n📦 Tuist Setting..."
if [ -f Makefile ]; then
  # Makefile의 generate 타겟 실행 (tuist install/generate 포함 권장)
  make generate
else
  tuist install
  tuist generate
fi

# ---------------------------------------------------------
# 9. Fastlane Match
# ---------------------------------------------------------
echo -e "\n🔐 Installing Certificates..."
bundle exec fastlane match development --readonly
bundle exec fastlane match appstore --readonly

echo -e "\n✅ 온보딩 완료! 이제 Xcode에서 프로젝트를 빌드할 수 있습니다."
