import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import GooglePlaces
import FirebaseAuth
import Foundation


class TrainerProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate {
    // Properties
    let sexTextField = UITextField()
    let ageTextField = UITextField()
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    let experienceTextField = UITextField()
    let priceTextField = UITextField()
    
    private let profileManager = TrainerProfileManager()
    
    
    let sexPicker = UIPickerView()
    let agePicker = UIPickerView()
    let heightPicker = UIPickerView()
    let weightPicker = UIPickerView()
    let pricePikcer = UIPickerView()
    let experiencePikcer = UIPickerView()
    let locationButton = UIButton(type: .system)
    let DateButton = UIButton(type: .system)
    
    
    let sexes = ["Male", "Female"]
    let ages = Array(18...65).map { "\($0)" }
    let heights = Array(150...220).map { "\($0)" }
    let weights = Array(40...100).map { "\($0)" }
    let price = Array(100...300).map { "\($0)" }
    let experience = Array(0...20).map { "\($0)" }
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var uploadedImageURLs: [String] = []
    private var selectedLocation: String?
    var unavailableDates: [Date] = []
    let childProgressView = ProgressSpinnerViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyDhcRgTLWiSqgW7FhdBXMTXkhETsLuBU4A")
        
        
        setupLocationButton()
        setupDateButton()
    
        
        
        self.view = TrainerProfileView(frame: self.view.frame, controller: self)
        
        setupGestureToDismissPickers()
        
