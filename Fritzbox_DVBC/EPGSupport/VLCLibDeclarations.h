#include <vlc/vlc.h>
#import <vlc/libvlc.h>

#import <sys/sysctl.h> // for sysctlbyname
#import <vlc_common.h>
#import <vlc_input_item.h>
#import <vlc/libvlc_picture.h>
#include <vlc/libvlc_media.h>
#include <vlc_input.h>
#include <vlc_player.h>
#include <vlc_viewpoint.h>
#import "libvlc_media.h"
#import "libvlc_events.h"
#import "vlc_input.h"

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



struct libvlc_media_player_t
{
    struct vlc_object_t obj;

    int                i_refcount;

    vlc_player_t *player;
    vlc_player_listener_id *listener;
    vlc_player_aout_listener_id *aout_listener;

    struct libvlc_instance_t * p_libvlc_instance; /* Parent instance */
    libvlc_media_t * p_md; /* current media descriptor */
    libvlc_event_manager_t event_manager;
};
