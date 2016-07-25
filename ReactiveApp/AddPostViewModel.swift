//
//  AddPostViewModel.swift
//  ReactiveApp
//
//  Created by SVYAT on 11.07.16.
//  Copyright © 2016 Svyatoslav Reshetnikov. All rights reserved.
//

import RxSwift
import RxCocoa

class AddPostViewModel {
    
    let validatedText: Observable<Bool>
    let sendEnabled: Observable<Bool>
    
    // If some process in progress
    let indicator: Observable<Bool>
    
    // Has feed send in
    let sendedIn: Observable<AnyObject>
    
    init(input: (
        feedText: Observable<String>,
        sendButton: Observable<Void>
        ),
         dependency: (
        API: API,
        wireframe: Wireframe
        )
        ) {
        let API = dependency.API
        let wireframe = dependency.wireframe
        
        let indicator = ViewIndicator()
        self.indicator = indicator.asObservable()
        
        validatedText = input.feedText
            .map { text in
                return text.characters.count > 0
            }
            .shareReplay(1)
        
        sendedIn = input.sendButton.withLatestFrom(input.feedText)
            .flatMap { feedText -> Observable<AnyObject> in
                return API.addFeed(feedText).trackView(indicator)
            }
            .catchError { error in
                let nsError = error as NSError
                return wireframe.promptFor(nsError.localizedDescription, cancelAction: "OK", actions: [])
                    .map { _ in
                        return error
                    }
                    .flatMap { error -> Observable<Any> in
                        return Observable.error(error)
                }
            }
            .retry()
            .shareReplay(1)
        
        sendEnabled = Observable.combineLatest(
            validatedText,
            indicator.asObservable()
        )   { text, sendingIn in
                text &&
                !sendingIn
            }
            .distinctUntilChanged()
            .shareReplay(1)
    }
}
