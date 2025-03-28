import SwiftUI

struct PetsListView: View {
    
    @EnvironmentObject var favorites: Favorites
    @StateObject var viewModel: PetsListViewModel
    
    init(favorites: Favorites) {
        _viewModel = StateObject(wrappedValue: PetsListViewModel(favorites: favorites))
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                
                List {
                    ForEach(Array(viewModel.pets.enumerated()), id: \.element.id) { index, pet in
                        petRow(for: pet, index: index)
                    }
                    
                    if viewModel.isLoading {
                        ForEach(0..<6, id: \.self) { _ in
                            PetListCell(pet: nil, isLoading: true)
                        }
                    }
                }
                .navigationTitle("🐾 Adopt a Friend")
                .listStyle(.plain)
                .disabled(viewModel.isShowingDetail)
            }
            .task {
                if viewModel.pets.isEmpty {
                    viewModel.getPets()
                }
            }
            .blur(radius: viewModel.isShowingDetail ? 20 : 0)
            
            if viewModel.isShowingDetail {
                PetDetailView(pet: viewModel.selectedPet!,
                                    isShowingDetail: $viewModel.isShowingDetail)
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        .overlay(
            Group {
                if let toast = viewModel.toastMessage {
                    Text(toast)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    viewModel.toastMessage = nil
                                }
                            }
                        }
                        .padding(.bottom, 50)
                }
            },
            alignment: .bottom
        )
    }
    
    @ViewBuilder
    private func petRow(for pet: Pet, index: Int) -> some View {
        let model = PetListCellModel.from(pet, favorites: viewModel.favorites)

        PetListCell(pet: model, onFavoriteToggle: { viewModel.toggleFavorite(for: $0) })
            .listRowSeparatorTint(.petPrimary)
            .onTapGesture {
                viewModel.selectedPet = pet
                viewModel.isShowingDetail = true
            }
            .onAppear {
                if index == viewModel.pets.count - 10 {
                    viewModel.loadNextPageIfNeeded()
                }
            }
    }
}

struct PetsListView_Previews: PreviewProvider {
    static var previews: some View {
        PetsListView(favorites: Favorites())
            .environmentObject(Favorites())
    }
}
