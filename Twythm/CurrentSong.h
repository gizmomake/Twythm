//
//  CurrentSong.h
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <Accounts/Accounts.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SafariActivity.h"
#import "GADBannerView.h"

@interface CurrentSong : ViewController
{
    UILabel IBOutlet *Text;
    IBOutlet UILabel *Artist;
    IBOutlet UIButton *Tweet;
    IBOutlet UIButton *Facebook;
    GADBannerView *bannerView_;
    NSString *link_formatted;
    NSString * title;
    NSString * artist;
    SLComposeViewController *mySLComposerSheet;

}
@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (nonatomic, retain) UIButton *Link;

@end
