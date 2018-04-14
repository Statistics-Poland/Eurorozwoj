import Foundation


/// class that handles logic of first phase for every game
class CountriesHelper {
    // just to be sure that every element isn't duplicated
    private static let _countries: Set<Country> = [
        Country.austria,
        Country.bosniaAndHerzegovina,
        Country.belgium,
        Country.bulgaria,
        Country.cyprus,
        Country.czechRepublic,
        Country.germany,
        Country.denmark,
        Country.estonia,
        Country.greece,
        Country.spain,
        Country.finland,
        Country.france,
        Country.hungary,
        Country.ireland,
        Country.italy,
        Country.lithuania,
        Country.latvia,
        Country.poland,
        Country.portugal,
        Country.romania,
        Country.sweden,
        Country.slovenia,
        Country.slovakia,
        Country.unitedKingdom
    ]
    
    // it's easier to get random element form array than set
    private var countries: [Country] = Array<Country>(CountriesHelper._countries)
    
    
    func getRandomCountry() -> Country? {
        guard countries.count > 0 else { return nil }
        let index: Int = Int(arc4random_uniform(UInt32(countries.count)))
        return countries.remove(at: index)
    }
    
    
}
