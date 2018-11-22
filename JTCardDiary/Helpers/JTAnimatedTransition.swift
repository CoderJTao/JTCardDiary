//
//  JTAnimatedTransition.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/31.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Foundation

enum JTAnimationTransitionType {
    case listToDisplay
    case mainPushToDashboard
    case dashboardPopToMain
}

class JTAnimatedTransition: NSObject {
    
    
    var transitionType = JTAnimationTransitionType.listToDisplay
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    /// 返回一个转场对象
    static func animatedTransition(type: JTAnimationTransitionType) -> JTAnimatedTransition {
        let animationTransition = JTAnimatedTransition()
        animationTransition.transitionType = type
        
        return animationTransition
    }
}

extension JTAnimatedTransition: UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //返回动画执行时长
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        switch self.transitionType {
//        case .listToDisplay:
            
            
        case .dashboardPopToMain:
            fromView.frame = containerView.bounds // dashboard view
            toView.frame = containerView.bounds // main
            
            fromView.transform = CGAffineTransform.identity
            
            toView.transform = CGAffineTransform(translationX: 0, y: kScreenHeight-fromView.safeAreaInsets.top-fromView.safeAreaInsets.bottom-100)
            
            containerView.insertSubview(toView, aboveSubview: fromView)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.6, y: 0.7)
                toView.transform = CGAffineTransform.identity
                
            }) { (finished) in
                transitionContext.completeTransition(true)
                fromView.transform = CGAffineTransform.identity
                transitionContext.view(forKey: UITransitionContextViewKey.from)?.layer.mask = nil
                transitionContext.view(forKey: UITransitionContextViewKey.to)?.layer.mask = nil
                
                toView.backgroundColor = UIColor(r: 245, g: 245, b: 245)
            }
        
        default:
            break
        }
        
        
    }
    
// MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let context = self.transitionContext else { return }
        
        // 告诉系统转场动画完成
        context.completeTransition(true)
        
        // 清楚相应控制器视图的mask
        context.view(forKey: UITransitionContextViewKey.from)?.layer.mask = nil
        context.view(forKey: UITransitionContextViewKey.to)?.layer.mask = nil
    }
    
}
