//
//  NotImplementedStubs.swift
//  ReactiveApp
//
//  Created by SVYAT on 18.07.16.
//  Copyright © 2016 Svyatoslav Reshetnikov. All rights reserved.
//

import Foundation
import RxSwift
import RxTests

// MARK: Not implemented stubs

func notImplemented<T1, T2>() -> (T1) -> Observable<T2> {
    return { _ in
        //fatalError()
        return Observable.empty()
    }
}

func notImplementedSync<T1>() -> (T1) -> Void {
    return { _ in
        fatalError()
    }
}
