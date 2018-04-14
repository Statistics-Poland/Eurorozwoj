import Foundation
import Alamofire
import PromiseKit


class ApiService {
  let baseUrl: String = "http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en"
  private let alamofireManager: SessionManager
  static let shared: ApiService = ApiService()
  
  private init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5 // seconds
    configuration.timeoutIntervalForResource = 5
    self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
  }
  
  
  func request<T>(url: URLConvertible, parser: @escaping (String) throws -> T) -> Promise<T> {
    return stringRequest(url: url, retrys: 5).map {
      return try  parser($0)
    }
  }
  
  
  private func stringRequest(url: URLConvertible, retrys: Int) -> Promise<String> {
    return alamofireManager.request(url).responseString().map {
      $0.string
    }.recover {
      (error: Error) -> Promise<String> in
      if retrys > 0 {
        return self.stringRequest(url: url, retrys: retrys - 1)
      }
      return Promise<String>(error: error)
      }
  }
}

