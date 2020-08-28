import UIKit
import Kingfisher

final class UserTableViewCell: UITableViewCell {
    private var avatarImageUrl: String?

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(user: .none)
    }

    func configure(user: UserViewModel?) {
        if let user = user {
            nameLabel.text = user.login
            avatarImageUrl = user.avatarUrl

            avatarImageView.alpha = 1
            nameLabel.alpha = 1

            indicatorView.stopAnimating()
        } else {
            avatarImageUrl = nil
            avatarImageView.image = nil

            avatarImageView.alpha = 0
            nameLabel.alpha = 0

            indicatorView.startAnimating()
        }
    }
}

extension UserTableViewCell: ImageDownloadingInterface {
    func startImageDownloading() {
        guard let avatarImageUrl = avatarImageUrl else { return }

        avatarImageView.kf.setImage(with: URL(string: avatarImageUrl),
                                         placeholder: UIImage(named: "avatarPlaceholder"))
    }

    func cancelImageDownloading() {
        avatarImageView.kf.cancelDownloadTask()
    }
}

