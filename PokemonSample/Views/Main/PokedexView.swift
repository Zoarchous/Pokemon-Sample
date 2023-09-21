//
//  PokedexView.swift
//  PokemonSample
//
//  Created by user on 14.09.23.
//

import SwiftUI

struct PokedexView: View {
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 2)
    @StateObject private var vm: PokemonViewModel
    @State private var hasAppeared = false
    init () {
#if DEBUG
        if UITestingHelper.isUITesting {
            let mock: NetworkingManager = UITestingHelper.isPokemonNetworkingSuccessful ? PokemonsNetworkingSuccessMock() : PokemonsNetworkingFailureMock()
            _vm = StateObject(wrappedValue: PokemonViewModel(networkingManager: mock))
        } else {
            _vm = StateObject(wrappedValue: PokemonViewModel())
        }
#else
        _vm = StateObject(wrappedValue: PokemonViewModel())
        vm.fetchPokemons()
#endif
    }
    
    var body: some View {
        NavigationView {
            if vm.isLoading {
                ProgressView()
            } else if vm.hasError {
                VStack {
                    Text("An error occured")
                    Button("Refresh") {
                        Task {
                            if !vm.isFetching && !vm.isLoading {
                                if NetworkState.isConnectedToNetwork() {
                                    await vm.fetchPokemons()
                                } else {
                                    await vm.fetchPokemonsFromDB()
                                }
                            }
                        }
                    }
                }.navigationTitle("Pokedex")
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        ForEach(vm.pokemons, id: \.id) { pokemon in
                            NavigationLink {
                                PokemonDetailView(pokemon: pokemon)
                            } label: {
                                PokemonCell(pokemon: pokemon)
                                    .accessibilityIdentifier("item_\(pokemon.id)")
                                    .task {
                                        if vm.hasReachedEnd(of: pokemon) && !vm.isFetching && NetworkState.isConnectedToNetwork(){
                                            await vm.fetxhNextPage()
                                        }
                                    }
                            }
                        }
                    }
                    .padding(10)
                    .accessibilityIdentifier("pokemonsGrid")
                }
                .navigationTitle("Pokedex")
                .refreshable {
                    if !vm.isFetching && !vm.isLoading {
                        if NetworkState.isConnectedToNetwork() {
                            await vm.fetchPokemons()
                        } else {
                            await vm.fetchPokemonsFromDB()
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    if vm.isFetching {
                        ProgressView()
                    }
                }
            }
        }
        .tint(.black)
        .task {
            if !hasAppeared {
                if NetworkState.isConnectedToNetwork(){
                    await vm.fetchPokemons()
                    hasAppeared = true
                } else {
                    await vm.fetchPokemonsFromDB()
                    hasAppeared = true
                }
            }
        }
    }
}

#if DEBUG
struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
#endif
