import Foundation
import ObjectMapper



struct Table<T>: ImmutableMappable {
    private let values: [Country: [Int: Value<T>]]
    
    var name: String = "TODO implement table name"
    
    init(map: Map) throws {
        let status: [String: String] = try map.value("status")
        let values: [String: T] = try map.value("value")
        
        var count: Int = 0
        for (key, _) in status {
            if let i: Int = Int(key) {
                count = max(i, count)
            }
        }
        for (key, _) in values {
            if let i: Int = Int(key) {
                count = max(i, count)
            }
        }
        count = count + 1
        var _data: [Value<T>?] = [Value<T>?](repeating: nil, count: count)
        
        for (key, _) in status {
            if let i: Int = Int(key) {
                _data[i] = Value<T>.unknown
            }
        }
        
        for (key, value) in values {
            if let i: Int = Int(key) {
                
                let value: Value<T> = Value<T>.value(val: value)
                if let exist: Value<T> = _data[i] {
                    _data[i] = exist.merge(with: value)
                } else {
                    _data[i] = value
                }
            }
        }
        let data: [Value<T>] = _data.map {
            $0 ?? Value<T>.unknown
        }
        let _rows: [String: Int] = try map.value("dimension.geo.category.index")
        var rows: [Country: Int] = [:]
        for (countryCode, index) in _rows {
            if let country: Country = Country(code: countryCode) {
                rows[country] = index
            }
        }
        let _columns: [String: Int] = try map.value("dimension.time.category.index")
        var columns: [Int: Int] = [:]
        for (year, index) in _columns {
            columns[Int(year)!] = index
        }
        self.values = TableConverter.convert(rows: rows, colums: columns, data: data)
    }
    
    func valueFor(country: Country, year: Int) -> Value<T> {
        return values[country]?[year] ?? Value<T>.unknown
    }
}
