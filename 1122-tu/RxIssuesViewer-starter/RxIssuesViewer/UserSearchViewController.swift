//
//  UserSearchViewController.swift
//  RxIssuesViewer
//
//  Created by fnord on 11/22/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class UserSearchViewController: UIViewController {
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userOrOrgIcon: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var reposButton: UIButton!
    let disposeBag = DisposeBag()
    
    var user: User?
    var searchTextVariable: Variable<String> = Variable("")
    var searchFieldTextObservable: Observable<String>

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        searchField
            .rx.text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter{ ($0?.characters.count)! > 0 }
            .distinctUntilChanged { (a, b) -> Bool in
                return a == b
            }
            .subscribe(onNext: { (next) in
                let req = URLRequest(url: RxGitHubAPI.url(for: RxGitHubAPI.GitHubEndpoint.user(next ?? ""))!)
                
                let responseJSON = URLSession.shared.rx.json(request: req)
                
                let cancelRequest = responseJSON.subscribe(onNext: { (json) in
                    let usableJSON = JSON(json)
                    print(usableJSON)
                    self.user = User(identifier: usableJSON["id"].int ?? 0, login: usableJSON["login"].string!, name: usableJSON["name"].string ?? "", email: usableJSON["email"].string ?? "")
                        
                }, onError: {(error) in
                    print(error)
                }, onCompleted: {() in
                    print("Complete")
                }, onDisposed: {() in
                    print("Disposed")
                })
                
                
                Thread.sleep(forTimeInterval: 3.0)
                
                // if you want to cancel request after 3 seconds have passed just call
                cancelRequest.dispose()
            }, onError: {(error) in
                print(error)
            }, onCompleted: {() in
                print("Complete")
            }, onDisposed: {() in
                print("Disposed")
            })
            .addDisposableTo(self.disposeBag)
//        let userString: Observable<String> = searchFieldObservable.map {
//            var returnString = ""
//            
//            returnString += "login: " + $0.login
//            
//            return returnString
//        }
//        
//        userString
//            .bindTo(userInfoLabel.rx.text)
//            .addDisposableTo(disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
