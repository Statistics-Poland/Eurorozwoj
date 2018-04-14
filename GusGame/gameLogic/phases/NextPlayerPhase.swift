import Foundation


final class NextPlayerPhase: Phase {
    let player: Player
    private let nextPhase: Phase
    
    init(player: Player, nextPhase: Phase, game: MutableGame) {
        self.player = player
        self.nextPhase = nextPhase
        super.init(game: game)
    }
    
    func confirm() -> Phase {
        return nextPhase
    }
}
