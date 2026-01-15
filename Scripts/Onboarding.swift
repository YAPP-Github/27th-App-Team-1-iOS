#!/bin/bash

# 에러 발생 시 즉시 중단
set -e

echo -e "🚀 Onboarding Start\n"

# 0. 실행 경로 고정 (프로젝트 루트)
cd "$(dirname "$0")/.."

# 1. 관리자에게 직접 전달받아야 할 필수 파일 체크
REQUIRED_FILES=(
  "fastlane/.env.default"
  "xcconfigs/Debug.xcconfig"
  "xcconfigs/Release.xcconfig"
  "xcconfigs/NDGL.entitlements"
)

echo "🔍 필수 설정 파일 확인 중..."
MISSING_FILES=()

for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    MISSING_FILES+=("$FILE")
  fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
  echo -e "\n❌ [Error] 아래 파일이 누락되었습니다:"
  for MISSING in "${MISSING_FILES[@]}"; do
    echo "  - $MISSING"
  done
  echo -e "\n👉 관리자에게 해당 파일들을 전달받아 정해진 경로에 넣어주세요."
  exit 1
fi

echo -e "✅ 모든 필수 파일이 확인되었습니다.\n"

# 2. .env.default 환경 변수 로드 (fastlane match 실행용)
# fastlane 폴더 안에 있는 설정을 로드합니다.
export $(grep -v '^#' fastlane/.env.default | xargs)

# 3. mise 설치 및 활성화
if ! command -v mise &> /dev/null; then
  echo -e "[mise] Installing mise..."
  brew install mise
fi
eval "$(mise activate zsh)"

# 4. 도구 설치 (tuist 등)
if [ -f .mise.toml ]; then
  echo -e "[mise] Installing tools from .mise.toml..."
  mise install
fi

# 5. rbenv 및 Ruby 설정
if ! command -v rbenv &> /dev/null; then
  brew install rbenv
fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

RUBY_VERSION=$(cat .ruby-version 2>/dev/null || echo "3.2.2")
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  rbenv install "$RUBY_VERSION"
fi
rbenv global "$RUBY_VERSION"
rbenv rehash

# 6. Bundler 및 의존성 설치
export PATH="$HOME/.rbenv/shims:$PATH"
bundle install

# 7. Tuist 종속성 설치 및 프로젝트 생성
echo -e "\n📦 Tuist Setting..."
tuist install
tuist generate

# 8. Fastlane Match (인증서 설치)
echo -e "\n🔐 Installing Certificates..."
bundle exec fastlane match development --readonly
bundle exec fastlane match appstore --readonly

echo -e "\n✅ 온보딩 완료! 이제 Xcode에서 프로젝트를 빌드할 수 있습니다."
