//
//  DetailsTableViewCell.m
//  ScreeningMoreTag
//
//  Created by 韩新辉 on 2017/12/24.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "SDAutoLayout.h"
#import "Details.h"



@interface DetailsTableViewCell()
@property (strong, nonatomic) UILabel *nameLabel;/**<标题*/
@property (strong, nonatomic) UIImageView *chooseImgView;/**<选中图片*/

@end

@implementation DetailsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.45];
        [self creatSeekCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatSeekCell{
    //名字
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.45];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout.
    leftSpaceToView(self.contentView,15).
    centerYEqualToView(self.contentView).widthIs(25).heightIs(25);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //图片
    self.chooseImgView = [[UIImageView alloc] init];
    self.chooseImgView.image = [UIImage imageNamed:@"choose"];
    [self.chooseImgView setContentMode:UIViewContentModeScaleToFill];
    [self.contentView addSubview:self.chooseImgView];
    self.chooseImgView.sd_layout.
    leftSpaceToView(self.nameLabel,3).
    centerYEqualToView(self.contentView).widthIs(10).heightIs(10);
    
    
}
-(void)setDetailsModel:(Details *)detailsModel{
    _detailsModel = detailsModel;
    self.nameLabel.text = detailsModel.text;
    [self clickSelectItem:detailsModel.flag];
}

- (void)clickSelectItem:(BOOL)selected {
    if (selected) {
        self.nameLabel.textColor = [UIColor orangeColor];
        self.chooseImgView.hidden = NO;
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.chooseImgView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
