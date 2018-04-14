import Foundation


final class EndTurnPhase: Phase {
    func commit() -> Phase {
        game.endTurn()
        if let country: Country = game.getNextCountry() {
            return FindCountryPhase(country: country, player: game.firstPlayer(), game: game)
        }
        return EndGamePhase(game: game)
    }
}
