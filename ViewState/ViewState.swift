//
//  ViewStatw.swift
//  ViewState
//
//  Created by Jamie Pinkham on 12/21/16.
//  Copyright © 2016 jamiepinkham. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ViewState<T> {
    case result(T)
    case empty
    case loading
    case error(Error)
}

protocol ViewStateDriven {
    associatedtype Result
    var state: AnyObserver<ViewState<Result>> { get }
}
