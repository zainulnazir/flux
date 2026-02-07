import SwiftUI
import AppKit

// A circular, refractive glass background that uses AppKit's NSGlassEffectView.
// Use as a background behind icons to achieve the Apple TV-style bending/refraction.
struct RefractiveGlassCircle: NSViewRepresentable {
    var diameter: CGFloat
    var tintColor: NSColor? = nil

    func makeNSView(context: Context) -> NSGlassEffectView {
        let view = NSGlassEffectView(frame: .zero)
        view.wantsLayer = true
        view.layer?.masksToBounds = true
        // Corner radius will be set in update to react to SwiftUI sizing
        if let tintColor { view.tintColor = tintColor }
        return view
    }

    func updateNSView(_ nsView: NSGlassEffectView, context: Context) {
        nsView.frame.size = CGSize(width: diameter, height: diameter)
        let radius = diameter / 2
        nsView.cornerRadius = radius
        nsView.layer?.cornerRadius = radius
        nsView.tintColor = tintColor
    }
}
