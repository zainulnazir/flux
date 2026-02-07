import SwiftUI

struct SeasonSelectionList: View {
    let seasons: [Season]
    let selectedSeason: Season?
    let onSelect: (Season) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Seasons")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(seasons) { season in
                        Button {
                            onSelect(season)
                        } label: {
                            HStack {
                                if selectedSeason?.id == season.id {
                                    Image(systemName: "checkmark")
                                        .frame(width: 16)
                                } else {
                                    Spacer().frame(width: 16)
                                }
                                
                                Text(season.name)
                                Spacer()
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .background(selectedSeason?.id == season.id ? Color.white.opacity(0.1) : Color.clear)
                        .cornerRadius(6)
                    }
                }
                .padding(8)
            }
        }
        .frame(minWidth: 200, maxHeight: 300)
        .padding(.bottom, 8)
    }
}
