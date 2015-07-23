//
//  GPKGSLoadTilesViewController.h
//  geopackage-sample-ios
//
//  Created by Brian Osborn on 7/23/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPKGSLoadTilesData.h"

@interface GPKGSLoadTilesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) GPKGSLoadTilesData * data;

@end
