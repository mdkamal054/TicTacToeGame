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
    
    @State private var isGameBoardDisabled = false
    @State private var alertItem:AlertItem?
    
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
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContex.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves){
                                alertItem = AlertContex.draw
                                return
                            }
                            
                            // we are disabling gameboard until computer moves
                            isGameBoardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPos = determentComputerMovePosition(in: moves)
                                
                                moves[computerPos] = Move(palyer:.computer, boardIndex: computerPos)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContex.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    alertItem = AlertContex.draw
                                    return
                                }
                            }
                            
                           
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                
                
                Alert(title: alertItem.title,message: alertItem.message,dismissButton: .default(alertItem.buttonTitle,action: {
                    resetGame()
                }))
                
            })
            
        }
            
           
        
       
    }
    
    
    func isSquareOccupied(in moves:[Move?], forIndex index:Int)-> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    
    // if AI can win then win
    // if AI can't win , then block
    // if AI can't block , then take middle square
    // if AI can't take middle square , take random available square
    
    func determentComputerMovePosition(in moves:[Move?])-> Int{
        
        // if AI can win then win
        
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],
                                          [0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap{$0}.filter{$0.palyer == .computer}
        let computerPos = Set(computerMoves.map { $0.boardIndex})
        
        for pattern in winPatterns {
            let winPos = pattern.subtracting(computerPos)
            if winPos.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPos.first!)
                if isAvailable {return winPos.first!}
            }
        }
        
        
        // if AI can't win , then block
        
        let humanMoves = moves.compactMap{$0}.filter{$0.palyer == .human}
        let humanPos = Set(humanMoves.map { $0.boardIndex})
        
        for pattern in winPatterns {
            let winPos = pattern.subtracting(humanPos)
            if winPos.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPos.first!)
                if isAvailable {return winPos.first!}
            }
        }
        
        
        // if AI can't block , then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        // if AI can't take middle square , take random available square
        var movePos = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePos){
        movePos = Int.random(in: 0..<9)
        }
        
        return movePos
    }
    
    func checkWinCondition(for player:Player, in moves:[Move?])-> Bool{
        
        // this is possible win possition
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],
                                          [0,4,8],[2,4,6]]
        
        // checking player moves and position
        let playerMoves = moves.compactMap{$0}.filter{$0.palyer == player}
        let playerPos = Set(playerMoves.map { $0.boardIndex})
        
        // if pattern match we show win or draw or lose dialog
        for pattern in winPatterns where pattern.isSubset(of: playerPos){return true}
        
        return false
    }
    
    func checkForDraw(in moves :[Move?]) -> Bool{
        return moves.compactMap{$0}.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
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
