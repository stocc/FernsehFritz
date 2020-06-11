import UIKit

protocol ChannelViewControllerDelegate {
    func channelViewControllerwillDisappear(channelVC: ChannelViewController)
    func getSubtitleOptions() -> [String:Int32]
    func didChooseSubtitleOption(at index: Int32)
    func getAudiotrackOptions() -> [String:Int32]
    func didChooseAudiotrackOption(at index: Int32)
    func didSetTeletextPage(to page: Int32)
    func didPerform(teletextAction: String)
    func didSetTeletextTransparency(to state: Bool)
 }

fileprivate var alertController = UIAlertController()

class ChannelViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var channelLogo: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    private let blurEffectView = UIVisualEffectView()
    @IBOutlet weak var teleTextField: UITextField!
    
    @IBOutlet weak var currentShowNameLabel: UILabel!
    @IBOutlet weak var currentShowDetailLabel: UILabel!
    @IBOutlet weak var currentShowTimeLabel: UILabel!
    @IBOutlet weak var currentShowDescriptionTextView: UITextView!
    //    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ChannelViewControllerDelegate?
    var channel: Channel?
    var image: UIImage?
    
    @IBAction func audioButtonTriggered(_ sender: Any) {
        alertController = UIAlertController(title:"Audio options", message: nil, preferredStyle: .alert)
        
        guard let options = delegate?.getAudiotrackOptions() else {
            return
        }
        
        for option in options {
            alertController.addAction(UIAlertAction(title: option.key, style: .default, handler: { (action) in
                self.delegate?.didChooseAudiotrackOption(at: option.value)
            }))
        }
        
        let actionDismiss = UIAlertAction(title: "Dismiss", style: .destructive) { (action : UIAlertAction) -> Void in
        }
        
        
        alertController.addAction(actionDismiss)
        self.present(alertController, animated: true, completion: nil)

    }
    @IBAction func subtitleButtonTriggered(_ sender: Any) {
        alertController = UIAlertController(title:"Select Subtitles", message: nil, preferredStyle: .alert)
        
        guard let options = delegate?.getSubtitleOptions() else {
            return
        }
        
        for option in options {
            alertController.addAction(UIAlertAction(title: option.key, style: .default, handler: { (action) in
                self.delegate?.didChooseSubtitleOption(at: option.value)
            }))
        }
        
        let actionDismiss = UIAlertAction(title: "Dismiss", style: .destructive) { (action : UIAlertAction) -> Void in
        }
        

        alertController.addAction(actionDismiss)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func reloadData() {
        showCurrentShow()
    }
    
    override func viewDidLoad() {
        self.channelLogo.image = image
        self.channelNameLabel.text = channel!.name
        teleTextField.delegate = self
//        collectionView.dataSource = self
        
        currentShowDescriptionTextView.isUserInteractionEnabled = true
        currentShowDescriptionTextView.isSelectable = true
        currentShowDescriptionTextView.isScrollEnabled = true
        currentShowDescriptionTextView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.indirect.rawValue] as [NSNumber]
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.view.backgroundColor = UIColor.clear
            
            blurEffectView.effect = UIBlurEffect(style: .light)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.insertSubview(blurEffectView, at: 0)
        } else {
            self.view.backgroundColor = UIColor.black
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.channelViewControllerwillDisappear(channelVC: self)
    }
    var transparentState = false
    @IBAction func indexButtonPressed(_ sender: Any) {
        delegate?.didPerform(teletextAction: "Index")
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        delegate?.didPerform(teletextAction: "Red")
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        delegate?.didPerform(teletextAction: "Green")
    }
    @IBAction func yellowButtonPressed(_ sender: Any) {
        delegate?.didPerform(teletextAction: "Yellow")
    }
    @IBAction func blueButtonPressed(_ sender: Any) {
        delegate?.didPerform(teletextAction: "Blue")
    }
    @IBAction func transparentButtonPressed(_ sender: Any) {
        transparentState = !transparentState
        delegate?.didSetTeletextTransparency(to: transparentState)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didSetTeletextPage(to: Int32(textField.text!)!)
    }
}


extension ChannelViewController {
    fileprivate func showCurrentShow() {
        #if DISABLE_CUSTOM_VLC
        currentShowTimeLabel.text = ""
        currentShowDetailLabel.text = "No EPG Data available"
        currentShowNameLabel.text = ""
        currentShowDescriptionTextView.text = ""
        #else
        if let currentShow = EpgManager.sharedInstance.epg(for: channel?.name ?? "")?.currentEvent {
            currentShowNameLabel.text = currentShow.name
            currentShowDescriptionTextView.text = currentShow.longDescription
            currentShowDetailLabel.text = currentShow.shortDescription
            let formatter = DateFormatter()
            let dcFormatter = DateComponentsFormatter()
            formatter.dateFormat = "HH:mm"
            dcFormatter.includesTimeRemainingPhrase = true
            dcFormatter.unitsStyle = .abbreviated
            dcFormatter.allowedUnits = [.hour, .minute]

            currentShowTimeLabel.text = String.init(format: "%@-%@, %@", formatter.string(from: currentShow.start), formatter.string(from: currentShow.end), dcFormatter.string(from: Date(), to: currentShow.end) ?? "")
        } else {
            currentShowTimeLabel.text = ""
            currentShowDetailLabel.text = "No EPG Data available"
            currentShowNameLabel.text = ""
            currentShowDescriptionTextView.text = ""
        }
        #endif
    }
}
