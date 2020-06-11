import UIKit

class EPGListCollectionViewController: UIViewController {
    var channel: Channel?
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
    }
}
