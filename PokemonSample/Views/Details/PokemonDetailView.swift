//
//  PokemonDetailView.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonDetail
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                    .frame(height: 250)
                    .clipped()
            }
            .ignoresSafeArea(edges: .top)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [pokemon.backgroundColor(forType: pokemon.primaryType), pokemon.backgroundColor(forType: pokemon.primaryType).opacity(0.5)], startPoint: .top, endPoint: .bottom))
            
            GeometryReader { geometry in
                ZStack {
                    Rectangle().fill(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(40)
                    Rectangle()
                        .fill(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .offset(y: geometry.size.height / 2)
                }
                .offset(y: -40)
                .edgesIgnoringSafeArea(.all)
                ZStack(alignment: .top) {
                    AsyncImage(url: .init(string: pokemon.image)) { image in
                        image
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                    }
                    .offset(y: -225)
                    Text(pokemon.name.capitalized)
                        .font(.title)
                        .foregroundColor(.black)
                    VStack {
                        Text(pokemon.primaryType.capitalized)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(pokemon.backgroundColor(forType: pokemon.primaryType).opacity(0.5))
                            )
                            .frame(width: 100, height: 24)
                        Text("Weight: \(pokemon.weightKg) kg.")
                            .offset(y: 10)
                        Text("Height: \(pokemon.heightCm) cm.")
                            .offset(y: 16)
                        Text("Stats:")
                            .font(.headline)
                            .bold()
                            .frame(width: geometry.size.width, alignment: .leading)
                            .offset(y: 26)
                            .padding(.leading, 23)
                        ForEach(pokemon.stats, id: \.statName) { stat in
                            if(NeededStats.allCases.contains(where: {
                                $0.rawValue == stat.statName.capitalized
                            })) {
                                PokemonStatRow(stat: stat)
                            }
                        }
                        .offset(y: 36)
                        .padding(.trailing, 16)
                    }
                    .offset(y: 50)
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: PokemonDetail.fake)
    }
}
