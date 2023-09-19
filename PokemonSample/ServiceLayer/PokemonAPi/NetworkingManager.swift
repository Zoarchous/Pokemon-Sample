//
//  NetworkingManager.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation

protocol NetworkingManager {
    func request<T: Codable>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T
    func request(session: URLSession, _ endpoint: Endpoint) async throws
}

class NetworkingManagerImpl: NetworkingManager {
    
    static let shared = NetworkingManagerImpl()
    
    private init() {
        print("Manager init")
    }
    
    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        let request = buildRequest(from: url)
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        let decoder = JSONDecoder()
        let res = try decoder.decode(T.self, from: data)
        if res is PokemonDetail {
            (res as! PokemonDetail).store()
        }
        return res
    }
    
    func request(session: URLSession, _ endpoint: Endpoint) async throws {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url)
        let (_, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
    
}


extension NetworkingManagerImpl {
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkingManagerImpl.NetworkingError: Equatable {
    static func == (lhs: NetworkingManagerImpl.NetworkingError, rhs: NetworkingManagerImpl.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}

extension NetworkingManagerImpl.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isn't valid"
        case .invalidStatusCode:
            return "Status code falls into the wrong range"
        case .invalidData:
            return "Response data is invalid"
        case .failedToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "Something went wrong \(err.localizedDescription)"
        }
    }
}

private extension NetworkingManagerImpl {
    func buildRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

