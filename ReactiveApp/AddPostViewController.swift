//
//  AddPostViewController.swift
//  ReactiveApp
//
//  Created by SVYAT on 11.07.16.
//  Copyright © 2016 Svyatoslav Reshetnikov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class AddProfileViewController: UIViewController {
    
    @IBOutlet weak var feedTextView: UITextView!
    @IBOutlet weak var sendFeed: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = AddPostViewModel(
            input: (
                feedText: feedTextView.rx_text.asObservable(),
                sendButton: sendFeed.rx_tap.asObservable()
            ),
            dependency: (
                API: APIManager.sharedAPI,
                wireframe: DefaultWireframe.sharedInstance
            )
        )
        
        let progress = MBProgressHUD()
        progress.mode = MBProgressHUDMode.Indeterminate
        progress.labelText = "Загрузка данных..."
        progress.dimBackground = true
        
        viewModel.indicator.asObservable()
            .bindTo(progress.rx_mbprogresshud_animating)
            .addDisposableTo(disposeBag)
        
        viewModel.sendEnabled
            .subscribeNext { [weak self] valid  in
                self!.sendFeed.enabled = valid
                self!.sendFeed.alpha = valid ? 1.0 : 0.5
            }
            .addDisposableTo(self.disposeBag)
        
        viewModel.sendedIn
            .flatMap { _ -> Observable<String> in
                return DefaultWireframe.sharedInstance.promptFor("Ваша запись успешно опубликована!", cancelAction: "OK", actions: [])
                    .flatMap { action -> Observable<Any> in
                        return Observable.just(action)
                    }
            }
            .subscribeNext { action in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            .addDisposableTo(self.disposeBag)
        
        let tapBackground = UIPanGestureRecognizer()
        tapBackground.cancelsTouchesInView = false
        tapBackground.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
