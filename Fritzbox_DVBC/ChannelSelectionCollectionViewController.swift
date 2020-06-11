import UIKit
import SDWebImage

protocol ChannelSelectionViewControllerDelegate {
    func didSelectChannel(_ channel:Channel)
}
class ChannelSelectionCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "channel"
    private var channels : [Channel] = []
    var delegate: ChannelSelectionViewControllerDelegate?
    var isInContext = false
    var blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JvBCRUDRequest.request(type: .GET, urlString: "http://fritz.box/dvb/m3u/tvhd.m3u", queryParameters: nil, dataDictionary: nil, headers: nil) { (e, hd, r) in
            JvBCRUDRequest.request(type: .GET, urlString: "http://fritz.box/dvb/m3u/tvsd.m3u", queryParameters: nil, dataDictionary: nil, headers: nil, completion: { (e, sd, r) in
                JvBCRUDRequest.request(type: .GET, urlString: "http://fritz.box/dvb/m3u/radio.m3u", queryParameters: nil, dataDictionary: nil, headers: nil, completion: { (e, radio, r) in
                    
                    do {
                        let regex = try NSRegularExpression(pattern: "#EXTINF:0,(.*)\n.*\n(.*)", options: .caseInsensitive)
                        let sdmatches = regex.matches(in: sd!, range: NSMakeRange(0, sd!.utf16.count))
                        let sdArr = sdmatches.map{match->String in
                            let matchingRange = match.range(at: 0)
                            let matchingString = (sd! as NSString).substring(with: matchingRange) as String
                            return matchingString
                        }
                        
                        sdArr.forEach({ (sda) in
                            self.channels.append(Channel(m3uString: sda, channelType: .SD_TV)!)
                        })
                        
                        let hdmatches = regex.matches(in: hd!, range: NSMakeRange(0, hd!.utf16.count))
                        let hdArr = hdmatches.map{match->String in
                            let matchingRange = match.range(at: 0)
                            let matchingString = (hd! as NSString).substring(with: matchingRange) as String
                            return matchingString
                        }
                        
                        hdArr.forEach({ (hda) in
                            self.channels.append(Channel(m3uString: hda, channelType: .HD_TV)!)
                        })
                        
                        self.collectionView?.reloadData()
                    } catch {}
                    
                    
                    
                    
                })
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isInContext {
            self.view.backgroundColor = UIColor.clear
            
            blurEffectView.effect = UIBlurEffect(style: .light)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.insertSubview(blurEffectView, at: 0)

        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        (segue.destination as! PlayerViewController).channel = channels[collectionView!.indexPath(for: (sender as! UICollectionViewCell))!.row]
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChannelCollectionViewCell
        cell.logo.image = nil
        // Configure the cell
        cell.name.text = channels[indexPath.row].name
        
            cell.logo.sd_setImage(with: channels[indexPath.row].iconURL, completed: { (i, e, t, u) in
                if let _ = e {
                    return
                }
                cell.logo.image = self.resizeImageWithAspectFit(image: i!, size: CGSize(width: 531, height: 230))
                cell.logo.sizeToFit()
                cell.layoutIfNeeded()
            })

 
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if isInContext {
           delegate?.didSelectChannel(channels[indexPath.row])
        } else {
            performSegue(withIdentifier: "play", sender: collectionView.cellForItem(at: indexPath))
        }
        isInContext = false
    }

    func resizeImageWithAspectFit(image:UIImage, size:CGSize) -> UIImage {
        let aspectFitSize = self.getAspectFitRect(origin: image.size, destination: size)
        let resizedImage = self.resizeImage(image: image, size: aspectFitSize)
        return resizedImage
    }
    
    func getAspectFitRect(origin src:CGSize, destination dst:CGSize) -> CGSize {
        var result = CGSize()
        var scaleRatio = CGPoint()
        
        if (dst.width != 0) {scaleRatio.x = src.width / dst.width}
        if (dst.height != 0) {scaleRatio.y = src.height / dst.height}
        let scaleFactor = max(scaleRatio.x, scaleRatio.y)
        
        result.width  = scaleRatio.x * dst.width / scaleFactor
        result.height = scaleRatio.y * dst.height / scaleFactor
        return result
    }
    
    func resizeImage(image:UIImage, size:CGSize) -> UIImage {
        let scale     = UIScreen.main.scale
        let size      = scale > 1 ? CGSize(width:size.width/scale, height:size.height/scale) : size
        let imageRect = CGRect(x:0.0, y:0.0, width:size.width, height:size.height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.draw(in: imageRect)
        let scaled = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaled!;
    }
}
