#!/user/bin/swift
import Foundation

// 1. 유틸리티 함수: 날짜 가져오기
func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: Date())
}

// 2. 입력 받기
print("🚀 새 Feature 모듈 생성을 시작합니다.")

print("입력: 모듈 이름 (예: Home, MyPage)", terminator: " : ")
guard let name = readLine(), !name.isEmpty else {
    print("❌ 모듈 이름은 필수입니다."); exit(1)
}

print("입력: 작성자 이름", terminator: " : ")
guard let author = readLine(), !author.isEmpty else {
    print("❌ 작성자 이름은 필수입니다."); exit(1)
}

let currentDate = getCurrentDate()

// 3. 실행할 tuist scaffold 명령어 구성
// 템플릿 이름이 'feature'라고 가정합니다. (Template.swift가 있는 폴더명)
let command = [
    "tuist", "scaffold", "Feature",
    "--name", name,
    "--author", author,
    "--current_date", currentDate
]

print("\n-------------------------------------------")
print("생성 정보 확인")
print("- 모듈명: \(name)Feature")
print("- 작성자: \(author)")
print("- 날짜: \(currentDate)")
print("-------------------------------------------\n")

// 4. 프로세스 실행
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
process.currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
process.arguments = command

do {
    try process.run()
    process.waitUntilExit()
    
    if process.terminationStatus == 0 {
        print("\n✅ \(name)Feature 모듈이 성공적으로 생성되었습니다!")
        print("💡 'tuist generate'를 실행하여 프로젝트를 갱신하세요.")
    } else {
        print("\n❌ 모듈 생성 중 오류가 발생했습니다. (Status: \(process.terminationStatus))")
    }
} catch {
    print("❌ 명령어 실행 실패: \(error)")
}
