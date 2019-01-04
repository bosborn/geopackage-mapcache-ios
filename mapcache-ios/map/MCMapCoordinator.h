//
//  MCMapCoordinator.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 9/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCGeoPackageListCoordinator.h"
#import "GPKGGeoPackageFactory.h"
#import "GPKGGeoPackageManager.h"
#import "MCSettingsCoordinator.h"


@class MCMapViewController;
@protocol MCMapActionDelegate;

@protocol MCMapDelegate <NSObject>
- (void) updateMapLayers;
- (void) toggleGeoPackage:(GPKGSDatabase *) geoPackage;
- (void) zoomToSelectedGeoPackage:(NSString *) geoPackageName;
@end


@interface MCMapCoordinator : NSObject <MCMapDelegate, MCMapActionDelegate>
- (instancetype) initWithMapViewController:(MCMapViewController *) mapViewController;

@property (nonatomic, strong) id<NGADrawerViewDelegate> drawerViewDelegate;
@end
