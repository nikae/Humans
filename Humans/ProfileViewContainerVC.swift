//
//  ProfileViewContainerVC.swift
//  Humans
//
//  Created by Nika on 10/3/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class ProfileViewContainerVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {

     @IBOutlet weak var pageControl: UIPageControl!
    
    var pageContainer: UIPageViewController!
    var pages = [UIViewController]()
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page1: UIViewController! = storyboard.instantiateViewController(withIdentifier: "ProfileSettingsVC")
        let page2: UIViewController! = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        let page3: UIViewController! = storyboard.instantiateViewController(withIdentifier: "MapVC")
        let page4: UIViewController! = storyboard.instantiateViewController(withIdentifier: "DatePickerVC")
        //let page5: UIViewController! = storyboard.instantiateViewController(withIdentifier: "connect")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        // pages.append(page5)
        
        //MARK: Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.view.insertSubview(pageContainer.view, at: 0)
        
        for i in pageContainer.view.subviews {
            if let view = i as? UIScrollView {
                view.delegate = self
                break
            }
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        currentIndex = 0
      //  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.next(_:)),  userInfo: nil, repeats: true)
    }
    
    @objc func next(_ timer: Timer) {
        pageContainer.goToNextPage(animated: true, completion: nil)
        currentIndex = currentIndex! + 1
        if currentIndex == pageControl.numberOfPages {
            currentIndex = 0
        }
        pageControl.currentPage = currentIndex!
        
        
    }
    // MARK: - UIPageViewController delegates
    
    func updatePageControl () {
        pageControl.currentPage = currentIndex!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            updatePageControl()
        }else{
            pendingIndex = currentIndex
        }
    }
}
