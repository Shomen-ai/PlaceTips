import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

public class APIService {
    public static let shared = APIService()
    
    public enum APIError: Error{
        case error(_ errorString: String)
    }
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String, docName: String, completion: @escaping (Cities?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument( completion: { (document, error) in
            guard error == nil else { completion(nil); return}
            let doc = Cities(Russia: document?.get("Russia") as! [String])
            completion(doc)
        })
    }
    
    func getImage(picName: String, completion: @escaping(UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathRef = reference.child("Images")
        
        var image: UIImage = UIImage(named: "default_pic")!
        
        let fileRef = pathRef.child(picName + ".jpeg")
        fileRef.getData(maxSize: 1024*1024, completion: { data, error in
            guard error == nil else { completion(image); return}
            image = UIImage(data: data!)!
            completion(image)
        })
    }
//    private func getJSON<T: Decodable>(urlString: String,
//                                      dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
//                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
//                                      completion: @escaping (Result<T, APIError>)->Void){
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
//            return
//        }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(.error("Error: \(error.localizedDescription)")))
//            }
//            guard let data = data else {
//                completion(.failure(.error(NSLocalizedString("Error: Data was corrupted.", comment: ""))))
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = dateDecodingStrategy
//            decoder.keyDecodingStrategy = keyDecodingStrategy
//            do {
//                let decodedData = try decoder.decode(T.self, from: data)
//                completion(.success(decodedData))
//                return
//            } catch let decodingError {
//                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
//                return
//            }
//        }.resume()
//    }
}


