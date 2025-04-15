//
//  DebounceModifier.swift
//  Movix
//
//  Created by Ancel Dev account on 15/4/25.
//

import SwiftUI


class DebouncedViewModel: ObservableObject {
    @Published var userInput: String = ""
}

struct DebounceModifier: ViewModifier {
    
    @State private var viewModel = DebouncedViewModel()

    @Binding var text: String
    @Binding var debouncedText: String
    let debounceSeconds: TimeInterval
    
    func body(content: Content) -> some View {
        content
            .onReceive(viewModel.$userInput.debounce(for: RunLoop.SchedulerTimeType.Stride(debounceSeconds), scheduler: RunLoop.main)) { value in
                debouncedText = value
            }
            .onChange(of: text) { _, newValue in
                viewModel.userInput = newValue
            }
    }
}
extension View {
    public func debounced(text: Binding<String>, debouncedText: Binding<String>, debouncedSeconds: TimeInterval = 1.0) -> some View {
        modifier(DebounceModifier(text: text, debouncedText: debouncedText, debounceSeconds: debouncedSeconds))
    }
}

//struct TextDebouncer: View {
//    
//    @State private var text: String = ""
//    @State private var debouncedText: String = ""
//    
//    var body: some View {
//        VStack {
//            TextField("text", text: $text)
//                .debounced(text: $text, debouncedText: $debouncedText)
//            Text(debouncedText)
//                .bold()
//        }
//        .foregroundStyle(.bw10)
//    }
//}
//#Preview {
//    VStack {
//        TextDebouncer()
//    }
//    .background(.white)
//}
