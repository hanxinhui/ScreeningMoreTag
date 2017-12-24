//
//  ChooseMoreItems.m
//  ScreeningMoreTag
//
//  Created by 韩新辉 on 2017/12/24.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import "ChooseMoreItems.h"
#import "SDAutoLayout.h"
#import "ChooseAreasBase.h"
#import "ChooseAreasAndSubChildren.h"
#import "ChooseAreasChidren.h"
#import "Details.h"
#import "MJExtension.h"
#import "DetailsTableViewCell.h"
#import "SVProgressHUD.h"


static NSString *DETAIL_IDENTIF = @"cellThree";

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, ChooseMoreMenuItem) {
    ChooseMoreMenuItemArea ,  /**<区域*/
    ChooseMoreMenuItemSubways , /***<地铁*/
    ChooseMoreMenuItemNear /***<附近*/
};

/** tableView高度 */
static const CGFloat tableViewHeight = 350;


@interface ChooseMoreItems ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * firsttableView;
@property (nonatomic ,strong) UITableView * sectiondtableView;
@property (nonatomic ,strong) UITableView * threetableView;
@property (nonatomic, strong) NSMutableArray *baseArray;/**<大数据*/
@property (nonatomic, strong) NSMutableArray *baseSecondArray;/**<第一个tab数据*/
@property (nonatomic, strong) NSMutableArray *baseAreaArray;/**<第二个tab数据区域*/
@property (nonatomic, strong) NSMutableArray *baseSubArray;/**<第二个tab数据地铁*/
@property (nonatomic, strong) NSMutableArray *listAreasArray;/**<第三个tab区域数据*/
@property (nonatomic, strong) NSMutableArray *listSunArray;/**<第三个tab地铁数据*/
@property (nonatomic ,strong) NSMutableArray * selectedSectondAreasArray;/**<选中区域*/
@property (nonatomic ,strong) NSMutableArray * selectedSectondSubArray;/**<选中地铁*/
@property (nonatomic ,strong) NSMutableArray * selectedAreasArray;/**<选中具体区域*/
@property (nonatomic ,strong) NSMutableArray * selectedSubArray;/**<选中具体地铁*/

@property (nonatomic, assign) ChooseMoreMenuItem menuItem;/**<选中的类别*/
/** 选中二级菜单 */
@property (nonatomic, copy) NSString *selectStr;

@property (nonatomic, copy) NSString *selectSubStr;


@end



