struct Attributes: Codable {
    let shotsCurrent: Bool
    let specialNeeds: Bool
    let declawed: Bool?
    let houseTrained: Bool
    let spayedNeutered: Bool

    enum CodingKeys: String, CodingKey {
        case shotsCurrent = "shots_current"
        case specialNeeds = "special_needs"
        case declawed
        case houseTrained = "house_trained"
        case spayedNeutered = "spayed_neutered"
    }
}
