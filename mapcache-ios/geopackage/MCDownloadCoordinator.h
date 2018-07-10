//
//  GPKGSDownloadCoordinator.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 11/1/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPKGSDownloadFileViewController.h"
#import "GPKGSUtils.h"
#import "GPKGSProperties.h"
#import "GPKGSConstants.h"


@protocol GPKGSDownloadCoordinatorDelegate <NSObject>
- (void) downloadCoordinatorCompletitonHandler:(bool) didDownload;
@end

@protocol GPKGSDownloadCoordinatorDismissedDelegate <NSObject>
- (void) dismissDownloadCoordinator;
@end


@interface MCDownloadCoordinator : NSObject <GPKGSDownloadFileDelegate>

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController andDelegate:(id<GPKGSDownloadCoordinatorDelegate>) delegate;
- (void)start;

@end
