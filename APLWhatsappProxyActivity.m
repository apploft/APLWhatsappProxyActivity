//
//  APLWhatsappProxyActivity.m
//
//
//  Created by Christopher Groß on 01.12.14.
//  Copyright (c) 2014 apploft GmbH. All rights reserved.
//

#import "APLWhatsappProxyActivity.h"
#import <Social/Social.h>

static NSString * const kAPLWhatsappActivityType = @"de.apploft.sharing.whatsapp";
static NSString * const kAPLWhatsappActivityName = @"Whatsapp";
static NSString * const kAPLWhatsappActivityUrl = @"whatsapp://send?text=%@";

@interface APLWhatsappProxyActivity ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation APLWhatsappProxyActivity

+ (instancetype)proxyActivity {
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
        [self addString:[self stringFromActivityItem:item] toMessageText:&messageText currentIndex:idx];
    }];
    
    if ([messageText length] > 0) {
        NSString * whatsappURL = [NSString stringWithFormat:kAPLWhatsappActivityUrl, messageText];
        NSURL * escapedWhatsappURL = [NSURL URLWithString:[whatsappURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: escapedWhatsappURL]) {
            [[UIApplication sharedApplication] openURL: escapedWhatsappURL];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Whatsapp installed on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"Error sharing via Whatsapp. No message to share");
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

- (NSString *)stringFromActivityItem:(id)item {
    if ([item isKindOfClass:[NSString class]]) {
        return (NSString *)item;
    } else if ([item isKindOfClass:[NSURL class]]) {
        return [(NSURL *)item absoluteString];
    }
    return nil;
}

@end
