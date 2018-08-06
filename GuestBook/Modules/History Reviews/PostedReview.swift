//
//  PostedReview.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 31.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class PostedReview: UIViewController {
    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageViewController : UIPageViewController?
    var currentIndex : Int = 0
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentAdded(_:)), name: Notification.Name.init(Notification.Keys.publicCommentAdded), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func commentAdded(_ notification: NSNotification) {
        guard let comment = notification.userInfo?["comment"] as? Comment else {
            return
        }
        self.comments.insert(comment, at: 0)
        self.loadPageViewControllers()
    }
    
    func loadComments() {
        DataManager.shared.getComments { (result) in
            self.comments = result
            if self.comments.count > 0 {
                self.loadPageViewControllers()
            }
        }
    }
    
    func loadPageViewControllers() {
        let startingViewController: PostedReviewContent = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: pageView.frame.size.height)
        
        addChildViewController(pageViewController!)
        self.pageView.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        pageControl.numberOfPages = comments.count
        pageControl.currentPage = 0
    }
    
    func viewControllerAtIndex(index: Int) -> PostedReviewContent? {
        if self.comments.count == 0 || index >= self.comments.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        guard let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostedReviewContent") as? PostedReviewContent else {
            return nil
        }
        pageContentViewController.comment = comments[index]
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
}

extension PostedReview: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageControl.currentPage = currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        currentIndex = (pendingViewControllers.first as! PostedReviewContent).pageIndex
    }
}

extension PostedReview: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let pageContent = viewController as? PostedReviewContent else {
            return nil
        }
        
        var index = pageContent.pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContent = viewController as? PostedReviewContent else {
            return nil
        }
        
        var index = pageContent.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if (index == self.comments.count) {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return comments.count
    }
    
}
