import SwiftUI

struct ClassifiedListView: View {
    
    let gridItem = GridItem(.adaptive(minimum: 300), spacing: 8.0, alignment: .leading)
    
    @State var classifieds = Classified.mocks
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [gridItem]) {
                    
                    ForEach($classifieds) { $classified in
                        VStack(spacing: 0) {
                            NavigationLink {
                                ClassifiedDetail(classified: $classified)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                ClassifiedListItem(classified: $classified)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                                .padding(.bottom)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Listings")
        }
    }
}

struct ClassifiedListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedListView()
        ClassifiedListView()
            .navigationViewStyle(.stack)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
