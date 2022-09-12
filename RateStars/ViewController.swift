import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Сreate a variable in which we will store the current rating Int
    private var selectedRate: Int = 0
    
    /// Adding a Selection Feedback effect to clicking on a star
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    // MARK: - User Interface
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 70
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate our service"
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .init(hexString: "#9b70b7")
        return label
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexString: "#ce6a8c")
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showAlertAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var starsContainer: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        /// Adding a UITapGestureRecognizer to our stack of stars to handle clicking on a star
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRate))
        stackView.addGestureRecognizer(tapGesture)
        
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStars()
        setupUI()
    }
    
    // MARK: - User Action
    
    @objc private func didSelectRate(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: starsContainer)
        let starWidth = starsContainer.bounds.width / CGFloat(Constants.starsCount)
        let rate = Int(location.x / starWidth) + 1
        
        /// if current star doesn't match selectedRate then we change our rating
        if rate != self.selectedRate {
            feedbackGenerator.selectionChanged()
            self.selectedRate = rate
        }
        
        /// loop through starsContainer arrangedSubviews and
        /// look for all Subviews of type UIImageView and change
        /// their isHighlighted state (icons depend on it)
        starsContainer.arrangedSubviews.forEach { subview in
            guard let starImageView = subview as? UIImageView else {
                return
            }
            starImageView.isHighlighted = starImageView.tag <= rate
        }
    }
    
    @objc private func showAlertAction() {
        let alert = UIAlertController(title: "Info",
                                      message: "Thank you very much for your feedback! \nWe value everyone and strive to be better.",
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Close", style: .default)
        
        alert.addAction(okayAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    
    private func createStars() {
        /// loop through the number of our stars and add them to the stackView (starsContainer)
        for index in 1...Constants.starsCount {
            let star = makeStarIcon()
            star.tag = index
            starsContainer.addArrangedSubview(star)
        }
    }
    
    private func makeStarIcon() -> UIImageView {
        /// declare default icon and highlightedImage
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_unfilled_star"), highlightedImage: #imageLiteral(resourceName: "icon_filled_star"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    private func setupUI() {
        /// Bonus: Adding a Pulsation Animation to our Button
        sendButton.addPulsationAnimation()
        
        view.backgroundColor = .init(hexString: "#ffd5c2")
        
        /// container
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.containerHorizontalInsets).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.containerHorizontalInsets).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        /// star container
        starsContainer.translatesAutoresizingMaskIntoConstraints = false
        starsContainer.heightAnchor.constraint(equalToConstant: Constants.starContainerHeight).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.heightAnchor.constraint(equalToConstant: Constants.sendButtonHeight).isActive = true
        
        /// ArrangedSubview
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(starsContainer)
        container.addArrangedSubview(sendButton)
    }
    
    // MARK: - Constants {
    
    private struct Constants {
        static let starsCount: Int = 5
        
        static let sendButtonHeight: CGFloat = 50
        static let containerHorizontalInsets: CGFloat = 30
        static let starContainerHeight: CGFloat = 40
    }
}
