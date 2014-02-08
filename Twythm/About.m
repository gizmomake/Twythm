//
//  About.m
//  Twythm
//
//  Created by Ben Thomson on 6/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "About.h"


@interface About()
    


@end

@implementation About

@synthesize scrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 50, self.view.frame.size.width-30, self.view.frame.size.height-30)];
    NSInteger viewcount= 5;
    
    for(int i = 0; i< viewcount; i++) {
        
        CGFloat y = i * self.view.frame.size.height;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,self.view.frame.size.width, 300)];
        view.backgroundColor = [UIColor clearColor];
        scrollview.pagingEnabled = YES;
        [scrollview setShowsHorizontalScrollIndicator:NO];
        [scrollview addSubview:view];
        
     }
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *viewcount);
    [self.view addSubview:scrollview];
    
    
    
    
    
    NSArray *text = [NSArray arrayWithObjects:@"Welcome!",@"Using Twythm",@"Sharing", @":)", nil];
    NSArray *bodytext = [NSArray arrayWithObjects:@"Welcome to Twythm! Twythm allows you to share the song you're listening to on Twitter and Facebook. \n \n Swipe to see how it works.",@"First, we'll learn how to navigate. To go back, swipe from the very left side of your screen. Next, we'll learn how to search for a song. Tap the search button and type in a song and an artist. You'll get a page with the song you searched for. There, you can share it and listen to it. Don't worry if it's not right, just refine your search. Finally, instead of searching for a song, you can use the one that's playing in your music app. Just tap \"Share the song I'm listening to\" \n \n Swipe left to learn more ",@"Once you have searched for a song, or used the one playing, You can share it in a Tweet, post it on Facebook, or copy the link. When you share the song, your friends will get a unique link for that song. If they visit it, they too can listen to the song, buy it on Amazon, and more. For example, let's say you typed in \"Countdown by Rush\", you'd get a link like this: http://twyt.co/gHl8rP. If you tap it, you can listen to it as well.", @"Enjoy!", nil];

    for (int i = 0; i < text.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollview.frame.size.width * i;
        frame.origin.y = -175;
        frame.size = self.scrollview.frame.size;
        
        CGRect bodyframe;
        bodyframe.origin.x = self.scrollview.frame.size.width * i;
        bodyframe.origin.y = 20;
        bodyframe.size = self.scrollview.frame.size;
        
        
        UILabel *hello = [ [UILabel alloc ] initWithFrame:frame];
        hello.textAlignment =  UITextAlignmentCenter;
        hello.textColor = [UIColor whiteColor];
        hello.backgroundColor = [UIColor clearColor];
        hello.font = [UIFont fontWithName:@"Helvetica Neue" size:(36.0)];
        [self.scrollview addSubview:hello];
        hello.text = [text objectAtIndex:i];
        
        UILabel *body = [ [UILabel alloc ] initWithFrame:bodyframe];
        body.textAlignment =  UITextAlignmentCenter;
        body.textColor = [UIColor whiteColor];
        body.numberOfLines = 20;
        body.backgroundColor = [UIColor clearColor];
        body.font = [UIFont fontWithName:@"Helvetica Neue-Light" size:(27.0)];
        [self.scrollview addSubview:body];
        body.text = [bodytext objectAtIndex:i];
     
    }
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * text.count, 300);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollview = nil;
}



    - (IBAction)openMail:(id)sender
    {
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setSubject:@"Feedback on the app"];
            NSArray *toRecipients = [NSArray arrayWithObjects:@"hello@twythm.com", nil];
            [mailer setToRecipients:toRecipients];
            NSString *emailBody = @" Type your comments here ";
            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentModalViewController:mailer animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Your device doesn't support the composer sheet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
           }
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}
@end