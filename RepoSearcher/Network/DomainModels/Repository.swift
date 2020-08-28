struct Repository: Decodable {
    let name: String
    let description: String?
    let forks: Int
    let watchers: Int
    let owner: User
}
