//
//  FINCustomMenuModel.m
//  demo
//
//  Created by Haley on 2020/12/17.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "FINCustomMenuModel.h"

@implementation FINCustomMenuModel

@synthesize menuId, menuIconImage, menuTitle, menuType;

- (id)copyWithZone:(NSZone *)zone
{
    FINCustomMenuModel *model = [[FINCustomMenuModel allocWithZone:zone] init];
    model.menuId = self.menuId;
    model.menuIconImage = self.menuIconImage;
    model.menuTitle = self.menuTitle;
    return model;
}

@end
