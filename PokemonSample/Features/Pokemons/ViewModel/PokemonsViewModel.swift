//
//  PokemonsViewModel.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation

final class PokemonViewModel: ObservableObject {
    @Published private(set) var pokemons: [PokemonDetail] = []
    @Published private(set) var error: NetworkingManagerImpl.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private(set) var offset = 0
    private(set) var hasNextPage: Bool = true
    
    private let networkingManager: NetworkingManager!
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    
    @MainActor
    func fetchPokemons() async {
        reset()
        viewState = .loading
        defer {viewState = .finished }
        
        do {
            let response = try await networkingManager.request(session: .shared, .pokemon(offset: offset), type: PokemonsResponse.self)
            let pokemonsList: [Pokemon] = response.results
            var pokemons: [PokemonDetail] = []
            pokemonsList.forEach { poke in
                Task {
                    let itemResponse = try await networkingManager.request(session: .shared, .detail(name: poke.name), type: PokemonDetail.self)
                    pokemons.append(itemResponse)
                }
            }
            if response.next != nil {
                self.hasNextPage = true
            } else {
                self.hasNextPage = false
            }
            self.pokemons = pokemons
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManagerImpl.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetxhNextPage() async {
        guard hasNextPage else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        offset += 50
        
        do {
            let response = try await networkingManager.request(session: .shared, .pokemon(offset: offset), type: PokemonsResponse.self)
            let pokemonsList: [Pokemon] = response.results
            var pokemons: [PokemonDetail] = []
            pokemonsList.forEach { poke in
                Task {
                    let itemResponse = try await networkingManager.request(session: .shared, .detail(name: poke.name), type: PokemonDetail.self)
                    pokemons.append(itemResponse)
                }
            }
            if response.next != nil {
                self.hasNextPage = true
            } else {
                self.hasNextPage = false
            }
            self.pokemons = pokemons
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManagerImpl.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd() -> Bool {
        self.hasNextPage
    }
}


extension PokemonViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PokemonViewModel {
    func reset() {
        if viewState == .finished {
            pokemons.removeAll()
            offset = 0
            hasNextPage = true
            viewState = nil
        }
    }
}
