//
//  DateCalculationOperationTests.swift
//  DateCalculationTests
//
//  Created by Hai Le Thanh on 5/6/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import XCTest
@testable import DateCalculation

class DateCalculationOperationTests: XCTestCase {
    let queue = OperationQueue()
    
    override func setUp() {
        queue.cancelAllOperations()
    }
    
    func testDateFrom07082014to11082014() {
        let expectation = self.expectation(description: "Test data from 07/08/2014 to 13/08/2014")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: Date.date(from: "07/08/2014")!,
                                                 date2: Date.date(from: "11/08/2014")!)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 1, "Should return 1, Friday 8/8/2014")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom13082014to21082014() {
        let expectation = self.expectation(description: "Test data from 07/08/2014 to 13/08/2014")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: Date.date(from: "13/08/2014")!,
                                                 date2: Date.date(from: "21/08/2014")!)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 5, "Should return 5")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom29122013to31012014() {
        let expectation = self.expectation(description: "Test data from 29/12/2013 to 31/01/2014")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: Date.date(from: "29/12/2013")!,
                                                 date2: Date.date(from: "31/01/2014")!)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 22, "Should return 23")
                XCTAssert(data.1.count == 2, "Holiday is New Year and Australia Day")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom01012020To31012020() {
        let start = Date.date(from: "01/01/2020")!
        let end = Date.date(from: "31/01/2020")!
        let expectation = self.expectation(description: "Test data from 01/01/2020 to 31/01/2020")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 20, "Should return 20")
                XCTAssert(data.1.count == 1, "Australia Day")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
