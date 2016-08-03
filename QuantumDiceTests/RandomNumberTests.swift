//
//  RandomNumberTests.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import XCTest

@testable import QuantumDice

class RandomNumberTests: XCTestCase {
    
    let RNG = RandomNumberGenerator()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRandomNumber() {
        let result = RNG.random()
        XCTAssertTrue(result)
    }
    
    func testQuantumBlock() {
        let result = RNG.quantumBlock()
        XCTAssertTrue(result)
    }

}
