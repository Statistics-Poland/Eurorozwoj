import UIKit


extension MainViewController: GameManagerDelegate {
    func gameManager(showFindSurface manager: GameManager) {
        
    }
    func gameManager(_ manager: GameManager, enterSelectCountry country: Country, player: Player) {
        sceneView.showTopLbl(withText: "Kraj do zaznaczenai: \(country)")
        inSelectCountry = true
    }
    func gameManager(invalidCountrySelected manager: GameManager) {
        print("Potrząśij ekranem")
        
    }
    func gameManager(_ manager: GameManager, showData: QuestionData, for country: Country) {
            }
    
    
    func gameManager(_ manager: GameManager, askQuestionWithData showData: QuestionData, country: Country, player: Player) {
        var barNodes: [BarNodeType] = []
        let maxRealHeight: Double = 1.0
        for (index, data) in showData.values.enumerated() {
            print("data: \(data)")
            let barheight = ( maxRealHeight / (showData.maxValue - showData.minValue)) * (data - showData.minValue)
            let barNode = BarNodeType(name: "\(index)", value: data, barHight: CGFloat(barheight))
            print(barNode)
            barNodes.append(barNode)
        }
        showActive(country: country, barNodes: barNodes)
        questionData = showData
        sceneView.showTopLbl(withText: showData.name)
        isShowingData = true
    }
    
    func gameManager(_ manager: GameManager, switchTo player: Player) {
        print("zmien gracza")
        
        let alert: UIAlertController = UIAlertController(
            title: nil,
            message: "Przekaż telefon do \(player.name)",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let cancel: UIAlertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel) {
            _ -> Void in
            manager.playerWasSwitched()
        }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func gameManager(_ manager: GameManager, delegateWorkers player: Player, country: Country) {
        print("ustaw pracowników")
    }
    func gameManager(endTurn manager: GameManager) {
        print("koniec tury")
    }
    func gameManager(endGame manager: GameManager) {
        print("koniec gry")
    }
}
