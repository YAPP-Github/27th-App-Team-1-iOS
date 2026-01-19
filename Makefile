generate:
	tuist install
	tuist generate

clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	make clean

regenerate:
	make clean
	tuist generate

# Feature 모듈 생성
feature:
	@swift Scripts/GenerateModule.swift
	tuist edit

# 팀원이 파일을 모두 배치한 후 실행
setup:
	@chmod +x Scripts/Onboarding.sh
	@/bin/bash Scripts/Onboarding.sh

# 디바이스 추가
device:
	bundle exec fastlane register_new_device
