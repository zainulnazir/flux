import SwiftUI

struct SectionHeader<Destination: View>: View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.title2) // Matches Apple TV section header size
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold)) // Smaller, bold chevron
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(.top, 2) // Slight optical alignment
            }
            .contentShape(Rectangle()) // Make the whole area clickable
        }
        .buttonStyle(.plain) // Removes default button styling
    }
}

struct ListSectionHeader<Value: Hashable>: View {
    let title: String
    let value: Value
    
    var body: some View {
        NavigationLink(value: value) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(.top, 2)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black
        SectionHeader(title: "Trending Movies", destination: Text("Destination"))
    }
}
