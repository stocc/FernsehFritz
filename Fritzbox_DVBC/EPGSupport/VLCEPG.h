//
//  VLCEPG.h
//  MobileVLCKit
//
//  Created by Daniel Petri on 07.04.17.
//
//

#import <Foundation/Foundation.h>
@class VLCMedia;
@class VLCEpgEvent;


@interface VLCEPG : NSObject
@property (nonatomic, strong, readonly) NSString *channelName;
@property (nonatomic, readonly) NSString *channelId;
@property (nonatomic, strong, readonly) VLCEpgEvent *currentEvent;
@property (nonatomic, strong, readonly) NSArray<VLCEpgEvent *> *events;
@property (nonatomic, strong, readonly) VLCEpgEvent* upcoming;

-(instancetype)initWithInternalEpg:(void *)e;
-(void)mergeWith:(VLCEPG *)newEpg;
@end
