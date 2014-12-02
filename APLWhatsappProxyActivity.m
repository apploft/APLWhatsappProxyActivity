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
static NSString * const kAPLWhatsappTestScheme = @"whatsapp://";

@interface APLWhatsappProxyActivity ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation APLWhatsappProxyActivity

+ (instancetype)proxyActivity {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAPLWhatsappTestScheme]]) {
        return [self new];
    }
    return nil;
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
    return [self activityItems:activityItems containObjectsOfType:@[[NSURL class], [NSString class]]];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.items = activityItems;
}

- (void)performActivity {
    __block NSString *messageText = @"";
    [self.items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        [self addString:[self stringFromActivityItem:item] toMessageText:&messageText currentIndex:idx];
    }];
    
    NSString * whatsappURLString = [NSString stringWithFormat:kAPLWhatsappActivityUrl, messageText];
    NSURLComponents *whatsappUrl = [NSURLComponents componentsWithString:[whatsappURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:whatsappUrl.URL];
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

/*
 Check if the array of activity items contains one or more objects that correspond
 to the object types the UIActivity supports
 */
- (BOOL)activityItems:(NSArray *)items containObjectsOfType:(NSArray *)objectTypes {
    __block NSInteger foundObjectTypes = 0;
    [items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        [objectTypes enumerateObjectsUsingBlock:^(id objectType, NSUInteger idx, BOOL *stop) {
            if ([item isKindOfClass:[objectType class]]) {
                foundObjectTypes++;
            }
        }];
    }];
    return foundObjectTypes > 0;
}

@end
