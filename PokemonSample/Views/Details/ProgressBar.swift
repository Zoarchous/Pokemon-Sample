//
//  ProgressBar.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import SwiftUI

struct ProgressBar: View {
    let value: Float
    let color: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                .foregroundColor(color)
                Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .animation(.linear, value: value)
            }
        }.cornerRadius(45)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: 0.45, color: .red)
    }
}
