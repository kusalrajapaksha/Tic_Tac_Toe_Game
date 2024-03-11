//
//  ContentView.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-10.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rotationAngle: Double = 0.0
    
    @State var toggleAngle = false
    @State var showGameView = false
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.black.opacity(0.8).ignoresSafeArea()
                
                VStack{
                    animatedTitle
                    Spacer().frame(height: 50)
                    newGameView
                    
                    //--Navigation link to Game View
                    NavigationLink(
                        destination: GameView(),
                        isActive: $showGameView
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
    }
}

extension ContentView{
    var animatedTitle: some View{
        Text("Tic-Tac-Toe")
            .font(.custom(CustomFont.ubuntuBold, size: 50))
            .foregroundStyle(Color.pink)
           
            .background(
                ZStack {
                    Text("Tic-Tac-Toe")
                        .font(.custom(CustomFont.ubuntuBold, size: 50))
                        .foregroundStyle(Color.white)
                        .offset(x: 1, y: 1)
                }
            )
            .rotation3DEffect(
                .degrees( toggleAngle ? 30 : -30),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            .onAppear {
                if !showGameView{
                    withAnimation(Animation.spring(duration: 1).repeatForever(autoreverses: true)) {
                        toggleAngle.toggle()
                    }
                }
                
            }
    }
    
    var newGameView: some View{
        Group{
            HStack{
                Text("Play with AI")
                Image(systemName: "play.fill")
            }
            .foregroundColor(.white)
            .padding()
            
            Text("New Game")
                .font(.custom(CustomFont.ubuntuBold, size: 20))
                .padding()
                .background(Color.primary)
                .foregroundColor(.white)
                .cornerRadius(16)
                .onTapGesture {
                    showGameView.toggle()
                }
        }
    }
}

#Preview {
    ContentView()
}
