//
//  MCTileHelper.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 9/20/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPKGSDatabase.h"
#import "GPKGSTileTable.h"
#import "GPKGGeoPackageManager.h"
#import "GPKGGeoPackageFactory.h"
#import "GPKGTileBoundingBoxUtils.h"
#import "GPKGTileTableScaling.h"
#import "GPKGSTileTable.h"
#import "GPKGTileBoundingBoxUtils.h"
#import "GPKGBoundedOverlay.h"
#import "GPKGOverlayFactory.h"
#import "SFPProjectionFactory.h"
#import "SFGeometryEnvelopeBuilder.h"
#import "SFPProjectionConstants.h"
#import "GPKGSDatabases.h"


@protocol MCTileHelperDelegate <NSObject>
- (void) addTileOverlayToMapView: (MKTileOverlay *) tileOverlay;
@end


@interface MCTileHelper : NSObject
@property (nonatomic, strong) id<MCTileHelperDelegate> tileHelperDelegate;

- (instancetype)initWithTileHelperDelegate: (id<MCTileHelperDelegate>) delegate;
- (void)prepareTiles;
- (MKTileOverlay *)createOverlayForTiles: (GPKGSTileTable *) tiles fromGeoPacakge:(GPKGGeoPackage *) geoPackage;
- (GPKGBoundingBox *)tilesBoundingBox;
- (GPKGBoundingBox *)transformBoundingBoxToWgs84: (GPKGBoundingBox *)boundingBox withSrs: (GPKGSpatialReferenceSystem *)srs;
@end
