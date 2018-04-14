import Foundation


final class PutWorkersPhase: Phase {
    let country: Country
    let player: Player
    
    init(country: Country, player: Player, game: MutableGame) {
        self.country = country
        self.player = player
        super.init(game: game)
    }
    
    
    func put(_ workers: Int) -> Phase {
        game.putWorkers(on: country, player: player, count: workers)
        if let nextPlayer: Player = game.player(after: player) {
            let putWorkersPhase: Phase = PutWorkersPhase(country: country, player: nextPlayer, game: game)
            return NextPlayerPhase(player: nextPlayer, nextPhase: putWorkersPhase, game: game)
        } else {
            let nextPlayer: Player = game.firstPlayer()
            
            let questionPhase: Phase = PresentDataPhase(
                table: game.getTable(for: country),
                country: country,
                game: game
            )
            return NextPlayerPhase(
                player: nextPlayer,
                nextPhase: questionPhase,
                game: game
            )
        }
    }
}