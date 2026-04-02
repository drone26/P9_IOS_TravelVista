//
//  DetailView.swift
//  TravelVista
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import SwiftUI
import UIKit

struct DetailView: UIViewControllerRepresentable {
    // Propriété demandée pour récupérer le pays cliqué
    let country: Country
    
    // Fonction 1 : Création du contrôleur
    func makeUIViewController(context: Context) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instanciation sécurisée avec guard et as?
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // Transmission de la donnée
        detailVC.country = self.country
        
        return detailVC
    }
    
    // Fonction 2 : Mise à jour (statique, donc vide)
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        
    }
}

#Preview {
    DetailView(country: .init(name: "France", capital: "Paris", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat.", rate: 4, pictureName: "france", coordinates: .init(latitude: 48.8566, longitude: 2.3522)))
}
