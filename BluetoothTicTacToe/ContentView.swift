import SwiftUI

struct ContentView: View {
    @StateObject private var multipeerService = MultipeerService()
    @StateObject private var gameLogic = GameLogic()
    @State private var showingGame = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Bluetooth 三目並べ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if multipeerService.connectedPeers.isEmpty {
                    VStack(spacing: 20) {
                        Button(action: {
                            multipeerService.startHosting()
                            gameLogic.setPlayerSymbol("X", isHost: true)
                        }) {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("ゲームを作成")
                            }
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            multipeerService.joinGame()
                            gameLogic.setPlayerSymbol("O", isHost: false)
                        }) {
                            HStack {
                                Image(systemName: "person.badge.clock")
                                Text("ゲームに参加")
                            }
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 20) {
                        Text("接続済み: \(multipeerService.connectedPeers.first?.displayName ?? "")")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Button(action: {
                            showingGame = true
                        }) {
                            HStack {
                                Image(systemName: "gamecontroller")
                                Text("ゲーム開始")
                            }
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Bluetooth 三目並べ")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingGame) {
            GameView(gameLogic: gameLogic, multipeerService: multipeerService)
        }
        .alert("ゲーム招待", isPresented: $multipeerService.gameInviteReceived) {
            Button("参加") {
                gameLogic.setPlayerSymbol("O", isHost: false)
                showingGame = true
            }
            Button("拒否", role: .cancel) {}
        } message: {
            Text("\(multipeerService.invitingPeer?.displayName ?? "Unknown")からゲーム招待が届きました")
        }
    }
}