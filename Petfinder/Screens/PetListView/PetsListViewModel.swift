import SwiftUI
import Combine

@MainActor final class PetsListViewModel: ObservableObject {
    
    let favorites: Favorites
    @Published var pets: [Pet] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var selectedPet: Pet?
    @Published var toastMessage: String?
    
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init(favorites: Favorites) {
        self.favorites = favorites
        observeZipcodeChanges()
    }

    private func observeZipcodeChanges() {
        locationManager.$zipcode
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard self.locationManager.zipcodeChanged else { return }

                self.pets = []
                self.toastMessage = "Hold on a minute. Updating results based on your location"
                self.getPets()
            }
            .store(in: &cancellables)
    }
    
    func getPets(zipcode: String? = nil) {
        isLoading = true
        
        Task {
            do {
                let fetched = try await NetworkManager.shared.fetchPets(from: nil, currentZipCode: nil).animals
                var seenIDs = Set<Int>()
                self.pets = fetched.filter { pet in
                    guard !seenIDs.contains(pet.id) else { return false }
                    seenIDs.insert(pet.id)
                    return true
                }
                isLoading = false
            } catch {
                if let PError = error as? PError {
                    switch PError {
                    case .invalidURL:
                        alertItem = AlertContext.Network.invalidURL
                    case .invalidResponse:
                        alertItem = AlertContext.Network.invalidResponse
                    case .invalidData:
                        alertItem = AlertContext.Network.invalidData
                    case .unableToComplete:
                        alertItem = AlertContext.Network.unableToComplete
                    case .invalidToken:
                        alertItem = AlertContext.Network.invalidToken
                    }
                } else {
                    alertItem = AlertContext.Network.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    func loadNextPageIfNeeded() {
        guard !isLoading else { return }
        isLoading = true

        Task {
            do {
                if let response = try await NetworkManager.shared.loadNextPageIfNeeded() {
                    await MainActor.run {
                        var seenIDs = Set<Int>()
                        self.pets = (self.pets + response.animals).filter { pet in
                            guard !seenIDs.contains(pet.id) else { return false }
                            seenIDs.insert(pet.id)
                            return true
                        }
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.alertItem = AlertContext.Network.invalidResponse
                    self.isLoading = false
                }
            }
        }
    }
    
    func toggleFavorite(for model: PetListCellModel) {
        guard let pet = pets.first(where: { $0.id == Int(model.id) }) else { return }

        if let index = favorites.pets.firstIndex(of: pet) {
            favorites.pets.remove(at: index)
        } else {
            favorites.pets.append(pet)
        }
    }
}
