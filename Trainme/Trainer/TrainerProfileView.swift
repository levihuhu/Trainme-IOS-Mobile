import UIKit

class TrainerProfileView: UIView {
    
    public var picturesStackView: UIStackView!
    public var pictureHolders: [UIImageView] = [] //
 
    private weak var controller: TrainerProfileViewController?
    init(frame: CGRect, controller: TrainerProfileViewController) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.controller = controller
        setupUI(controller: controller)
        if picturesStackView == nil {
                  fatalError("picturesStackView was not initialized")
              }
       
    }

    required init?(coder: NSCoder) {
      
        fatalError("init(coder:) has not been implemented")
    }
  
    private func setupUI(controller: TrainerProfileViewController) {
        let sectionTitle = UILabel()
        sectionTitle.text = "Fill in Your Information Here"
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 20)
        sectionTitle.textAlignment = .center

      
        // Add icons to text fields
        configurePickerFieldWithIcon(controller: controller, textField: controller.sexTextField, picker: controller.sexPicker, placeholder: "Select your sex", iconName: "person.fill")
        configurePickerFieldWithIcon(controller: controller, textField: controller.ageTextField, picker: controller.agePicker, placeholder: "Select your age", iconName: "calendar")
        configurePickerFieldWithIcon(controller: controller, textField: controller.heightTextField, picker: controller.heightPicker, placeholder: "Select your height (cm)", iconName: "ruler")
        configurePickerFieldWithIcon(controller: controller, textField: controller.weightTextField, picker: controller.weightPicker, placeholder: "Select your weight (kg)", iconName: "scalemass")
        configurePickerFieldWithIcon(controller: controller, textField: controller.experienceTextField, picker: controller.experiencePikcer, placeholder: "Select your years of experience (years)", iconName: "briefcase.fill")
        configurePickerFieldWithIcon(controller: controller, textField: controller.priceTextField, picker: controller.pricePikcer, placeholder: "Select your desired price (dollars/hr)", iconName: "dollarsign.circle")

        controller.locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
         picturesStackView = createPicturesStackView()
        
        let saveButton = createButton(title: "Save Profile Info", action: #selector(controller.saveProfileInfo), controller: controller)
        saveButton.backgroundColor = .systemPink
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 0.1
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowRadius = 4
        let editButton = createButton(title: "Edit Profile", action: #selector(controller.enableEditing), controller: controller)
        editButton.backgroundColor = .systemBlue
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.cornerRadius = 10
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOpacity = 0.1
        editButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        editButton.layer.shadowRadius = 4
        
      

        // Stack View
        let stackView = UIStackView(arrangedSubviews: [
            sectionTitle,
         
            controller.sexTextField,
            controller.ageTextField,
            controller.heightTextField,
            controller.weightTextField,
            controller.experienceTextField,
            controller.priceTextField,
            controller.locationButton,
            controller.DateButton,
            picturesStackView,
         
            saveButton,
            editButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    private func createPicturesStackView() -> UIStackView {
          // Create the stack view to hold picture placeholders
        let picturesStackView = UIStackView()
        picturesStackView.axis = .horizontal
        picturesStackView.alignment = .center
        picturesStackView.distribution = .fillEqually
        picturesStackView.spacing = 15
        picturesStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add 4 placeholders
        for _ in 1...4 {
            let imageView = createPicturePlaceholder()
            pictureHolders.append(imageView)
            picturesStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 90), // Height of each placeholder
                imageView.widthAnchor.constraint(equalToConstant: 90) // Width of each placeholder
            ])

        }
        

        return picturesStackView
    }
    
    private func createPicturePlaceholder() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.badge.plus") // Placeholder image
       
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true // Enable interaction for uploading

        // Add a tap gesture recognizer for image picking
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePictureUpload(_:)))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }
    private func viewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    @objc private func handlePictureUpload(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        // Pass the selected imageView to the controller for image picking
        if let controller = self.controller as? TrainerProfileViewController {
            controller.openImagePicker(for: tappedImageView)
        }
    }
   
    private func configurePickerFieldWithIcon(controller: TrainerProfileViewController, textField: UITextField, picker: UIPickerView, placeholder: String, iconName: String) {
        picker.delegate = controller
        picker.dataSource = controller

        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .gray
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        textField.inputView = picker
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = icon
        textField.leftViewMode = .always

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func createButton(title: String, action: Selector, controller: TrainerProfileViewController) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(controller, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44) // Standard height for text fields
         ])
        return button
    }
}
