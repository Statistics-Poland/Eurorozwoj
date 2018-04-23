import Foundation


extension R.string {
    subscript(country: Country) -> String {
        let argument: String = NSLocalizedString("\(rawValue)_country_\(country.rawValue)", comment: "")
        return self[argument]
    }
    
    subscript(_ arguments: CVarArg...) -> String {
        return String(format: self^, arguments: arguments)
    }
}


postfix operator ^

postfix func ^ (key: R.string) -> String {
    return NSLocalizedString(key.rawValue, comment: "")
}
