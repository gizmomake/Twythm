//
//  CurrentSong.m
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "CurrentSong.h"
#define AdMob_ID @"a151ead211d0faa"
@interface CurrentSong ()

@end

@implementation CurrentSong
@synthesize Link;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] != MPMusicPlaybackStatePlaying) {

    [self.audioPlayer play];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

   //Media player info
   MPMediaItem * song = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
   title   = [song valueForProperty:MPMediaItemPropertyTitle];
   artist  = [song valueForProperty:MPMediaItemPropertyArtist];
   [Text setText:title];
   [Artist setText:artist];
    
    //Remove spaces from artist and title
    NSString *title_replaced =[title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *title_formatted = [NSString stringWithFormat: @"%@", title_replaced];
    
    NSString *artist_replaced =[artist stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *artist_formatted = [NSString stringWithFormat: @"%@", artist_replaced];
    
    //Get Link
    NSString *raw_link = [NSString stringWithFormat: @"http://twyt.co/generate.php?query=%@+%@", title_formatted, artist_formatted];
    NSLog(@"%@",raw_link);
    NSURL *link_url = [NSURL URLWithString:raw_link];
    NSError *error;
    NSString *link = [NSString stringWithContentsOfURL:link_url
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    link_formatted = [NSString stringWithFormat: @"%@", link];
    
    
    NSLog(@"%@",link_formatted);

    
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

}

- (IBAction)Link:(id)sender {
    SafariActivity *ActivityProvider = [[SafariActivity alloc] init];
    //UIImage *ImageAtt = [UIImage imageNamed:@"safari.png"];
    NSArray *Items = @[ActivityProvider];
    
    
    UIActivityViewController *ActivityView = [[UIActivityViewController alloc]
                                              initWithActivityItems:Items
                                              applicationActivities:nil];
    [ActivityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypePrint,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypePostToWeibo]];
    
    [self presentViewController:ActivityView animated:YES completion:nil];
    [ActivityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         
     }];

}

- (IBAction)Facebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; 
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@",title, artist, link_formatted]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    }
- (IBAction)Tweet:(id)sender {


        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"I'm listening to %@ by %@ on Twythm.com! %@",title, artist, link_formatted]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
