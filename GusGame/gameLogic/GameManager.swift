import Foundation


protocol GameManagerDelegate: class {
    func gameManager(showFindSurface manager: GameManager)
    func gameManager(_ manager: GameManager, enterSelectCountry country: Country, player: Player)
    func gameManager(invalidCountrySelected manager: GameManager)
    func gameManager(_ manager: GameManager, showData: QuestionAnswer, for country: Country)
    func gameManager(_ manager: GameManager, askQuestionWithData data: QuestionData, country: Country, player: Player)
    func gameManager(_ manager: GameManager, switchTo player: Player)
    func gameManager(_ manager: GameManager, delegateWorkers player: Player, country: Country)
    func gameManager(endTurn manager: GameManager, winners: [Player], country: Country)
    func gameManager(endGame manager: GameManager)
}


class GameManager {
    let game: Game
    
    weak var delegate: GameManagerDelegate?
    
    private var previousFindPhase: FindCountryPhase!
    private var previousPresentData: PresentDataPhase!
    private var previousQuestion: QuestionPhase! {
        didSet {
            print("ustawiam")
        }
    }
    private var previousPlayer: NextPlayerPhase!
    private var previousPutworkers: PutWorkersPhase!
    private var previousEndTurn: EndTurnPhase!
    
    
    init(dataSet: [Table<Double>]) {
        game = MutableGame(dataSet: dataSet)
    }
    
    
    func start() {
        delegate?.gameManager(showFindSurface: self)
    }
    
    func mapWasPlaced() {
        handle(phase: game.start())
    }
    
    
    func selected(country: Country) {
        let nextPhase: Phase = previousFindPhase.select(country: country)
        
        if country != previousFindPhase.country {
            delegate?.gameManager(invalidCountrySelected: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.handle(phase: nextPhase)
            }
        } else {
            self.handle(phase: nextPhase)
        }
    }
    
    func dataWasPresented() {
        self.handle(phase: previousPresentData.commit())
    }
    
    func playerWasSwitched() {
        self.handle(phase: previousPlayer.confirm())
    }
    
    func putWorkers(_ count: Int) {
//        print("lel")
        self.handle(phase: previousPutworkers.put(count))
        
    }
    
    func answer(_ answer: [(year: Int, value: Double)]) {
        print(previousQuestion != nil)
        self.handle(phase: previousQuestion.answer(answer: answer))
    }
    
    func turnEnded() {
        self.handle(phase: previousEndTurn.commit())
    }
    
    
    private func handle(phase: Phase) {
        if let find: FindCountryPhase = phase as? FindCountryPhase {
            handle(findCountry: find)
        } else if let present: PresentDataPhase = phase as? PresentDataPhase {
            handle(presenrData: present)
        } else if let put: PutWorkersPhase = phase as? PutWorkersPhase {
            handle(putWorkers: put)
        } else if let question: QuestionPhase = phase as? QuestionPhase {
            handle(question: question)
        } else if let next: NextPlayerPhase = phase as? NextPlayerPhase {
            handle(nextPerson: next)
        } else if let endTurn: EndTurnPhase = phase as? EndTurnPhase {
            handle(endTurn: endTurn)
        } else if let endgame: EndGamePhase = phase as? EndGamePhase {
            handle(endGame: endgame)
        } else {
            fatalError("won't happen")
        }
    }
    
    
    private func handle(findCountry phase: FindCountryPhase) {
        previousFindPhase = phase
        delegate?.gameManager(self, enterSelectCountry: phase.country, player: phase.player)
    }
    
    
    private func handle(presenrData phase: PresentDataPhase) {
        previousPresentData = phase
        delegate?.gameManager(self, showData: phase.questionAnswer, for: phase.country)
    }
    
    private func handle(question phase: QuestionPhase) {
        previousQuestion = phase
        delegate?.gameManager(self, askQuestionWithData: phase.questionData, country: phase.country, player: phase.player)
    }
    
    private func handle(nextPerson phase: NextPlayerPhase) {
        previousPlayer = phase
        delegate?.gameManager(self, switchTo: phase.player)
    }
    
    private func handle(putWorkers phase: PutWorkersPhase) {
        previousPutworkers = phase
        delegate?.gameManager(self, delegateWorkers: phase.player, country: phase.country)
    }
    
    
    private func handle(endTurn phase: EndTurnPhase) {
        previousEndTurn = phase
        delegate?.gameManager(endTurn: self, winners: phase.winners, country: phase.country)
    }
    
    private func handle(endGame phase: EndGamePhase) {
        delegate?.gameManager(endGame: self)
    }
}
