//
//  VLCEpgEvent.h
//  MobileVLCKit
//
//  Created by Daniel Petri on 07.04.17.
//
//

#import <Foundation/Foundation.h>

@interface VLCEpgEvent : NSObject
@property (nonatomic, strong, readonly) NSDate *start;
@property (nonatomic, strong, readonly) NSDate *end;
@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *shortDescription;
@property (nonatomic, strong, readonly) NSString *longDescription;
@property (nonatomic, readonly) int rating;


-(instancetype)initWithInternalEvent:(void *)e;
@end
