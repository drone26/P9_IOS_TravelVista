//
//  TravelVistaUITests.swift
//  TravelVistaUITests
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import XCTest

class TravelVistaUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false // Arrête le test immédiatement si une étape échoue
        app = XCUIApplication()
        app.launch() // Lance l'application comme un vrai utilisateur
    }

    // MARK: - Test CustomCell (CountryRow)

    func testCustomCellDisplaysCountryInfo() throws {
        // Vérifie que la liste est chargée
        let navBarTitle = app.navigationBars["Liste de voyages"]
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 3), "L'écran d'accueil doit être affiché.")

        // Vérifie qu'une cellule affiche le nom du pays
        let countryName = app.staticTexts["Italie"]
        XCTAssertTrue(countryName.waitForExistence(timeout: 3), "Le nom du pays doit être affiché dans la cellule.")

        // Vérifie que la capitale est affichée dans la cellule
        let capitalName = app.staticTexts["Rome"]
        XCTAssertTrue(capitalName.waitForExistence(timeout: 3), "La capitale doit être affichée dans la cellule.")

        // Vérifie que la note est affichée dans la cellule
        let rate = app.staticTexts["3"]
        XCTAssertTrue(rate.waitForExistence(timeout: 3), "La note du pays doit être affichée dans la cellule.")

        // Vérifie que l'image du pays est présente
        let countryImage = app.images["italie"]
        XCTAssertTrue(countryImage.waitForExistence(timeout: 3), "L'image du pays doit être affichée dans la cellule.")
    }

    func testCustomCellTapNavigatesToDetail() throws {
        // Vérifie que la liste est chargée
        let navBarTitle = app.navigationBars["Liste de voyages"]
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 3))

        // Tape sur une cellule
        let countryCell = app.staticTexts["Italie"]
        XCTAssertTrue(countryCell.waitForExistence(timeout: 3))
        countryCell.tap()

        // Vérifie que la navigation vers le détail fonctionne
        let detailNavBar = app.navigationBars["Italie"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 3), "Taper sur une cellule doit naviguer vers l'écran de détail du pays.")
    }

    func testMultipleCustomCellsDisplayed() throws {
        // Vérifie que plusieurs cellules sont affichées dans la liste
        let navBarTitle = app.navigationBars["Liste de voyages"]
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 3))

        // Vérifie la présence de plusieurs pays dans la liste
        XCTAssertTrue(app.staticTexts["Italie"].waitForExistence(timeout: 3), "Italie doit être affichée.")
        XCTAssertTrue(app.staticTexts["Norvège"].waitForExistence(timeout: 3), "Norvège doit être affichée.")
    }

    // MARK: - Test End-to-End Navigation

    func testEndToEndNavigation() throws {
        // 1. Vérification de la vue liste (SwiftUI)
        let navBarTitle = app.navigationBars["Liste de voyages"]
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 3), "L'écran d'accueil SwiftUI doit afficher le bon titre de navigation.")

        // 2. Interaction avec la liste SwiftUI — on navigue vers l'Italie
        let italieCell = app.staticTexts["Italie"]
        XCTAssertTrue(italieCell.waitForExistence(timeout: 3), "Le pays Italie doit être affiché dans la liste.")
        italieCell.tap()

        // 3. Vérification de l'écran de Détail (UIKit via SwiftUI Representable)
        let detailNavBar = app.navigationBars["Italie"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 3), "La barre de navigation doit afficher 'Italie' sur l'écran de détail.")

        // Vérifie la présence de la capitale (gérée par UIKit)
        let romeText = app.staticTexts["Rome"]
        XCTAssertTrue(romeText.waitForExistence(timeout: 2), "Le TitleViewSwiftUI injecté dans le DetailViewController doit afficher la capitale.")

        // 4. Test du bouton Map (UIKit vers UIKit)
        let mapButton = app.buttons["openMapButton"]
        XCTAssertTrue(mapButton.waitForExistence(timeout: 2), "Le bouton pour ouvrir la carte doit exister.")
        mapButton.tap()

        // 5. Retour depuis la Map vers le Detail
        let backFromMapButton = app.navigationBars.buttons["Italie"]
        XCTAssertTrue(backFromMapButton.waitForExistence(timeout: 3), "Le bouton retour de la map doit apparaître.")
        backFromMapButton.tap()

        // 6. Retour depuis le Detail vers la Liste
        let backToListButton = app.navigationBars.buttons["Liste de voyages"]
        XCTAssertTrue(backToListButton.waitForExistence(timeout: 3), "Le bouton retour vers la liste doit être visible.")
        backToListButton.tap()

        // 7. Vérification finale — retour sur la liste principale
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 3), "L'utilisateur doit être de retour sur la liste principale après les animations.")
    }
}
