import XCTest
@testable import GusGame

class TableConverterTests: XCTestCase {
  func testConvert() {
    let data: [Int] = [0, 1, 2, 3, 4, 5]
    let rows: [Int: Int] = [
      15: 0,
      31312: 1,
      6: 2,
    ]
    let columns: [Int: Int] = [
      2012: 0,
      2013: 1,
    ]
    
    let table: [Int: [Int: Int]] = TableConverter.convert(rows: rows, colums: columns, data: data)
    
    XCTAssertEqual(table[15]?[2012], Optional<Int>(0))
    XCTAssertEqual(table[15]?[2013], Optional<Int>(1))
    XCTAssertEqual(table[31312]?[2012], Optional<Int>(2))
    XCTAssertEqual(table[31312]?[2013], Optional<Int>(3))
    XCTAssertEqual(table[6]?[2012], Optional<Int>(4))
    XCTAssertEqual(table[6]?[2013], Optional<Int>(5))
    
  }
}
