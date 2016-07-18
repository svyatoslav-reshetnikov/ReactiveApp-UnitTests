//
//  MockAPI.swift
//  ReactiveApp
//
//  Created by SVYAT on 18.07.16.
//  Copyright © 2016 Svyatoslav Reshetnikov. All rights reserved.
//

import Foundation
import RxSwift
@testable import ReactiveApp

class MockAPI : API {
    
    let _getFeeds: () -> Observable<GetFeedsResponse>
    let _getFeedInfo: (String) -> Observable<GetFeedInfoResponse>
    let _addFeed: (String) -> Observable<Any>
    
    init(
        getFeeds: () -> Observable<GetFeedsResponse> = notImplemented(),
        getFeedInfo: (String) -> Observable<GetFeedInfoResponse> = notImplemented(),
        addFeed: (String) -> Observable<Any> = notImplemented()
        ) {
        _getFeeds = getFeeds
        _getFeedInfo = getFeedInfo
        _addFeed = addFeed
    }
    
    func getFeeds() -> Observable<GetFeedsResponse> {
        return _getFeeds()
    }
    
    func getFeedInfo(feedId: String) -> Observable<GetFeedInfoResponse> {
        return _getFeedInfo(feedId)
    }
    
    func addFeed(feedMessage: String) -> Observable<Any> {
        return _addFeed(feedMessage)
    }
}