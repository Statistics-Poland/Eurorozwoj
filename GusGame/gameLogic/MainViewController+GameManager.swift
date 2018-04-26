import UIKit


extension MainViewController: GameManagerDelegate {
    func gameManager(showFindSurface manager: GameManager) {
//        sceneView.showBottomBtn(withText: "Start")
    }
    func gameManager(_ manager: GameManager, enterSelectCountry country: Country, player: Player) {
        addSelectCountryTapGestureToSceneView()
        
        sceneView.showTopLbl(withText: R.string.game_select_country[country])
        inSelectCountry = true
    }
    func gameManager(invalidCountrySelected manager: GameManager) {
        sceneView.showTopLbl(withText: R.string.game_select_country_invalid^)
        sceneView.layer.add(Animations.shakeAnimation, forKey: "shakeItBycz")
        
    }
    func gameManager(_ manager: GameManager, showData: QuestionAnswer, for country: Country) {
        print("XDDDDDDDDDD")
        sceneView.hideWorkers()
        addBarInfosWithYears(data: showData.values)
        sceneView.showBottomBtn(withText: R.string.game_end_turn_btn^)
        turnEnd = true 
    }
    
    func gameManager(_ manager: GameManager, askQuestionWithData showData: QuestionData, country: Country, player: Player) {
        var barNodes: [BarNodeType] = []
        let maxRealHeight: Double = 2.0
        for (index, data) in showData.values.enumerated() {
            print("data: \(data)")
            let barheight = ( maxRealHeight / (showData.maxValue - showData.minValue)) * (data - showData.minValue)
            let barNode = BarNodeType(name: "\(index)", value: data, barHight: CGFloat(barheight), color: colors[index])
            print(barNode)
            barNodes.append(barNode)
        }
        showActive(country: country, barNodes: barNodes)
        questionData = showData
        sceneView.showTopLbl(withText: showData.name)
        
    }
    
    func gameManager(_ manager: GameManager, switchTo player: Player) {
        print("zmien gracza")
        let alert: UIAlertController = UIAlertController(
            title: nil,
            message: R.string.game_change_player_text[player.name],
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let cancel: UIAlertAction = UIAlertAction(title: R.string.game_change_confirm_btn^, style: UIAlertActionStyle.cancel) {
            _ -> Void in
            manager.playerWasSwitched()
        }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func gameManager(_ manager: GameManager, delegateWorkers player: Player, country: Country) {
        if let gest = gestureBarRecognizer {
            sceneView.removeGestureRecognizer(gest)
        }
        sceneView.showWorkers(player: player)
        print("ustaw pracowników")
    }
    func gameManager(endTurn manager: GameManager, winners: [Player], country: Country) {
        hideActive(country: country)
        setColor(for: country, color: winners.first?.color ?? UIColor.blue)
        sceneView.hideBottomBtn()
        isActive = false
    }
    
    func gameManager(endGame manager: GameManager, players: [Player]) {
        let playersHEH = players.sorted(by: { $0.points > $1.points })
        var heh: [(Player, Int)] = []
        for (index, player) in playersHEH.enumerated() {
            heh.append((player, index + 1))
        }
          sceneView.showSummary(players: heh)
    }
}
