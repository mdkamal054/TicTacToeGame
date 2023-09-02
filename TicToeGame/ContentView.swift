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
                            
                            if isSquareOccupied(in: moves, forIndex: i){return}
                            
                            moves[i] = Move(palyer:.human, boardIndex: i)
                            
                            // check for win condition or draw
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPos = determentComputerMovePosition(in: moves)
                                
                                moves[computerPos] = Move(palyer:.computer, boardIndex: computerPos)
                            }
                            
                           
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
        }
            
           
        
       
    }
    
    
    func isSquareOccupied(in moves:[Move?], forIndex index:Int)-> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determentComputerMovePosition(in moves:[Move?])-> Int{
        var movePos = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePos){
        movePos = Int.random(in: 0..<9)
        }
        
        return movePos
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
