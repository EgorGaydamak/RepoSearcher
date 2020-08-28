import UIKit

final class UserTableViewCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        //TODO: image
        avatarImageView.image = UIImage(named: "avatarPlaceholder")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(user: .none)
    }

    func configure(user: UserViewModel?) {
        if let user = user {
            nameLabel.text = user.login
            //TODO: image

            avatarImageView.alpha = 1
            nameLabel.alpha = 1

            indicatorView.stopAnimating()
        } else {
            avatarImageView.alpha = 0
            nameLabel.alpha = 0

            indicatorView.startAnimating()
        }
    }
}
