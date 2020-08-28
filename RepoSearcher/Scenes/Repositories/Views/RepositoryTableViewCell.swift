import UIKit
import Kingfisher

final class RepositoryTableViewCell: UITableViewCell {
    private var ownerAvatarImageUrl: String?

    @IBOutlet private weak var ownerAvatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var numbersContainerView: UIView!
    @IBOutlet private weak var numberOfForksLabel: UILabel!
    @IBOutlet private weak var numberOfWatchersLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private lazy var informationViews: [UIView] = {
        return [ownerAvatarImageView,
                nameLabel,
                descriptionLabel,
                numbersContainerView]
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(repository: .none)
    }

    func configure(repository: RepositoryViewModel?) {
        if let repository = repository {
            ownerAvatarImageUrl = repository.ownerAvatarUrl
            nameLabel.text = repository.name
            descriptionLabel.text = repository.description
            numberOfForksLabel.text = repository.numberOfForks
            numberOfWatchersLabel.text = repository.numberOfWatchers

            informationViews.forEach { $0.alpha = 1 }

            indicatorView.stopAnimating()
        } else {
            ownerAvatarImageUrl = nil
            ownerAvatarImageView.image = nil
            informationViews.forEach { $0.alpha = 0 }

            indicatorView.startAnimating()
        }
    }
}

extension RepositoryTableViewCell: ImageDownloadingInterface {
    func startImageDownloading() {
        guard let ownerAvatarImageUrl = ownerAvatarImageUrl else { return }

        ownerAvatarImageView.kf.setImage(with: URL(string: ownerAvatarImageUrl),
                                         placeholder: UIImage(named: "avatarPlaceholder"))
    }

    func cancelImageDownloading() {
        ownerAvatarImageView.kf.cancelDownloadTask()
    }
}
