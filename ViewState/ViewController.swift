//
//  ViewController.swift
//  ViewState
//
//  Created by Jamie Pinkham on 12/21/16.
//  Copyright © 2016 jamiepinkham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum DemoError: Error {
    case something
}

class ViewController: UIViewController {
    
    @IBOutlet var resultView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var refreshItem: UIBarButtonItem!
    
    let backgroundColors: [UIColor] = [.blue, .orange, .red, .green]
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshItem
            .rx.tap
            .scan(0) { previousValue,_ in
                return previousValue + 1
            }
            .map { int -> ViewState<UIColor> in
                if int % 10 == 0 {
                    return .error(DemoError.something)
                } else if int % 2 == 0 {
                    let rand = arc4random_uniform(UInt32(self.backgroundColors.count))
                    return .result(self.backgroundColors[Int(rand)])
                } else {
                    return .empty
                }
            }
            .asDriver(onErrorRecover: { error in
                return Driver.just(.error(error))
            })
            .drive(self.viewState)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ViewStateTransitionable {
    typealias Result = UIColor
    typealias UIElement = ViewController
    var viewState: UIBindingObserver<UIElement, ViewState<Result>> {
        return UIBindingObserver(UIElement: self) { viewController, state in
            switch state {
            case .result(let color):
                self.resultView.backgroundColor = color
                UIView.transition(with: self.resultView, duration: 0.2, options: [], animations: {
                    self.view.bringSubview(toFront: self.resultView)
                }, completion: nil)
            case .empty:
                UIView.transition(with: self.emptyView, duration: 0.2, options: [], animations: {
                    self.view.bringSubview(toFront: self.emptyView)
                }, completion: nil)
            case .error:
                UIView.transition(with: self.errorView, duration: 0.2, options: [], animations: {
                    self.errorLabel.text = "An error occurred"
                    self.view.bringSubview(toFront: self.errorView)
                }, completion: nil)
            default: return
            }
        }
    }
    
}

