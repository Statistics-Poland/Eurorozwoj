import Foundation
import UIKit


fileprivate var lastId: Int = 1

struct Player: Equatable, Hashable {
    private let id: Int
    var name: String
    var color: UIColor
    var points: Int { return countries.count }
    var workers: Int
    
    var countries: [Country]
    
    init(name: String, color: UIColor) {
        self.id = lastId
        lastId += 1
        self.name = name
        self.color = color
        self.workers = 100
        self.countries = []
    }
    
    // MARK: Equatable
    static func ==(_ lhs: Player, _ rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: Hashable
    var hashValue: Int { return id.hashValue }
}
