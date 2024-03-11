//
//  Extensions.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import Foundation
import SwiftUI

extension View{
    func scaleEffectAnimationOnTap(onTapAction: @escaping () -> Void, scaleTo: CGFloat = 0.8) -> some View {
        self.modifier(ScaleEfffectAnimationModifier(scaleTo: scaleTo, tapAction: {
            onTapAction()
        }))
    }
}
