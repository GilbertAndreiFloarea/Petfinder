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
    private let zipcodeChangesToastMessage = "Hold on a minute. Updating results based on your location"
    
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init(favorites: Favorites) {
        self.favorites = favorites
        observeZipcodeChanges()
    }
    
    func getPets(zipcode: String? = nil) {
        isLoading = true
        
        Task {
            do {
                let fetched = try await NetworkManager.shared.fetchPets(from: nil, currentZipCode: nil).animals
                self.pets = filterPets(pets: fetched)
                isLoading = false
            } catch {
                alertItem = mapErrorToAlert(error)
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
                        self.pets = filterPets(pets: self.pets + response.animals)
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.alertItem = self.mapErrorToAlert(error)
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

extension PetsListViewModel {
    
    // We do this because the response sends duplicates pets (guess it's a random)
    func filterPets(pets: [Pet]) -> [Pet] {
        var seenIDs = Set<Int>()
        return pets.filter { pet in
            guard !seenIDs.contains(pet.id) else { return false }
            seenIDs.insert(pet.id)
            return true
        }
    }
    
    private func mapErrorToAlert(_ error: Error) -> AlertItem {
        guard let error = error as? PError else {
            return AlertContext.Network.invalidResponse
        }
        
        switch error {
        case .invalidURL: return AlertContext.Network.invalidURL
        case .invalidResponse: return AlertContext.Network.invalidResponse
        case .invalidData: return AlertContext.Network.invalidData
        case .unableToComplete: return AlertContext.Network.unableToComplete
        case .invalidToken: return AlertContext.Network.invalidToken
        }
    }
    
    private func observeZipcodeChanges() {
        locationManager.$zipcode
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.locationManager.zipcodeChanged else { return }

                self.pets = []
                self.toastMessage = zipcodeChangesToastMessage
                self.getPets()
            }
            .store(in: &cancellables)
    }
}
