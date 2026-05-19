# CLAUDE.md — PulseNews

This file is the authoritative guide for Claude Code when working in this repository.
Read it fully before generating, editing, or refactoring any code.

---

## Project overview

**PulseNews** is an iOS 26 news reader application built as a professional portfolio project.
It demonstrates senior-level iOS engineering across clean architecture, modern SwiftUI,
async networking, offline-first persistence, comprehensive testing, and polished UI.

- **Platform:** iOS 26+
- **Language:** Swift 6.2
- **UI Framework:** SwiftUI (Liquid Glass design system)
- **Architecture:** MVVM + Clean Architecture (layered)
- **Concurrency:** Swift 6.2 strict concurrency (`async`/`await`, `Actor`, `Sendable`)
- **Persistence:** Core Data (offline-first)
- **Networking:** URLSession with `async`/`await`
- **Testing:** XCTest + Swift Testing framework

---

## Repository structure

```
PulseNews/
├── App/
│   ├── PulseNewsApp.swift          # @main entry point, DI root
│   └── AppDependencies.swift       # Assembles the DI container
│
├── Presentation/
│   ├── Feed/
│   │   ├── FeedView.swift
│   │   └── FeedViewModel.swift
│   ├── Detail/
│   │   ├── ArticleDetailView.swift
│   │   └── ArticleDetailViewModel.swift
│   ├── Search/
│   │   ├── SearchView.swift
│   │   └── SearchViewModel.swift
│   ├── Bookmarks/
│   │   ├── BookmarksView.swift
│   │   └── BookmarksViewModel.swift
│   └── Components/
│       ├── ArticleCardView.swift
│       ├── SkeletonLoadingView.swift
│       └── ErrorStateView.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── Article.swift           # Pure Swift struct, no framework imports
│   │   └── NewsCategory.swift
│   ├── Repositories/               # Protocols only — no implementations here
│   │   ├── NewsRepositoryProtocol.swift
│   │   └── BookmarkRepositoryProtocol.swift
│   └── UseCases/
│       ├── FetchTopHeadlinesUseCase.swift
│       ├── SearchArticlesUseCase.swift
│       ├── BookmarkArticleUseCase.swift
│       └── GetBookmarksUseCase.swift
│
├── Data/
│   ├── Network/
│   │   ├── APIClient.swift         # Generic async/await HTTP client
│   │   ├── APIEndpoint.swift       # Endpoint definitions
│   │   ├── NetworkError.swift      # Typed error enum
│   │   └── DTOs/
│   │       ├── ArticleDTO.swift
│   │       └── NewsResponseDTO.swift
│   ├── Persistence/
│   │   ├── PulseNewsDataModel.xcdatamodeld
│   │   ├── CoreDataStack.swift
│   │   └── Entities/
│   │       └── ArticleEntity+CoreData.swift
│   └── Repositories/
│       ├── NewsRepository.swift    # Implements NewsRepositoryProtocol
│       └── BookmarkRepository.swift
│
├── Core/
│   ├── DI/
│   │   └── DIContainer.swift
│   ├── Extensions/
│   │   ├── Date+Formatting.swift
│   │   ├── String+Truncation.swift
│   │   └── View+Modifiers.swift
│   ├── Logger/
│   │   └── AppLogger.swift         # OSLog-based structured logger
│   └── Constants/
│       └── AppConstants.swift
│
├── Resources/
│   ├── Assets.xcassets
│   └── Localizable.xcstrings       # String catalog (iOS 17+ format)
│
├── PulseNewsTests/
│   ├── UseCases/
│   ├── ViewModels/
│   ├── Network/
│   └── Mocks/
│
└── PulseNewsUITests/
    └── Flows/
```

---

## Architecture rules

These rules are **non-negotiable**. Never violate layer boundaries.

### Layer dependency direction

```
Presentation → Domain ← Data
                ↑
              Core
```

