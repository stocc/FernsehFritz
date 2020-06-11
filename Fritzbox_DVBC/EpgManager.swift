import UIKit
//REQUIRES MANUAL BUILD
#if DISABLE_CUSTOM_VLC
#else
class EpgManager: NSObject {
    static let sharedInstance = EpgManager()
    private var epgs: Dictionary<String, VLCEPG> = [:]
    var epgWasAvailable = false
    var epgCount = 0
    func updateWithEpg(for media: VLCMedia) {
        guard let mediaEpgs = media.parseEpg() else {
            epgWasAvailable = false
            epgCount = 0
            return
        }
        epgWasAvailable = true
        epgCount = mediaEpgs.count

        for e in mediaEpgs {
            if let e = e as? VLCEPG {
                
                if let old = epgs[e.channelName] {
                    old.merge(with: e)
                } else {
                    epgs[e.channelName] = e
                }
                
            }
        }
    }
    
    func epg(for channelName: String) -> VLCEPG? {
        if let value = epgs[channelName] {
            return value
        }
        return nil
    }
}
#endif
