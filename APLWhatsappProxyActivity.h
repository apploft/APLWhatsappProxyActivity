//
//  APLWhatsappProxyActivity.h
//
//
//  Created by Christopher Groß on 01.12.14.
//  Copyright (c) 2014 apploft GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APLWhatsappProxyActivity : UIActivity

/**
 *	Returns an proxy activity if Whatsapp is installed on the device.
 *	@return	APLWhatsappProxyActivity
 */
+ (instancetype) proxyActivity;
@end
