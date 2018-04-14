import Foundation


class TableConverter<TRow: Hashable, TCol: Hashable> {
  static func convert<T>(rows: [TRow : Int], colums: [TCol: Int], data: [T]) -> [TRow: [TCol: T]] {
    var result: [TRow: [TCol: T]] = [:]
    for (rowVal, row) in rows {
      var rowData: [TCol: T] = [:]
      for (colVal, col) in colums {
        rowData[colVal] = data[getIndex(row: row, col: col, columns: colums.count)]
      }
      result[rowVal] = rowData
    }
    return result
  }
  
  private static func getIndex(row: Int, col: Int, columns: Int) -> Int {
    return col + (row * columns)
  }
}
