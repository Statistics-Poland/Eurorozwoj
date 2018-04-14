import Foundation
import RxSwift


class Game {
    var players: Observable<[Player]> { get { fatalError("todo") } }
    
    
    
    func start() -> Phase {
        fatalError("to override")
    }
}
