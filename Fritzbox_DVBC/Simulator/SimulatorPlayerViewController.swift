import UIKit

/// Dummy PlayerViewController for the Simulator
class LivePlayerViewController: PlayerViewController {
    var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(frame: self.liveView.frame)
        self.liveView.addSubview(imageView)
        imageView.contentMode = .center
    }

    override func didSelectChannel(_ channel: Channel) {
        super.didSelectChannel(channel)
        imageView.sd_setImage(with: channel.iconURL)
    }

}
