//
//  APLWhatsappProxyActivity.m
//
//
//  Created by Heiko Wichmann on 04.04.2013.
//  Copyright (c) 2013 apploft GmbH. All rights reserved.
//

#import "APLWhatsappProxyActivity.h"
#import <Social/Social.h>

static NSString * const kAPLWhatsappActivityType = @"de.zeit.sharing.whatsapp";
static NSString * const kAPLWhatsappActivityName = @"Whatsapp";

@interface APLWhatsappProxyActivity ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation APLWhatsappProxyActivity

+ (instancetype)proxyActivityIfNeeded {
    return [self new];
}

- (NSString *)activityTitle {
    return kAPLWhatsappActivityName;
}

- (UIImage *)activityImage {
    UIImage *anActivityImage = [UIImage imageNamed:@"whatsapp_share_proxy.png"];
    return anActivityImage;
}

- (NSString *)activityType {
    return kAPLWhatsappActivityType;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.items = activityItems;
}

- (void)performActivity {
    __block NSString *messageText = @"";
    [self.items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        NSString *itemAsString = [self stringFromItem:item];
        [self addString:itemAsString toMessageText:&messageText currentIndex:idx];
    }];
    
    if ([messageText length] > 0) {
        NSString * whatsappURL = [NSString stringWithFormat:@"whatsapp://send?text=%@",messageText];
        NSURL * escapedWhatsappURL = [NSURL URLWithString:[whatsappURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: escapedWhatsappURL]) {
            [[UIApplication sharedApplication] openURL: escapedWhatsappURL];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Whatsapp installed on the device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)addString:(NSString *)text toMessageText:(NSString **)messageText currentIndex:(NSUInteger)index {
    if (text == nil) return;
    
    if (index < [self.items count] - 1) {
        *messageText = [*messageText stringByAppendingString:[NSString stringWithFormat:@"%@\n", text]];
    } else {
        *messageText = [*messageText stringByAppendingString:[NSString stringWithFormat:@"%@", text]];
    }
}

- (NSString *)stringFromItem:(id)item {
    if ([item isKindOfClass:[NSString class]]) {
        return (NSString *)item;
    } else if ([item isKindOfClass:[NSURL class]]) {
        return [(NSURL *)item absoluteString];
    }
    return nil;
}

@end
