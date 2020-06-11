import UIKit

class LivePlayerViewController: PlayerViewController,  VLCMediaDelegate, VLCMediaPlayerDelegate {
    let player = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.drawable = self.liveView
        playerView = liveView

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stop()
    }
    
    override func pressedTVRemotePlayPauseButton() {
        if player.state == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        updateEpg()
        updateEpgShowLabels()
        
        var fps = "null"
        var width = "null"
        var height = "null"
        if let info = player.media.tracksInformation as? [Dictionary<String,Any>]{
            if info.count > 0 {
                for track in info {
                    if track[VLCMediaTracksInformationType] as! String == "video" {
                        fps = String.init(format: "%@", track[VLCMediaTracksInformationFrameRate] as! NSNumber)
                        width = String.init(format: "%@", track[VLCMediaTracksInformationVideoWidth] as! NSNumber)
                        height = String.init(format: "%@", track[VLCMediaTracksInformationVideoHeight] as! NSNumber)
                        break
                    }
                }
            }
        }
        
        let epgString = getCurrentEpgInfoText()
        self.otherStuffLabel.text = String.init(format:"%@fps %@x%@ %@",fps, width, height, epgString)
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        liveView.bringSubviewToFront(infoView)

        if player.state == .paused {
            self.infoView.fadeIn()
        } else if player.state == .playing && !timer.isValid {
            self.infoView.fadeOut()
        }
    }
    
    override func getAudiotrackOptions() -> [String:Int32] {
        var options:[String:Int32] = [:]
        let indices = player.audioTrackIndexes as! [Int32]
        let names = player.audioTrackNames as! [String]
        var i = 0
        for index in indices {
            var name = names[i]
            if index == player.currentAudioTrackIndex {
                name = "✓ ".appending(name)
            }
            options[name] = index
            i = i+1
        }
        
        return options
    }
    
    override func didChooseAudiotrackOption(at index: Int32) {
        player.currentAudioTrackIndex = index
        
    }
    
    
    override func getSubtitleOptions() -> [String:Int32] {
        var options:[String:Int32] = [:]
        let indices = player.videoSubTitlesIndexes as! [Int32]
        let names = player.videoSubTitlesNames as! [String]
        var i = 0
        for index in indices {
            var name = names[i]
            if index == player.currentVideoSubTitleIndex {
                name = "✓ ".appending(name)
            }
            options[name] = index
            i = i+1
        }
        
        return options
    }
    

    override func didChooseSubtitleOption(at index: Int32) {
        player.currentVideoSubTitleIndex = index
        
    }
    
    
    override func didSetTeletextPage(to page: Int32) {
        setTeletextPage(to: page)
    }
    
    override func didPerform(teletextAction: String) {
        perform(teletextAction: teletextAction)
    }
    
    override func didSetTeletextTransparency(to state: Bool) {
        setTeletextTransparency(to: state)
    }
    
    
    override func didSelectChannel(_ channel: Channel) {
        super.didSelectChannel(channel)
        
        player.stop()
        let media = VLCMedia(url: URL(string:channel.streamURL.absoluteString)!)         
        player.media = media
        media.delegate = self
        player.delegate = self
        
        player.media.parse(withOptions: VLCMediaParsingOptions(VLCMediaParseNetwork))
        player.play()
    }

}


extension LivePlayerViewController {
    fileprivate func getCurrentEpgInfoText() -> String {
        #if DISABLE_CUSTOM_VLC
        return ""
        #else
        return EpgManager.sharedInstance.epgWasAvailable ? String.init(format:"%i", EpgManager.sharedInstance.epgCount) : "EPG not available"
        #endif
    }
    
    fileprivate func updateEpg() {
        #if DISABLE_CUSTOM_VLC
        #else
        EpgManager.sharedInstance.updateWithEpg(for: player.media)
        #endif
    }
    
    
    fileprivate func updateEpgShowLabels() {
        #if DISABLE_CUSTOM_VLC
        #else
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let myEpg = EpgManager.sharedInstance.epg(for: channel!.name) {
            if let currentShow = myEpg.currentEvent {
                self.currentShowLabel.text = String.init(format: "Now: %@", currentShow.name)
                self.currentTimeLabel.text = String.init(format: "%@-%@", formatter.string(from: currentShow.start), formatter.string(from: currentShow.end))
            }
            if let upcoming = myEpg.upcoming {
                self.upcomingLabel.text = String.init(format: "Next: %@", upcoming.name)
                self.nextTimeLabel.text = String.init(format: "%@-%@", formatter.string(from: upcoming.start), formatter.string(from: upcoming.end))
            }
        }
        #endif
    }
    
    fileprivate func setTeletextPage(to page: Int32){
        #if DISABLE_CUSTOM_VLC
        #else
        player.setTeletextPageTo(page)
        #endif
    }
    
    fileprivate func perform(teletextAction: String) {
        #if DISABLE_CUSTOM_VLC
        #else
        player.telxNavLink(teletextAction)
        #endif
    }
    
    fileprivate func setTeletextTransparency(to state: Bool) {
        #if DISABLE_CUSTOM_VLC
        #else
        player.telxTransparent(state)
        #endif
    }
}

