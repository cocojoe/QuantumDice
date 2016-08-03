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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuantumJSONRetrieval() {
        
        let expectation = expectationWithDescription("QuantumJSONData")
        
        let URL = "https://\(Constants.Quantum.domain)/API/jsonI.php"
        let parameters = ["length": Constants.Quantum.block, "type" :  Constants.Quantum.type]
        
        NetworkManager.sharedInstance.requestJSON(URL, parameters: parameters) {
            (result: Bool, jsonData: JSON?) in
  
                XCTAssertNotNil(jsonData, "JSON Should not be nil")
                expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
