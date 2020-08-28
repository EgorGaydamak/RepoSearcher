import UIKit

final class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var ownerAvatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var numbersContainerView: UIView!
    @IBOutlet private weak var numberOfForksLabel: UILabel!
    @IBOutlet private weak var numberOfWatchersLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private lazy var informationViews: [UIView] = {
        return [nameLabel,
                descriptionLabel,
                numbersContainerView]
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        //TODO: replace with proper image loading
        configure(image: .none)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(repository: .none)
        configure(image: .none)
    }

    func configure(repository: RepositoryViewModel?) {
        if let repository = repository {
            nameLabel.text = repository.name
            descriptionLabel.text = repository.description
            numberOfForksLabel.text = repository.numberOfForks
            numberOfWatchersLabel.text = repository.numberOfWatchers

            informationViews.forEach { $0.alpha = 1 }

            indicatorView.stopAnimating()
        } else {
            informationViews.forEach { $0.alpha = 0 }

            indicatorView.startAnimating()
        }
    }

    func configure(image: UIImage?) {
        if let image = image {
            ownerAvatarImageView.image = image
        } else {
            ownerAvatarImageView.image = UIImage(named: "avatarPlaceholder")
        }
    }
}
