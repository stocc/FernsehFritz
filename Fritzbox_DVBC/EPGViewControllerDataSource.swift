import UIKit

extension EPGListCollectionViewController: UICollectionViewDataSource {
    #if DISABLE_CUSTOM_VLC
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    #else
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(20, EpgManager.sharedInstance.epg(for: channel?.name ?? "")?.events.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let events = EpgManager.sharedInstance.epg(for: channel?.name ?? "")?.events
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "epgCell", for: indexPath) as! EPGCollectionViewCell
        let currentShow = events![indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.timeLabel.text = String.init(format: "%@-%@", formatter.string(from: currentShow.start), formatter.string(from: currentShow.end))
        cell.nameLabel.text = currentShow.name
        return cell
    }
    #endif
    
}

