//
//  ChooseAreasBase.h
//  ChooseAreas
//
//  Created by 韩新辉 on 2017/12/12.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseAreasBase : NSObject

@property (nonatomic, assign) int layer;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *text;


@end
