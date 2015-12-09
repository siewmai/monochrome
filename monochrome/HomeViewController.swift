//
//  HomeViewController.swift
//  monochrome
//
//  Created by Siew Mai Chan on 09/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    var ref: Firebase!
    var handle: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Firebase(url: "\(FIREBASE_URL)")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
    
        handle = ref.childByAppendingPath("feeds").childByAppendingPath(uid).observeEventType(.ChildAdded, withBlock: { snapshot in
            print(snapshot.value)
            
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                let post = Post(key: key, dictionary: dictionary)
                self.posts.append(post)
                print(post)
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        ref.removeObserverWithHandle(handle)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as? PostTableViewCell {
            cell.configure(post)
            return cell
        } else {
            let cell = PostTableViewCell()
            cell.configure(post)
            return cell
        }
    }
}
