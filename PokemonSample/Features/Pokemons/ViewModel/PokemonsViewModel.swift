//
//  PokemonsViewModel.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation

final class PokemonViewModel: ObservableObject {
    @Published private(set) var pokemons: [PokemonUIModel] = []
    @Published private(set) var error: NetworkingManagerImpl.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private(set) var offset = 0
    private(set) var hasNextPage: Bool = true
    
    private let networkingManager: NetworkingManager!
    private let uiModelMapper: UiModelMapper!
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared, uiModelMapper: UiModelMapper = UiModelMapper.shared) {
        print("VM Initialized")
        self.uiModelMapper = uiModelMapper
        self.networkingManager = networkingManager
    }
    
    @MainActor
    func fetchPokemons() async {
        reset()
        viewState = .loading
        defer {
            viewState = .finished
        }
        do {
            print("fetch called")
            let response = try await networkingManager.request(session: .shared, .pokemon(offset: offset), type: PokemonsResponse.self)
            let pokemonsList: [Pokemon] = response.results
            var pokemons: [PokemonDetail] = []
            let myGroup = DispatchGroup()
            CoreDataManager.shared.resetAllRecords(in: "PokemonCoreDetail")
            CoreDataManager.shared.resetAllRecords(in: "StatItem")
            print("vm db clear")
            pokemonsList.forEach { poke in
                myGroup.enter()
                Task {
                    do {
                        let itemResponse = try await networkingManager.request(session: .shared, .detail(name: poke.name), type: PokemonDetail.self)
                        itemResponse.store()
                        pokemons.append(itemResponse)
                    } catch {
                        print(error)
                        return
                    }
                    myGroup.leave()
                }
            }
            if response.next != nil {
                self.hasNextPage = true
            } else {
                self.hasNextPage = false
            }
            myGroup.notify(queue: .main) {
                let sortedList =  pokemons.sorted { $0.id < $1.id }
                self.pokemons = self.uiModelMapper.mapApiModelList(apiModelList: sortedList)
                self.hasError = false
            }
        } catch {
            self.hasError = true
            print("fetch error - \(error)")
            if let networkingError = error as? NetworkingManagerImpl.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
            
        }
    }
    
    @MainActor
    func fetchPokemonsFromDB() async {
        reset()
        viewState = .loading
        defer {
            viewState = .finished
        }
        let pokemonsList = CoreDataManager.shared.fetch(type: PokemonCoreDetail.self).sorted {
            $0.id < $1.id
        }
        self.pokemons = UiModelMapper.shared.mapDBModelList(dbModelList: pokemonsList)
        hasError = false
    }
    
    @MainActor
    func fetxhNextPage() async {
        guard hasNextPage else { return }
        viewState = .fetching
        defer {
            viewState = .finished
        }
        
        offset += 50
        
        do {
            let response = try await networkingManager.request(session: .shared, .pokemon(offset: offset), type: PokemonsResponse.self)
            let pokemonsList: [Pokemon] = response.results
            let myGroup = DispatchGroup()
            pokemonsList.forEach { poke in
                myGroup.enter()
                Task {
                    let itemResponse = try await networkingManager.request(session: .shared, .detail(name: poke.name), type: PokemonDetail.self)
                    self.pokemons.append(uiModelMapper.mapApiModel(apiModel: itemResponse))
                    myGroup.leave()
                }
            }
            if response.next != nil {
                self.hasNextPage = true
            } else {
                self.hasNextPage = false
            }
            myGroup.notify(queue: .main) {
                self.hasError = false
            }
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManagerImpl.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(of pokemon: PokemonUIModel) -> Bool {
        pokemons.last?.id == pokemon.id
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
            viewState = .loading
        }
    }
}
