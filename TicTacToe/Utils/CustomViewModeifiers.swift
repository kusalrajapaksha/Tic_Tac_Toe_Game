//
//  CustomViewModeifiers.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import Foundation
import SwiftUI

struct ScaleEfffectAnimationModifier: ViewModifier{
    @State private var isScaled: Bool
    @State private var scaleFactor: Double
    private var minScale:CGFloat
    private var tapAction: () -> Void
    
    init(isScaled: Bool = false, scaleFactor: Double = 1.0, scaleTo: CGFloat, tapAction: @escaping () -> Void) {
        self.isScaled = isScaled
        self.scaleFactor = scaleFactor
        self.minScale = scaleTo
        self.tapAction = tapAction
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scaleFactor)
            .onTapGesture {
                withAnimation{
                    self.scaleFactor = minScale
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        withAnimation{
                            self.scaleFactor = 1.0
                            tapAction()
                        }
                    })
                }
            }
    }
}
