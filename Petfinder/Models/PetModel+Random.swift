import Foundation

// MARK: - Random Pet
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
}
