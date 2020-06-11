import UIKit
//import Hero

class PlayerViewController: UIViewController, UIViewControllerTransitioningDelegate, ChannelViewControllerDelegate, ChannelSelectionViewControllerDelegate {
    
    var channel: Channel?
    var timer = Timer()
    var touchBegan: TimeInterval = 0
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var otherStuffLabel: UILabel!
    @IBOutlet weak var upcomingLabel: UILabel!
    @IBOutlet weak var currentChannelLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var currentShowLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    weak var playerView: UIView?
    
    private let blurEffectView = UIVisualEffectView()
//    private let animator = ChannelViewTransition()
    private var isInfoViewVisible = false
    
    var panGR: UIPanGestureRecognizer!

    
    var inContext = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // play pause
        let tapPlayPause = UITapGestureRecognizer()
        tapPlayPause.addTarget(self, action: #selector(pressedTVRemotePlayPauseButton))
        tapPlayPause.allowedPressTypes = [NSNumber (value: UIPress.PressType.playPause.rawValue)]
        self.view!.addGestureRecognizer(tapPlayPause)
        
        let menu = UITapGestureRecognizer()
        menu.addTarget(self, action: #selector(pressedMenu))
        menu.allowedPressTypes = [NSNumber (value: UIPress.PressType.menu.rawValue)]
        self.view!.addGestureRecognizer(menu)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        swipeUp.delaysTouchesBegan = true
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        swipeDown.delaysTouchesBegan = true
        
        let pressUp = UITapGestureRecognizer()
        pressUp.addTarget(self, action: #selector(swipedDown))
        pressUp.allowedPressTypes = [NSNumber (value: UIPress.PressType.upArrow.rawValue)]
        self.view!.addGestureRecognizer(pressUp)
        pressUp.delaysTouchesBegan = true
        
        let pressLeft = UITapGestureRecognizer()
        pressLeft.addTarget(self, action: #selector(pressedLeft))
        pressLeft.allowedPressTypes = [NSNumber (value: UIPress.PressType.leftArrow.rawValue)]
        self.view!.addGestureRecognizer(pressLeft)
        pressLeft.delaysTouchesBegan = true
        
        let pressRight = UITapGestureRecognizer()
        pressRight.addTarget(self, action: #selector(pressedRight))
        pressRight.allowedPressTypes = [NSNumber (value: UIPress.PressType.rightArrow.rawValue)]
        self.view!.addGestureRecognizer(pressRight)
        pressRight.delaysTouchesBegan = true
        
        let pressDown = UITapGestureRecognizer()
        pressDown.addTarget(self, action: #selector(swipedUp))
        pressDown.allowedPressTypes = [NSNumber (value: UIPress.PressType.downArrow.rawValue)]
        self.view!.addGestureRecognizer(pressDown)
        pressDown.delaysTouchesBegan = true
 
        //only apply the blur if the user hasn't disabled transparency effects
        infoView.layer.cornerRadius = 20
        infoView.layer.masksToBounds = true
        
        blurEffectView.effect = UIBlurEffect(style: .light)
        blurEffectView.frame = self.infoView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        self.infoView.insertSubview(blurEffectView, at: 0)
        view.bringSubviewToFront(infoView)
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGR.cancelsTouchesInView = false
        panGR.delaysTouchesBegan = true
        playerView = view

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.didSelectChannel(channel!)
        playerView!.addGestureRecognizer(panGR)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "channel" {
            let destination = segue.destination as! ChannelViewController
//            destination.transitioningDelegate = self
            destination.channel = self.channel
            destination.image = logoImageView.image
            let _ = destination.view
            destination.delegate = self
            
        } else if segue.identifier == "channelSelection" {
            let destination = segue.destination as! ChannelSelectionCollectionViewController
            destination.delegate = self
            let _ = destination.view
            destination.isInContext = true
            infoView.fadeOut()
            isInfoViewVisible = false
            
        }
    }
    

    
    @objc func pressedTVRemotePlayPauseButton() {
    }
    
    @objc func pressedMenu() {
        if currentState != .collapsed {
            collapseSidePanels()
        } else {
            self.dismiss(animated: true, completion: {})
        }
    }
    
    @objc func swipedUp() {
        if isInfoViewVisible {
            infoView.alpha = 1
//            self.performSegue(withIdentifier: "channel", sender: nil)
        }
    }
    
    @objc func swipedDown() {
        if isInfoViewVisible {
            self.performSegue(withIdentifier: "channelSelection", sender: nil)
        }
    }
    var timeout = Date()
    @objc func pressedLeft() {
        guard (Date().timeIntervalSince(timeout)) > 0.5 else {return}
        timeout = Date()
        toggleLeftPanel()
    }
    @objc func pressedRight() {
        guard (Date().timeIntervalSince(timeout)) > 0.5 else {return}
        timeout = Date()
        toggleRightPanel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.bringSubviewToFront(infoView)
        
        if !isInfoViewVisible {
            self.showInfo()
        } else {
            timer.fire()
        }
        touchBegan = touches.first!.timestamp
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInfoViewVisible && (touches.first!.timestamp - touchBegan) > 0.5 {
            infoView.fadeOut()
            isInfoViewVisible = false
        }
        touchBegan = 0
        super.touchesEnded(touches, with: event)
    }
    
    
    func showInfo() {
        isInfoViewVisible = true
        infoView.fadeIn()
        self.infoView.alpha = 1
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (t) in
            t.invalidate()
            if self.touchBegan == 0 {
                self.infoView.fadeOut()
                self.isInfoViewVisible = false
            }
        })
        
    }
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return animator
//    }
//
    func getSubtitleOptions() -> [String : Int32] {
        return [:]
    }
    
    func didChooseSubtitleOption(at index: Int32) {
    }
    
    func getAudiotrackOptions() -> [String : Int32] {
        return [:]
    }
    
    func didChooseAudiotrackOption(at index: Int32) {
        
    }
    
    func didSetTeletextPage(to page: Int32) {
        
    }
    
    func didPerform(teletextAction: String) {
        
    }
    func didSetTeletextTransparency(to state: Bool) {
    }
    
    func channelViewControllerwillDisappear(channelVC: ChannelViewController) {
        self.infoView.isHidden = false
        self.isInfoViewVisible = false
    }
    
    func didSelectChannel(_ channel:Channel) {
        if let _ = presentedViewController {
            self.dismiss(animated: true, completion: { 
                
            })
        }
        self.channel = channel
        currentChannelLabel.text = channel.name
        upcomingLabel.text = ""
        currentShowLabel.text = ""
        otherStuffLabel.text = ""
        currentTimeLabel.text = ""
        nextTimeLabel.text = ""
        logoImageView.sd_setImage(with: channel.iconURL)
        
        
        self.showInfo()
    }
    
    enum SlideOutState {
        case collapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var leftViewController: ChannelViewController?
    var rightViewController: EPGListCollectionViewController?
    var currentState: SlideOutState = .collapsed

    @objc func pan(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)

        switch recognizer.state {
            
        case .began:
            if currentState == .collapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                } else {
                    addRightPanelViewController()
                }
                
            }
            
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > 566
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            if let _ = rightViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 566
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }

    func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        if let vc = storyboard!.leftViewController() {
            vc.channel = self.channel
            vc.image = logoImageView.image
            let _ = vc.view
            vc.delegate = self
            vc.reloadData()
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    func addRightPanelViewController() {
        
        guard rightViewController == nil else { return }
        
        if let vc = storyboard?.rightViewController() {
            vc.channel = channel
            vc.collectionView?.reloadData()
            addChildSidePanelController(vc)
            rightViewController = vc
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: UIViewController) {
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: 566)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .collapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -566)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .collapsed
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        print("animate call")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.playerView!.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
}


extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}


private extension UIStoryboard {
    
    static func main() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    func leftViewController() -> ChannelViewController? {
        return instantiateViewController(withIdentifier: "channelVC") as? ChannelViewController
    }
    
    func rightViewController() -> EPGListCollectionViewController? {
        return instantiateViewController(withIdentifier: "epgVC") as? EPGListCollectionViewController

    }
}
