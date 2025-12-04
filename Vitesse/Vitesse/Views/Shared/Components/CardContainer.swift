//
//  CardContainer.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 03/12/2025.
//

import SwiftUI

struct CardContainerModifier: ViewModifier {
    let isAppeared: Bool
    let shakeOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 12)
            )
            .padding(.horizontal)
            .opacity(isAppeared ? 1 : 0)
            .offset(y: isAppeared ? 0 : 20)
            .animation(.spring(response: 0.5, dampingFraction: 0.85), value: isAppeared)
            .offset(x: shakeOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

extension View {
    func cardContainer(isAppeared: Bool, shakeOffset: CGFloat) -> some View {
        self.modifier(CardContainerModifier(isAppeared: isAppeared, shakeOffset: shakeOffset))
    }
}

struct CardContainer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppBackground()
            Text("VITESSE")
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 12)
                .padding(.horizontal)
        }
        .previewDisplayName("CardContainer Preview")
    }
}
