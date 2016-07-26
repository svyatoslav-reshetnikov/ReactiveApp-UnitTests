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
    // Для событий кнопки
    let events = ["x" : ()]
    let errors = [
        "#1" : NSError(domain: "Some unknown error maybe", code: -1, userInfo: nil),
    ]
    
    let textValues = [
        "ft" : "feed",
        "e" : ""
    ]
    
    let feeds = [
        "fs" : GetFeedsResponse()
    ]
    
    let feedInfo = [
        "fi" : GetFeedInfoResponse()
    ]
    
    let feedArray = [
        "fa" : [Feed]()
    ]
    
    let feed = [
        "f" : Feed(createdTime: "1", feedId: "1")
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFeed() {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)
        
        // mock the universe
        let mock = mockAPI(scheduler)
        
        // expected events and test data
        let (
        feedTextEvents,
            buttonTapEvents,
                
                expectedValidatedTextEvents,
                    expectedSendFeedEnabledEvents
                        ) = (
                            scheduler.parseEventsAndTimes("e----------ft------", values: textValues).first!,
                            scheduler.parseEventsAndTimes("-----------------x-", values: events).first!,
                                    
                            scheduler.parseEventsAndTimes("f----------t-------", values: booleans).first!,
                            scheduler.parseEventsAndTimes("f----------t-------", values: booleans).first!
        )
        
        let wireframe = MockWireframe()
        
        let viewModel = AddPostViewModel(
            input: (
                feedText: scheduler.createHotObservable(feedTextEvents).asObservable(),
                sendButton: scheduler.createHotObservable(buttonTapEvents).asObservable()
            ),
            dependency: (
                API: mock,
                wireframe: wireframe
            )
        )
        
        // run experiment
        let recordedSendFeedEnabled = scheduler.record(viewModel.sendEnabled)
        let recordedValidatedTextEvents = scheduler.record(viewModel.validatedText)
        
        scheduler.start()
        
        // validate
        XCTAssertEqual(recordedValidatedTextEvents.events, expectedValidatedTextEvents)
        XCTAssertEqual(recordedSendFeedEnabled.events, expectedSendFeedEnabledEvents)
    }
    
    func testFeeds() {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)
        
        // mock the universe
        let mock = mockAPI(scheduler)
        
        // expected events and test data
        let (
        expectedClickCell,
            expectedClickObservable
                ) = (
                    scheduler.parseEventsAndTimes("----f--------------", values: feed).first!,
                    scheduler.parseEventsAndTimes("----------fi-------", values: feedInfo).first!
        )
        
        let wireframe = MockWireframe()
        
        let viewModel = FeedsViewModel(
            input: (
                scheduler.createHotObservable(expectedClickCell).asObservable()
            ),
            dependency: (
                API: mock,
                wireframe: wireframe
            )
        )
        
        // run experiment
        let recordedClickObservable = scheduler.record(viewModel.clickObservable)
        
        scheduler.start()
        
        // validate
        XCTAssertEqual(recordedClickObservable.events.count, expectedClickObservable.count)
    }
}

// MARK: Mocks
extension ReactiveAppTests {
    func mockAPI(scheduler: TestScheduler) -> API {
        return MockAPI(
            getFeeds: scheduler.mock(feeds, errors: errors) { _ -> String in
                return "--fs"
            },
            getFeedInfo: scheduler.mock(feedInfo, errors: errors) { _ -> String in
                return "--fi"
            },
            addFeed: scheduler.mock(textValues, errors: errors) { _ -> String in
                return "--ft"
            }
        )
    }
}
