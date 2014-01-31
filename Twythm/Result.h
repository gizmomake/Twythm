//
//  Result.h
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <Accounts/Accounts.h>
#import "GADBannerView.h"
#import "SafariActivity.h"
@interface Result : ViewController

{
    UITextField *textField;
    NSString *link_formatted;
    NSString *title_formatted;
    IBOutlet UIButton *Tweet;
    IBOutlet UIButton *Facebook;
    NSString *artist_formatted;
    IBOutlet UIButton *Link;
    IBOutlet UIButton *play;
    GADBannerView *bannerView_;
    SLComposeViewController *mySLComposerSheet;
    NSString *raw_video;
    UIActivityViewController *ActivityView;
}


@property (nonatomic,retain) UIActivityViewController *ActivityView;

@property (strong, nonatomic) IBOutlet UILabel *Text;
@property (strong, nonatomic) IBOutlet UILabel *Artist;
@property (nonatomic, retain) UIButton *Link;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property (nonatomic,strong) id infoRequest;
- (IBAction)home;
- (IBAction)play:(id)sender;

@end
