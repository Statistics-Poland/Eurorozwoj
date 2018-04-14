import Foundation


struct QuestionData {
    let name: String
    let values: [Double]
    let years: [Int]
    let maxValue: Double
    
    init(table: Table<Double>, country: Country) {
        name = table.name
        let years: [Int] = [2009, 2012, 2015]
        print("todo polosowac")
        values = years.map {
            table.valueFor(country: country, year: $0).value!
        }
        self.years = years.sorted()
        maxValue = fmax(values[0], fmax(values[1], values[2]))
    }
}
