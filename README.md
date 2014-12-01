APLWhatsappProxyActivity
=========

Apple's UIActivityViewController does not display a Whatsapp Button. We add a custom application activity here, to display a Whatsapp Button in this case. 
Our activity composes a message text from the given activity items and opens the whatsapp app if it's installed on the device.

## Installation
Install via cocoapods by adding this to your Podfile:

	pod "APLWhatsappProxyActivity", "~> 0.0.1"

## Usage
Import header file:

	#import <APLWhatsappProxyActivity/APLWhatsappProxyActivity.h>
	
Initialize `APLWhatsappProxyActivity`:
	
	APLWhatsappProxyActivity *whatsappProxyActivity = 	[APLWhatsappProxyActivity proxyActivity];
    NSArray *applicationActivities = @[whatsappProxyActivity];
    
Finally init your `UIActivityViewController` with the `applicationActivities` array.