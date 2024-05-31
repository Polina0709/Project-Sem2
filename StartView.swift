//
//  StartView.swift
//  Game_of_Life
//
//  Created by Polya Melnik on 31.05.2024.
//
import SwiftUI

struct StartView: View {
    @State private var showGame = false
    @State private var movingCells = [MovingCell]()

    var body: some View {
        VStack {
            if showGame {
                ContentView()
            } else {
                ZStack {
                    VStack {
                        Spacer()
                        
                        Text("Game of Life")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            showGame = true
                        }) {
                            Text("New Game")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    
                    ForEach(movingCells) { cell in
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 10, height: 10)
                            .position(cell.position)
                            .onAppear {
                                cell.startMoving(bounds: UIScreen.main.bounds)
                            }
                    }
                }
                .onAppear(perform: createMovingCells)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showGame)
    }
    
    func createMovingCells() {
        for _ in 0..<10 {
            let cell = MovingCell()
            movingCells.append(cell)
        }
    }
}

class MovingCell: Identifiable, ObservableObject {
    let id = UUID()
    @Published var position: CGPoint = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                               y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
    
    func startMoving(bounds: CGRect) {
        let xMovement = CGFloat.random(in: -50...50)
        let yMovement = CGFloat.random(in: -50...50)
        let duration = Double.random(in: 2...5)
        
        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: true)) {
            position = CGPoint(x: position.x + xMovement, y: position.y + yMovement)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

#Preview {
    StartView()
}
