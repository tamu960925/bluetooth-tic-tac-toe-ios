import SwiftUI

struct GameView: View {
    @ObservedObject var gameLogic: GameLogic
    @ObservedObject var multipeerService: MultipeerService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("あなた: \(gameLogic.mySymbol)")
                        .font(.title2)
                        .foregroundColor(gameLogic.isMyTurn ? .blue : .gray)
                    
                    Spacer()
                    
                    Text("相手: \(gameLogic.opponentSymbol)")
                        .font(.title2)
                        .foregroundColor(!gameLogic.isMyTurn ? .red : .gray)
                }
                .padding(.horizontal)
                
                if gameLogic.gameOver {
                    Text(gameLogic.winner == "Draw" ? "引き分け!" : 
                         gameLogic.winner == gameLogic.mySymbol ? "あなたの勝ち!" : "相手の勝ち!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(gameLogic.winner == gameLogic.mySymbol ? .green : 
                                       gameLogic.winner == "Draw" ? .orange : .red)
                } else {
                    Text(gameLogic.isMyTurn ? "あなたのターン" : "相手のターン")
                        .font(.title2)
                        .foregroundColor(gameLogic.isMyTurn ? .blue : .red)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                    ForEach(0..<9) { index in
                        let row = index / 3
                        let col = index % 3
                        
                        Button(action: {
                            if gameLogic.makeMove(row: row, col: col) {
                                let move = GameMove(row: row, col: col, player: gameLogic.mySymbol)
                                multipeerService.sendMove(move)
                            }
                        }) {
                            Text(gameLogic.board[row][col])
                                .font(.system(size: 40, weight: .bold))
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                        }
                        .disabled(!gameLogic.isMyTurn || gameLogic.gameOver || !gameLogic.board[row][col].isEmpty)
                    }
                }
                .padding()
                
                if gameLogic.gameOver {
                    Button(action: {
                        gameLogic.resetGame()
                        multipeerService.sendGameReset()
                    }) {
                        Text("もう一度プレイ")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("三目並べ")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("戻る") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}