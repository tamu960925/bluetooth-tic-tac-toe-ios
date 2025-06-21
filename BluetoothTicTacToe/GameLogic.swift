import Foundation

class GameLogic: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var currentPlayer: String = "X"
    @Published var gameOver: Bool = false
    @Published var winner: String = ""
    @Published var isMyTurn: Bool = true
    @Published var mySymbol: String = "X"
    @Published var opponentSymbol: String = "O"
    
    init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .gameMove,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let move = notification.object as? GameMove {
                self?.processOpponentMove(move)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .gameMessage,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let message = notification.object as? GameMessage {
                self?.processGameMessage(message)
            }
        }
    }
    
    func makeMove(row: Int, col: Int) -> Bool {
        guard !gameOver && isMyTurn && board[row][col].isEmpty else {
            return false
        }
        
        board[row][col] = mySymbol
        
        if checkWinner() {
            gameOver = true
            winner = mySymbol
        } else if isBoardFull() {
            gameOver = true
            winner = "Draw"
        } else {
            isMyTurn = false
        }
        
        return true
    }
    
    private func processOpponentMove(_ move: GameMove) {
        guard !gameOver && !isMyTurn && board[move.row][move.col].isEmpty else {
            return
        }
        
        board[move.row][move.col] = opponentSymbol
        
        if checkWinner() {
            gameOver = true
            winner = opponentSymbol
        } else if isBoardFull() {
            gameOver = true
            winner = "Draw"
        } else {
            isMyTurn = true
        }
    }
    
    private func processGameMessage(_ message: GameMessage) {
        switch message.type {
        case .reset:
            resetGame()
        case .playerAssignment:
            if let assignment = message.data {
                mySymbol = assignment
                opponentSymbol = assignment == "X" ? "O" : "X"
                isMyTurn = mySymbol == "X"
            }
        }
    }
    
    private func checkWinner() -> Bool {
        for i in 0..<3 {
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] && !board[i][0].isEmpty {
                return true
            }
            if board[0][i] == board[1][i] && board[1][i] == board[2][i] && !board[0][i].isEmpty {
                return true
            }
        }
        
        if board[0][0] == board[1][1] && board[1][1] == board[2][2] && !board[0][0].isEmpty {
            return true
        }
        if board[0][2] == board[1][1] && board[1][1] == board[2][0] && !board[0][2].isEmpty {
            return true
        }
        
        return false
    }
    
    private func isBoardFull() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        gameOver = false
        winner = ""
        isMyTurn = mySymbol == "X"
    }
    
    func setPlayerSymbol(_ symbol: String, isHost: Bool) {
        if isHost {
            mySymbol = "X"
            opponentSymbol = "O"
            isMyTurn = true
        } else {
            mySymbol = "O"
            opponentSymbol = "X"
            isMyTurn = false
        }
    }
}