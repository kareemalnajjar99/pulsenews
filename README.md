# PulseNews

![iOS](https://img.shields.io/badge/iOS-26%2B-black?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-6.2-orange?style=flat-square&logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-blue?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean-purple?style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/kareemalnajjar99/PulseNews/ci.yml?style=flat-square&label=CI)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

A news reader for iOS 26 built with SwiftUI and Clean Architecture.

<br />

## Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/16cf3dbb-5c03-4bf2-b70e-c58656919a09" width="240" alt="Feed screen"></td>
    <td><img src="https://github.com/user-attachments/assets/311927d8-3610-47b9-a59e-28c159da57f1" width="240" alt="Search screen"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/aa76f8fc-e132-47b1-b9f3-a9478e8c758f" width="240" alt="Bookmarks screen"></td>
    <td><img src="https://github.com/user-attachments/assets/8655bb90-a9d5-41ee-a7ef-31902e9d24a3" width="240" alt="Article detail screen"></td>
  </tr>
</table>

<br />

## Features

- Browse top headlines by category
- Full-text search across sources
- Bookmark articles for offline reading
- Offline-first — cached content loads without a network connection
- Liquid Glass UI with hero transitions and animated tab bar
- Skeleton loading states

<br />

## Architecture

Clean Architecture with an MVVM presentation layer using the `@Observable` macro for state management. Dependencies flow strictly inward — the Domain layer has zero framework imports.

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│         SwiftUI Views  ←→  ViewModels (@MainActor)   │
└───────────────────────┬─────────────────────────────┘
                        │  Uses (via protocols)
┌───────────────────────▼─────────────────────────────┐
│                    Domain Layer                      │
│          Use Cases   │   Entities   │   Protocols    │
│             (pure Swift — no framework imports)      │
└───────────────────────┬─────────────────────────────┘
                        │  Implements
┌───────────────────────▼─────────────────────────────┐
│                     Data Layer                       │
│   APIClient (URLSession)  │  Repositories (CoreData) │
└─────────────────────────────────────────────────────┘
```

<br />

## Tech Stack

| | |
|---|---|
| Language | Swift 6.2 — strict concurrency |
| UI | SwiftUI, Liquid Glass (iOS 26) |
| Architecture | MVVM + Clean Architecture |
| State Management | `@Observable` macro (iOS 17+) |
| Concurrency | `async`/`await` · `Actor` · `@MainActor` |
| Networking | `URLSession` — generic `APIClient` |
| Persistence | Core Data (offline-first) |
| Testing | XCTest + Swift Testing |
| CI | GitHub Actions |
| Code Style | File headers with name, project, and author |
| Localization | String Catalogs (`.xcstrings`) |
| Logging | `OSLog` |

<br />

## Getting Started

### Requirements

- Xcode 26+
- iOS 26+ simulator or device
- [NewsAPI.org](https://newsapi.org) API key

### Setup

1. Clone the repo
   ```bash
   git clone https://github.com/kareemalnajjar99/PulseNews.git
   cd PulseNews
   ```

2. Create `Secrets.xcconfig` in the project root (git-ignored):
   ```
   NEWS_API_KEY = your_api_key_here
   ```

3. Open and run
   ```bash
   open PulseNews.xcodeproj
   ```

<br />

## Testing

```bash
xcodebuild test \
  -scheme PulseNews \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -enableCodeCoverage YES
```

<br />

## License

MIT — see [LICENSE](LICENSE).
