//
//  Result.m
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "Result.h"
#import "ViewController.h"
#import "SafariActivity.h"
#import "XCDYouTubeVideoPlayerViewController.h"

#define AdMob_ID @"a151ead211d0faa"

@interface Result () <UIPopoverControllerDelegate>
{
    UIPopoverController *_popover;
}

@end

@implementation Result
@synthesize Text, Artist, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)home{

[textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *song = [defaults objectForKey:@"song"];
    if(song.length == 0) {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                          message:@"Please tap the search bar and type the song you want to share. "
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    song = [song stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                  self.view.frame.size.height -
                                                                  GAD_SIZE_320x50.height,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView_.adUnitID = AdMob_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
   [bannerView_ loadRequest:[GADRequest request]];
    
    //LINK
    NSString *raw_link = [NSString stringWithFormat: @"http://twyt.co/generate.php?query=%@", song];
    NSLog(@"%@",raw_link);
    NSURL *link_url = [NSURL URLWithString:raw_link];
    NSError *error;
    NSString *link = [NSString stringWithContentsOfURL:link_url
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    link_formatted = [NSString stringWithFormat: @"%@", link];
    
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }

    
    //TITLE
    

    NSString *raw_title = [NSString stringWithFormat: @"http://twythm.com/iphone/title.php?song=%@", song];
    NSLog(@"%@",raw_title);
    NSURL *title_url = [NSURL URLWithString:raw_title];
    NSString *title = [NSString stringWithContentsOfURL:title_url
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
    
    NSString *title_replaced =[title stringByReplacingOccurrencesOfString:@"'" withString:@""];

    title_formatted = [NSString stringWithFormat: @"%@", title_replaced];

    //ARTIST
    
    
    NSString *raw_artist = [NSString stringWithFormat: @"http://twythm.com/iphone/artist.php?song=%@", song];
    NSURL *artist_url = [NSURL URLWithString:raw_artist];
    NSString *artist = [NSString stringWithContentsOfURL:artist_url
                                               encoding:NSUTF8StringEncoding
                                                  error:&error];
    NSString *artist_replaced =[artist stringByReplacingOccurrencesOfString:@"'" withString:@""];

    artist_formatted = [NSString stringWithFormat: @"%@", artist_replaced];
    
    
    [Artist setText:artist_formatted];
    [Text setText:title_formatted];
    
    
}

-(IBAction)play:(id)sender {

    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"YGf-RQXhhBw"];
	[self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];



}


-(IBAction)showActivities:(id)sender
{
    
    SafariActivity *ActivityProvider = [[SafariActivity alloc] init];
    //UIImage *ImageAtt = [UIImage imageNamed:@"safari.png"];
    NSString *url = link_formatted;
    NSArray *Items = @[ActivityProvider,url];

    APActivityIcon *ca = [[APActivityIcon alloc] init];
    NSArray *Acts = @[ca];

   ActivityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:Items
                                               applicationActivities:Acts];
    [ActivityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypePrint,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypePostToWeibo]];
    
    [self presentViewController:ActivityView animated:YES completion:nil];
    [ActivityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         if ( [act isEqualToString:@"com.ben.Safari"] )           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];


     }];

}



- (IBAction)Facebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@",title_formatted, artist_formatted, link_formatted]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook accounts set up" message:@"Please add your Facebook account in settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)Tweet:(id)sender {

    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@",title_formatted, artist_formatted, link_formatted]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter accounts set up" message:@"Please add your Twitter account in settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    _popover = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
