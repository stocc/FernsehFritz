//
//  VLCEpgEvent.m
//  MobileVLCKit
//
//  Created by Daniel Petri on 07.04.17.
//
//

#import "VLCEpgEvent.h"
#import <vlc_common.h>
#import <vlc_epg.h>
#import "VLCHelperCode.h"

@interface VLCEpgEvent ()
@property (nonatomic) vlc_epg_event_t *p_event;
@end

@implementation VLCEpgEvent
-(instancetype)initWithInternalEvent:(void *)e{
    self = [super init];
    if (self) {
        self.p_event = e;
        if (_p_event == NULL) {
            return self;
        }
        [self parseEvent];
    }
    return self;
}

-(void)parseEvent{
    _name = toNSStr(_p_event->psz_name);
    _shortDescription = toNSStr(_p_event->psz_short_description);
    _longDescription = toNSStr(_p_event->psz_description);
    _rating = _p_event->i_rating;
    
    _duration = _p_event->i_duration;
    _start = [NSDate dateWithTimeIntervalSince1970:_p_event->i_start];
    _end = [NSDate dateWithTimeIntervalSince1970:(_p_event->i_start + _p_event->i_duration)];
}

-(NSString *)description {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [NSString stringWithFormat:@"<\"%@\", start: %@, end: %@>", self.name, [formatter stringFromDate:self.start], [formatter stringFromDate:self.end]];
}
@end
