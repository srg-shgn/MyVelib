//
//  RootViewController.swift
//  MyVelib
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  let modelController = ModelController()
  let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
  let pagesDataSource = PagesDataSource()

  @IBOutlet weak var infoButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pagesDataSource.lists = modelController.lists
    
    pageViewController.delegate = self
    pageViewController.dataSource = pagesDataSource
    pageViewController.setViewControllers(pagesDataSource.firstPages, direction: .forward, animated: false, completion: nil)
    
    addChildViewController(pageViewController)
    pageViewController.view.frame = view.bounds
    view.insertSubview(pageViewController.view, at: 0)
    pageViewController.didMove(toParentViewController: self)
    
    refresh()
  }

  func refresh() {
    modelController.refreshStations { (result) in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error) : self.displayError(error)
        case .success: self.refreshUI()
        }
      }
    }
  }
  
  func displayError(_ error: Error) {
    print(error.localizedDescription)
  }

  func refreshUI() {
    (pageViewController.viewControllers?.first as? ListViewController)?.refreshUI()
  }

}

extension RootViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    infoButton.layer.opacity = 0
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    infoButton.layer.opacity = 1
  }
}

class PagesDataSource: NSObject, UIPageViewControllerDataSource {
  var lists: [StationsList]!
  
  let startIndex = 2
  var firstPages: [UIViewController]? { return [page(for: startIndex)] }
  
  func page(for index: Int) -> ListViewController {
    let page = ListViewController.instantiate()
    page.index = index
    page.list = lists[index]
    return page
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentPage = viewController as? ListViewController else { return nil }
    let currentIndex = currentPage.index
    guard currentIndex > 0 else { return nil }
    return page(for: currentIndex - 1)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentPage = viewController as? ListViewController else { return nil }
    let currentIndex = currentPage.index
    guard currentIndex < lists.count - 1 else { return nil }
    return page(for: currentIndex + 1)
  }

}
