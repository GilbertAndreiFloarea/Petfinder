struct Pagination: Codable {
    let currentPage: Int
    let countPerPage: Int
    let totalPages: Int
    let totalCount: Int
    let links: PaginationLinks

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case countPerPage = "count_per_page"
        case totalPages = "total_pages"
        case totalCount = "total_count"
        case links = "_links"
    }
}

struct PaginationLinks: Codable {
    let next: HrefLink?
}
