//
//  GPKGSGeopackageSingleViewController.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 10/31/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPKGSTable.h"
#import "GPKGSFeatureTable.h"
#import "GPKGSTileTable.h"
#import "GPKGSDatabase.h"
#import "MCHeaderCellTableViewCell.h"
#import "GPKGSSectionTitleCell.h"
#import "GPKGSLayerCell.h"
#import "GPKGSButtonCell.h"
#import "GPKGSConstants.h"
#import "GPKGSProperties.h"
#import "MCGeoPackageOperationsCell.h"
#import <GPKGGeoPackageManager.h>
#import <GPKGGeoPackageFactory.h>
#import "GPKGSUtils.h"


@protocol MCOperationsDelegate <NSObject>
- (void) newLayer;
- (void) deleteGeoPackage;
- (void) copyGeoPackage;
- (void) callCompletionHandler;
- (void) deleteLayer:(NSString *) layerName;
- (void) showInfo;
- (void) showLayerDetails:(NSString *) layerName;
@end


@interface MCGeopackageSingleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GPKGSButtonCellDelegate, GPKGSHeaderCellButtonPressedDelegate, MCGeoPackageButtonsCellDelegate>
@property (strong, nonatomic) GPKGSDatabase *database;
@property (weak, nonatomic) id<MCOperationsDelegate> delegate;
- (void) update;
- (void) removeLayerNamed:(NSString *) layerName;
@end
