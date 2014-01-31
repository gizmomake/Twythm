//
//  SafariActivity.m
//  Twythm
//
//  Created by Ben Thomson on 1/12/14.
//  Copyright (c) 2014 Gizmomake. All rights reserved.
//

#import "SafariActivity.h"
#import "Result.h"

@implementation SafariActivity
- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"This is a #twitter post!";
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"This is a facebook post!";
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        NSLog(@"%@", _url);
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return _url;
    if ( [activityType isEqualToString:@"com.ben.Safari"] )
        
        return _url;

    
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }
@end

@implementation APActivityIcon

- (NSString *)activityType { return @"com.ben.Safari"; }
- (NSString *)activityTitle { return @"Open in Safari"; }
- (UIImage *) activityImage { return [UIImage imageNamed:@"safari.png"]; }
- (BOOL) canPerformWithActivityItems:(NSArray *)activityItems { return YES; }
- (void) prepareWithActivityItems:(NSArray *)activityItems { }
- (UIViewController *) activityViewController { return nil; }
- (void) performActivity {
    BOOL completed = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    
    [self activityDidFinish:completed];
}
@end