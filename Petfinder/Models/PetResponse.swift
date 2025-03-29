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
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            func decode<T>(_ type: T.Type, forKey key: CodingKeys) -> T where T: Decodable {
                do {
                    return try container.decode(T.self, forKey: key)
                } catch {
                    print("⚠️ Failed to decode '\(key.stringValue)' as \(T.self): \(error)")
                    fatalError("Decoding failure for key \(key): \(error)")
                }
            }

            func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKeys) -> T? where T: Decodable {
                do {
                    return try container.decodeIfPresent(T.self, forKey: key)
                } catch {
                    print("⚠️ Failed to decodeIfPresent '\(key.stringValue)' as \(T.self): \(error)")
                    return nil
                }
            }

            id = decode(Int.self, forKey: .id)
            name = decode(String.self, forKey: .name)
            gender = decode(String.self, forKey: .gender)
            size = decode(String.self, forKey: .size)
            status = decode(String.self, forKey: .status)
            distance = decodeIfPresent(Double.self, forKey: .distance)
            url = decode(String.self, forKey: .url)
            breeds = decode(Breeds.self, forKey: .breeds)
            colors = decode(Colors.self, forKey: .colors)
            tags = decode([String].self, forKey: .tags)
            organizationAnimalID = decodeIfPresent(String.self, forKey: .organizationAnimalID)
            statusChangedAt = decode(String.self, forKey: .statusChangedAt)
            publishedAt = decode(String.self, forKey: .publishedAt)
            species = decode(String.self, forKey: .species)
            contact = decode(Contact.self, forKey: .contact)
            type = decode(PetType.self, forKey: .type)
            primaryPhotoCropped = decodeIfPresent(Photo.self, forKey: .primaryPhotoCropped)
            organizationID = decode(String.self, forKey: .organizationID)
            coat = decodeIfPresent(String.self, forKey: .coat)
            environment = decode(Environment.self, forKey: .environment)
            photos = decode([Photo].self, forKey: .photos)
            age = decode(String.self, forKey: .age)
            links = decode(Links.self, forKey: .links)
            videos = decode([Video].self, forKey: .videos)
            attributes = decode(Attributes.self, forKey: .attributes)
            description = decodeIfPresent(String.self, forKey: .description)
        }

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
