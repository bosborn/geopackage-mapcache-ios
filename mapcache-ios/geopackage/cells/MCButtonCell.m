//
//  GPKGSButtonCell.m
//  mapcache-ios
//
//  Created by Tyler Burgett on 11/27/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "MCButtonCell.h"

@implementation MCButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)buttonTapped:(id)sender {
    [_delegate performButtonAction:_action];
}


- (void) enableButton {
    _button.userInteractionEnabled = YES;
    _button.backgroundColor = [MCColorUtil getAccent];
}


- (void) disableButton {
    _button.userInteractionEnabled = NO;
    _button.backgroundColor = [MCColorUtil getAccentLight];
}

@end