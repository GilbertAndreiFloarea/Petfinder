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
    
    init(
        id: Int,
        name: String = "",
        breeds: Breeds = Breeds(),
        age: String = "",
        gender: String = "",
        size: String = "",
        status: String = "",
        distance: Double? = nil,
        tags: [String] = [],
        attributes: Attributes = Attributes(shotsCurrent: false, specialNeeds: false, declawed: nil, houseTrained: false, spayedNeutered: false),
        contact: Contact = Contact(email: nil, phone: nil, address: Address(address1: nil, address2: nil, city: nil, state: nil, postcode: nil, country: nil)),
        url: String = "",
        description: String? = nil,
        primaryPhotoCropped: Photo? = nil,
        photos: [Photo] = [],
        type: PetType = .unknown,
        colors: Colors = Colors(),
        organizationAnimalID: String? = nil,
        statusChangedAt: String = "",
        publishedAt: String = "",
        species: String = "",
        organizationID: String = "",
        coat: String? = nil,
        environment: Environment = Environment(cats: nil, dogs: nil, children: nil),
        links: Links = Links(type: HrefLink(href: ""), organization: HrefLink(href: ""), self: HrefLink(href: "")),
        videos: [Video] = []
    ) {
        self.id = id
        self.name = name
        self.breeds = breeds
        self.age = age
        self.gender = gender
        self.size = size
        self.status = status
        self.distance = distance
        self.tags = tags
        self.attributes = attributes
        self.contact = contact
        self.url = url
        self.description = description
        self.primaryPhotoCropped = primaryPhotoCropped
        self.photos = photos
        self.type = type
        self.colors = colors
        self.organizationAnimalID = organizationAnimalID
        self.statusChangedAt = statusChangedAt
        self.publishedAt = publishedAt
        self.species = species
        self.organizationID = organizationID
        self.coat = coat
        self.environment = environment
        self.links = links
        self.videos = videos
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

// MARK: - Mock Pet

extension Pet {

    static func random(
        id: Int = Int.random(in: 1...999_999),
        name: String = UUID().uuidString,
        breeds: Breeds = Breeds(
            primary: Bool.random() ? "Breed \(UUID().uuidString.prefix(5))" : nil,
            secondary: Bool.random() ? "Breed \(UUID().uuidString.prefix(5))" : nil,
            mixed: Bool.random(),
            unknown: Bool.random()
        ),
        age: String = ["Baby", "Young", "Adult", "Senior"].randomElement() ?? "Unknown",
        gender: String = ["Male", "Female"].randomElement() ?? "Unknown",
        size: String = ["Small", "Medium", "Large", "XLarge"].randomElement() ?? "Unknown",
        status: String = ["adoptable", "pending", "adopted"].randomElement() ?? "unknown",
        distance: Double? = Bool.random() ? Double.random(in: 0...100) : nil,
        tags: [String] = (0..<Int.random(in: 0...5)).map { _ in "Tag\(Int.random(in: 1...100))" },
        attributes: Attributes = Attributes(
            shotsCurrent: Bool.random(),
            specialNeeds: Bool.random(),
            declawed: Bool.random(),
            houseTrained: Bool.random(),
            spayedNeutered: Bool.random()
        ),
        contact: Contact = Contact(
            email: Bool.random() ? "\(UUID().uuidString.prefix(5))@example.com" : nil,
            phone: Bool.random() ? "555-\(Int.random(in: 1000...9999))" : nil,
            address: Address(
                address1: Bool.random() ? "123 \(UUID().uuidString.prefix(3)) St" : nil,
                address2: nil,
                city: Bool.random() ? "City\(Int.random(in: 1...100))" : nil,
                state: Bool.random() ? "CA" : nil,
                postcode: Bool.random() ? "\(Int.random(in: 90000...99999))" : nil,
                country: "US"
            )
        ),
        url: String = "https://example.com/\(UUID().uuidString)",
        description: String? = Bool.random() ? "A friendly pet that loves people." : nil,
        primaryPhotoCropped: Photo? = Bool.random() ? Photo(
            small: "https://example.com/small.jpg",
            medium: "https://example.com/medium.jpg",
            large: "https://example.com/large.jpg",
            full: "https://example.com/full.jpg"
        ) : nil,
        photos: [Photo] = (0..<Int.random(in: 0...3)).map { _ in
            Photo(
                small: "https://example.com/small.jpg",
                medium: "https://example.com/medium.jpg",
                large: "https://example.com/large.jpg",
                full: "https://example.com/full.jpg"
            )
        },
        type: PetType = PetType.allCases.randomElement() ?? .unknown,
        colors: Colors = Colors(
            primary: Bool.random() ? "Black" : nil,
            secondary: Bool.random() ? "White" : nil,
            tertiary: Bool.random() ? "Gray" : nil
        ),
        organizationAnimalID: String? = Bool.random() ? UUID().uuidString : nil,
        statusChangedAt: String = ISO8601DateFormatter().string(from: Date()),
        publishedAt: String = ISO8601DateFormatter().string(from: Date().addingTimeInterval(-3600)),
        species: String = ["Cat", "Dog", "Rabbit", "Bird"].randomElement() ?? "Unknown",
        organizationID: String = UUID().uuidString.prefix(4).uppercased(),
        coat: String? = Bool.random() ? ["Short", "Medium", "Long"].randomElement() : nil,
        environment: Environment = Environment(
            cats: Bool.random(),
            dogs: Bool.random(),
            children: Bool.random()
        ),
        links: Links = Links(
            type: HrefLink(href: "/v2/types/\(UUID().uuidString)"),
            organization: HrefLink(href: "/v2/organizations/\(UUID().uuidString)"),
            self: HrefLink(href: "/v2/animals/\(Int.random(in: 1...999_999))")
        ),
        videos: [Video] = []
    ) -> Pet {
        return Pet(
            id: id,
            name: name,
            breeds: breeds,
            age: age,
            gender: gender,
            size: size,
            status: status,
            distance: distance,
            tags: tags,
            attributes: attributes,
            contact: contact,
            url: url,
            description: description,
            primaryPhotoCropped: primaryPhotoCropped,
            photos: photos,
            type: type,
            colors: colors,
            organizationAnimalID: organizationAnimalID,
            statusChangedAt: statusChangedAt,
            publishedAt: publishedAt,
            species: species,
            organizationID: organizationID,
            coat: coat,
            environment: environment,
            links: links,
            videos: videos
        )
    }
}
