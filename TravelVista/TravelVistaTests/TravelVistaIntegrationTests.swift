//
//  TravelVistaIntegrationTests.swift
//  TravelVistaTests
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import XCTest
import SwiftUI
@testable import TravelVista

class TravelVistaIntegrationTests: XCTestCase {

    func testDetailViewControllerStoryboardInstantiationAndDataInjection() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mockCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        let mockCountry = Country(name: "France", capital: "Paris", description: "Une belle description.", rate: 5, pictureName: "france_img", coordinates: mockCoordinates)
        
        // When : Instanciation comme le ferait le pont SwiftUI
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        
        // Injection de la dépendance
        detailVC?.country = mockCountry
        
        // Force le rendu de la vue en mémoire (déclenche viewDidLoad)
        detailVC?.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(detailVC, "Le DetailViewController doit pouvoir être instancié depuis le Storyboard avec le bon ID.")
        XCTAssertEqual(detailVC?.title, "France", "Le viewDidLoad devrait avoir assigné le nom du pays au titre du ViewController.")
        XCTAssertEqual(detailVC?.descriptionTextView.text, "Une belle description.", "La description doit correspondre à celle du pays injecté.")
    }
}
