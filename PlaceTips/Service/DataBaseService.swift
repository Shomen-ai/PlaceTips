import Foundation
import CoreLocation

class DataBaseService {
    
    static let shared = DataBaseService()
    
    func getData(city: String, completion: @escaping (Result<[Places], Errors>) -> Void) {
        
        let url = "https://firestore.googleapis.com/v1/projects/placetips-492f2/databases/(default)/documents/\(city)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            guard let data = data, error == nil else {
                fatalError("Data not found.")
            }
            print(data.debugDescription)
            let response = try? JSONDecoder().decode(ResponseData.self, from: data)
            if let data = response?.responseData {
                    print(data)
                    completion(.success(data))
            } else {
                completion(.failure(Errors.responseError("Response wasn't fetched")))
            }

        }.resume()
    }
}

