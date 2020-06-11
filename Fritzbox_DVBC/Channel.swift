import UIKit

enum ChannelType {
    case SD_TV
    case HD_TV
    case Radio
}

class Channel: NSObject {
    var name: String
    var type: ChannelType
    var streamURL: URL

    init(name: String, streamURL: URL, type: ChannelType) {
        self.name = name
        self.streamURL = streamURL
        self.type = type
        super.init()
    }
    
    convenience init?(m3uString:String, channelType: ChannelType) {
               
        do {
            let regex = try NSRegularExpression(pattern: "^#EXTINF:0,(.*)\n.*\n(.*)$", options: .caseInsensitive)
            let matches = regex.matches(in: m3uString, range: NSMakeRange(0, m3uString.utf16.count))
            guard !matches.isEmpty else {
                return nil
            }
            guard matches[0].numberOfRanges == 3 else {
                return nil
            }
            var matchingRange = matches[0].range(at: 1)
            let name = (m3uString as NSString).substring(with: matchingRange) as String
            matchingRange = matches[0].range(at: 2)
            let streamURL = URL(string: (m3uString as NSString).substring(with: matchingRange) as String)!
            self.init(name: name, streamURL: streamURL, type: channelType)
            
        } catch {
            return nil
        }
        
    }
    
    
}


extension Channel {
    var iconURL: URL {
        get {
            var subfolder = ""
            if type == .Radio {
                subfolder = "/radio"
            } else if type == .HD_TV {
                subfolder = "/hd"
            }
            let fullURL = String(format: "http://tv.avm.de/tvapp/logos%@/%@.png", subfolder, name.lowercased().replacingOccurrences(of: " ", with: "_", options: .literal, range: nil))
            return URL(string: fullURL.removingSpecialCharacters())!
        }
    }
}
