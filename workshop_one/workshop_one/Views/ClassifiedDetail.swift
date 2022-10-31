import SwiftUI

struct ClassifiedDetail: View {
    
    @State private var isAlertPresented = false
    @State private var isSheetPresented = false

    @Binding var classified: Classified
    
    let service = ClassifiedVisitService()
    
    var body: some View {
        CustomVStack {
            ClassifiedListItem(classified: $classified)
            Divider()
            VStack(alignment: .leading, spacing: 8.0) {
                Text("Description")
                    .font(.dsH1)
                Text(classified.description)
                    .lineLimit(5)
                Button("See more") {
                    isSheetPresented.toggle()
                }
                .accessibilityHidden(true)
                
                Text("This classified has been seen at : \(service.formattedDate)")
                
                Spacer()
                Button {
                    isAlertPresented.toggle()
                } label: {
                    Label("Contact owner", systemImage: "phone")
                }
                .buttonStyle(.main)
                .frame(maxWidth: .infinity)
            }
            .font(.dsBody)
            .alert("Call owner at: XXX-XX-XX", isPresented: $isAlertPresented) {
                Button("Ok", role: .cancel) {}
            }
            .sheet(isPresented: $isSheetPresented, content: {
                CustomVStack {
                    Text("Description")
                        .font(.dsH1)
                    Text(classified.description)
                        .font(.dsBody)
                }
                .padding()
            })
        }
        .padding()
    }
}

struct ClassifiedDetail_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedDetail(classified: .constant(Classified.mocks[0]))
        ClassifiedDetail(classified: .constant(Classified.mocks[2]))
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}

class ClassifiedVisitService {
    
    private let seenDate = Date()
    
    init() {}
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd - HH':'mm':'ss"
        return formatter.string(from: seenDate)
    }
}