### Domain layer (pure)
- **Zero** imports of `SwiftUI`, `UIKit`, `CoreData`, or any third-party library.
- Contains only Swift structs, enums, and protocols.
- Entities are value types (`struct`), not classes.
- Repository protocols define what data operations exist — not how they work.
- Use cases contain all business logic. One use case per file. One public `execute()` method.

### Presentation layer
- Every screen has exactly one `View` file and one `ViewModel` file.
- ViewModels are `@MainActor final class` conforming to `ObservableObject`.
- Views are `struct`. No business logic in views — delegate everything to the ViewModel.
- ViewModels depend on Use Case protocols, never on repository or network types directly.
- Use `@StateObject` for owned ViewModels, `@ObservedObject` for injected ones.

### Data layer
- Repository implementations conform to Domain protocols.
- DTOs (Data Transfer Objects) live only in the Data layer. Map them to Domain entities before returning.
- `APIClient` is generic and knows nothing about business logic.
- Core Data `NSManagedObject` subclasses never leave the Data layer.

### Core layer
- Utilities, extensions, DI container, logger, and constants only.
- No business logic. No UI code.

---

## Swift 6.2 concurrency rules

- Enable strict concurrency checking: `SWIFT_STRICT_CONCURRENCY = complete` in build settings.
- All ViewModels must be annotated `@MainActor`.
- All network and persistence work runs off the main actor using `async`/`await`.
- Use `Actor` types for shared mutable state (e.g., `CoreDataStack`).
- All types crossing concurrency boundaries must conform to `Sendable`.
- Never use `DispatchQueue.main.async` — use `await MainActor.run { }` or `@MainActor` annotations.
- Never use `DispatchQueue` at all unless wrapping a legacy callback-based API.

---

## Naming conventions

### Files
- Views: `<Feature>View.swift` — e.g., `FeedView.swift`
- ViewModels: `<Feature>ViewModel.swift` — e.g., `FeedViewModel.swift`
- Use Cases: `<Verb><Noun>UseCase.swift` — e.g., `FetchTopHeadlinesUseCase.swift`
- Protocols: `<Name>Protocol.swift` — e.g., `NewsRepositoryProtocol.swift`
- DTOs: `<Name>DTO.swift` — e.g., `ArticleDTO.swift`
- Mocks: `Mock<Name>.swift` — e.g., `MockNewsRepository.swift`

### Types
- Protocols: noun or noun phrase — `NewsRepositoryProtocol`, `FetchTopHeadlinesUseCaseProtocol`
- Enums for errors: `<Context>Error` — `NetworkError`, `PersistenceError`
- Core Data entities: `<Name>Entity` — `ArticleEntity`

### Functions
- Use case entry point: always `execute(...)` — never `fetch`, `get`, `load`, etc.
- Async functions: no `async` suffix — `func fetchHeadlines()` not `func fetchHeadlinesAsync()`
- Boolean properties: `is`, `has`, `should` prefix — `isLoading`, `hasError`, `shouldShowEmpty`

---

## iOS 26 / SwiftUI conventions

- Use the new `TabView` APIs with `.tabViewStyle(.sidebarAdaptable)` for navigation.
- Apply `glassEffect(_:in:isEnabled:)` for Liquid Glass surfaces on cards and sheets.
- Use `ToolbarSpacer` for toolbar layout grouping.
- Use `WebView` (native SwiftUI, iOS 26) — never `WKWebView` wrapped in `UIViewRepresentable`.
- Use `NavigationStack` with typed `NavigationPath` for all navigation — never `NavigationView`.
- Prefer `@Observable` macro (Swift 5.9+) for new types where appropriate.
- Animation: use `.matchedGeometryEffect` for hero transitions between list and detail.
- Use `.symbolEffect` for SF Symbol animations on state changes.
- Skeleton loading: use `redacted(reason: .placeholder)` with shimmer overlay.
- Images: use `AsyncImage` with custom phase handling — never load images synchronously.
- All strings must use `String(localized:)` — no raw string literals in UI.

---

## Error handling

