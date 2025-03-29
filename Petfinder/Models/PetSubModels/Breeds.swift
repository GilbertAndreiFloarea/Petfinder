struct Breeds: Codable {
    let primary: String?
    let secondary: String?
    let mixed: Bool?
    let unknown: Bool?
    
    init(primary: String? = nil, secondary: String? = nil, mixed: Bool? = nil, unknown: Bool? = nil) {
            self.primary = primary
            self.secondary = secondary
            self.mixed = mixed
            self.unknown = unknown
        }
}
