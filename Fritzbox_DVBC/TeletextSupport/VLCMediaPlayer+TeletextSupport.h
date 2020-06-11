#import <TVVLCKit/TVVLCKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VLCMediaPlayer (TeletextSupport)
- (void)telxNavLink:(NSString *)sender;
- (void)setTeletextPageTo:(int) page;
- (void)telxTransparent:(BOOL)sender;
@end

NS_ASSUME_NONNULL_END
