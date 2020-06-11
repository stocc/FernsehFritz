import UIKit

class ChannelViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PlayerViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? ChannelViewController else {
            return
        }
        
        let container = transitionContext.containerView
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.frame = fromVC.infoView.frame
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(effectView)
        //fromVC.infoView.alpha = 0
        
        let logoSnap = fromVC.logoImageView.snapshotView(afterScreenUpdates: true)!
        let nameSnap = fromVC.currentChannelLabel.snapshotView(afterScreenUpdates: true)!
        
        logoSnap.frame = container.convert(fromVC.logoImageView.frame, from: fromVC.logoImageView.superview)
        nameSnap.frame = container.convert(fromVC.currentChannelLabel.frame, from: fromVC.currentChannelLabel.superview)
        

        fromVC.logoImageView.isHidden = true
       // fromVC.infoView.isHidden = true
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(logoSnap)
        container.addSubview(nameSnap)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            effectView.frame = toVC.view.frame
            logoSnap.frame = toVC.channelLogo.frame
            var nameRect = toVC.channelNameLabel.frame
            nameRect = CGRect(x: nameRect.origin.x, y: nameRect.origin.y, width: nameSnap.frame.width, height: nameRect.height)
            nameSnap.frame = nameRect
            
        }) { _ in
            
            toVC.view.alpha = 1
            toVC.channelLogo.isHidden = false
            fromVC.logoImageView.isHidden = false
            
            toVC.channelNameLabel.isHidden = false
            fromVC.currentChannelLabel.isHidden = false
            
            fromVC.logoImageView.isHidden = false
            toVC.channelLogo.isHidden = false
                        
            nameSnap.removeFromSuperview()
            logoSnap.removeFromSuperview()
            effectView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
    }


}
