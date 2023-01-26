import UIKit

final class ProfileViewController: UIViewController {
    
    let token = OAuth2TokenStorage().token
    let profileService = ProfileService()
    
    let profileImageView = UIImageView(image: .profileImage).withConstraints()
    let profileNameLabel = UILabel(text: "", font: .ysBold(23))
    let userNameLabel = UILabel(text: "", textColor: .ypGray)
    let profileDescription = UILabel(text: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchProfile()
        
    }
    //Общий метод для отображения всех View на экране
    func setupUI() {
        
        //Отображение изображения профиля
        view.addSubview(profileImageView)
        
        //Проверка на наличие изображения для кнопки Logout. Если ее нет, метод ничего не отобразит, но в консоль напечатает из-за чего это произошло.
        let buttonImage = UIImage(named: "ProfileExitImage")
        guard let buttonImage else {
            print("Ошибка загрузки изображения для кнопки Logout")
            return
        }
        
        //Настройка кнопки выхода из профиля
        let button = UIButton.systemButton(with: buttonImage,
                                           target: self,
                                           action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        //Настройка StackView для всех Label(Имя, Ник, Описание)
        let profileLabelStackView = UIStackView(arrangedSubviews: [profileNameLabel,
                                                                   userNameLabel,
                                                                   profileDescription])
        profileLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabelStackView)
        profileLabelStackView.spacing = 8
        profileLabelStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo:  profileImageView.centerYAnchor ),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            profileLabelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileLabelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileLabelStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    func fetchProfile() {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.update(profile: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(profile: ProfileService.Profile) {
        profileNameLabel.text = profile.name
        userNameLabel.text = profile.loginName
        profileDescription.text = profile.bio
    }
    
    //Заглушка для настройки кнопки. Пока не используется
    @objc
    private func didTapLogoutButton() {}
}

extension UIImage {
    static let profileImage = UIImage(named: "ProfilePhoto")
}

extension UIView {
    func withConstraints(_ with: Bool = true) -> Self {
        translatesAutoresizingMaskIntoConstraints = !with
        return self
    }
}

extension UIFont {
    static func ysRegular(_ size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansDisplay-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func ysBold(_ size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansDisplay-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
}

extension UILabel {
    static func label(text: String? = nil,
                      textColor: UIColor = .ypWhite,
                      font: UIFont = .ysRegular(13)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        
        return label
    }
    convenience init(text: String? = nil,
                     textColor: UIColor = .ypWhite,
                     font: UIFont = .ysRegular(13),
                     withConstraints: Bool = true) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        translatesAutoresizingMaskIntoConstraints = !withConstraints
    }
}
