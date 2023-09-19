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
            print("called ui test")
            let mock: NetworkingManager = UITestingHelper.isPokemonNetworkingSuccessful ? PokemonsNetworkingSuccessMock() : PokemonsNetworkingFailureMock()
            _vm = StateObject(wrappedValue: PokemonViewModel(networkingManager: mock))
        } else {
            print("called ui else")
            _vm = StateObject(wrappedValue: PokemonViewModel())
        }
#else
        print("Called else")
        _vm = StateObject(wrappedValue: PokemonViewModel())
        vm.fetchPokemons()
#endif
    }
    
    var body: some View {
        NavigationView {
            if vm.isLoading {
                ProgressView()
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
                                        if vm.hasReachedEnd(of: pokemon) && !vm.isFetching {
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
                    if !vm.isFetching && !vm.isLoading{
                        await vm.fetchPokemons()
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
                await vm.fetchPokemons()
                hasAppeared = true
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