@implementation ChooseMoreItems

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.67];
        //本地数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ProductList" ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:plistPath];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *SubwayJsonV1 = dic[@"SubwayJsonV1"];
        NSArray *arr = SubwayJsonV1[@"root"];
        NSDictionary *childrenDic = arr[0];
        NSArray *childrenArr = childrenDic[@"children"];
        
        for (int i = 0 ; i<childrenArr.count; i++) {
            NSDictionary *dic = childrenArr[i];
            ChooseAreasBase *baseDic = [ChooseAreasBase mj_objectWithKeyValues:dic];
            [self.baseArray  addObject:baseDic];
        }
        
        NSLog(@"dic %@",self.baseArray);
        for (int j = 0; j<self.baseArray.count; j++) {
            NSDictionary *dic = self.baseArray[j];
            ChooseAreasAndSubChildren *baseChildren = [ChooseAreasAndSubChildren  mj_objectWithKeyValues:dic];
            [self.baseSecondArray addObject:baseChildren];
        }
        [self.baseSecondArray removeObjectAtIndex:2];//移除附近数据
        
        //区域
        NSDictionary *seconDic = self.baseSecondArray[0];
        ChooseAreasAndSubChildren *baseChildren = [ChooseAreasAndSubChildren  mj_objectWithKeyValues:seconDic];
        self.baseAreaArray = [ChooseAreasChidren mj_objectArrayWithKeyValuesArray:baseChildren.children];
        
        //地铁
        NSDictionary *threeDic = self.baseSecondArray[1];
        ChooseAreasAndSubChildren *baseChildrenThree = [ChooseAreasAndSubChildren  mj_objectWithKeyValues:threeDic];
        self.baseSubArray = [ChooseAreasChidren mj_objectArrayWithKeyValuesArray:baseChildrenThree.children];
        
        self.firsttableView = [[UITableView alloc] init];
        self.firsttableView.delegate = self;
        self.firsttableView.dataSource = self;
        self.firsttableView.estimatedSectionHeaderHeight = 0;
        self.firsttableView.estimatedSectionFooterHeight = 0;
        self.firsttableView.estimatedRowHeight = 0;
        self.firsttableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview: self.firsttableView];
        self.firsttableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(SCREEN_WIDTH*0.5).heightIs(tableViewHeight);
        
        self.sectiondtableView = [[UITableView alloc] init];
        self.sectiondtableView.delegate = self;
        self.sectiondtableView.dataSource = self;
        self.sectiondtableView.estimatedSectionHeaderHeight = 0;
        self.sectiondtableView.estimatedSectionFooterHeight = 0;
        self.sectiondtableView.estimatedRowHeight = 0;
        self.sectiondtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview: self.sectiondtableView];
        self.sectiondtableView.sd_layout.leftSpaceToView(self.firsttableView, 0).topSpaceToView(self, 0).widthIs(SCREEN_WIDTH*0.5).heightIs(tableViewHeight);
        
        self.threetableView = [[UITableView alloc] init];
        self.threetableView.delegate = self;
        self.threetableView.dataSource = self;
        self.threetableView.estimatedSectionHeaderHeight = 0;
        self.threetableView.estimatedSectionFooterHeight = 0;
        self.threetableView.estimatedRowHeight = 0;
        self.threetableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview: self.threetableView];
        self.threetableView.sd_layout.leftSpaceToView(self.sectiondtableView, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(tableViewHeight);
        
        //底部view
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - tableViewHeight)];
        bottomLineView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.35];
        
        [self addSubview:bottomLineView];
        UITapGestureRecognizer *tapThePicImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picDetail:)];
        [bottomLineView addGestureRecognizer:tapThePicImageView];
        
    }
    return self;
}

