//
//  MCTileHelper.m
//  mapcache-ios
//
//  Created by Tyler Burgett on 9/20/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "MCTileHelper.h"


@interface MCTileHelper()
@property (nonatomic, strong) GPKGGeoPackageManager *manager;
@property (nonatomic, strong) GPKGBoundingBox * tilesBoundingBox;
@property (nonatomic, strong) GPKGSDatabases *active;
@end


@implementation MCTileHelper

- (instancetype) init {
    self = [super init];
    self.active = [GPKGSDatabases getInstance];
    self.manager = [GPKGGeoPackageFactory getManager];
    
    return self;
}


- (instancetype) initWithTileHelperDelegate: (id<MCTileHelperDelegate>) delegate {
    self = [super init];
    self.tileHelperDelegate = delegate;
    self.active = [GPKGSDatabases getInstance];
    self.manager = [GPKGGeoPackageFactory getManager];
    
    return self;
}


- (void) prepareTiles {
    NSArray *activeDatabases = [[NSArray alloc] initWithArray: [self.active getDatabases]];

    for (GPKGSDatabase *database in activeDatabases) {
        GPKGGeoPackage *geoPackage = [self.manager open:database.name];
        
        if (geoPackage != nil) {
            for (GPKGSTileTable *tiles in [database getTiles]) {
                @try {
                    MKTileOverlay *tileOverlay = [self createOverlayForTiles:tiles fromGeoPacakge:geoPackage];
                    [self.tileHelperDelegate addTileOverlayToMapView:tileOverlay];
                } @catch (NSException *e) {
                    NSLog(@"%@", [e description]);
                } 
            }
        }
    }
}


// MCTileHelper version of -(void) displayTiles: (GPKGSTileTable *)
-(MKTileOverlay *) createOverlayForTiles: (GPKGSTileTable *) tiles fromGeoPacakge:(GPKGGeoPackage *) geoPackage {
    GPKGTileDao * tileDao = [geoPackage getTileDaoWithTableName:tiles.name];
    GPKGTileTableScaling *tileTableScaling = [[GPKGTileTableScaling alloc] initWithGeoPackage:geoPackage andTileDao:tileDao];
    GPKGTileScaling *tileScaling = [tileTableScaling get];
    GPKGBoundedOverlay * overlay = [GPKGOverlayFactory boundedOverlay:tileDao andScaling:tileScaling];
    overlay.canReplaceMapContent = false;
    
    GPKGTileMatrixSet * tileMatrixSet = tileDao.tileMatrixSet;
    
    // TODO: handle feature tiles.
    //    GPKGFeatureTileTableLinker * linker = [[GPKGFeatureTileTableLinker alloc] initWithGeoPackage:geoPackage];
    //    NSArray<GPKGFeatureDao *> * featureDaos = [linker getFeatureDaosForTileTable:tileDao.tableName];
    //    for(GPKGFeatureDao * featureDao in featureDaos){
    //
    //        // Create the feature tiles
    //        GPKGFeatureTiles * featureTiles = [[GPKGFeatureTiles alloc] initWithGeoPackage:geoPackage andFeatureDao:featureDao];
    //
    //        self.featureOverlayTiles = true;
    //
    //        // Add the feature overlay query
    ////        GPKGFeatureOverlayQuery * featureOverlayQuery = [[GPKGFeatureOverlayQuery alloc] initWithBoundedOverlay:overlay andFeatureTiles:featureTiles];
    //        [self.featureOverlayQueries addObject:featureOverlayQuery];
    //    }
    
    GPKGBoundingBox *displayBoundingBox = [tileMatrixSet getBoundingBox];
    GPKGTileMatrixSetDao * tileMatrixSetDao = [geoPackage getTileMatrixSetDao];
    GPKGSpatialReferenceSystem *tileMatrixSetSrs = [tileMatrixSetDao getSrs:tileMatrixSet];
    GPKGContents *contents = [tileMatrixSetDao getContents:tileMatrixSet];
    GPKGBoundingBox *contentsBoundingBox = [contents getBoundingBox];
    if(contentsBoundingBox != nil){
        GPKGContentsDao *contentsDao = [geoPackage getContentsDao];
        SFPProjectionTransform *transform = [[SFPProjectionTransform alloc] initWithFromProjection:[[contentsDao getSrs:contents] projection] andToProjection:[tileMatrixSetSrs projection]];
        GPKGBoundingBox *transformedContentsBoundingBox = contentsBoundingBox;
        if(![transform isSameProjection]){
            transformedContentsBoundingBox = [transformedContentsBoundingBox transform:transform];
        }
        displayBoundingBox = [GPKGTileBoundingBoxUtils overlapWithBoundingBox:displayBoundingBox andBoundingBox:transformedContentsBoundingBox];
    }
    
    [self updateTileBoundingBox:displayBoundingBox withSrs:tileMatrixSetSrs andSpecifiedBoundingBox:nil];
    return overlay;
}



-(void) updateTileBoundingBox: (GPKGBoundingBox *) dataBoundingBox withSrs: (GPKGSpatialReferenceSystem *) srs andSpecifiedBoundingBox: (GPKGBoundingBox *) specifiedBoundingBox{

    GPKGBoundingBox * boundingBox = dataBoundingBox;
    if(boundingBox != nil){
        boundingBox = [self transformBoundingBoxToWgs84:boundingBox withSrs:srs];
    }else{
        boundingBox = [[GPKGBoundingBox alloc] initWithMinLongitudeDouble:-PROJ_WGS84_HALF_WORLD_LON_WIDTH andMinLatitudeDouble:PROJ_WEB_MERCATOR_MIN_LAT_RANGE andMaxLongitudeDouble:PROJ_WGS84_HALF_WORLD_LON_WIDTH andMaxLatitudeDouble:PROJ_WEB_MERCATOR_MAX_LAT_RANGE];
    }
    
    if(specifiedBoundingBox != nil){
        boundingBox = [GPKGTileBoundingBoxUtils overlapWithBoundingBox:boundingBox andBoundingBox:specifiedBoundingBox];
    }
    
    if(self.tilesBoundingBox == nil){
        self.tilesBoundingBox = boundingBox;
    }else{
        self.tilesBoundingBox = [GPKGTileBoundingBoxUtils unionWithBoundingBox:self.tilesBoundingBox andBoundingBox:boundingBox];
    }
}


- (GPKGBoundingBox *)transformBoundingBoxToWgs84: (GPKGBoundingBox *)boundingBox withSrs: (GPKGSpatialReferenceSystem *)srs {
    
    SFPProjection *projection = [srs projection];
    if([projection isUnit:SFP_UNIT_DEGREES]){
        boundingBox = [GPKGTileBoundingBoxUtils boundDegreesBoundingBoxWithWebMercatorLimits:boundingBox];
    }
    SFPProjectionTransform *transformToWebMercator = [[SFPProjectionTransform alloc] initWithFromProjection:projection andToEpsg:PROJ_EPSG_WEB_MERCATOR];
    GPKGBoundingBox *webMercatorBoundingBox = [boundingBox transform:transformToWebMercator];
    SFPProjectionTransform *transform = [[SFPProjectionTransform alloc] initWithFromEpsg:PROJ_EPSG_WEB_MERCATOR andToEpsg:PROJ_EPSG_WORLD_GEODETIC_SYSTEM];
    boundingBox = [webMercatorBoundingBox transform:transform];
    return boundingBox;
}


-(GPKGBoundingBox *) tilesBoundingBox; {
    return _tilesBoundingBox;
}

@end
