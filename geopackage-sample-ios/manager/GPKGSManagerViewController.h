//
//  GPKGSManagerViewController.h
//  geopackage-sample-ios
//
//  Created by Brian Osborn on 7/6/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPKGSDownloadFileViewController.h"
#import "GPKGSIndexerProtocol.h"
#import "GPKGSCreateFeaturesViewController.h"
#import "GPKGSManagerCreateTilesViewController.h"
#import "GPKGSManagerLoadTilesViewController.h"

extern NSString * const GPKGS_MANAGER_SEG_DOWNLOAD_FILE;
extern NSString * const GPKGS_MANAGER_SEG_DISPLAY_TEXT;
extern NSString * const GPKGS_MANAGER_SEG_CREATE_FEATURES;
extern NSString * const GPKGS_MANAGER_SEG_CREATE_TILES;
extern NSString * const GPKGS_EXPANDED_PREFERENCE;

extern const char ConstantKey;

@interface GPKGSManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GPKGSDownloadFileDelegate, GPKGSIndexerProtocol, GPKGSCreateFeaturesDelegate, GPKGSManagerCreateTilesDelegate, GPKGSManagerLoadTilesDelegate>

@property (weak, nonatomic) IBOutlet UIButton *clearActiveButton;

@end