#pragma mark - UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firsttableView) {
        return self.baseSecondArray.count;
    }
    else if (tableView == self.sectiondtableView) {
        if (self.menuItem == ChooseMoreMenuItemArea) {
            return self.baseAreaArray.count;
        }
        else if (self.menuItem == ChooseMoreMenuItemSubways) {
            return self.baseSubArray.count;
        }
    }
    else  {
        if (self.menuItem == ChooseMoreMenuItemArea) {
            return self.listAreasArray.count;
        }
        else if (self.menuItem == ChooseMoreMenuItemSubways) {
            return self.listSunArray.count;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.firsttableView) {
        static NSString *identifier = @"lefCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ChooseAreasAndSubChildren *baseChildren = [self.baseSecondArray objectAtIndex:indexPath.row];
        cell.textLabel.text = baseChildren.text;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor orangeColor];
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else if (tableView == self.sectiondtableView) {
        static NSString *centerIdentifier = @"centerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:centerIdentifier];
        }
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor orangeColor];
        if (self.menuItem == ChooseMoreMenuItemArea) {
            ChooseAreasChidren *vcitem = self.baseAreaArray[indexPath.row];
            cell.textLabel.text = vcitem.text;
        }
        else if (self.menuItem == ChooseMoreMenuItemSubways) {
            ChooseAreasChidren *vcitem = self.baseSubArray[indexPath.row];
            cell.textLabel.text = vcitem.text;
        }
       
        return cell;
    }
    else if (tableView == self.threetableView) {
        DetailsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_IDENTIF];
        if (!cell) {
            cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DETAIL_IDENTIF];
        }
        if (self.menuItem == ChooseMoreMenuItemArea) {
            Details *vcitem = self.listAreasArray[indexPath.row];
            for (Details *vc in self.selectedAreasArray) {
                if (vc.text == vcitem.text) {
                    NSLog(@"vc.text %@---vcitem.text%@",vc.text, vcitem.text);
                    vcitem.flag = YES;
                }
            }
            cell.detailsModel = vcitem;
        }
        else if (self.menuItem == ChooseMoreMenuItemSubways) {
            Details *vcitem = self.listSunArray[indexPath.row];
            for (Details *vc in self.selectedSubArray) {
                if (vc.text == vcitem.text) {
                    NSLog(@"vc.text %@---vcitem.text%@",vc.text, vcitem.text);
                    vcitem.flag = YES;
                }
            }
            cell.detailsModel = vcitem;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击了第一个tableview对应更新第二个tabview的cell个数
    if (tableView == self.firsttableView ) {
        if (indexPath.row == 0) {//点击了区域
            self.menuItem = ChooseMoreMenuItemArea;
        }
        else if (indexPath.row == 1) {//点击了地铁
            self.menuItem = ChooseMoreMenuItemSubways;
        }
        self.firsttableView.sd_layout.widthIs(SCREEN_WIDTH*0.5);
        self.sectiondtableView.sd_layout.widthIs(SCREEN_WIDTH*0.5);
        [self.sectiondtableView reloadData];
    }
    
    if (tableView == self.sectiondtableView ) {
        if (self.menuItem == ChooseMoreMenuItemArea) {
            [self.listAreasArray removeAllObjects];
            ChooseAreasChidren *dic = self.baseAreaArray[indexPath.row];
            NSLog(@"区域%@",dic.text);//选中的区域二级
            self.selectStr = dic.text;
            NSArray *arrayDetail = dic.children;
            for (int jk = 0; jk<arrayDetail.count; jk++) {
                NSDictionary *dic = arrayDetail[jk];
                Details *dv = [[Details alloc] init];
                dv.text = dic[@"text"];
                dv.flag = NO;
                [self.listAreasArray addObject:dv];
            }
        }
        if (self.menuItem == ChooseMoreMenuItemSubways) {
            [self.listSunArray removeAllObjects];
            ChooseAreasChidren *dic = self.baseSubArray[indexPath.row];
            NSLog(@"地铁%@",dic.text);//选中的地铁二级
            self.selectSubStr = dic.text;
            NSArray *arrayDetail = dic.children;
            for (int jk = 0; jk<arrayDetail.count; jk++) {
                NSDictionary *dic = arrayDetail[jk];
                Details *dv = [[Details alloc] init];
                dv.text = dic[@"text"];
                dv.flag = NO;
                [self.listSunArray addObject:dv];
            }
        }
        self.firsttableView.sd_layout.widthIs(SCREEN_WIDTH*0.33);
        self.sectiondtableView.sd_layout.widthIs(SCREEN_WIDTH*0.33);
        [self.threetableView reloadData];
    }
    
    if (tableView == self.threetableView) {
        
        if (self.menuItem == ChooseMoreMenuItemArea) {//区域
            Details *model =self.listAreasArray[indexPath.row];
            [self updateSelectedItemListWithItem:model chooseTyep:ChooseMoreMenuItemArea  and:self.selectStr];
        }
        if (self.menuItem == ChooseMoreMenuItemSubways) {//地铁
            Details *model =self.listSunArray[indexPath.row];
            [self updateSelectedItemListWithItem:model chooseTyep:ChooseMoreMenuItemSubways and:self.selectSubStr];
            
        }
        
    }
    
}

