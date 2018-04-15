import Foundation
import UIKit


fileprivate var lastId: Int = 0


fileprivate let  names: [String] = [
    "Krzysiek",
    "Mateusz",
    "Paweł",
    "Tomek"
]


fileprivate let __colors: [UIColor] = [
    #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
    #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
    #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),
    #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
]

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
        self.name = names[id]
        self.color = __colors[id]
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
