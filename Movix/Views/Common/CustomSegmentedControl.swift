//
//  CustomSegmentedControl.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI


struct CustomSegmentedControl<T: Hashable & CaseIterable & Identifiable>: View {
    @Binding var state: T
    @Namespace private var segmentedControl
    
    var body: some View {
        HStack(spacing: 24) {
            GeometryReader {
                let widthSize = $0.size.width / 3
                let cases = Array(T.allCases)
                HStack {
                    ForEach(cases, id: \.self) { state in
                        Button {
                            withAnimation {
                                self.state = state
                            }
                        } label: {
                            Text("\(state)".capitalized)
                                .padding(8)
                                .foregroundStyle(.white)
                        }
                        .matchedGeometryEffect(
                            id: state,
                            in: segmentedControl
                        )
                        .frame(width: widthSize, height: 36)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 36)
        .background(
            Rectangle()
                .fill(.blue1)
                .frame(height: 4)
                .padding(.horizontal, 4)
                .matchedGeometryEffect(
                    id: state,
                    in: segmentedControl,
                    isSource: false
                )
        )
        .padding(4)
        .buttonStyle(.plain)
        
    }
}

#Preview {
    @Previewable @State var control: ListControls = .favorites
    CustomSegmentedControl(state: $control)
        .background(.bw10)
}
