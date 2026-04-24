//
//  TravelVistaTests.swift
//  TravelVistaTests
//
//  Created by Mathieu ARRIO on 01/04/2026.
//

import XCTest
import UIKit
@testable import TravelVista

class TravelVistaUnitTests: XCTestCase {

    // MARK: - Test CustomCell.setUpCell

    // Références fortes pour les sous-vues (les outlets de CustomCell sont weak)
    private var nameLabel: UILabel!
    private var capitalLabel: UILabel!
    private var rateLabel: UILabel!
    private var imageView: UIImageView!

    /// Crée une CustomCell avec des outlets connectés manuellement (pas de storyboard)
    private func makeCustomCell() -> CustomCell {
        let cell = CustomCell(style: .default, reuseIdentifier: "CustomCell")

        nameLabel = UILabel()
        capitalLabel = UILabel()
        rateLabel = UILabel()
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))

        cell.countryNameLabel = nameLabel
        cell.capitalLabel = capitalLabel
        cell.rateLabel = rateLabel
        cell.countryImageView = imageView

        return cell
    }

    private func makeSampleCountry() -> Country {
        return Country(
            name: "TestPays",
            capital: "TestCapitale",
            description: "Description test",
            rate: 5,
            pictureName: "italie",
            coordinates: Coordinates(latitude: 0.0, longitude: 0.0)
        )
    }

    func testSetUpCellConfiguresLabelsCorrectly() throws {
        // Given
        let cell = makeCustomCell()
        let country = makeSampleCountry()

        // When
        cell.setUpCell(country: country)

        // Then
        XCTAssertEqual(cell.countryNameLabel.text, "TestPays", "Le label du nom doit afficher le nom du pays.")
        XCTAssertEqual(cell.capitalLabel.text, "TestCapitale", "Le label de la capitale doit afficher la capitale.")
        XCTAssertEqual(cell.rateLabel.text, "5", "Le label de la note doit afficher la note convertie en String.")
    }

    func testSetUpCellStoresCountry() throws {
        // Given
        let cell = makeCustomCell()
        let country = makeSampleCountry()

        // When
        cell.setUpCell(country: country)

        // Then
        XCTAssertEqual(cell.country?.name, "TestPays", "La propriété country de la cellule doit être mise à jour.")
        XCTAssertEqual(cell.country?.capital, "TestCapitale")
        XCTAssertEqual(cell.country?.rate, 5)
    }

    func testSetUpCellMakesImageCircular() throws {
        // Given
        let cell = makeCustomCell()
        let country = makeSampleCountry()

        // When
        cell.setUpCell(country: country)

        // Then
        let expectedRadius = cell.countryImageView.frame.size.width / 2
        XCTAssertEqual(cell.countryImageView.layer.cornerRadius, expectedRadius, "L'image doit être arrondie en cercle (cornerRadius = largeur / 2).")
    }

    func testSetUpCellLoadsImage() throws {
        // Given
        let cell = makeCustomCell()
        let country = makeSampleCountry()

        // When
        cell.setUpCell(country: country)

        // Then
        XCTAssertNotNil(cell.countryImageView.image, "L'image du pays doit être chargée depuis les assets.")
    }

    // MARK: - Test Service

    // Test du Service de chargement JSON
    func testServiceLoadsDataCorrectly() throws {
        // Given
        let service = Service()

        // When
        let regions: [Region] = try service.load("Source.json")

        // Then
        XCTAssertFalse(regions.isEmpty, "Le fichier Source.json devrait contenir des régions.")

        let firstRegion = try XCTUnwrap(regions.first, "La liste des régions ne devrait pas être nulle.")
        XCTAssertFalse(firstRegion.countries.isEmpty, "La région devrait contenir des pays.")

        let firstCountry = try XCTUnwrap(firstRegion.countries.first)
        XCTAssertNotNil(firstCountry.name, "Le pays doit avoir un nom valide.")
        XCTAssertGreaterThan(firstCountry.rate, 0, "La note du pays doit être supérieure à 0.")
    }

    // MARK: - Test Service.load — Gestion d'erreurs

    func testLoadThrowsFileNotFoundForInvalidFilename() {
        // Given
        let service = Service()

        // When / Then
        XCTAssertThrowsError(try (service.load("FichierInexistant.json") as [Region])) { error in
            guard let serviceError = error as? ServiceError else {
                return XCTFail("L'erreur doit être de type ServiceError.")
            }
            if case .fileNotFound(let filename) = serviceError {
                XCTAssertEqual(filename, "FichierInexistant.json", "Le nom du fichier doit être inclus dans l'erreur.")
            } else {
                XCTFail("L'erreur doit être de type .fileNotFound, reçu : \(serviceError)")
            }
        }
    }

    func testLoadThrowsParsingFailedForInvalidJSON() {
        // Given
        let service = Service()

        // When / Then — Info.plist existe dans le bundle mais n'est pas un JSON valide pour [Region]
        XCTAssertThrowsError(try (service.load("Info.plist") as [Region])) { error in
            guard let serviceError = error as? ServiceError else {
                return XCTFail("L'erreur doit être de type ServiceError.")
            }
            if case .parsingFailed(let filename, _) = serviceError {
                XCTAssertEqual(filename, "Info.plist", "Le nom du fichier doit être inclus dans l'erreur.")
            } else {
                XCTFail("L'erreur doit être de type .parsingFailed, reçu : \(serviceError)")
            }
        }
    }

    // MARK: - Test ServiceError.errorDescription

    func testErrorDescriptionFileNotFound() {
        // Given
        let error = ServiceError.fileNotFound("Test.json")

        // When
        let description = error.errorDescription

        // Then
        XCTAssertEqual(description, "Impossible de trouver Test.json dans le bundle principal.")
    }

    func testErrorDescriptionLoadingFailed() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "fichier corrompu"])
        let error = ServiceError.loadingFailed("Test.json", underlyingError)

        // When
        let description = error.errorDescription

        // Then
        XCTAssertTrue(description?.contains("Impossible de charger Test.json") == true, "Le message doit mentionner le fichier.")
        XCTAssertTrue(description?.contains("fichier corrompu") == true, "Le message doit contenir la description de l'erreur sous-jacente.")
    }

    func testErrorDescriptionParsingFailed() {
        // Given
        let underlyingError = NSError(domain: "test", code: 2, userInfo: [NSLocalizedDescriptionKey: "format invalide"])
        let error = ServiceError.parsingFailed("Test.json", underlyingError)

        // When
        let description = error.errorDescription

        // Then
        XCTAssertTrue(description?.contains("Impossible de décoder Test.json") == true, "Le message doit mentionner le fichier.")
        XCTAssertTrue(description?.contains("format invalide") == true, "Le message doit contenir la description de l'erreur sous-jacente.")
    }
}
