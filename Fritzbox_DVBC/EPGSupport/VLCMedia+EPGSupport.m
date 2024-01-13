#import "VLCMedia+EPGSupport.h"
#import "VLCLibDeclarations.h"

@implementation VLCMedia (EPGSupport)

@dynamic libVLCMediaDescriptor;

    -(NSArray *)parseEpg{
        libvlc_media_t *p_media = (__bridge libvlc_media_t *)([self performSelector:@selector(libVLCMediaDescriptor)]);
        input_item_t *p_item = p_media->p_input_item;
        NSMutableArray *epgs = [NSMutableArray new];
        if (p_item->pp_epg) {
            vlc_mutex_lock(&p_item->lock);
            
            for (int i = 0; i<p_item->i_epg ; i++) {
                vlc_epg_t *p_epg = p_item->pp_epg[i];
                if (p_epg != NULL) {
                    VLCEPG *epg = [[VLCEPG alloc] initWithInternalEpg:p_epg];
                    [epgs addObject:epg];
                }
                
            }
            
            vlc_mutex_unlock(&p_item->lock);
            return epgs;
        }
        return nil;
    }
@end
