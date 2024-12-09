import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class TrainerProfileManager {
    private let db = Firestore.firestore()

     let storage = Storage.storage()

    
    // Upload a single image
    func uploadImage(image: UIImage, userID: String, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference().child("trainerPhotos/\(userID)/\(UUID().uuidString).jpg")
        print("Storage Path: \(storageRef.fullPath)")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }
        print("Uploading image with size: \(imageData.count) bytes")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                let nsError = error as NSError
                       // Detailed error logging
                       print("Error uploading image: \(nsError.localizedDescription)")
                      
                       // If available, provide extra details
                       if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                           print("Underlying Error: \(underlyingError.localizedDescription)")
                       }
                       completion(nil)
                       return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                print("Download URL fetched: \(url?.absoluteString ?? "nil")")
                completion(url?.absoluteString)
            }
        }
    }
    
    // Upload multiple images
    func uploadImages(images: [UIImage], userID: String, completion: @escaping ([String]) -> Void) {
        var uploadedUrls: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            dispatchGroup.enter()
            uploadImage(image: image, userID: userID) { url in
                if let url = url {
                    uploadedUrls.append(url)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All images uploaded. URLs: \(uploadedUrls)")
            completion(uploadedUrls)
        }
    }
    
    // Save trainer profile data to Firestore
    func saveProfileData(userID: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        print("Saving trainer data: \(data)")
        db.collection("trainers").document(userID).setData(data) { error in
            if let error = error {
                print("Error saving data to Firestore: \(error.localizedDescription)")
            } else {
                print("Data saved to Firestore successfully")
            }
            completion(error)
        }
    }
}

