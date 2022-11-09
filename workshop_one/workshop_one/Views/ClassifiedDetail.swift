import SwiftUI

struct ClassifiedDetail: View {
    
    @State private var isAlertPresented = false
    @State private var isSheetPresented = false
    @State private var isButtonEnabled = true
    
    @Binding var classified: Classified
    @StateObject var viewModel = ClassifiedDetailViewModel()
    
    let service = ClassifiedVisitService()
    
    init(classified: Binding<Classified>) {
        _classified = classified
        debugPrint("Init ClassifiedDetail !")
    }
    
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
                Text(viewModel.lastContactText)
                Toggle("Button enable status", isOn: $isButtonEnabled)
                  
                Spacer()
                CounterView()
                Text("IS ? \(isButtonEnabled ? "oui" :"non")")
                Button {
                    isAlertPresented.toggle()
                    viewModel.updateLastContactText()
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

class ClassifiedDetailViewModel: ObservableObject {
    
    @Published var lastContactText: String = ""
    
    func updateLastContactText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY 'at' HH':'mm':'ss"
        lastContactText = "Contacted the \(formatter.string(from: Date()))"
    }
}

struct CounterView: View {
    /// Using @StateObject instead of @ObservedObject
    @ObservedObject var viewModel = CounterViewModel()

    init() {
        debugPrint("CounterView init")
    }
    
    var body: some View {
        VStack {
            Text("Count is: \(viewModel.count)")
            Button("Increment Counter") {
                viewModel.incrementCounter()
            }
        }
    }
}

final class CounterViewModel: ObservableObject {
    private(set) var count = 0

    func incrementCounter() {
        count += 1
        objectWillChange.send()
    }
}
