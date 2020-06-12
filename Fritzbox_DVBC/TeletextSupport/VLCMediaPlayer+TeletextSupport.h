#import <TVVLCKit/TVVLCKit.h>
#import "VLCLibDeclarations.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VLCTeletextLink) {
    Index,
    Red,
    Green,
    Blue,
    Yellow
};

@interface VLCMediaPlayer (TeletextSupport)

- (void)followTeletextLink:(VLCTeletextLink)link;

- (void)setTeletextPageTo:(int) page;

- (void)setTeletextTransparencyTo:(BOOL)sender;
@end

NS_ASSUME_NONNULL_END

