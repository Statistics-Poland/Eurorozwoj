import Foundation


class PresentDataPhase: Phase {
    let country: Country
    let table: Table<Double>
    let questionData: QuestionData
    
    init(table: Table<Double>, country: Country, game: MutableGame) {
        
        self.table = table
        self.country = country
        self.questionData = QuestionData(table: table, country: country)
        super.init(game: game)
    }
    
    
    func commit() -> Phase {
        return QuestionPhase(table: table, country: country, player: game.firstPlayer(), game: game)
    }
}
