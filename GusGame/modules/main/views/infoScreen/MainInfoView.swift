//
//  MainInfoView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit



class MainInfoView: BasicView {
    
    
    let infoView: InfoView = InfoView()
    
//    let playerSummary: PositionView = PositionView()
        let playerSummary: SummaryView = SummaryView()
    
    let players: PlayersView = PlayersView()
    
    override func initialize() {
        
        self.addSubview(players)
        
        self.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(playerSummary)
        playerSummary.translatesAutoresizingMaskIntoConstraints = false
        playerSummary.isHidden = true
        
        
        infoView.scrollLbl.text = instruction
        let infoHeight = self.frame.width * 0.75
        let infoWidth = self.frame.height * 0.6
        infoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true
        infoView.widthAnchor.constraint(equalToConstant: infoWidth).isActive = true
        
        
        playerSummary.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerSummary.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playerSummary.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        playerSummary.widthAnchor.constraint(equalToConstant: 200).isActive = true

        layoutIfNeeded()
        
        self.backgroundColor = .yellow
        
    }
    
    
}

let instruction: String = """
Zasady gry:\n
▰4 graczy;\n
▰Każdy gracz posiada 100 pracowników;\n
▰6 Rynków(Krajów) do zagospodarowania;\n
▰Każdy z graczy w jednej turze może delegować maksymalnie 15 pracowników;\n
▰ Wygrywa gracz który zajął największą liczbę państw;\n
▰Państwo zajmuje gracz z największą liczbą pracowników na danym terytorium po wszystkich turach.\n
▰Gracze rywalizują pomiędzy sobą w turowym muliplayerze na jedno urządzenie;\n
▰Każdy gracz po delegowaniu pracowników na dane pole otrzymuje do poglądu trzy statystki w formie histogramów oraz nazwę statystyki;\n
▰Następnie zadaniem gracza jest poprawnie określenie lat dla każdego z trzech prostopadłościanów histogramu, czyli danej statystyki i danego państwa;\n
▰Gra toczy się, aż ostatni z graczy wyśle wszystkich swoich pracowników. \n
▰Dodatkowy element służący do nauki na początku każdej tury: \n
– wskazanie przez każdego kolejnego gracza rozpoczynającego turę właściwego państwa. \n
Ile punktów dostaje gracz:\n
▰Za 3 poprawne odpowiedzi - liczba pracowników razy 2\n
▰Za 1 poprawną odpowiedź - liczba pracowników taka ja wydelegowana na początku\n
▰Za 0 poprawnych odpowiedzi – liczba pracowników zmniejszona o połowę.\n
"""
