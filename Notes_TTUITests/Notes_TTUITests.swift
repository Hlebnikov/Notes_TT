

//
//  Notes_TTUITests.swift
//  Notes_TTUITests
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import XCTest

class Notes_TTUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        app.navigationBars["Notes_TT.View"].childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        
        let element = app.otherElements.containingType(.NavigationBar, identifier:"Новая запись").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let textField = element.childrenMatchingType(.TextField).element
        textField.tap()
        textField.typeText("new")
        
        
        let textView = element.childrenMatchingType(.TextView).element
        textView.tap()
        textView.typeText("Ghyf")
        app.navigationBars["Новая запись"].buttons["Save"].tap()
        
        XCTAssert(app.textFields["new"].exists)
        
    }
    
}
