#import <TVVLCKit/TVVLCKit.h>
#import "VLCEPG.h"

@interface VLCMedia (EPGSupport)
- (void *)libVLCMediaDescriptor;
- (NSArray *)parseEpg;
@end

