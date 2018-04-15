import Foundation
import RxSwift


class MutableGame: Game {
    private let _players: Variable<[Player]>
    private let countriesHelper: CountriesHelper = CountriesHelper()
    
    override var players: Observable<[Player]> {
        return _players.asObservable()
    }
    
    private var currentCountry: Country?
    private var poligon: [Player: Int]?
    private var modifiers: [Player: Int] = [:]
    private let dataSet: [Table<Double>]
    
    
    init(players: Int = 2, dataSet: [Table<Double>]) {
        let players: [Player] = (0 ..< players).map {
            Player(name: "Player \($0)", color: UIColor.app.black)
        }
        _players = Variable<[Player]>(players)
        self.dataSet = dataSet
    }
    
    /// give bonus
    func addWorkers(to player: Player, count: Int) {
        if let index: Int = _players.value.index(of: player) {
            _players.value[index].workers += count
        }
        
    }
    
    /// puts workers of given player on given country
    func putWorkers(on country: Country, player: Player, count: Int) {
        guard country == currentCountry else { fatalError() }
        guard let index: Int = _players.value.index(of: player) else { fatalError() }
        _players.value[index].workers -= count
        let previousValue: Int = poligon?[player] ?? 0
        
        poligon?[player] = previousValue + count
    }
    
    /// aplays answers
    func applyAnswerBonus(correctAnnswers: Int, country: Country, player: Player) {
        guard country == currentCountry else { fatalError() }
        
        
        switch correctAnnswers {
        case 0: modifiers[player] = -1
        case 1: modifiers[player] = 0
        default: modifiers[player] = 1
        }
        
    }
    
    
    /// gives next player, and updates players queue
    func player(after player: Player) -> Player? {
        guard let index: Int = _players.value.index(of: player) else { return nil }
        guard index + 1 < _players.value.count else { return nil }
        return _players.value[(index + 1)]
    }
    
    
    /// gives first player and  generates new player queue
    func firstPlayer() -> Player {
        return _players.value[0]
    }
    
    
    /// returns dataset for given country
    func getTable(for country: Country) -> Table<Double> {
        let index: Int = Int(arc4random_uniform(UInt32(dataSet.count)))
        return dataSet[index]
    }
    
    
    
    /// returns next country and updates state
    func getNextCountry() -> Country? {
        currentCountry = countriesHelper.getRandomCountry()
        if currentCountry != nil {
            poligon = [:]
            modifiers = [:]
        } else {
            poligon = nil
            modifiers = [:]
        }
        return currentCountry
    }
    
    
    func endTurn() -> [Player] {
        guard var poligon: [Player: Int] = poligon else { return [] }
        guard let country: Country = currentCountry else { return [] }
        for (player, modifier) in modifiers {
            if modifier == -1 {
                poligon[player] = poligon[player]! / 2
            } else if modifier == 1 {
                poligon[player] = poligon[player]! * 2
            }
        }
        
        
        var maxWorkers: Int = 0
        for (_, workers) in poligon {
            maxWorkers = max(workers, maxWorkers)
        }
        var result: [Player] = []
        for (player, workers) in poligon {
            if workers == maxWorkers {
                if let index: Int = _players.value.index(of: player) {
                    _players.value[index].countries.append(country)
                    result.append(_players.value[index])
                }
            }
        }
        return result
    }
    
    override func start() -> Phase {
        let country: Country = getNextCountry()!
        return FindCountryPhase(country: country, player: firstPlayer(), game: self)
    }
}
