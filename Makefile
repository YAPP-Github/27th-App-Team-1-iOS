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
	@chmod +x Scripts/onboarding.sh
	@/bin/bash Scripts/onboarding.sh
