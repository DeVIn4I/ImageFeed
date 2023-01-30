import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private let profileImageView = UIImageView(image: .profileImage).withConstraints()
    private let profileNameLabel = UILabel(text: "", font: .ysBold(23))
    private let loginNameLabel = UILabel(text: "", textColor: .ypGray)
    private let profileDescription = UILabel(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateProfileInfo(profile: profileService.profile)
    }
    
    private func updateProfileInfo(profile: ProfileService.Profile?) {
        profileNameLabel.text = profile?.name ?? ""
        loginNameLabel.text = profile?.loginName ?? ""
        profileDescription.text = profile?.bio
    }

    //Общий метод для отображения всех View на экране
    func setupUI() {
        
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
                                                                   loginNameLabel,
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
    
    //Заглушка для настройки кнопки. Пока не используется
    @objc
    private func didTapLogoutButton() {}
    
}
