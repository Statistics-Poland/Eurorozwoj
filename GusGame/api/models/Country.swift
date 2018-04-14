import Foundation


enum Country: String, Hashable, CustomStringConvertible {
    case andorra =              "AD"
    case albania =              "AL"
    case armenia =              "AM"
    case austria =              "AU"
    case azerbaijan =           "AZ"
    case bosniaAndHerzegovina = "BA"
    case belgium =              "BE"
    case bulgaria =             "BG"
    case belarus =              "BY"
    case switzerland =          "CH"
    case cyprus =               "CY"
    case czechRepublic =        "CZ"
    case germany =              "DE"
    case denmark =              "DK"
    case estonia =              "EE"
    case greece =               "EL"
    case spain =                "ES"
    case finland =              "FI"
    case france =               "FR"
    case georgia =              "GE"
    case croatia =              "HR"
    case hungary =              "HU"
    case ireland =              "IE"
    case iceland =              "IS"
    case italy =                "IT"
    case liechtenstein =        "LI"
    case lithuania =            "LT"
    case luxembourg =           "LU"
    case latvia =               "LV"
    case monaco =               "MC"
    case moldova =              "MD"
    case republicOfMacedonia =  "MK"
    case malta =                "MT"
    case netherlands =          "NL"
    case norway =               "NO"
    case poland =               "PL"
    case portugal =             "PT"
    case romania =              "RO"
    case serbia =               "RS"
    case russia =               "RU"
    case sweden =               "SE"
    case slovenia =             "SI"
    case slovakia =             "SK"
    case sanMarino =            "SM"
    case turkey =               "TR"
    case ukraine =              "UA"
    case unitedKingdom =        "UK"
    
    
    init?(code: String) {
        self.init(rawValue: code.uppercased())
    }
    
    
    var description: String {
        return NSLocalizedString("country_\(self.rawValue)", tableName: "Localization", comment: "country name")
    }
}
