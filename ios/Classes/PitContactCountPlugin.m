#import "PitContactCountPlugin.h"
#import <pit_contact_count/pit_contact_count-Swift.h>

@implementation PitContactCountPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPitContactCountPlugin registerWithRegistrar:registrar];
}
@end