#pragma mark - 处理第三级数据是否点击
- (void)updateSelectedItemListWithItem:(Details*)model chooseTyep:(ChooseMoreMenuItem)menType and:(NSString*)seleString{
    NSLog(@"seleString---->%@",seleString);
    model.flag = !model.flag;
    //加入ChooseMoreMenuItem区分点击的类型是区域还是地铁
    if (menType == ChooseMoreMenuItemArea) {//区域
        if (model.flag) {//选中
            if ((self.selectedAreasArray.count +self.selectedSubArray.count)>=5 ) {
                model.flag = NO;
                [SVProgressHUD showErrorWithStatus:@"最多只能选择5个"];
                return;
            }
            [self.selectedAreasArray addObject:model];
            [self.selectedSectondAreasArray addObject:seleString];
        } else {//取消
            
            NSMutableArray * tempArray = self.selectedAreasArray;
            NSMutableArray * tempAreasArray = self.selectedSectondAreasArray;
            
            [tempArray mutableCopy];
            [tempAreasArray mutableCopy];
            
            for (int i=0; i<tempArray.count; i++) {
                Details * tempModel = tempArray[i];
                if ([tempModel.text isEqualToString:model.text]) {
                    [tempArray removeObject:tempModel];
                    [tempAreasArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.selectedAreasArray = tempArray;
            self.selectedSectondAreasArray = tempAreasArray;
        }
        NSLog(@"区域-----%@---------------->%@",self.selectedAreasArray,self.selectedSectondAreasArray);
    }
    else{//选择地铁
        if (model.flag) {//选中
            if ((self.selectedAreasArray.count +self.selectedSubArray.count)>=5 ) {
                model.flag = NO;
                [SVProgressHUD showErrorWithStatus:@"最多只能选择5个"];
                return;
            }
            [self.selectedSubArray addObject:model];
            [self.selectedSectondSubArray addObject:seleString];
            
        } else {//取消
            NSMutableArray * tempArray = self.selectedSubArray;
            [tempArray mutableCopy];
            NSMutableArray * tempSubArray = self.selectedSectondSubArray;
            [tempSubArray mutableCopy];
            
            for (int i=0; i<tempArray.count; i++) {
                Details * tempModel = tempArray[i];
                if ([tempModel.text isEqualToString:model.text]) {
                    [tempArray removeObject:tempModel];
                    [tempSubArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.selectedSubArray = tempArray;
            self.selectedSectondSubArray = tempSubArray;
        }
        NSLog(@"地铁----------%@--------------->%@",self.selectedSubArray,self.selectedSectondSubArray);
    }
    [self.threetableView reloadData];
}

#pragma mark - 点击了背景
-(void)picDetail:(UITapGestureRecognizer *)tap{
    if (self.didRemoveFromSuperViewHandle) {
        self.didRemoveFromSuperViewHandle();
    }
}
#pragma mark da数据
- (NSMutableArray *)baseArray {
    if (_baseArray == nil) {
        _baseArray = [NSMutableArray array];
    }
    return _baseArray;
}
#pragma mark 第一个tab元数据
- (NSMutableArray *)baseSecondArray {
    if (_baseSecondArray == nil) {
        _baseSecondArray = [NSMutableArray array];
    }
    return _baseSecondArray;
}
#pragma mark 区域二级初始数据
- (NSMutableArray *)baseAreaArray {
    if (_baseAreaArray == nil) {
        _baseAreaArray = [NSMutableArray array];
    }
    return _baseAreaArray;
}
#pragma mark 地铁二级初始数据
- (NSMutableArray *)baseSubArray {
    if (_baseSubArray == nil) {
        _baseSubArray = [NSMutableArray array];
    }
    return _baseSubArray;
}

#pragma mark 区域三级初始数据
- (NSMutableArray *)listAreasArray {
    if (_listAreasArray == nil) {
        _listAreasArray = [NSMutableArray array];
    }
    return _listAreasArray;
}
#pragma mark 地铁三级初始数据
- (NSMutableArray *)listSunArray {
    if (_listSunArray == nil) {
        _listSunArray = [NSMutableArray array];
    }
    return _listSunArray;
}
#pragma mark 选中的区域
/**选中的区域*/
- (NSMutableArray *)selectedSectondAreasArray {
    if (_selectedSectondAreasArray == nil) {
        _selectedSectondAreasArray = [NSMutableArray array];
    }
    return _selectedSectondAreasArray;
}
/**选中的区域*/
- (NSMutableArray *)selectedAreasArray {
    if (_selectedAreasArray == nil) {
        _selectedAreasArray = [NSMutableArray array];
    }
    return _selectedAreasArray;
}
#pragma mark 选中的地铁
/**选中的地铁*/
- (NSMutableArray *)selectedSubArray {
    if (_selectedSubArray == nil) {
        _selectedSubArray = [NSMutableArray array];
    }
    return _selectedSubArray;
}
/**选中的地铁*/
- (NSMutableArray *)selectedSectondSubArray {
    if (_selectedSectondSubArray == nil) {
        _selectedSectondSubArray = [NSMutableArray array];
    }
    return _selectedSectondSubArray;
}
@end
