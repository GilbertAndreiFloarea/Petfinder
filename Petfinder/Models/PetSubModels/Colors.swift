struct Colors: Codable {
    let primary: String?
    let secondary: String?
    let tertiary: String?
    
    init(primary: String? = nil, secondary: String? = nil, tertiary: String? = nil) {
            self.primary = primary
            self.secondary = secondary
            self.tertiary = tertiary
        }
}
