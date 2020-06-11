//
//  VLCMedia+EPGSupport.h
//  Fritzbox_DVBC_VLCPod
//
//  Created by Daniel Petri on 11.06.20.
//  Copyright © 2020 Daniel Petri. All rights reserved.
//

#import <TVVLCKit/TVVLCKit.h>
#import "VLCEPG.h"

@interface VLCMedia (EPGSupport)
- (void *)libVLCMediaDescriptor;
- (NSArray *)parseEpg;
@end

