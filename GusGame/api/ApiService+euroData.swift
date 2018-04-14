import Foundation
import PromiseKit
import ObjectMapper


extension ApiService {
  func getFishingData() -> Promise<Table<Double>> {
    return request(url: "\(baseUrl)/tag00076?precision=1&species=F00&fishreg=0&unit=TLW&filterNonGeo=1&shortLabel=1&groupedIndicators=1&unitLabel=label") {
        (jsonStr: String) -> Table<Double> in
        
        return try Table<Double>(JSONString: jsonStr)
    }
  }
}
