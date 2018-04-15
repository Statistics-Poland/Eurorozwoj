import Foundation


final class QuestionPhase: Phase {
    private let table: Table<Double>
    let country: Country
    let player: Player
    let questionData: QuestionData
    
    init(table: Table<Double>, country: Country, player: Player, game: MutableGame) {
        self.table = table
        self.country = country
        self.player = player
        self.questionData = QuestionData(table: table, country: country)
        super.init(game: game)
    }
    
    
    func answer(answer: [(year: Int, value: Double)]) -> Phase {
        let correctAnswers: Int = answer.reduce(0) {
            (result: Int, element: (year: Int, vlaue: Double)) -> Int in
            if element.vlaue == self.table.valueFor(country: self.country, year: element.year).value {
                return result + 1
            }
            return result
        }
        game.applyAnswerBonus(correctAnnswers: correctAnswers, country: country, player: player)
        
        if let nextPlayer: Player = game.player(after: player) {
            
            let questionPhase: Phase = QuestionPhase(table: table, country: country, player: nextPlayer, game: game)
            return NextPlayerPhase(player: nextPlayer, nextPhase: questionPhase, game: game)
        } else {
            let nextPlayer: Player = game.firstPlayer()
            let putPhase: Phase = PutWorkersPhase(country: country, player: nextPlayer, game: game)
            return NextPlayerPhase(player: nextPlayer, nextPhase: putPhase, game: game)
        }
        
    }
}
