//
//  VLCMedia+EPGSupport.m
//  Fritzbox_DVBC_VLCPod
//
//  Created by Daniel Petri on 11.06.20.
//  Copyright © 2020 Daniel Petri. All rights reserved.
//

#import "VLCMedia+EPGSupport.h"
#import <vlc/libvlc.h>
#import <sys/sysctl.h> // for sysctlbyname
#import <vlc_common.h>
#import <vlc_input_item.h>
#import <vlc/libvlc_picture.h>

#import "libvlc_media.h"
#import "libvlc_events.h"

typedef struct libvlc_event_manager_t libvlc_event_manager_t;
struct libvlc_event_manager_t
{
    void * p_obj;
    vlc_array_t listeners;
    vlc_mutex_t lock;
};

struct libvlc_media_t
{
    libvlc_event_manager_t event_manager;
    input_item_t      *p_input_item;
    int                i_refcount;
    libvlc_instance_t *p_libvlc_instance;
    libvlc_state_t     state;
    VLC_FORWARD_DECLARE_OBJECT(libvlc_media_list_t*) p_subitems; /* A media descriptor can have Sub items. This is the only dependancy we really have on media_list */
    void *p_user_data;

    vlc_cond_t parsed_cond;
    vlc_mutex_t parsed_lock;
    vlc_mutex_t subitems_lock;

    libvlc_media_parsed_status_t parsed_status;
    bool is_parsed;
    bool has_asked_preparse;
};


@implementation VLCMedia (EPGSupport)
    -(NSArray *)parseEpg{
        libvlc_media_t *p_media = (__bridge libvlc_media_t *)([self performSelector:@selector(libVLCMediaDescriptor)]);
        input_item_t *p_item = p_media->p_input_item;
        NSMutableArray *epgs = [NSMutableArray new];
        if (p_item->pp_epg) {
//            vlc_mutex_lock(&p_item->lock);
            
            for (int i = 0; i<p_item->i_epg ; i++) {
                vlc_epg_t *p_epg = p_item->pp_epg[i];
                if (p_epg != NULL) {
                    VLCEPG *epg = [[VLCEPG alloc] initWithInternalEpg:p_epg];
                    [epgs addObject:epg];
                }
                
            }
            
//            vlc_mutex_unlock(&p_item->lock);
            return epgs;
        }
        return nil;
    }
@end
