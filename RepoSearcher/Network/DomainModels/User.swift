struct User: Decodable {
    let avatarUrl: String
    let login: String
    let publicRepositoriesCount: Int?
    let repositoriesUrl: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
        case publicRepositoriesCount = "public_repos"
        case repositoriesUrl = "repos_url"
    }
}
