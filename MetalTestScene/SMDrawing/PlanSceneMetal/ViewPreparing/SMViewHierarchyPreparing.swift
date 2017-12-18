/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * A static class for preparing the view hierarchy whis standart UI elements.
 */

import UIKit

typealias ContainerViewHierarchy = (scrollView: UIScrollView,
                                    scrollContainerView: UIView,// The view that we will rotate is located on scrollView
                                    drawContainerView: UIView)// View that we will scales is located on scrollContainerView

class SMViewHierarchyPreparing {
  
// MARK: - Container view hierarchy
  
  static func prepareViewHierarchy(mainContainerView: UIView) -> ContainerViewHierarchy {
    let hierarchy: ContainerViewHierarchy = (scrollView: UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)),
                                             scrollContainerView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)),
                                             drawContainerView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
    
    hierarchy.scrollView.isUserInteractionEnabled = true
    
    // Scroll
    setupScroll(mainContainerView: mainContainerView, scrollView: hierarchy.scrollView)
    // Scroll container view
    setupScrollContainerView(scrollView: hierarchy.scrollView, scrollContainerView: hierarchy.scrollContainerView)
    // Draw container view
    setupDrawContainerView(scrollContainerView: hierarchy.scrollContainerView, drawContainerView: hierarchy.drawContainerView)
    mainContainerView.layoutIfNeeded()
    
    return hierarchy
  }
  //-----------------------------------------------------------------------------------
  
  static private func setupScroll(mainContainerView: UIView, scrollView: UIView) {
    mainContainerView.addSubview(scrollView)
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    // Top
    mainContainerView.addConstraint(NSLayoutConstraint(item: scrollView,
                                                       attribute: .top,
                                                       relatedBy: .equal,
                                                       toItem: mainContainerView,
                                                       attribute: .top,
                                                       multiplier: 1,
                                                       constant: 0))
    // Bottom
    mainContainerView.addConstraint(NSLayoutConstraint(item: scrollView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: mainContainerView,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: 0))
    // Leading
    mainContainerView.addConstraint(NSLayoutConstraint(item: scrollView,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: mainContainerView,
                                                       attribute: .leading,
                                                       multiplier: 1,
                                                       constant: 0))
    // Trailing
    mainContainerView.addConstraint(NSLayoutConstraint(item: scrollView,
                                                       attribute: .trailing,
                                                       relatedBy: .equal,
                                                       toItem: mainContainerView,
                                                       attribute: .trailing,
                                                       multiplier: 1,
                                                       constant: 0))
  }
  //-----------------------------------------------------------------------------------
  
  static private func setupScrollContainerView(scrollView: UIScrollView, scrollContainerView: UIView) {
    scrollView.addSubview(scrollContainerView)
    
    scrollContainerView.translatesAutoresizingMaskIntoConstraints = false
    
    // Top
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0))
    // Bottom
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .bottom,
                                                multiplier: 1,
                                                constant: 0))
    // Leading
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .leading,
                                                multiplier: 1,
                                                constant: 0))
    // Trailing
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .trailing,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .trailing,
                                                multiplier: 1,
                                                constant: 0))
    // Equal width
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .width,
                                                multiplier: 1,
                                                constant: 0))
    // Equal height
    scrollView.addConstraint(NSLayoutConstraint(item: scrollContainerView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .height,
                                                multiplier: 1,
                                                constant: 0))
  }
  //-----------------------------------------------------------------------------------
  
  static private func setupDrawContainerView(scrollContainerView: UIView, drawContainerView: UIView) {
    scrollContainerView.addSubview(drawContainerView)
    
    drawContainerView.translatesAutoresizingMaskIntoConstraints = false
    
    // Top
    scrollContainerView.addConstraint(NSLayoutConstraint(item: drawContainerView,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: scrollContainerView,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: 0))
    // Bottom
    scrollContainerView.addConstraint(NSLayoutConstraint(item: drawContainerView,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: scrollContainerView,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: 0))
    // Leading
    scrollContainerView.addConstraint(NSLayoutConstraint(item: drawContainerView,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: scrollContainerView,
                                                         attribute: .leading,
                                                         multiplier: 1,
                                                         constant: 0))
    // Trailing
    scrollContainerView.addConstraint(NSLayoutConstraint(item: drawContainerView,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: scrollContainerView,
                                                         attribute: .trailing,
                                                         multiplier: 1,
                                                         constant: 0))
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Location view hierarchy
}
