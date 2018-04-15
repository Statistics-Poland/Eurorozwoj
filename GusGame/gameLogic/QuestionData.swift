import Foundation


struct QuestionData {
    let name: String
    let values: [Double]
    let years: [Int]
    let maxValue: Double
    let minValue: Double
    
    init(table: Table<Double>, country: Country) {
        name = table.name
        let years: [Int] = [2009, 2012, 2015]
        print("todo polosowac")
        values = years.map {
            table.valueFor(country: country, year: $0).value!
        }
        self.years = years.sorted()
        maxValue = fmax(values[0], fmax(values[1], values[2]))
        minValue = fmin(fmin(values[0], Double(0.0)), fmin(values[1], values[2]))
    }
}


struct QuestionAnswer {
    let name: String
    let values: [(value: Double, year: Int)]
//    let years: [Int]
    let maxValue: Double
    let minValue: Double
    
    init(table: Table<Double>, country: Country) {
        name = table.name
        values = [2009, 2012, 2015].map { (table.valueFor(country: country, year: $0).value!, $0) }

        maxValue = fmax(values[0].value, fmax(values[1].value, values[2].value))
        minValue = fmin(fmin(values[0].value, Double(0.0)), fmin(values[1].value, values[2].value))
    }
}
