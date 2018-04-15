import Foundation


final class EndTurnPhase: Phase {
    let winners: [Player]
    let country: Country
    
    init(winners: [Player], country: Country, game: MutableGame) {
        self.winners = winners
        self.country = country
        super.init(game: game)
    }
    
    func commit() -> Phase {
        if let country: Country = game.getNextCountry() {
            game.movefirstPlayer()
            let nextPlayer: Player = game.firstPlayer()
            let find: Phase = FindCountryPhase(country: country, player: nextPlayer, game: game)
            return NextPlayerPhase(player: nextPlayer, nextPhase: find, game: game)
        }
        return EndGamePhase(game: game)
    }
}
