//
//  ViewController.m
//  ScreeningMoreTag
//
//  Created by 韩新辉 on 2017/12/24.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import "ViewController.h"
#import "ChooseMoreItems.h"


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property (strong, nonatomic)ChooseMoreItems *subWayAndAreas;/**<区域地铁*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatTagsView];
}


-(void)creatTagsView{
    WS(weakSelf);
    self.subWayAndAreas = [[ChooseMoreItems alloc]init];
    self.subWayAndAreas.frame = CGRectMake(0, 150, SCREEN_WIDTH, 300);
    [self.subWayAndAreas setDidRemoveFromSuperViewHandle:^{
        [weakSelf subWayAndAreasViewRemoveFromSuperview];
    }];
    [self.view  addSubview:self.subWayAndAreas];
    self.subWayAndAreas.hidden = YES;
}

- (IBAction)chooseMoreTags:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.subWayAndAreas.hidden = NO;
    } else {
        [self subWayAndAreasViewRemoveFromSuperview];
    }
}
#pragma mark - 区域移除
- (void)subWayAndAreasViewRemoveFromSuperview {
    self.subWayAndAreas.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
