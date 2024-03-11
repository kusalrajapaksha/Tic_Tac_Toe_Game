//
//  GameView.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-10.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.8).ignoresSafeArea()
            
            GameOverOverlayView(viewModel: viewModel, presentationMode: presentationMode)
            
            GeometryReader{ geometry in
                
                VStack{
                    Spacer()
            
                    PointsView(viewModel: viewModel)
                    
                    LazyVGrid(columns: viewModel.columns,spacing: 5, content: {
                        ForEach(0..<9) { index in
                            ZStack{
                                GameCicleView(proxy: geometry)
                                PlayerIndicatorView(systemName: viewModel.moves[index]?.indicator ?? "")
                            }
                            .scaleEffectAnimationOnTap(onTapAction: {
                                withAnimation(.spring) {
                                    viewModel.processPlayerMove(for: index)
                                }
                            }, scaleTo: 0.8)
                        }
                    })
                    
                    Spacer()
                    
                    Text("Your turn")
                        .font(.custom(CustomFont.ubuntuRegular, size: 24))
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .opacity(viewModel.showYourTurn ? 1 : 0)
                }
                .disabled(viewModel.gameBoardDisabled)
                .padding(.horizontal, 16)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonText, action: {
                        viewModel.resetGameRound()
                    }))
                }
            }
        }
        
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.resetGame()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.white)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                })
            }

        })
        
    }
    
    
}

#Preview {
    GameView()
}

struct GameCicleView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .fill(Color.pink)
            .shadow(color:  .black, radius: 2, x: 2, y: 2)
    }
}

struct PlayerIndicatorView: View {
    
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 40,height: 40)
            .foregroundColor(.white)
    }
}

struct PointsView: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        HStack{
            VStack{
                Text("AI")
                    .font(.custom(CustomFont.ubuntuRegular, size: 16))
                    .foregroundStyle(Color.white)

                Text("Points - \(viewModel.computerPoints)")
                    .font(.custom(CustomFont.ubuntuRegular, size: 20))
                    .bold()
                    .foregroundStyle(Color.white)
                
            }
            
            
            Spacer()
            
            VStack{
                Text("You")
                    .font(.custom(CustomFont.ubuntuRegular, size: 16))
                    .foregroundStyle(Color.white)

                Text("Points - \(viewModel.humanPoints)")
                    .font(.custom(CustomFont.ubuntuRegular, size: 20))
                    .bold()
                    .foregroundStyle(Color.white)
            }
            
        }.padding()
    }
}

struct GameOverOverlayView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea().opacity(0.5)
                .animation(.bouncy)
                .opacity(viewModel.gameOver ? 1 : 0)
            
            VStack{
                Text(viewModel.humanPoints == 3 ? "You won!!!" : "You Lost :(")
                    .font(.custom(CustomFont.ubuntuBold, size: 32))
                
                    .foregroundColor(viewModel.humanPoints == 3 ? .green : .yellow)
                    .animation(.spring())
                    .padding()
                    .background(.black)
                    .cornerRadius(16)
                    .animation(.easeInOut)
                    .offset(y: viewModel.gameOver ? 0 : -UIScreen.main.bounds.height)
                
                HStack{
                    Button(action: {
                        $presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(.custom(CustomFont.ubuntuRegular, size: 16))
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(8)
                    })
                    
                    Button(action: {
                        viewModel.resetGame()
                    }, label: {
                        Text("Reset")
                            .font(.custom(CustomFont.ubuntuRegular, size: 16))
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                }
                .animation(.easeInOut)
                .offset(y: viewModel.gameOver ? 0 : UIScreen.main.bounds.height)
            }
            
        }
        .zIndex(4)
    }
}
