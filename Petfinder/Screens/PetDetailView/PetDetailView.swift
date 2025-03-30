import SwiftUI

struct PetDetailView: View {
    
    @EnvironmentObject var favorites: Favorites
    
    let pet: Pet
    @Binding var isShowingDetail: Bool
    var useCustomFrame: Bool = true
    
    private var labeledInfoGroup: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text("📋 Basic Info")
                    .font(.headline)
                    .padding(.top, 8)
                
                if !pet.name.isEmpty {
                    LabeledInfo(label: "Name", value: pet.name)
                }
                if let breed = pet.breeds.primary, !breed.isEmpty {
                    LabeledInfo(label: "Breed", value: breed)
                }
                if !pet.age.isEmpty {
                    LabeledInfo(label: "Age", value: pet.age)
                }
                if !pet.gender.isEmpty {
                    LabeledInfo(label: "Gender", value: pet.gender)
                }
                if !pet.size.isEmpty {
                    LabeledInfo(label: "Size", value: pet.size)
                }
                if !pet.status.isEmpty {
                    LabeledInfo(label: "Status", value: pet.status)
                }
            }

            if !pet.tags.isEmpty {
                Text("🧠 Traits")
                    .font(.headline)
                    .padding(.top, 8)
                let tagList = pet.tags.joined(separator: ", ")
                LabeledInfo(label: "Traits", value: tagList, lineLimit: 4)
            }

            Group {
                Text("❤️ Health & Habits")
                    .font(.headline)
                    .padding(.top, 8)

                if pet.attributes.spayedNeutered == true {
                    LabeledInfo(label: "Spayed / Neutered", value: "Yes")
                }
                if pet.attributes.shotsCurrent == true {
                    LabeledInfo(label: "Up to Date on Shots", value: "Yes")
                }
                if pet.attributes.houseTrained == true {
                    LabeledInfo(label: "House Trained", value: "Yes")
                }
                if pet.attributes.specialNeeds == true {
                    LabeledInfo(label: "Special Needs", value: "Yes")
                }
            }

            if let city = pet.contact.address.city,
               let state = pet.contact.address.state {
                Text("📍 Location")
                    .font(.headline)
                    .padding(.top, 8)
                let location = [city, state, pet.contact.address.postcode].compactMap { $0 }.joined(separator: ", ")
                Button(action: {
                    let encoded = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Open Maps at \(location)")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }

            if let email = pet.contact.email, !email.isEmpty {
                Text("✉️ Contact")
                    .font(.headline)
                    .padding(.top, 8)
                Button(action: {
                    if let url = URL(string: "mailto:\(email)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Email the contact")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }

            Text("🔗 Petfinder Listing")
                .font(.headline)
                .padding(.top, 8)
            Button(action: {
                if let url = URL(string: pet.url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("See the full listing details")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }

            if let description = pet.description, !description.isEmpty {
                Text("📝 Description")
                    .font(.headline)
                    .padding(.top, 8)
                LabeledInfo(label: "Info", value: description, lineLimit: 10)
            }

            LabeledInfo(label: "Distance", value: distanceText)
        }
        .padding(.bottom, 40)
    }

    private var distanceText: String {
        if let distance = pet.distance, distance > 0 {
            return "\(String(format: "%.1f", distance)) miles away"
        } else {
            return "Not specified"
        }
    }
    
    var body: some View {
        VStack {
            let imageUrlString = (pet.primaryPhotoCropped?.small ?? pet.photos.first?.small) ?? ""
            PetRemoteImage(urlString: imageUrlString, type: pet.type)
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.4
                }
                .padding(.bottom, 20)
            
            FavoriteToggleButton(isFavorite: .constant(favorites.pets.contains(pet))) {
                if let index = favorites.pets.firstIndex(of: pet) {
                    favorites.pets.remove(at: index)
                } else {
                    favorites.pets.append(pet)
                }
            }
            .frame(width: 40, height: 40)
            .padding(.bottom, 12)

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16) {
                    labeledInfoGroup
                        .padding(.horizontal)
                    
//                    Spacer(minLength: 30)
                }
            }
        }
        .frame(
            width: useCustomFrame ? UIScreen.main.bounds.width * 0.85 : nil,
            height: useCustomFrame ? UIScreen.main.bounds.height * 0.8 : nil
        )
        .background(Color(.systemBackground))
        .cornerRadius(useCustomFrame ? 12 : 0)
        .shadow(radius: 40)
        .overlay(
            Group {
                if useCustomFrame {
                    Button {
                        isShowingDetail = false
                    } label: {
                        XDismissButton()
                    }
                }
            },
            alignment: .topTrailing
        )
    }
}
