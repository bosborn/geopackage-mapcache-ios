//
//  GPKGSCoordinator.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 10/31/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPKGGeoPackageManager.h>
#import "GPKGSLoadTilesTask.h"
#import "MCGeopackageSingleViewController.h"
#import "GPKGSDatabase.h"
#import "GPKGSCreateTilesData.h"
#import "GPKGSLoadTilesData.h"
#import "GPKGSGenerateTilesData.h"
#import "GPKGSLoadTilesProtocol.h"
#import "MCCreateLayerViewController.h"
#import "MCFeatureLayerDetailsViewController.h"
#import "MCTileLayerDetailsViewController.h"
#import "MCBoundingBoxViewController.h"
#import "MCZoomAndQualityViewController.h"
#import "MCManualBoundingBoxViewController.h"

@protocol MCGeoPackageCoordinatorDelegate <NSObject>
- (void) geoPackageCoordinatorCompletionHandlerForDatabase:(NSString *) database withDelete:(BOOL)didDelete;
@end

@interface MCGeoPackageCoordinator: NSObject <MCOperationsDelegate, MCFeatureLayerCreationDelegate, MCTileLayerDetailsDelegate, MCTileLayerBoundingBoxDelegate, MCZoomAndQualityDelegate, MCCreateLayerDelegate, GPKGSLoadTilesProtocol, MCManualBoundingBoxDelegate>
- (instancetype) initWithNavigationController:(UINavigationController *) navigationController andDelegate:(id<MCGeoPackageCoordinatorDelegate>)delegate andDatabase:(GPKGSDatabase *) database;
- (void) start;
@end
