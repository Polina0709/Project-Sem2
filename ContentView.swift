//
//  ContentView.swift
//  Game_of_Life
//
//  Created by Polya Melnik on 31.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var grid: [[Bool]]
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var showStartView = false
    
    let rows = 20
    let cols = 18
    let cellSize: CGFloat = 20
    
    init() {
        _grid = State(initialValue: Array(repeating: Array(repeating: false, count: cols), count: rows))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showStartView = true
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            Text("Game of Life")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity) // Розміщення тексту по центру
            
            Spacer()
            
            Grid(grid: $grid, rows: rows, cols: cols, cellSize: cellSize)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        startGame()
                    } else {
                        stopGame()
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: clearGrid) {
                    Text("Clear")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showStartView) {
            StartView()
        }
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateGrid()
        }
    }
    
    func stopGame() {
        timer?.invalidate()
    }
    
    func clearGrid() {
        stopGame()
        isRunning = false
        grid = Array(repeating: Array(repeating: false, count: cols), count: rows)
    }
    
    func updateGrid() {
        var newGrid = grid
        for row in 0..<rows {
            for col in 0..<cols {
                let neighbors = liveNeighborCount(row: row, col: col)
                if grid[row][col] {
                    if neighbors < 2 || neighbors > 3 {
                        newGrid[row][col] = false
                    }
                } else {
                    if neighbors == 3 {
                        newGrid[row][col] = true
                    }
                }
            }
        }
        grid = newGrid
    }
    
    func liveNeighborCount(row: Int, col: Int) -> Int {
        var count = 0
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 { continue }
                let newRow = row + i
                let newCol = col + j
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols {
                    count += grid[newRow][newCol] ? 1 : 0
                }
            }
        }
        return count
    }
}

struct Grid: View {
    @Binding var grid: [[Bool]]
    let rows: Int
    let cols: Int
    let cellSize: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<cols, id: \.self) { col in
                        Rectangle()
                            .fill(grid[row][col] ? Color.black : Color.white)
                            .frame(width: cellSize, height: cellSize)
                            .border(Color.gray)
                            .onTapGesture {
                                grid[row][col].toggle()
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
