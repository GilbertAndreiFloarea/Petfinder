import Foundation

struct PetResponse: Codable {
    let animals: [Pet]
    let pagination: Pagination
}

struct Pet: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let breeds: Breeds
    let age: String
    let gender: String
    let size: String
    let status: String
    let distance: Double?
    let tags: [String]
    let attributes: Attributes
    let contact: Contact
    let url: String
    let description: String?
    let primaryPhotoCropped: Photo?
    let photos: [Photo]
    let type: PetType
    
    let colors: Colors
    let organizationAnimalID: String?
    let statusChangedAt: String
    let publishedAt: String
    let species: String
    let organizationID: String
    let coat: String?
    let environment: Environment
    let links: Links
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case id, name, gender, size, status, distance, url, breeds, colors, tags, species, contact, type, coat, environment, photos, age, videos, attributes, description
        case organizationAnimalID = "organization_animal_id"
        case statusChangedAt = "status_changed_at"
        case publishedAt = "published_at"
        case primaryPhotoCropped = "primary_photo_cropped"
        case organizationID = "organization_id"
        case links = "_links"
    }
    
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Environment: Codable {
    let cats: Bool?
    let dogs: Bool?
    let children: Bool?
}

struct Video: Codable {}

struct Links: Codable {
    let type: HrefLink
    let organization: HrefLink
    let `self`: HrefLink
}

struct HrefLink: Codable {
    let href: String
}
