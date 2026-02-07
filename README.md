# Flux for macOS

Flux is a modern, native macOS media center built with SwiftUI. It allows you to browse, manage, and play movies and TV shows with a premium "Glass" aesthetic.

![Flux App Icon](flux/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x.png)

## Features

-   **Native macOS Experience**: Built purely with SwiftUI.
-   **Flux Mode**: Intelligent stream racing to find the fastest playback source.
-   **TMDB Integration**: Extensive metadata, trending lists, and search.
-   **Personalization**: Watchlist, History, and "For You" AI recommendations.
-   **Custom Player**: Built on top of `mpv` for robust format support.

## Building from Source

### Prerequisites
-   Xcode 15.0+
-   macOS Sonoma (14.0)+
-   CocoaPods (likely not needed as dependencies are SPM/Local)

### Setup
1.  Clone the repository.
2.  **Secrets Configuration**:
    -   Copy `flux/flux/Services/SecretsExample.txt` to `flux/flux/Services/Secrets.swift`.
    -   **TMDB API Key**: Obtain a free API key from [The Movie Database](https://www.themoviedb.org/documentation/api) and paste it into `Secrets.swift`.
    -   **Stream Racer**: You can use the provided default URL or deploy your own Cloudflare Worker.
3.  **Firebase Configuration**:
    -   Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    -   Enable **Authentication** (Email/Password) and **Realtime Database**.
    -   Download the `GoogleService-Info.plist` file and add it to the `flux/flux/` directory (ensure it is added to the "flux" target in Xcode).
4.  Open `flux.xcodeproj` and run.

## Tech Stack
-   **SwiftUI**
-   **Combine**
-   **Firebase Auth**
-   **MPV (via LocalMPVKit)**

## Legal
Only intended for educational purposes. See [DISCLAIMER.md](DISCLAIMER.md) for more details.

## License
MIT
