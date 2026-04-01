//
//  ListView.swift
//  TravelVista
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import SwiftUI

// Vue de la cellule statique
struct CountryRow: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 52, height: 52)
            
            VStack(alignment: .leading) {
                Text("Toto Nom")
                    .font(.headline)
                    .foregroundColor(Color("CustomBlue"))
                Text("Toto Capitale")
                    .font(.subheadline)
            }
            
            Spacer()
            
            HStack {
                Text("5")
                Image(systemName: "star.fill")
                    .foregroundColor(Color("CustomSand"))
            }
        }
    }
}

// Vue principale
struct ListView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Région de test")) {
                    ForEach(0..<5) { index in
                        
                        let fakeCountry = Country(
                            name: "Pays Toto \(index)",
                            capital: "Capitale Toto",
                            description: "eurieuruyeruyeury eryeruye ury erieoriueriu rueirueiru  eriueriuerieru Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat.",
                            rate: 5,
                            pictureName: "vietnam",
                            coordinates: Coordinates(latitude: 0.0, longitude: 0.0)
                        )
                        
                        NavigationLink(
                            destination: DetailView(country: fakeCountry)
                                .navigationTitle(fakeCountry.name)
                                
                        ) {
                            CountryRow()
                        }
                        
                    }
                }
            }
            .navigationTitle("Liste de voyages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ListView()
}
