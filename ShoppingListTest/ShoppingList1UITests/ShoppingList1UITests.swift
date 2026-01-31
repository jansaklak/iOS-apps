import XCTest

final class ShoppingList1UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testFullUserFlow() {
        // 1-3. Weryfikacja struktury głównej
        XCTAssertTrue(app.navigationBars["Produkty"].exists)
        XCTAssertTrue(app.tabBars.buttons["Produkty"].exists)
        XCTAssertTrue(app.tabBars.buttons["Koszyk"].exists)

        // 4-6. Produkty z bazy danych
        XCTAssertTrue(app.staticTexts["Jabłko"].exists)
        XCTAssertTrue(app.staticTexts["Banan"].exists)
        XCTAssertTrue(app.staticTexts["Bagietka"].exists)

        // 7. Cena z obsługą lokalizacji (kropka/przecinek)
        let applePricePredicate = NSPredicate(format: "label CONTAINS '2' AND label CONTAINS '50' AND label CONTAINS 'zł'")
        XCTAssertTrue(app.staticTexts.element(matching: applePricePredicate).exists)

        // 8. Szybkie dodawanie Jabłka
        let addAppleButton = app.buttons["Dodaj Jabłko do koszyka"]
        XCTAssertTrue(addAppleButton.exists)
        addAppleButton.tap()

        // 9-10. Szczegóły Jabłka
        app.staticTexts["Jabłko"].tap()
        XCTAssertTrue(app.navigationBars["Jabłko"].exists)
        XCTAssertTrue(app.staticTexts["Opis produktu"].exists)
        
        // 11. Powrót i wejście w szczegóły Banana
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.staticTexts["Banan"].tap()
        
        // 12-13. Opis banana i dodanie z detali
        let descPredicate = NSPredicate(format: "label CONTAINS 'Ekwadoru' AND label CONTAINS 'potasu'")
        XCTAssertTrue(app.staticTexts.element(matching: descPredicate).waitForExistence(timeout: 2))
        app.buttons["Dodaj do koszyka"].tap()

        // 14. Powrót do listy
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 15-16. Przejście do koszyka
        app.tabBars.buttons["Koszyk"].tap()
        XCTAssertTrue(app.navigationBars["Koszyk"].waitForExistence(timeout: 2))

        // 17-19. Zawartość koszyka
        XCTAssertTrue(app.staticTexts["Jabłko"].exists)
        XCTAssertTrue(app.staticTexts["Ilość: 1"].exists)
        XCTAssertTrue(app.staticTexts["Suma"].exists)

        // 20. Suma (Jabłko 2.50 + Banan 4.99 = 7.49)
        let totalSumPredicate = NSPredicate(format: "label CONTAINS '7' AND label CONTAINS '49'")
        XCTAssertTrue(app.staticTexts.element(matching: totalSumPredicate).exists)

        // 21-22. Usuwanie Jabłka
        let removeApple = app.buttons["Usuń Jabłko z koszyka"]
        XCTAssertTrue(removeApple.exists)
        removeApple.tap()

        // 23-24. Weryfikacja po usunięciu
        XCTAssertFalse(app.staticTexts["Jabłko"].exists)
        XCTAssertTrue(app.staticTexts["Banan"].exists)

        // 25. Powrót do produktów
        app.tabBars.buttons["Produkty"].tap()

        // 26-27. Wielokrotne dodawanie Banana
        let addBananQuick = app.buttons["Dodaj Banan do koszyka"]
        addBananQuick.tap() // Teraz są 2 Banany
        app.tabBars.buttons["Koszyk"].tap()
        XCTAssertTrue(app.staticTexts["Ilość: 2"].exists)

        // 28-30. Tytuły i stan końcowy
        app.tabBars.buttons["Produkty"].tap()
        app.staticTexts["Bagietka"].tap()
        XCTAssertEqual(app.navigationBars.firstMatch.identifier, "Bagietka")
        XCTAssertTrue(app.buttons["Dodaj do koszyka"].isHittable)
        XCTAssertTrue(app.tabBars.element.exists)
    }
}
