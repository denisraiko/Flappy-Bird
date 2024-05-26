//
//  BirdView.swift
//  Flappy Bird
//
//  Created by Denis Raiko on 22.01.24.
//

import SwiftUI

struct BirdView: View {
    
    let birdSize: CGFloat
    
    var body: some View {
        Image(.flappyBird)
            .resizable()
            .scaledToFit()
            .frame(width: birdSize, height: birdSize)
    }
}

#Preview {
    BirdView(birdSize: 80)
}
