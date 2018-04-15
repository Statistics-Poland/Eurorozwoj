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
    
    
    func getShityData1() -> Promise<Table<Double>> {
        return request(url: "\(baseUrl)/tec00115?precision=1&na_item=B1GQ&unit=CLV_PCH_PRE") {
            (jsonStr: String) -> Table<Double> in
            var table: Table<Double> = try Table<Double>(JSONString: jsonStr)
            table.name = "Wzrost PKB"
            return table
        }
    }
    
    
    func getShityData2() -> Promise<Table<Double>> {
        return request(url: "\(baseUrl)/demo_gind?precision=1&indic_de=GROW") {
            (jsonStr: String) -> Table<Double> in
            var table: Table<Double> = try Table<Double>(JSONString: jsonStr)
            table.name = "Przyrost ludności"
            return table
        }
    }
    
    
    func getShityData3() -> Promise<Table<Double>> {
        return request(url: "\(baseUrl)/isoc_ci_ifp_fu?indic_is=I_IDAY&precision=1&unit=PC_IND&ind_type=Y0_15") {
            (jsonStr: String) -> Table<Double> in
            var table: Table<Double> = try Table<Double>(JSONString: jsonStr)
            table.name = "Procentowe użycie internetu przez młodzież i dzieci przed 15 rokiem życia"
            return table
        }
    }
    
    func getAllShityData() -> Promise<[Table<Double>]> {
        return when(fulfilled: [getShityData1(), getShityData2(), getShityData3()])
    }
    
    
}
