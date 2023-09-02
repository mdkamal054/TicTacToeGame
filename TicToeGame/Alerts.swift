//
//  Alerts.swift
//  TicToeGame
//
//  Created by Osama Kamal on 03/09/23.
//

import SwiftUI

struct AlertItem :Identifiable{
    let id = UUID()
    var title:Text
    var message:Text
    var buttonTitle:Text
}

struct AlertContex{
   static let humanWin = AlertItem(title: Text("You Win"), message: Text("You are so smart. You beat your own AI"),
                             buttonTitle: Text("Hell Yeah") )
    
   static let computerWin = AlertItem(title: Text("You Lost"), message: Text("You lost. You program a super AI"),
                                buttonTitle: Text("Rematch"))
    
   static let draw = AlertItem(title: Text("Draw"), message: Text("what a battle"),
                         buttonTitle: Text("Try Again"))
}
