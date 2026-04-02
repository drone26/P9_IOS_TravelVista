//
//  Service.swift
//  TravelVista
//
//  Created by Amandine Cousin on 18/12/2023.
//

import Foundation

enum ServiceError: LocalizedError {
    case fileNotFound(String)
    case loadingFailed(String, Error)
    case parsingFailed(String, Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Impossible de trouver \(filename) dans le bundle principal."
        case .loadingFailed(let filename, let error):
            return "Impossible de charger \(filename) : \(error.localizedDescription)"
        case .parsingFailed(let filename, let error):
            return "Impossible de décoder \(filename) : \(error.localizedDescription)"
        }
    }
}

class Service {
    // Fonction qui permet de recupérer les données d'un fichier
    // Et qui les transforme en données utilisables en Swift
    // Ici nous l'utilisons uniquement pour notre fichier Source.json
    // Elle retourne un tableau de type Region
    func load<T: Decodable>(_ filename: String) throws -> T {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            throw ServiceError.fileNotFound(filename)
        }

        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch {
            throw ServiceError.loadingFailed(filename, error)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ServiceError.parsingFailed(filename, error)
        }
    }
}
