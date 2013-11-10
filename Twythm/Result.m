//
//  Result.m
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "Result.h"
#import "ViewController.h"
#define AdMob_ID @"a151ead211d0faa"

@interface Result ()

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
    
    
    
    
    NSString *raw_watchurl_raw = [NSString stringWithFormat: @"http://twythm.com/youtubegetter.php?query=%@+%@", title_formatted, artist_formatted];
    NSString *raw_watchurl = [raw_watchurl_raw stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"%@",raw_watchurl);

    NSURL *watch_url = [NSURL URLWithString:raw_watchurl];
    NSString *watchurl = [NSString stringWithContentsOfURL:watch_url
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    
   raw_video = [NSString stringWithFormat: @"https://www.youtube.com/v/%@", watchurl];

    NSLog(@"%@",raw_video);

    
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 200\"/></head><body style=\"background:#00;margin-top:0px;margin-left:0px\"><div><object width=\"200\" height=\"200\"><param name=\"movie\" value=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"200\" height=\"200\"></embed></object></div></body></html>", raw_video, raw_video];
    
    [webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:webView];
   
        
}

-(IBAction)play:(id)sender {
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:raw_video] quality:LBYouTubeVideoQualityLarge];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error) {
            NSLog(@"Did extract video URL using completion block: %@", videoURL);
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
        moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
        
        [moviePlayerController.view setFrame:CGRectMake(0, 70, 320, 270)];
        [self.view addSubview:moviePlayerController.view];
        moviePlayerController.fullscreen = YES;
        [moviePlayerController play];
    }];
    


}

-(void)videoPlayBackDidFinish:(NSNotification*)notification  {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [moviePlayerController stop];
    [moviePlayerController.view removeFromSuperview];
    [self dismissMoviePlayerViewControllerAnimated];
}
- (void)MPMoviePlayerDidExitFullscreen:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:nil];
    
    [moviePlayerController stop];
    [moviePlayerController.view removeFromSuperview];
}
- (IBAction)Link:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = link_formatted;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Link copied to clipboard!"
                                                   message: nil
                                                  delegate: self
                                         cancelButtonTitle:@"Got It"
                                         otherButtonTitles:nil];
    
    
    [alert show];
}



- (IBAction)Facebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@ ",title_formatted, artist_formatted, link_formatted, mySLComposerSheet.serviceType]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}
- (IBAction)Tweet:(id)sender {

    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@ ",title_formatted, artist_formatted, link_formatted]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
