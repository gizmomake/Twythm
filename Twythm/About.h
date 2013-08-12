//
//  About.h
//  Twythm
//
//  Created by Ben Thomson on 6/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
@interface About : ViewController {
    UIScrollView* scrollview;
    UIPageControl *page;
}
@property (nonatomic, retain) IBOutlet UIScrollView* scrollview;
@property (strong, nonatomic) IBOutlet UIPageControl *page;
- (IBAction)openMail:(id)sender;

