import Foundation


class MutableGame: Game {
    /// give bonus
    func addWorkers(to: Player, count: Int) {
        print("Todo")
    }
    
    /// puts workers of given player on given country
    func putWorkers(on country: Country, player: Player, count: Int) {
        print("TODO")
    }
    
    /// aplays answers
    func applyAnswerBonus(correctAnnswers: Int, country: Country, player: Player) {
        print("TODO")
    }
    
    
    /// gives next player, and updates players queue
    func player(after player: Player) -> Player? {
        fatalError("todo")
    }
    
    /// gives first player and  generates new player queue
    func firstPlayer() -> Player {
        fatalError("todo")
    }
    
    
    
    /// returns dataset for given country
    func getTable(for country: Country) -> Table<Double> {
        fatalError("todo")
    }
    
    
    
    /// returns next country and updates state
    func getNextCountry() -> Country? {
        fatalError("todo")
    }
    
    
    func endTurn() {
        print("TODO")
    }
    
    override func start() -> Phase {
        let country: Country = getNextCountry()!
        return FindCountryPhase(country: country, player: firstPlayer(), game: self)
    }
}