        if let currentUser = Auth.auth().currentUser {
               print("User is authenticated: \(currentUser.uid)")
               fetchProfileData(userID: currentUser.uid) // Fetch and populate data
               self.setupRightBarButton()
           } else {
               print("User is not authenticated")
               // Allow empty fields for new input
           }
        
        
        
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
    }
    
  

    private func fetchProfileData(userID: String) {
        db.collection("trainers").document(userID).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching trainer data: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.populateFields(with: data)
            } else {
                print("No trainer data found for user.")
            }
        }
    }
    
    @objc func openUnavailableDates() {
          let unavailableDatesVC = UnavailableDatesViewController()
          unavailableDatesVC.delegate = self
          unavailableDatesVC.preselectedDates = unavailableDates
          navigationController?.pushViewController(unavailableDatesVC, animated: true)
      }

    private func populateFields(with data: [String: Any]) {
        sexTextField.text = data["sex"] as? String
        ageTextField.text = data["age"] as? String
        heightTextField.text = data["height"] as? String
        weightTextField.text = data["weight"] as? String
        experienceTextField.text = data["experience"] as? String
        priceTextField.text = data["price"] as? String
        selectedLocation = data["location"] as? String
        locationButton.setTitle(selectedLocation, for: .normal)
        DateButton.setTitle("unavalible date selected", for: .normal)

        // If images are available, load them
        if let imageUrls = data["images"] as? [String] {
            loadImages(from: imageUrls)
        }
        disableEditing()
    }
    
    private func disableEditing() {
        sexTextField.isUserInteractionEnabled = false
        ageTextField.isUserInteractionEnabled = false
        heightTextField.isUserInteractionEnabled = false
        weightTextField.isUserInteractionEnabled = false
        experienceTextField.isUserInteractionEnabled = false
        priceTextField.isUserInteractionEnabled = false
        locationButton.isUserInteractionEnabled = false

        // Disable interaction with image placeholders
        if let trainerProfileView = self.view as? TrainerProfileView {
            for imageView in trainerProfileView.pictureHolders {
                imageView.isUserInteractionEnabled = false
            }
        }
        setTextFieldAppearance(isEditable: false)
    }


    // Load images from URLs into placeholders
    private func loadImages(from urls: [String]) {
        guard let trainerProfileView = self.view as? TrainerProfileView else { return }

        for (index, url) in urls.enumerated() {
            guard index < trainerProfileView.pictureHolders.count else { break }
            let imageView = trainerProfileView.pictureHolders[index]
            // Load image asynchronously (e.g., using SDWebImage or similar library)
            DispatchQueue.global().async {
                if let imageUrl = URL(string: url), let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }
    }


    func setupLocationButton() {
        locationButton.setTitle("Tap to select location", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.backgroundColor = UIColor.white
        locationButton.layer.borderWidth = 0.5
        locationButton.layer.borderColor = UIColor.lightGray.cgColor
        locationButton.layer.cornerRadius = 5
        locationButton.contentHorizontalAlignment = .left
        locationButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal) // Add an icon
        locationButton.tintColor = .gray // Tint the icon color
     
        // Add target action for button tap
        locationButton.addTarget(self, action: #selector(showLocationPicker), for: .touchUpInside)

        // Enable Auto Layout
        locationButton.translatesAutoresizingMaskIntoConstraints = false

        // Add locationButton to its parent view
       
    }
    
    func setupDateButton() {
        DateButton.setTitle("Select unavailable dates", for: .normal)
        DateButton.setTitleColor(.black, for: .normal)
        DateButton.backgroundColor = UIColor.white
        DateButton.layer.borderWidth = 0.5
        DateButton.layer.borderColor = UIColor.lightGray.cgColor
        DateButton.layer.cornerRadius = 5
        DateButton.contentHorizontalAlignment = .left
        DateButton.setImage(UIImage(systemName: "calendar.badge.minus"), for: .normal) // Add an icon
        DateButton.tintColor = .gray // Tint the icon color
     
        // Add target action for button tap
        DateButton.addTarget(self, action: #selector(openUnavailableDates), for: .touchUpInside)

        // Enable Auto Layout
        DateButton.translatesAutoresizingMaskIntoConstraints = false

        // Add locationButton to its parent view
       
    }

    func openImagePicker(for imageView: UIImageView) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .popover
        imagePicker.popoverPresentationController?.sourceView = imageView
        present(imagePicker, animated: true)
    }

    // Handle the image picker result
 
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let tappedImageView = picker.popoverPresentationController?.sourceView as? UIImageView {
            tappedImageView.image = selectedImage // 将选中的图片存储到对应的占位符
        }
        dismiss(animated: true, completion: nil)
    }



    @objc private func showLocationPicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func saveProfileInfo(_ sender: UIButton) {
        // 打印每个值，检查其是否为 nil 或无效
        showActivityIndicator()
        print("Sex: \(sexTextField.text ?? "nil")")
        print("Age: \(ageTextField.text ?? "nil")")
        print("Height: \(heightTextField.text ?? "nil")")
        print("Weight: \(weightTextField.text ?? "nil")")
        print("Experience: \(experienceTextField.text ?? "nil")")
        print("Price: \(priceTextField.text ?? "nil")")
        print("Location: \(selectedLocation ?? "nil")")

        guard let userID = Auth.auth().currentUser?.uid,
              let user = Auth.auth().currentUser,
              let name = user.displayName,
              let sex = sexTextField.text, !sex.isEmpty,
              let age = ageTextField.text, !age.isEmpty,
              let height = heightTextField.text, !height.isEmpty,
              let weight = weightTextField.text, !weight.isEmpty,
              let experience = experienceTextField.text, !experience.isEmpty,
              let price = priceTextField.text, !price.isEmpty,
              let location = selectedLocation else {
            print("Please fill all fields.")
            return
        }

        // 打印通过 guard 的字段值
        print("All fields are valid. Proceeding to save...")

        let trainerData: [String: Any] = [
            "name":name,
            "trainerId":userID,
            "sex": sex,
            "age": age,
            "height": height,
            "weight": weight,
            "experience": experience,
            "price": price,
            "location": location
        ]
        // 收集用户选择的图片
        guard let trainerProfileView = self.view as? TrainerProfileView else {
                fatalError("TrainerProfileView not set as self.view")
            }

            print("Pictures Stack View: \(trainerProfileView.picturesStackView ?? nil)") // 检查是否为 nil

        func collectUserImages() -> [UIImage] {
            guard let trainerProfileView = self.view as? TrainerProfileView else { return [] }
         

            let placeholderImage = UIImage(systemName: "photo.badge.plus")!

            // 明确指定返回值类型为 [UIImage]
            guard let trainerProfileView = self.view as? TrainerProfileView else {
                fatalError("Expected view to be of type TrainerProfileView")
            }
            let images: [UIImage] = trainerProfileView.picturesStackView.arrangedSubviews.compactMap { subview in
                guard let imageView = subview as? UIImageView, imageView.image != placeholderImage else { return nil }
                print("Collected image: \(String(describing: imageView.image))")
                return imageView.image
                
            }
            
            print("Collected images: \(images.count)") // 调试输出
            return  images

        }



        // 上传图片并保存数据
        let images = collectUserImages()
        profileManager.uploadImages(images: images, userID: userID) { [weak self] imageUrls in
            guard let self = self else { return }

            var updatedData = trainerData
            updatedData["images"] = imageUrls

            self.profileManager.saveProfileData(userID: userID, data: updatedData) { error in
                if let error = error {
                    print("Error saving trainer info: \(error.localizedDescription)")
                } else {
                    print("Trainer info saved successfully")
                    self.hideActivityIndicator()
                    self.navigateToChatViewController()
                }
            }
        }
        
    }
    func navigateToChatViewController() {
        let chatVC = ChatViewController()
        self.navigationController?.pushViewController(chatVC, animated: true)
    }


    
    
    // Add gesture recognizer to dismiss pickers
    private func setupGestureToDismissPickers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPickers))
        tapGesture.cancelsTouchesInView = false // Allows other views to receive touches
        self.view.addGestureRecognizer(tapGesture)
    }

    // Dismiss the active picker or input field
    @objc private func dismissPickers() {
        print("Tap detected, dismissing picker...")

        self.view.endEditing(true)
    }
    @objc func enableEditing() {
        // Enable editing for all fields
        sexTextField.isUserInteractionEnabled = true
        ageTextField.isUserInteractionEnabled = true
        heightTextField.isUserInteractionEnabled = true
        weightTextField.isUserInteractionEnabled = true
        experienceTextField.isUserInteractionEnabled = true
        priceTextField.isUserInteractionEnabled = true
        locationButton.isUserInteractionEnabled = true

        // Enable interaction with picture placeholders
        if let trainerProfileView = self.view as? TrainerProfileView {
            for imageView in trainerProfileView.pictureHolders {
                imageView.isUserInteractionEnabled = true
            }
        }

        print("Editing enabled")
        setTextFieldAppearance(isEditable: true)
    }
    private func setTextFieldAppearance(isEditable: Bool) {
        let backgroundColor: UIColor = isEditable ? .white : UIColor.systemGray6
        let textColor: UIColor = isEditable ? .black : UIColor.darkGray
        let borderStyle: UITextField.BorderStyle = isEditable ? .roundedRect : .none
        let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Configure for sexTextField
        sexTextField.backgroundColor = backgroundColor
        sexTextField.textColor = textColor
        sexTextField.borderStyle = borderStyle
        sexTextField.layer.borderWidth = isEditable ? 1 : 0
        sexTextField.layer.cornerRadius = isEditable ? 8 : 0
        sexTextField.font = font
        
        // Configure for ageTextField
        ageTextField.backgroundColor = backgroundColor
        ageTextField.textColor = textColor
        ageTextField.borderStyle = borderStyle
        ageTextField.layer.borderWidth = isEditable ? 1 : 0
        ageTextField.layer.cornerRadius = isEditable ? 8 : 0
        ageTextField.font = font
        
        // Configure for heightTextField
        heightTextField.backgroundColor = backgroundColor
        heightTextField.textColor = textColor
        heightTextField.borderStyle = borderStyle
        heightTextField.layer.borderWidth = isEditable ? 1 : 0
        heightTextField.layer.cornerRadius = isEditable ? 8 : 0
        heightTextField.font = font
        
        // Configure for weightTextField
        weightTextField.backgroundColor = backgroundColor
        weightTextField.textColor = textColor
        weightTextField.borderStyle = borderStyle
        weightTextField.layer.borderWidth = isEditable ? 1 : 0
        weightTextField.layer.cornerRadius = isEditable ? 8 : 0
        weightTextField.font = font
        
        // Configure for experienceTextField
        experienceTextField.backgroundColor = backgroundColor
        experienceTextField.textColor = textColor
        experienceTextField.borderStyle = borderStyle
        experienceTextField.layer.borderWidth = isEditable ? 1 : 0
        experienceTextField.layer.cornerRadius = isEditable ? 8 : 0
        experienceTextField.font = font
        
        // Configure for priceTextField
        priceTextField.backgroundColor = backgroundColor
        priceTextField.textColor = textColor
        priceTextField.borderStyle = borderStyle
        priceTextField.layer.borderWidth = isEditable ? 1 : 0
        priceTextField.layer.cornerRadius = isEditable ? 8 : 0
        priceTextField.font = font
        
        // Configure locationButton appearance
        locationButton.backgroundColor = backgroundColor
        locationButton.setTitleColor(textColor, for: .normal)
        locationButton.layer.borderWidth = isEditable ? 1 : 0
        locationButton.layer.cornerRadius = isEditable ? 8 : 0
    }





    

 

    // MARK: - UIPickerView Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sexPicker: return sexes.count
        case agePicker: return ages.count
        case heightPicker: return heights.count
        case weightPicker: return weights.count
        case pricePikcer: return price.count
        case experiencePikcer: return experience.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sexPicker: return sexes[row]
        case agePicker: return ages[row]
        case heightPicker: return heights[row]
        case weightPicker: return weights[row]
        case experiencePikcer: return experience[row]
        case pricePikcer: return price[row]
        default: return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sexPicker:
            sexTextField.text = sexes[row]
        case agePicker:
            ageTextField.text = "\(ages[row]) years old"
        case heightPicker:
            heightTextField.text = "\(heights[row]) cm"
        case weightPicker:
            weightTextField.text = "\(weights[row]) kg"
        case experiencePikcer:
            experienceTextField.text = "\(experience[row]) years of experience"
        case pricePikcer:
            priceTextField.text = "\(price[row]) USD per hour"
        default:
            break
        }
        self.view.endEditing(true) // Dismiss picker after selection
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension TrainerProfileViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("didAutocompleteWith place called")
        print("Selected place: \(place.name ?? "No name")")
        selectedLocation = place.formattedAddress ?? place.name
        locationButton.setTitle(selectedLocation, for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("didFailAutocompleteWithError called")
        print("Autocomplete Error: \(error.localizedDescription)")
        print("Error details: \(error)")
        print("Autocomplete Error: \(error.localizedDescription)")
          if let error = error as NSError? {
              print("Error code: \(error.code)")
              print("Error domain: \(error.domain)")
              print("Error userInfo: \(error.userInfo)")
          }
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("wasCancelled called")
        dismiss(animated: true, completion: nil)
    }
}

extension TrainerProfileViewController: UnavailableDatesDelegate {
    func didUpdateUnavailableDates(_ dates: [Date]) {
        self.unavailableDates = dates
        saveUnavailableDates(dates)
        if !dates.isEmpty {
                 DateButton.setTitle("Unavailable Dates Selected", for: .normal)
             } else {
                 DateButton.setTitle("Select Unavailable Dates", for: .normal)
             }
    }
    
    private func saveUnavailableDates(_ dates: [Date]) {
        guard let trainerId = Auth.auth().currentUser?.uid else { return }
        
        let unavailableDatesData = dates.map { Timestamp(date: $0) }
        
        db.collection("availability").document(trainerId).setData(["unavailableDates": unavailableDatesData]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                // 如果保存失败，弹出错误提示框
                self.showAlert(title: "Error", message: "Failed to save unavailable dates: \(error.localizedDescription)")
            } else {
                // 如果保存成功，弹出成功提示框
                self.showAlert(title: "Success", message: "Unavailable dates saved successfully!")
            }
        }
    }

    // 添加一个用于显示 Alert 的方法
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}


