//
//  ListView.swift
//  TravelVista
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import SwiftUI

struct CountryRow: View {
    let country: Country

    var body: some View {
        HStack {
            Image(country.pictureName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(Color("CustomBlue"))
                Text(country.capital)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("\(country.rate)")
                Image(systemName: "star.fill")
                    .font(.system(size: 15))
                    .frame(width: 19, height: 19)
                    .clipped()
                    .foregroundColor(Color("CustomSand"))
            }
        }
    }
}

struct ListView: View {
    // Chargement des données réelles depuis Source.json
    let regions: [Region] = Service().load("Source.json")

    var body: some View {
        NavigationView {
            List {
                // Première boucle : on parcourt les régions
                ForEach(regions, id: \.name) { region in
                    Section(header: Text(region.name)) {
                        
                        // Deuxième boucle : on parcourt les pays dans chaque région
                        ForEach(region.countries, id: \.name) { country in
                            
                            NavigationLink(
                                destination: DetailView(country: country)
                                    .navigationTitle(country.name)
                            ) {
                                CountryRow(country: country)
                            }
                            
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Liste de voyages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
