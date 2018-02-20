//
//  GPKGSNewLayerViewController.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 1/4/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPKGSTable.h"
#import "GPKGSFeatureTable.h"
#import "GPKGSTileTable.h"
#import "GPKGSDatabase.h"
#import "GPKGSCreateTilesData.h"
#import "GPKGSLoadTilesData.h"
#import "GPKGSGenerateTilesData.h"
#import "GPKGSCreateLayerViewController.h"
#import "GPKGSTileLayerDetailsViewController.h"
#import "GPKGSFeatureLayerDetailsViewController.h"
#import "MCBoundingBoxViewController.h"
#import "MCZoomAndQualityViewController.h"

@protocol MCNewLayerWizardDelegate
- (void) createTileLayer:(GPKGSCreateTilesData *) tileData;
@end

@interface GPKGSNewLayerWizard : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, GPKGSCreateLayerDelegate, MCTileLayerDetailsDelegate, MCTileLayerBoundingBoxDelegate, MCZoomAndQualityDelegate>
@property (strong, nonatomic) GPKGSDatabase *database;
@property (weak, nonatomic) id<MCNewLayerWizardDelegate> layerCreationDelegate;
@property (weak, nonatomic) id<GPKGSFeatureLayerCreationDelegate> featureLayerDelegate;
@end
