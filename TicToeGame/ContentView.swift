//
//  ContentView.swift
//  TicToeGame
//
//  Created by Osama Kamal on 03/09/23.
//

import SwiftUI



struct ContentView: View {
    
    
    let columns:[GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    
    @State private var moves:[Move?] = Array(repeating: nil, count: 9)
    @State private var isHumansTurn = true
    
    var body: some View {
        
        GeometryReader{geometry in
            
            VStack{
                Spacer()
                LazyVGrid(columns: columns,spacing: 5){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3-15,height: geometry.size.width/3-15)
                            
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40,height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            moves[i] = Move(palyer: isHumansTurn ? .human : .computer, boardIndex: i)
                            
                            isHumansTurn.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
        }
            
           
        
       
    }
}

enum Player{
    case human,computer
}

struct Move{
    let palyer:Player
    let boardIndex:Int
    
    var indicator:String{
        return palyer == .human ? "xmark" : "circle"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
