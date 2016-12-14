//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstValueTextField: UITextField!
    @IBOutlet weak var secondValueTextField: UITextField!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    let disposeBag = DisposeBag()
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let operationTypeObservable: Observable<Calculator.Operation> = operationSegmentedControl!.rx.value.map {
            return Calculator.Operation(rawValue: $0)!
        }
        
        let firstValObservable: Observable<Int> = firstValueTextField.rx.text.map {
            let val = $0 ?? "0"
            return Int(val) ?? 0
        }
        
        let secondValObservable: Observable<Int> = secondValueTextField.rx.text.map {
            let val = $0 ?? "0"
            return Int(val) ?? 0
        }
        
        
        let combineObservable: Observable<Int> = Observable.combineLatest(firstValObservable, secondValObservable) { firstVal, secondVal in
            var val = 0
            
            _ = operationTypeObservable
                .asObservable()
                .map{
                    switch $0{
                    case .addition: val = firstVal + secondVal
                    case .subtraction: val = firstVal - secondVal
                    }
                }
            
            return val
        }
        
        let result: Observable<String> = combineObservable.map{
            return String($0)
        }
        
        result
            .bindTo(resultLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        operationTypeObservable
            .asObservable()
            .map{
                switch $0 {
                case .addition: return "+"
                case .subtraction: return "-"
                }
            }.bindTo(operationLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
}

