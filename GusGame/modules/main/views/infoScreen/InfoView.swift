//
//  InfoScrollView.swift
//  GusGame
//
//  Created by Tomasz Lizer on 15/04/2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit

class InfoView: BasicView {
    
    
    private let button: TextControl = {
        let button: TextControl = TextControl()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
        button.text = "OK"
        
        return button
    }()
    
    
     var scrollLbl: ScrollLabel = {
        let scrollLbl: ScrollLabel = ScrollLabel()
        scrollLbl.translatesAutoresizingMaskIntoConstraints = false
    
       return scrollLbl
    }()
    

    @objc func dismissView() {
        UIView.animate(withDuration: 0.3, delay: 0.1,
                       animations: {
                        self.alpha = 0.0
                        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3) },
                       completion: {_ in self.removeFromSuperview()})
        
    }
    
    override func initialize() {
        super.initialize()
        self.addSubview(scrollLbl)
        self.addSubview(button)
        addButtonConstraints()
        addScrollLblConstraints()
        setView()
        popAnimation()
    }
    
    func setView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        self.alpha = 0.0
        self.isHidden = true
    }
    
    func addScrollLblConstraints () {
        
        scrollLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
        scrollLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        scrollLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        scrollLbl.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true
    }
    
    func addButtonConstraints () {

        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func popAnimation() {
        self.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 2.5, options: [],
                       animations: {
                        self.transform = CGAffineTransform.identity
                        self.alpha = 1.0 }, completion: nil)
    }
    
}

//fileprivate var instructionTitle: NSAttributedString = {
//    
//   return in
//}()
let instruction: String = """
Zasady gry:\n
▰4 graczy;\n
▰Każdy gracz posiada 100 pracowników;\n
▰6 Rynków(Krajów) do zagospodarowania;\n
▰Każdy z graczy w jednej turze może delegować maksymalnie 20 pracowników;\n
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
