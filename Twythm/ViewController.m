//
//  ViewController.m
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "ViewController.h"
#import "CurrentSong.h"
#import "Result.h"
#import "iRate.h"
#import "Reachability.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize CaptureInformation;
- (void)viewDidLoad
{
    [iRate sharedInstance].previewMode = NO;
    [iRate sharedInstance].appStoreID = 518215205;

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oh Darn!"
                                                          message:@"You need internet access to use Twythm. Please turn on WiFi or use cell data."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];      }
    else
    {
    }
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.CaptureInformation.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"FirstTime"] == nil)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello!"
                                                          message:@"Welcome to Twythm! \n\n Twythm is the easiest way to share the song you're listening to. When you share a song, a unique link for it will be generated, allowing your friends to listen too! To navigate, swipe to the right to go back. \n\n Contact us for help and feedback at hello@twythm.com"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];    }
    [defaults setObject:@"firsttime" forKey:@"FirstTime"];
}




- (IBAction)SendInformation:(id)sender
{
    
    
    
    NSString *song  = [CaptureInformation text];
    
 
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:song forKey:@"song"];
    [defaults synchronize];
    NSLog(@"Data saved");
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
