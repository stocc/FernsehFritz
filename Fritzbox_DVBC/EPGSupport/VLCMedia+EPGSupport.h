#import <TVVLCKit/TVVLCKit.h>
#import "VLCEPG.h"

@interface VLCMedia (EPGSupport)
@property (readonly) void * libVLCMediaDescriptor;

- (NSArray *)parseEpg;
@end

