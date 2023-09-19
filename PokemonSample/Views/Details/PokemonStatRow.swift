//
//  PokemonStatRow.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import SwiftUI

struct PokemonStatRow: View {
    let stat: StatElement
    var body: some View {
        HStack {
            Text(stat.stat.name.capitalized).frame(width: 80)
            Spacer()
            ProgressBar(value: stat.statValue, color: getColor(forStat: stat.stat.name.capitalized)).frame(height: 20)
        }.padding()
    }
}

extension PokemonStatRow {
    func getColor(forStat stat: String) -> Color {
        switch stat {
        case "Hp": return .green
        case "Attack": return .red
        case "Defense": return .blue
        default: return.orange
        }
    }
}

struct PokemonStatRow_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStatRow(stat: PokemonDetail.fake.stats[0])
    }
}
