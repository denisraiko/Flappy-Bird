//
//  PipeView.swift
//  Flappy Bird
//
//  Created by Denis Raiko on 22.01.24.
//

import SwiftUI

struct PipeView: View {
    
    let topPipeHeight: CGFloat
    let pipeWidth: CGFloat
    let pipeSpacing: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let avaliableSpacing = geometry.size.height - pipeSpacing
            let bottomPipeHeight = avaliableSpacing - topPipeHeight
            
            VStack {
                Image(.flappeBirdPipe)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: pipeWidth, height: topPipeHeight)
                
                Spacer()
                    .frame(height: pipeSpacing)
                
                Image(.flappeBirdPipe)
                    .resizable()
                    .frame(width: pipeWidth, height: bottomPipeHeight)
            }
        }
        
    }
}

#Preview {
    PipeView(topPipeHeight: 300, pipeWidth: 100, pipeSpacing: 100)
}
