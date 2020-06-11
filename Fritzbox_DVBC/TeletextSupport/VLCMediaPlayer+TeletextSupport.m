#import "VLCMediaPlayer+TeletextSupport.h"
#include <vlc/vlc.h>
#include <vlc/libvlc_media.h>
#include <vlc_input.h>
#include <vlc_player.h>
#include <vlc_viewpoint.h>

struct libvlc_media_player_t
{
    struct vlc_object_t obj;

    int                i_refcount;

    vlc_player_t *player;
    vlc_player_listener_id *listener;
    vlc_player_aout_listener_id *aout_listener;

    struct libvlc_instance_t * p_libvlc_instance; /* Parent instance */
    libvlc_media_t * p_md; /* current media descriptor */
    //libvlc_event_manager_t event_manager;
};

@implementation VLCMediaPlayer (TeletextSupport)
- (void)setTeletextPageTo:(int) page
{
    libvlc_media_player_t *player = (__bridge libvlc_media_player_t *)([self performSelector:@selector(libVLCinstance)]);
    libvlc_video_set_teletext(player, page);
}


- (void)telxNavLink:(NSString *)sender
{
    //vlc_object_t *p_vbi;
    int i_page = 0;
    
    if ([sender isEqualToString:@"Index"])
        i_page = 'i' << 16;
    else if ([sender isEqualToString:@"Red"])
        i_page = 'r' << 16;
    else if ([sender isEqualToString:@"Green"])
        i_page = 'g' << 16;
    else if ([sender isEqualToString:@"Yellow"])
        i_page = 'y' << 16;
    else if ([sender isEqualToString:@"Blue"])
        i_page = 'b' << 16;
    if (i_page == 0) return;
    
    [self setTeletextPageTo:i_page];
    
    /*p_vbi = (vlc_object_t *) vlc_object_find_name([self libVLCMediaPlayer], "zvbi");
    if (p_vbi) {
        var_SetInteger(p_vbi, "vbi-page", i_page);
        vlc_object_release(p_vbi);
    }*/
}


- (void)telxTransparent:(BOOL)sender
{
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
