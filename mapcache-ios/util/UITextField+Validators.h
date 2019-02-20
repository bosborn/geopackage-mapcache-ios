//
//  UITextField+Validators.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 2/7/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Validators)
- (BOOL)isValidURL:(UITextField *)textField;
- (void)trimWhiteSpace:(UITextField *)textField;
@end

NS_ASSUME_NONNULL_END
