import Foundation


final class FindCountryPhase: Phase {
    let country: Country
    let player: Player
    let bonus: Int
    
    init(country: Country, player: Player, game: MutableGame, bonus: Int = 5) {
        self.country = country
        self.player = player
        self.bonus = bonus
        super.init(game: game)
    }
    
    
    func select(country: Country) -> Phase {
        if self.country == country {
            game.addWorkers(to: player, count: bonus)
        }
        
        return QuestionPhase(table: game.getTable(for: country), country: self.country, player: player, game: game)
    }
    
    
}
