//
//  MasterViewController.h
//  geopackage-sample-ios
//
//  Created by Brian Osborn on 5/5/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *resultText;

- (IBAction)buttonTapped:(id)sender;

@end