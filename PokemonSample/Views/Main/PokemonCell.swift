//
//  PokemonCell.swift
//  PokemonSample
//
//  Created by user on 14.09.23.
//

import SwiftUI

struct PokemonCell: View {
    let pokemon: PokemonUIModel
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .padding(.leading)
                HStack {
                    Text(pokemon.primaryType.capitalized)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.25))
                        )
                        .frame(width: 100, height: 24)
                    
                    AsyncImage(url: .init(string: pokemon.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height:  68)
                            .padding([.bottom, .trailing], 4)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 68, height: 68)
                            .padding([.bottom, .trailing], 4)
                    }
                }
            }
        }
        .background(pokemon.backgroundColor(forType: pokemon.primaryType))
        .cornerRadius(12)
        .shadow(color: pokemon.backgroundColor(forType: pokemon.primaryType), radius: 6, x: 0.0, y: 0.0)
    }
}

#if DEBUG
struct PokemonCell_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCell(pokemon: PokemonUIModel.fake)
    }
}
#endif
