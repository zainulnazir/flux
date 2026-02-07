# Contributing to Flux

Thank you for your interest in contributing to Flux! We welcome contributions from everyone.

## Getting Started

1.  **Fork the repository** on GitHub.
2.  **Clone your fork** locally:
    ```bash
    git clone https://github.com/your-username/flux-mac-app.git
    cd flux-mac-app
    ```
3.  **Setup Secrets**:
    - Copy `flux/Services/SecretsExample.txt` to `flux/Services/Secrets.swift`.
    - Add your own TMDB API Key.
    - Add the GoogleService-Info.plist file (you will need to create your own Firebase project).

4.  **Open the project** in Xcode:
    ```bash
    open flux/flux.xcodeproj
    ```

## Development Workflow

-   **Branching**: Create a new branch for each feature or bug fix:
    ```bash
    git checkout -b feature/my-new-feature
    ```
-   **Style**: Follow standard Swift guidelines. We use SwiftUI for all new UI components.
-   **Testing**: Please verify your changes on macOS.

## Submitting Changes

1.  Push your changes to your fork.
2.  Submit a **Pull Request** to the main repository.
3.  Describe your changes clearly in the PR description.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
