import Foundation

struct Pet: Codable, Identifiable, Equatable {
    /// Unique identifier for the pet.
    let id: Int
    
    /// Name of the pet.
    let name: String
    
    /// Breed information for the pet.
    let breeds: Breeds
    
    /// Age category of the pet (e.g., "Young", "Adult").
    let age: String
    
    /// Gender of the pet (e.g., "Male", "Female").
    let gender: String
    
    /// Size category of the pet (e.g., "Small", "Medium", "Large").
    let size: String
    
    /// Adoption status of the pet (e.g., "Adoptable").
    let status: String
    
    /// Distance from the user's location, in miles.
    let distance: Double?
    
    /// Tags or keywords associated with the pet.
    let tags: [String]
    
    /// Additional characteristics of the pet such as spayed/neutered status, house training, and special needs.
    let attributes: Attributes
    
    /// Contact information for the pet's shelter or organization.
    let contact: Contact
    
    /// URL to the pet's detailed listing page.
    let url: String
    
    /// Description or biography of the pet.
    let description: String?
    
    /// Cropped primary photo of the pet.
    let primaryPhotoCropped: Photo?
    
    /// All available photos of the pet.
    let photos: [Photo]
    
    /// Type of pet (e.g., "Dog", "Cat").
    let type: PetType
    
    /// Color details of the pet's coat.
    let colors: Colors
    
    /// Organization-specific ID for the pet.
    let organizationAnimalID: String?
    
    /// Timestamp for when the pet's status last changed.
    let statusChangedAt: String
    
    /// Timestamp for when the pet was published.
    let publishedAt: String
    
    /// Species classification of the pet (e.g., "Canine", "Feline").
    let species: String
    
    /// ID of the organization responsible for the pet.
    let organizationID: String
    
    /// Type of coat the pet has, if known.
    let coat: String?
    
    /// Information about the environment the pet is good with (e.g., cats, dogs, children).
    let environment: Environment
    
    /// Related links for more information about the pet and organization.
    let links: Links
    
    /// List of videos featuring the pet.
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
