//
//  RandomNumberTests.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import QuantumDice

class RandomNumberGeneratorTests: XCTestCase {
    
    let RNG = RandomNumberGenerator()
    let JSONSampleGood = JSON.parse("{\"type\":\"uint8\",\"length\":10,\"data\":[197,202,139,42,209,125,69,103,93,99],\"success\":true}")
    let JSONSampleBad = JSON.parse("{\"type\":\"uint8\",\"length\":10,\"data\":[197,202,139,42,209,125,69,103,93],\"success\":true}")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuantumJSONRetrievalSuccess() {
        
        let expectation = expectationWithDescription("QuantumJSONData")
        
        let URL = "https://\(Constants.Quantum.domain)/API/jsonI.php"
        let parameters = ["length": String(Constants.Quantum.block), "type" :  Constants.Quantum.type]
        
        NetworkManager.sharedInstance.requestJSON(URL, parameters: parameters) {
            (result: Bool, jsonData: JSON?) in
  
                XCTAssertNotNil(jsonData, "JSON Should not be nil")
                expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testQuantumJSONRetrievalFailure() {
        
        let expectation = expectationWithDescription("QuantumJSONData")
        
        // Bad URL
        let URL = "https://\(Constants.Quantum.domain)/API/jsonI1.php"
        let parameters = ["length": String(Constants.Quantum.block), "type" :  Constants.Quantum.type]
        
        NetworkManager.sharedInstance.requestJSON(URL, parameters: parameters) {
            (result: Bool, jsonData: JSON?) in
            
            XCTAssertNil(jsonData, "JSON Should be nil")
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testPopulateQuantumBlockSuccess() {
        
        RNG.populateQuantumBlock(JSONSampleGood)
        let count = RNG.quantumBlock.count
        
        XCTAssertEqual(count,Constants.Quantum.block)
    }
    
    func testPopulateQuantumBlockFailure() {
        
        RNG.populateQuantumBlock(JSONSampleBad)
        let count = RNG.quantumBlock.count
        
        XCTAssertEqual(count,Constants.Quantum.block - 1)
    }
    
    func testNextNumberInBase20Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d20)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d20.rawValue)
    }
    
    func testNextNumberInBase12Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d12)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d12.rawValue)
    }
    
    func testNextNumberInBase10Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d10)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d10.rawValue)
    }
    
    func testNextNumberInBase8Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d8)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d8.rawValue)
    }
    
    func testNextNumberInBase6Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d6)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d6.rawValue)
    }
    
    func testNextNumberInBase4Success() {
        RNG.populateQuantumBlock(JSONSampleGood)
        
        let randomNumber = RNG.nextNumberInBase(Dice.d4)
        XCTAssertGreaterThanOrEqual(randomNumber, 1)
        XCTAssertLessThanOrEqual(randomNumber, Dice.d4.rawValue)
    }
    
}
