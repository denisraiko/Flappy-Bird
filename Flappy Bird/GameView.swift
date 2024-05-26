//
//  GameView.swift
//  Flappy Bird
//
//  Created by Denis Raiko on 22.01.24.
//

import SwiftUI

struct GameView: View {
    
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    @State private var topPipeHeight = CGFloat.random(in: 100...500)
    private let pipeWidth: CGFloat = 100
    private let pipeSpacing: CGFloat = 200
    @State private var pipeOffset: CGFloat = 0
    @State private var score: Int = 0
    @State private var highScore: Int = 0

    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State private var lastUpdateTime = Date()
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    private let birdSize = 80.0
    private let birdRadius = 30.0
    
    enum GameState {
        case ready, active, stopped
    }
    
    @State private var gameState: GameState = .ready
    
    @State private var passedPipe = false

    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.flappyBirdBackground)
                        .resizable()
                        .ignoresSafeArea()
                        .padding(.bottom, -50)
                        .padding(.trailing, -50)
                    
                    BirdView(birdSize: 80)
                        .position(birdPosition)
                    
                    PipeView(topPipeHeight: topPipeHeight, pipeWidth: pipeWidth, pipeSpacing: pipeSpacing)
                        .offset(x: geometry.size.width + pipeOffset)
                    
                    if gameState == .ready {
                        Button {
                            playAction()
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .font(.system(size: 100))
                        .foregroundColor(.white)

                    }
                    
                    if gameState == .stopped {
                        ResultView(score: score, highScore: highScore) {
                            resetAction()
                        }
                    }
                }
                .onTapGesture {
                    birdVelocity = CGVector(dx: 0, dy: -400)
                }
                .onReceive(timer, perform: { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBounds(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePosition(geometry: geometry)
                    if checkCoolision(geometry: geometry) {
                        gameState = .stopped
                    }
                    updateScore(geometry: geometry)
                    
                    lastUpdateTime = currentTime
                })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text(score.formatted())
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
            }
        }
    }
    
    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += CGFloat(1000 * deltaTime)
    }
    
    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * CGFloat(deltaTime)
    }
    
    private func checkBounds(geometry: GeometryProxy) {
        if birdPosition.y > geometry.size.height - 50 {
            birdPosition.y = geometry.size.height - 50
            birdVelocity.dy = 0
            gameState = .stopped
        }
        if birdPosition.y <= 0 {
            birdPosition.y = 0
            gameState = .stopped
        }
    }
    
    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= 300 * deltaTime
    }
    
    private func resetPipePosition(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - pipeWidth {
            pipeOffset = 0
            topPipeHeight = CGFloat.random(in: 100...500)
        }
    }
    
    private func playAction() {
        gameState = .active
        lastUpdateTime = Date()
    }
    
    private func resetAction() {
        gameState = .ready
        birdPosition = CGPoint(x: 100, y: 300)
        pipeOffset = 0
        topPipeHeight = CGFloat.random(in: 100...500)
        score = 0
    }
    
    private func checkCoolision(geometry: GeometryProxy) -> Bool {
        let birdFrame = CGRect(x: birdPosition.x - birdRadius / 2, y: birdPosition.y - birdRadius / 2, width: birdRadius, height: birdRadius)
        
        let topPipeFrame = CGRect(x: geometry.size.width + pipeOffset, y: 0, width: pipeWidth, height: topPipeHeight)
        
        let bottomPipeFrame = CGRect(x: geometry.size.width + pipeOffset, y: topPipeHeight + pipeSpacing, width: pipeWidth, height: topPipeHeight)
        
        return birdFrame.intersects(topPipeFrame) || birdFrame.intersects(bottomPipeFrame)
    }
    
    private  func updateScore(geometry: GeometryProxy) {
        if pipeOffset + pipeWidth + geometry.size.width < birdPosition.x && !passedPipe {
            score += 1
            passedPipe = true
            if score > highScore {
                highScore = score
            }
        } else if pipeOffset + geometry.size.width > birdPosition.x {
            passedPipe = false
        }
    }
    
}

#Preview {
    GameView()
}
