//
//  PokemonsNetworkingFailureMock.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//
#if DEBUG
import Foundation

class PokemonsNetworkingFailureMock: NetworkingManager {
    
    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkingManagerImpl.NetworkingError.invalidUrl
    }
    
    func request(session: URLSession, _ endpoint: Endpoint) async throws {}
}
#endif
