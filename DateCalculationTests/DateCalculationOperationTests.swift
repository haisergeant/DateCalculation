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
        let expectation = self.expectation(description: "Test data from 13/08/2014 to 21/08/2014")
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
                XCTAssert(data.0 == 22, "Should return 22")
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
    
    func testDateFrom01042020To30042020() {
        let start = Date.date(from: "01/04/2020")!
        let end = Date.date(from: "30/04/2020")!
        let expectation = self.expectation(description: "Test data from 01/04/2020 to 30/04/2020")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 18, "Should return 20")
                XCTAssert(data.1.count == 2, "Good Friday and Easter Monday")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom01062020to30062020() {
        let start = Date.date(from: "01/06/2020")!
        let end = Date.date(from: "30/06/2020")!
        let expectation = self.expectation(description: "Test data from 01/06/2020 to 30/06/2020")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 19, "Should return 19")
                XCTAssert(data.1.count == 1, "Queen birthday")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom01102020to30102020() {
        let start = Date.date(from: "01/10/2020")!
        let end = Date.date(from: "31/10/2020")!
        let expectation = self.expectation(description: "Test data from 01/10/2020 to 31/10/2020")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 20, "Should return 20")
                XCTAssert(data.1.count == 1, "Labour day")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom29112020to03012021() {
        let start = Date.date(from: "29/11/2020")!
        let end = Date.date(from: "03/01/2021")!
        let expectation = self.expectation(description: "Test data from 29/11/2020 to 03/01/2021")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 22, "Should return 22")
                XCTAssert(data.1.count == 3, "Christmas, Boxing day and New year day")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDateFrom04102021to31122021() {
        let start = Date.date(from: "04/10/2021")!
        let end = Date.date(from: "31/12/2021")!
        let expectation = self.expectation(description: "Test data from 04/10/2021 to 31/12/2021")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 == 61, "Should return 61")
                XCTAssert(data.1.count == 2, "Christmas, Boxing day")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPerformanceFrom01010001to31123999() {
        let start = Date.date(from: "01/01/0001")!
        let end = Date.date(from: "31/12/3999")!
        let expectation = self.expectation(description: "Test data from 01/01/0001 to 31/12/3999")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        let date = Date()
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 > 0, "Should return value")
                let interval = Date().timeIntervalSince(date)
                XCTAssert(interval < 3, "The operation should finish less than 3s")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testPerformanceFrom01010001to311210000() {
        let start = Date.date(from: "01/01/0001")!
        let end = Date.date(from: "31/12/10000")!
        let expectation = self.expectation(description: "Test data from 01/01/0001 to 31/12/10000")
        let operation = DateCalculationOperation(state: "nsw",
                                                 date1: start,
                                                 date2: end)
        let date = Date()
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssert(data.0 > 0, "Should return value")
                let interval = Date().timeIntervalSince(date)
                XCTAssert(interval < 8, "The operation should finish less than 8s")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "Should not return failure")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 8.0, handler: nil)
    }
}
