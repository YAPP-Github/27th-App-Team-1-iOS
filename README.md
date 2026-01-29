# NDGL-iOS

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" />
  <img src="https://img.shields.io/badge/Tuist-4.x-purple.svg" />
  <img src="https://img.shields.io/badge/Architecture-RIBs-green.svg" />
</p>

## 📱 프로젝트 소개

NDGL은 여행 콘텐츠를 따라가며 나만의 여행을 계획할 수 있는 iOS 앱입니다.

## 🛠 기술 스택

| 구분 | 기술 |
|:---:|:---|
| **Architecture** | RIBs (Router-Interactor-Builder-Presenter) |
| **UI** | UIKit, SnapKit, Then |
| **Reactive** | RxSwift, RxCocoa |
| **Network** | Moya, Alamofire |
| **Image** | Kingfisher |
| **Animation** | Lottie |
| **Push** | Firebase Cloud Messaging (FCM) |
| **Project** | Tuist |
| **CI/CD** | GitHub Actions, Fastlane |

## 📁 모듈 구조

```
NDGL-iOS
├── Projects
│   ├── App                    # 앱 타겟
│   ├── Features               # Feature 모듈
│   │   ├── RootFeature        # 앱 진입점 RIB
│   │   ├── TabBarFeature      # 탭바 RIB
│   │   ├── HomeFeature        # 홈 화면
│   │   ├── FollowFeature      # 따라가기 콘텐츠
│   │   ├── TravelFeature      # 다가오는 여행
│   │   └── BaseFeatureDependency
│   ├── Domain                 # Entity, UseCase, Repository Interface
│   ├── Data                   # Repository 구현체, DTO
│   ├── Core                   # 공통 유틸리티
│   └── Modules
│       ├── DSKit              # 디자인 시스템 (Color, Font, Component)
│       ├── Networks           # 네트워크 레이어
│       └── ThirdPartyLibs     # 외부 라이브러리 의존성
├── Plugins
│   └── EnvPlugin              # 환경 설정 플러그인
├── Tuist                      # Tuist 설정
├── fastlane                   # CI/CD 스크립트
└── Scripts                    # 빌드 스크립트
```

## 🏗 아키텍처

### RIBs Architecture

```
┌─────────────────────────────────────────────────┐
│                    Router                        │
│  (화면 전환, Child RIB Attach/Detach)            │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│                  Interactor                      │
│  (비즈니스 로직, 상태 관리)                       │
└─────────────────────────────────────────────────┘
                      │
          ┌──────────┴──────────┐
          ▼                     ▼
┌──────────────────┐  ┌──────────────────┐
│    Presenter     │  │     Builder      │
│  (View ↔ 통신)   │  │  (DI, RIB 생성)  │
└──────────────────┘  └──────────────────┘
          │
          ▼
┌──────────────────┐
│  ViewController  │
│    (UI 렌더링)    │
└──────────────────┘
```

### 모듈 의존성

```
                              ┌─────────┐
                              │   App   │
                              └────┬────┘
                                   │
              ┌────────────────────┼────────────────────┐
              ▼                    ▼                    ▼
        ┌──────────┐         ┌──────────┐        ┌───────────┐
        │   Data   │         │ Networks │        │   Root    │
        └────┬─────┘         └────┬─────┘        │  Feature  │
             │                    │              └─────┬─────┘
             │               ┌────┴────┐               │
             │               ▼         ▼               ▼
             │          ┌────────┐┌────────┐    ┌───────────┐
             │          │ Domain ││  Core  │    │  TabBar   │
             │          └────────┘└────────┘    │  Feature  │
             │                                  └─────┬─────┘
             │                                        │
             ▼                                        ▼
       ┌──────────┐                             ┌───────────┐
       │  Domain  │                             │   Home    │
       │ Networks │                             │  Feature  │
       └──────────┘                             └─────┬─────┘
                                                      │
                                                      ▼
                                         ┌─────────────────────┐
                                         │ BaseFeatureDependency│
                                         └──────────┬──────────┘
                                                    │
                                    ┌───────────────┼───────────────┐
                                    ▼               ▼               ▼
                               ┌────────┐     ┌────────┐      ┌───────┐
                               │  Core  │     │ Domain │      │ DSKit │
                               └────┬───┘     └────┬───┘      └───┬───┘
                                    │              │              │
                                    └──────────────┴──────────────┘
                                                   │
                                                   ▼
                                              ┌────────┐
                                              │  Core  │
                                              └────┬───┘
                                                   │
                                                   ▼
                                          ┌───────────────┐
                                          │ ThirdPartyLibs│
                                          └───────────────┘
```

### 주요 의존성 관계

| 모듈 | 의존성 |
|:---:|:---|
| **App** | Data, Networks, RootFeature |
| **RootFeature** | TabBarFeature |
| **TabBarFeature** | HomeFeature |
| **HomeFeature** | BaseFeatureDependency |
| **BaseFeatureDependency** | Core, Domain, DSKit |
| **Data** | Domain, Networks |
| **Networks** | Core, Domain |
| **Domain** | Core |
| **DSKit** | Core |
| **Core** | ThirdPartyLibs (RxSwift, RIBs, SnapKit, Then, Moya, Kingfisher) |

## 🌿 브랜치 전략

| 브랜치 | 설명 |
|:---:|:---|
| `main` | 프로덕션 배포 브랜치 |
| `develop` | 개발 통합 브랜치 |
| `feat/#이슈번호-작업내용` | 기능 개발 브랜치 |
| `fix/#이슈번호-작업내용` | 버그 수정 브랜치 |
| `hotfix/#이슈번호-작업내용` | 긴급 수정 브랜치 (develop에서 분기) |

### PR 규칙
- **2명 이상 승인** 시 머지 가능
- CI 통과 필수

## 🔄 CI/CD

| 환경 | 트리거 | 동작 |
|:---:|:---:|:---|
| **CI** | `develop` PR/Push | 빌드 체크, 린트 검사 |
| **CD** | `main` Push | Fastlane을 통한 TestFlight 배포 |

## 📝 커밋 컨벤션

```
feat: #이슈번호 - 작업 내용
```

| 타입 | 설명 |
|:---:|:---|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서 수정 |
| `style` | 코드 포맷팅 (기능 변경 없음) |
| `refactor` | 코드 리팩토링 |
| `test` | 테스트 코드 추가/수정 |
| `chore` | 빌드, 패키지 매니저 설정 |
| `design` | UI/UX 디자인 변경 |

## 📐 코드 컨벤션

[StyleShare Swift Style Guide](https://github.com/StyleShare/swift-style-guide) 준수

### SwiftLint
프로젝트 루트의 `.swiftlint.yml` 설정 파일 사용

## 🚀 시작하기

### 요구사항
- Xcode 16.0+
- iOS 17.0+
- [mise](https://mise.jdx.dev/) (Tuist, Ruby 버전 관리)

### 설치 및 실행

```bash
# 1. 저장소 클론
git clone https://github.com/YourOrg/NDGL-iOS.git
cd NDGL-iOS

# 2. mise로 도구 설치
mise install

# 3. 의존성 설치
bundle install
tuist install

# 4. 프로젝트 생성
tuist generate

# 5. Xcode에서 NDGL-iOS.xcworkspace 열기
```

## 👥 팀원

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/KimNahun">
        <img src="https://github.com/KimNahun.png" width="120" />
        <br />
        <b>김나훈</b>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/ChoiAnYong">
        <img src="https://github.com/ChoiAnYong.png" width="120" />
        <br />
        <b>최안용</b>
      </a>
    </td>
  </tr>
</table>
