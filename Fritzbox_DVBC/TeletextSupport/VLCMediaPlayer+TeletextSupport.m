#import "VLCMediaPlayer+TeletextSupport.h"
#import "VLCLibDeclarations.h"
#import <vlc_player.h>

@implementation VLCMediaPlayer (TeletextSupport)

@dynamic playerInstance;

- (void)setTeletextPageTo:(int) page
{
    libvlc_video_set_teletext(self.playerInstance, page);
}


- (void)followTeletextLink:(VLCTeletextLink) link
{
    //vlc_object_t *p_vbi;
    int i_page = 0;
 
    switch (link) {
        case Index:
            i_page = libvlc_teletext_key_index;
            break;
        case Red:
            i_page = libvlc_teletext_key_red;
            break;
        case Green:
            i_page = libvlc_teletext_key_green;
            break;
        case Yellow:
            i_page = libvlc_teletext_key_yellow;
            break;
        case Blue:
            i_page = libvlc_teletext_key_blue;
            break;
        default:
            break;
    }
    
    [self setTeletextPageTo:i_page];
    

}


- (void)setTeletextTransparencyTo:(BOOL)sender
{
    //libvlc_media_player_t *mediaPlayer = self.playerInstance;
    
    //vlc_player_SetTeletextTransparency(mediaPlayer->player, sender);
    
//    THIS IS NOT SUPPORTED AT THIS TIME TIME
//
    
//    vlc_object_t *p_vbi;
//    libvlc_media_player_t *player = (__bridge libvlc_media_player_t *)([self performSelector:@selector(libVLCinstance)]);
//    p_vbi = (vlc_object_t *) vlc_object_find_name(player, "zvbi");
//    if (p_vbi) {
//        var_SetBool(p_vbi, "vbi-opaque", sender);
//        vlc_object_release(p_vbi);
//    }
//    var_SetBool(((libvlc_media_player_t *)_playerInstance), "vbi-opaque", sender);
}
    
    
    
    

@end
