import Foundation


class PresentDataPhase: Phase {
    let country: Country
    let table: Table<Double>
    let questionAnswer: QuestionAnswer
    
    init(table: Table<Double>, country: Country, game: MutableGame) {
        
        self.table = table
        self.country = country
        self.questionAnswer = QuestionAnswer(table: table, country: country)
        super.init(game: game)
    }
    
    
    func commit() -> Phase {
        let nextPlayer: Player = game.firstPlayer()
        
        let winners: [Player] = game.endTurn()
        return NextPlayerPhase(
            player: nextPlayer,
            nextPhase: EndTurnPhase(winners: winners, country: country, game: game),
            game: game
        )
    }
}
