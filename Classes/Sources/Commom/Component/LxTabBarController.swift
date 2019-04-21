//
//  LxTabBarController.swift
//  LxTabBarControllerDemo
//

import UIKit

enum LxTabBarControllerInteractionStopReason {

    case Finished, Cancelled, Failed
}

let LxTabBarControllerDidSelectViewControllerNotification = "LxTabBarControllerDidSelectViewControllerNotification"

private enum LxTabBarControllerSwitchType {

    case Unknown, Last, Next
}

let TRANSITION_DURATION = 0.5
private var _switchType = LxTabBarControllerSwitchType.Unknown

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TRANSITION_DURATION
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)

        switch _switchType {

        case .Last:
            toViewController.view.frame.origin.x = -toViewController.view.frame.size.width
        case .Next:
            toViewController.view.frame.origin.x = toViewController.view.frame.size.width
        case .Unknown:
            break
        }

        UIView.animate(withDuration: TRANSITION_DURATION, animations: { () -> Void in

            switch _switchType {

            case .Last:
                fromViewController.view.frame.origin.x = fromViewController.view.frame.size.width
            case .Next:
                fromViewController.view.frame.origin.x = -fromViewController.view.frame.size.width
            case .Unknown:
                break
            }
            toViewController.view.frame = transitionContext.containerView.bounds

        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class LxTabBarController: UITabBarController,UITabBarControllerDelegate,UIGestureRecognizerDelegate {

    var panToSwitchGestureRecognizerEnabled: Bool {
        get {
            return _panToSwitchGestureRecognizer.isEnabled
        }
        set {
            _panToSwitchGestureRecognizer.isEnabled = newValue
        }
    }

    var recognizeOtherGestureSimultaneously = false
    var isTranslating = false
    var panGestureRecognizerBeginBlock = { () -> Void in }
    var panGestureRecognizerStopBlock = { (stopReason: LxTabBarControllerInteractionStopReason) -> Void in }

    let _panToSwitchGestureRecognizer = UIPanGestureRecognizer()
    var _interactiveTransition: UIPercentDrivenInteractiveTransition?

    convenience init () {
        self.init(nibName: nil, bundle: nil)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setup()
    }

    func setup() {
        self.delegate = self
        _panToSwitchGestureRecognizer.addTarget(self, action: #selector(self.panGestureRecognizerTriggerd(pan:)))
        _panToSwitchGestureRecognizer.delegate = self
        _panToSwitchGestureRecognizer.cancelsTouchesInView = false
        _panToSwitchGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(_panToSwitchGestureRecognizer)
    }

    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return animationController is Transition ? _interactiveTransition : nil
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return Transition()
    }

    @objc func panGestureRecognizerTriggerd(pan: UIPanGestureRecognizer) {

        var progress = pan.translation(in: pan.view!).x / pan.view!.bounds.size.width

        if progress > 0 {
            _switchType = .Last
        }
        else if progress < 0 {
            _switchType = .Next
        }
        else {
            _switchType = .Unknown
        }

        progress = abs(progress)
        progress = max(0, progress)
        progress = min(1, progress)

        switch pan.state {

        case .began:
            isTranslating = true
            _interactiveTransition = UIPercentDrivenInteractiveTransition()
            switch _switchType {

            case .Last:
                selectedIndex = max(0, selectedIndex - 1)
                selectedViewController = viewControllers![selectedIndex] as UIViewController
                panGestureRecognizerBeginBlock()
            case .Next:
                selectedIndex = min(viewControllers!.count, selectedIndex + 1)
                selectedViewController = viewControllers![selectedIndex] as UIViewController
                panGestureRecognizerBeginBlock()
            case .Unknown:
                break
            }
        case .changed:
            _interactiveTransition?.update(CGFloat(progress))
        case .failed:
            isTranslating = false
            panGestureRecognizerStopBlock(.Failed)
        default:

            if abs(progress) > 0.5 {
                _interactiveTransition?.finish()
                panGestureRecognizerStopBlock(.Finished)
            }
            else {
                _interactiveTransition?.cancel()
                panGestureRecognizerStopBlock(.Cancelled)
            }

            _interactiveTransition = nil
            isTranslating = false
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer == _panToSwitchGestureRecognizer {

            return !isTranslating
        }
        else {
            return true
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer == _panToSwitchGestureRecognizer || otherGestureRecognizer == _panToSwitchGestureRecognizer {

            return recognizeOtherGestureSimultaneously
        }
        else {
            return false
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let viewControllerIndex = tabBarController.viewControllers?.index(of: viewController)

        if viewControllerIndex! > selectedIndex {
            _switchType = .Next
        }
        else if viewControllerIndex! < selectedIndex {
            _switchType = .Last
        }
        else {
            _switchType = .Unknown
        }
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter
            .default
            .post(name: NSNotification.Name(rawValue: LxTabBarControllerDidSelectViewControllerNotification), object: nil)
    }
}
