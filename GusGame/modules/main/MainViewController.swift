import UIKit
import PromiseKit


class MainViewController: BasicViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ApiService.shared.getFishingData().done {
      (table: Table<Double>) in
      print(table.valueFor(country: Country.cyprus, year: 2015))
    }.catch {
      (error: Error) in
      print(error)
    }
  }
}

