import CoreLocation
import Firebase
import FirebaseStorage
import Foundation

class DBManager {
    static let shared = DBManager()
    // Заполнение массива places
    var places: [Place] = []
    var favPlaces: [Place] = []
    var userData: User = User()
    
    
    
    // Получение мест
    func getPlacesData(cityName: String, completion: @escaping ([Place]) -> Void) {
        let db = Firestore.firestore()
        db.collection(cityName).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.places.append(Place(id: document["id"] as! String,
                                             lon: document["lon"] as! Double,
                                             lat: document["lat"] as! Double,
                                             placeName: document["placeName"] as! String,
                                             other: document["other"] as? String))
                }
                completion(self.places)
            }
        }
    }

    // Получение данных пользователя
    func getUserData(userUID: String, completion: @escaping (User) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userUID)

        docRef.addSnapshotListener { snapshot, error in
            if error == nil {
                guard let data = snapshot?.data() else { return }
                self.userData = User(email: data["email"] as! String,
                                     favoriets: data["favorites"] as! [String: Any],
                                     imageURL: data["image"] as! String,
                                     login: data["login"] as! String,
                                     password: data["password"] as! String)
                self.getImage(url: self.userData.imageURL) { image in
                    self.userData.image = image
                }
                completion(self.userData)
                print(data)
            } else {
                completion(self.userData)
            }
        }
    }

    // получение картинки
    func getImage(url: String, completion: @escaping (UIImage) -> Void) {
        let ref = Storage.storage().reference(forURL: url)
        let megaByte = Int64(1*1024*1024)
        ref.getData(maxSize: megaByte) { data, _ in
            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            completion(image!)
        }
    }

    // загрузка картинки
    func uploadImage(id: String, photo: UIImage, path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child(path).child(id)

        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
}
