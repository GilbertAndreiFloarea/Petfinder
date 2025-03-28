enum PetType: String, Codable {
    case cat = "Cat"
    case dog = "Dog"
    case rabbit = "Rabbit"
    case bird = "Bird"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = PetType(rawValue: rawValue) ?? .unknown
    }
}
