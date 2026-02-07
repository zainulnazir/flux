import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label("General", systemImage: "gear") }
            StreamingSettingsView()
                .tabItem { Label("Streaming", systemImage: "antenna.radiowaves.left.and.right") }
            PlaybackSettingsView()
                .tabItem { Label("Playback", systemImage: "play.tv") }
            AdvancedSettingsView()
                .tabItem { Label("Advanced", systemImage: "slider.horizontal.3") }
        }
        .frame(width: 500, height: 400)
        .padding()
        .preferredColorScheme(.dark)
    }
}

// MARK: - 1. General Settings (Account + App)
struct GeneralSettingsView: View {
    @ObservedObject var authManager = AuthManager.shared
    @AppStorage("syncEnabled") private var syncEnabled = true
    
    var body: some View {
        Form {
            Section(header: Text("Account")) {
                if let user = authManager.currentUser {
                    HStack {
                         Text(user.email ?? "User")
                         Spacer()
                         Button("Sign Out") { authManager.signOut() }
                    }
                    Toggle("Sync Watchlist & History", isOn: $syncEnabled)
                } else {
                    Text("Not Signed In")
                }
            }
        }
        .formStyle(.grouped)
    }
}

// MARK: - 2. Streaming Settings
struct StreamingSettingsView: View {
    @AppStorage("enableFluxMode") private var enableFluxMode = true
    @AppStorage("enableWebStreamer") private var enableWebStreamer = true
    @AppStorage("enableNuvio") private var enableNuvio = true
    @AppStorage("rdApiKey") private var rdApiKey = ""
    @AppStorage("traktClientId") private var traktClientId = ""
    @AppStorage("preferredQuality") private var preferredQuality = "4K"
    
    var body: some View {
        Form {
            Section(header: Text("Flux Mode")) {
                Toggle("Enable Flux Mode", isOn: $enableFluxMode)
                Text("Automatically find and play the fastest stream.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Picker("Maximum Resolution", selection: $preferredQuality) {
                    Text("4K (2160p)").tag("4K")
                    Text("1080p").tag("1080p")
                    Text("720p").tag("720p")
                    Text("480p").tag("480p")
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Addons")) {
                Toggle("WebStreamer", isOn: $enableWebStreamer)
                Toggle("Nuvio Streams", isOn: $enableNuvio)
            }
            
            Section(header: Text("Services")) {
                SecureField("Real-Debrid API Key", text: $rdApiKey)
                SecureField("Trakt Client ID", text: $traktClientId)
            }
        }
        .formStyle(.grouped)
    }
}

// MARK: - 3. Playback Settings
struct PlaybackSettingsView: View {
    @AppStorage("useHardwareAcceleration") private var useHardwareAcceleration = true
    @AppStorage("defaultAudioLang") private var defaultAudioLang = "English"
    @AppStorage("defaultSubLang") private var defaultSubLang = "English"
    
    let languages = ["English", "Spanish", "French", "German", "Japanese", "Korean", "Hindi"]
    
    var body: some View {
        Form {
            Section(header: Text("Video Player")) {
                Toggle("Hardware Acceleration", isOn: $useHardwareAcceleration)
            }
            
            Section(header: Text("Languages")) {
                Picker("Default Audio", selection: $defaultAudioLang) {
                    ForEach(languages, id: \.self) { Text($0).tag($0) }
                }
                Picker("Default Subtitles", selection: $defaultSubLang) {
                    ForEach(languages, id: \.self) { Text($0).tag($0) }
                }
            }
        }
        .formStyle(.grouped)
    }
}

// MARK: - 4. Advanced Settings
struct AdvancedSettingsView: View {
    var body: some View {
        Form {
             Section(header: Text("Storage")) {
                Button("Clear Image Cache") {
                    if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                         try? FileManager.default.removeItem(at: cacheDir.appendingPathComponent("ImageCache"))
                    }
                }
            }
            
            Section(header: Text("About")) {
                Text("Version 1.0.0 (Beta)")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager.shared)
}
