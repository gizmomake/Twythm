//
//  ViewController.h
//  Twythm
//
//  Created by Ben Thomson on 6/13/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
}
@property (strong, nonatomic) IBOutlet UITextField *CaptureInformation;

- (IBAction)SendInformation:(id)sender;

- (IBAction)search:(id)sender;

@end
