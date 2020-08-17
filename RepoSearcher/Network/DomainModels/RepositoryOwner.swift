struct RepositoryOwner: Decodable {
    let avatarUrl: String
    let login: String

    enum CodingKeys: String, CodingKey {
      case avatarUrl = "avatar_url"
      case login
    }
}
