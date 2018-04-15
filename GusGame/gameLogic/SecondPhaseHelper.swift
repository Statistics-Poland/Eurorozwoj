import Foundation


class SecondPhaseHelper {
    private var dataSets: [Table<Double>] = []
    
    init(dataSets: [Table<Double>]) {
        self.dataSets = dataSets
    }
    
    func getDataFor(country: Country) -> Table<Double> {
        let index: Int = Int(arc4random_uniform(UInt32(dataSets.count)))
        return dataSets[index]
    }
    
    func getValues(table: Table<Double>, country: Country) -> (
            data: [(year: Int, value: Double)],
            maxValue: Double
        ) {
        
        let data: [(year: Int, value: Double)] = [
            (2009, table.valueFor(country: country, year: 2009).value ?? 0.0),
            (2012, table.valueFor(country: country, year: 2012).value ?? 0.0 ),
            (2015, table.valueFor(country: country, year: 2015).value ?? 0.0),
        ]
        let maxValue: Double = fmax(data[0].value, fmax(data[1].value, data[2].value))
        return (data, maxValue)
    }
}
