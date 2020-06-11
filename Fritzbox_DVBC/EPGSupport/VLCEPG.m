//
//  VLCEPG.m
//  MobileVLCKit
//
//  Created by Daniel Petri on 07.04.17.
//
//

#import "VLCEPG.h"
#import <vlc/libvlc.h>
#import <sys/sysctl.h> // for sysctlbyname
#import <vlc_common.h>
#import <vlc_input_item.h>
//#import "VLCLibVLCBridging.h"
#import "VLCHelperCode.h"
#import "VLCEpgEvent.h"

@interface VLCEPG ()
@property (nonatomic) vlc_epg_t* p_epg;
@end

@implementation VLCEPG
@synthesize currentEvent = _currentEvent;

-(instancetype)initWithInternalEpg:(void *)e {
    self = [super init];
    if (self) {
        self.p_epg = e;
        [self parseEpg];
    }
    return self;
}

-(void)parseEpg {
    NSMutableArray *m_events = [[NSMutableArray alloc] init];
    NSString *fullName = toNSStr(_p_epg->psz_name);
    NSRange beginning = [fullName rangeOfString:@" [Program "];
    if (beginning.length == 0) {
        NSRange beginning = [fullName rangeOfString:@"Program "];
        _channelId = [fullName substringWithRange:NSMakeRange(beginning.location + beginning.length, fullName.length - beginning.location - beginning.length)];
        _channelName = _channelId;
    } else {
        _channelName = [fullName substringToIndex:beginning.location];
        _channelId = [fullName substringWithRange:NSMakeRange(beginning.location + beginning.length, fullName.length - beginning.location - beginning.length - 1)];
    }
    
    if (_p_epg->p_current != nil) {
        _currentEvent = [[VLCEpgEvent alloc] initWithInternalEvent:(void *)_p_epg->p_current];

    }
    for (int i = 0; i < _p_epg->i_event; i++) {
        vlc_epg_event_t *p_event = _p_epg->pp_event[i];
        VLCEpgEvent *e = [[VLCEpgEvent alloc] initWithInternalEvent:p_event];
        if (e != nil) {
            [m_events addObject:e];
        }
    }
    _events = [m_events sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        VLCEpgEvent *first = obj1;
        VLCEpgEvent *second = obj2;
        return [first.start compare:second.start];
    }];
}

-(VLCEpgEvent *)currentEvent {
    if (_currentEvent != nil) {
        return _currentEvent;
    }
    for (VLCEpgEvent *event in self.events) {
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        if ([event.start compare:now] != NSOrderedDescending && [now compare:event.end] != NSOrderedDescending) {
            return event;
        }
    }
    return nil;
}

-(VLCEpgEvent *)upcoming{
    if (self.currentEvent == nil) {
        return nil;
    }
    for (VLCEpgEvent *event in self.events) {
        if ([self.currentEvent.end compare:event.start] != NSOrderedDescending) {
            return event;
        }
    }
    return nil;
}

-(void)mergeWith:(VLCEPG *)newEpg{
    _events = [newEpg.events copy];
    if (newEpg.currentEvent != nil) {
        _currentEvent = newEpg.currentEvent;
    }
}
@end