- Define typed error enums per layer: `NetworkError`, `PersistenceError`, `DomainError`.
- ViewModels expose errors as `var errorMessage: String?` — never expose raw `Error` types to views.
- All `async throws` functions must be called inside `do/catch` blocks in ViewModels.
- Network errors must distinguish between: no connectivity, timeout, server error (4xx/5xx), decoding failure.
- Never use `try!` or `try?` without explicit justification in a comment.
- Log all errors via `AppLogger` before surfacing to the UI.

---

## Testing standards

### Unit tests
- Every Use Case must have a corresponding test file.
- Every ViewModel must have a corresponding test file.
- `APIClient` response parsing must be tested with fixture JSON files.
- Use protocol-based mocks — never use third-party mocking libraries.
- Mock files live in `PulseNewsTests/Mocks/`.
- Test method naming: `test_<methodName>_<condition>_<expectedResult>` — e.g., `test_execute_whenNetworkFails_returnsError`.
- Use `XCTestExpectation` for async tests or the new Swift Testing `#expect` macro.

### UI tests
- Cover the three critical user flows: browse feed → open article, search for article, bookmark an article.
- Use accessibility identifiers set in Views — never rely on UI element text strings for queries.
- Accessibility identifiers format: `<screen>_<element>` — e.g., `feed_articleCard`, `detail_bookmarkButton`.

### Coverage target
- Aim for 70%+ overall coverage.
- Domain layer (Use Cases): 90%+ coverage required.
- Data layer (Repositories, APIClient): 80%+ coverage required.

---

## What Claude should always do

- Respect layer boundaries strictly. If a change requires violating them, flag it and propose a refactor.
- Add `// MARK: -` sections to all files longer than 50 lines.
- Write `OSLog`-based logging via `AppLogger` for all significant events (network calls, cache hits, errors).
- Generate a corresponding mock and test stub whenever creating a new protocol or use case.
- Use `@discardableResult` only when genuinely appropriate — never to silence warnings.
- Prefer composition over inheritance.
- Write `/// doc comment` documentation for all public types and methods.

## What Claude should never do

- Never import `SwiftUI` or `UIKit` in the Domain layer.
- Never put business logic in a View.
- Never use `UserDefaults` for anything other than lightweight user preferences.
- Never hard-code API keys, base URLs, or secrets — use `AppConstants` or `Secrets.xcconfig`.
- Never force-unwrap (`!`) without a `// SAFETY:` comment explaining why it is guaranteed safe.
- Never use `print()` — always use `AppLogger`.
- Never commit code with `TODO` or `FIXME` comments without an associated GitHub issue number.
- Never use `AnyView` type erasure unless there is no alternative — it degrades SwiftUI performance.

---

## API integration

- **Provider:** [NewsAPI.org](https://newsapi.org) — free tier, 100 requests/day in development.
- **Base URL:** stored in `AppConstants.swift` as `API.baseURL`.
- **API Key:** stored in `Secrets.xcconfig` (git-ignored) and accessed via `Bundle.main.infoDictionary`.
- **Endpoints used:**
  - `GET /v2/top-headlines` — main feed
  - `GET /v2/everything` — search
- Response DTOs map to Domain `Article` entity via `ArticleDTO.toDomain()`.

---

## Git conventions

- Branch naming: `feature/<short-description>`, `fix/<short-description>`, `chore/<short-description>`
- Commit messages: imperative mood, present tense — `Add FeedViewModel unit tests` not `Added tests`
- One logical change per commit. No "WIP" commits on `main`.
- All features developed on a branch and merged via PR — never commit directly to `main`.
- PR description must reference which architecture layer is affected.

---

## CI / CD

- GitHub Actions workflow at `.github/workflows/ci.yml`.
- Runs on every push to `main` and every pull request.
- Pipeline: `xcodebuild clean build` → `xcodebuild test` → report coverage.
- Build must pass with **zero warnings** — treat warnings as errors (`SWIFT_TREAT_WARNINGS_AS_ERRORS = YES`).

---

*Last updated: May 2026 — PulseNews v1.0*
