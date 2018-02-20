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
#import "GPKGSGeopackageSingleViewController.h"
#import "GPKGSDatabase.h"
#import "GPKGSNewLayerWizard.h"
#import "GPKGSLoadTilesProtocol.h"


@protocol GPKGSCoordinatorDelegate <NSObject>
- (void) geoPackageCoordinatorCompletionHandlerForDatabase:(NSString *) database withDelete:(BOOL)didDelete;
@end

@interface GPKGSCoordinator: NSObject <GPKGSOperationsDelegate, GPKGSFeatureLayerCreationDelegate, MCNewLayerWizardDelegate, GPKGSLoadTilesProtocol>
- (instancetype) initWithNavigationController:(UINavigationController *) navigationController andDelegate:(id<GPKGSCoordinatorDelegate>)delegate andDatabase:(GPKGSDatabase *) database;
- (void) start;
@end
