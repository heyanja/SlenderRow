//
//  ContentView.swift
//  SlenderRow
//
//  Created by Anna Fadieieva on 2024-05-16.
//

import SwiftUI

struct DiagonalStack: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        subviews.reduce(CGSize.zero) { result, subview in
            let size = subview.sizeThatFits(.unspecified)
            return CGSize(
                width: proposal.width ?? 0,
                height: result.height + size.height)
        }
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var point = bounds.origin
        var xPosition = bounds.maxX - subviews[0].dimensions(in: .unspecified).width
        let step = abs(bounds.minX - xPosition) / Double(subviews.count - 1)
        
        for subview in subviews.reversed() {
            point.x = xPosition
            subview.place(at: point, anchor: .zero, proposal: .unspecified)
            xPosition -= step
            point.y += subview.dimensions(in: .unspecified).height
        }
    }
}

struct ContentView: View {
    @State private var isDiagonal = false
    @State private var numberOfSquares: CGFloat = 7
    let stackSpacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            let layout = isDiagonal ? AnyLayout(DiagonalStack()) : AnyLayout(HStackLayout(spacing: stackSpacing))
            let squareSize: CGFloat = isDiagonal ?
            geometry.size.height / numberOfSquares :
            (geometry.size.width - stackSpacing * (numberOfSquares - 1)) / numberOfSquares
            HStack {
                Button(action: {
                    if numberOfSquares > 1 {
                        numberOfSquares -= 1
                    }
                }) {
//                    Image(systemName: "minus.circle.fill")
//                        .font(.largeTitle)
                }
                Button(action: {
                    numberOfSquares += 1
                }) {
//                    Image(systemName: "plus.circle.fill")
//                        .font(.largeTitle)
                }
            }
            
            .padding()
            .frame(width: geometry.size.width)
            layout {
                ForEach(0..<Int(self.numberOfSquares), id: \.self) { index in
                    Rectangle()
                        .fill(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(
                            width: squareSize,
                            height: squareSize)
                        .animation(.smooth, value: isDiagonal)
                        .animation(.bouncy, value: numberOfSquares)
                }
            }
            .onTapGesture {
                withAnimation {
                    self.isDiagonal.toggle()
                }
                
            }
            .frame(height: geometry.size.height)
        }
        
    }
}
extension Animation {
    static var smooth: Animation {
        .interpolatingSpring(stiffness: 100, damping: 10)
    }
    static var bouncy: Animation {
        .interpolatingSpring(stiffness: 100, damping: 5)
    }
}
