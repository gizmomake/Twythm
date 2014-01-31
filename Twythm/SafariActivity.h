//
//  SafariActivity.h
//  Twythm
//
//  Created by Ben Thomson on 1/12/14.
//  Copyright (c) 2014 Gizmomake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"
@interface SafariActivity : UIActivityItemProvider <UIActivityItemSource>
@property (nonatomic,retain) NSString *url;
@end

@interface APActivityIcon : UIActivity
@property (nonatomic,retain) NSString *url;

@end