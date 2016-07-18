//
//  ReactiveAppTests.swift
//  ReactiveAppTests
//
//  Created by Svyatoslav Reshetnikov on 25.01.16.
//  Copyright © 2016 Svyatoslav Reshetnikov. All rights reserved.
//

import XCTest
import RxTests
@testable import ReactiveApp

let resolution: NSTimeInterval = 0.2 // seconds

class ReactiveAppTests: XCTestCase {
    
    let booleans = ["t" : true, "f" : false]
    let events = ["x" : ()]
    let errors = [
        "#1" : NSError(domain: "Some unknown error maybe", code: -1, userInfo: nil),
        "#u" : NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
    ]
    
    let stringValues = [
        "h" : "Hello",
        "u2" : "secretuser",
        "u3" : "secretusername",
        "p1" : "huge secret",
        "p2" : "secret",
        "e" : ""
    ]
    
    let feed = []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_addFeed() {
        //let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)
    }
}

// MARK: Mocks

/*extension ReactiveAppTests {
    func mockAPI(scheduler: TestScheduler) -> API {
        return MockAPI(
            getFeeds: scheduler.mock(booleans, errors: errors) { _ -> String in
                if username == "secretusername" {
                    return "---t"
                }
                else if username == "secretuser" {
                    return "---#1"
                }
                else {
                    return "---f"
                }
            },
            getFeedInfo: scheduler.mock(booleans, errors: errors) { _ -> String in
                if username == "secretusername" {
                    return "---t"
                }
                else if username == "secretuser" {
                    return "---#1"
                }
                else {
                    return "---f"
                }
            },
            addFeed: scheduler.mock(booleans, errors: errors) { _ -> String in
                if username == "secretusername" {
                    return "---t"
                }
                else if username == "secretuser" {
                    return "---#1"
                }
                else {
                    return "---f"
                }
            }
        )
    }
}*/
