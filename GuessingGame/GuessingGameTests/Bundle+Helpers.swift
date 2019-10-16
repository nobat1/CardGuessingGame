import Foundation

extension Bundle {
    
    func getDataFromJSON(in fileName: String) -> Data? {
        guard let path = path(forResource: fileName, ofType: "json"),
            let string = try? String.init(contentsOfFile: path),
            let data = string.data(using: .utf8) else { return nil }
        return data
    }
}
