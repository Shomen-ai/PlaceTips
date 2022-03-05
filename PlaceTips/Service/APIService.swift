import Firebase
import FirebaseDatabase
import FirebaseStorage
import Foundation
import UIKit

public enum NetworkError: Error {
    case dbError

    var errorDescription: String {
        switch self {
            case .dbError:
                return "DB Error"
        }
    }
}

public class APIService {
    public static let shared = APIService()
    
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String, docName: String, completion: @escaping (Result<Cities, Error>) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument(completion: { document, error in
//            guard error == nil else { completion(nil); return}
//            let doc = Cities(russia: document?.get("Russia") as! [String])
//            completion(doc)
            if let error = error {
                completion(.failure(error))
            } else {
                guard let cities = document?.get("Russia") as? [String] else {
                    completion(.failure(NetworkError.dbError))
                    return
                }
                completion(.success(Cities(russia: cities)))
            }
        })
    }
    
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathRef = reference.child("Images")
        
        var image = UIImage(named: "default_pic")!
        
        let fileRef = pathRef.child(picName + ".jpeg")
        fileRef.getData(maxSize: 1024 * 1024, completion: { data, error in
            guard error == nil else { completion(image); return }
            image = UIImage(data: data!)!
            completion(image)
        })
    }
