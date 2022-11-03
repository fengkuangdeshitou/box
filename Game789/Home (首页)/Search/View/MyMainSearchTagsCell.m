//
//  MyMainSearchTagsCell.m
//  Game789
//
//  Created by Maiyou on 2020/12/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyMainSearchTagsCell.h"

@implementation MyMainSearchTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.clipsToBounds = YES;
        self.param =
        TagParam()
        .wSelectMoreSet(NO)
        .wSelectOneSet(YES)
//        .imageNameSet((indexPath.section == 1 && indexPath.row == 0) ? @"search_recommend_icon" : @"")
        .wBackGroundColorSet([UIColor whiteColor])
        .wSelectInnerColorSet([UIColor colorWithHexString:@"#F5F5F5"])
        .wInnerColorSet([UIColor colorWithHexString:@"#F5F5F5"])
        .wSelectColorSet([UIColor colorWithHexString:@"#666666"])
        .wColorSet([UIColor colorWithHexString:@"#666666"])
        .paddingTopSet(15)
        .paddingLeftSet(10)
        .marginTopSet(0)
        .marginBottomSet(0)
        .marginLeftSet(15)
        .marginRightSet(15)
        .btnLeftSet((indexPath.section == 1 && indexPath.row == 0) ? 40 : 20)
        .btnTopSet(12)
        .wRadiusSet(14.3)
        .imagePositionSet(TagImagePositionLeft)
        .wTypeSet(info)
//        .wMasonrySet(^(MASConstraintMaker * _Nonnull make) {
//            make.top.left.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(TagWitdh);
//        })
        .wTapClick(^(NSInteger index,id model,BOOL isSelected)
                   {
            MYLog(@"单点的点击回调 %ld %@", (long)index, model);
            if (self.tagClickBlock)
            {
                self.tagClickBlock(index,model);
            }
        })
        .wMoreTapClick(^(NSArray * _Nonnull indexArr, NSArray * _Nonnull modelArr) {
            MYLog(@"多点的点击回调 %@ %@", indexArr, modelArr);
        });
        NSLog(@"=========");
        self.myTag = [[WMZTags alloc]initConfigureWithModel:self.param withView:self.contentView];
        self.myTag.frame = CGRectMake(0, 0, ScreenWidth, 0);
    }
    return self;
}

- (void)setModel:(NSArray *)model
{
    [super setModel:model];
    
    self.param.wDataSet(model);
    if (self.myTag.tag == 2) {
        self.myTag.imagesArray = @[@"search_recommend_icon",@"search_xin_icon"];
    }
    [self.myTag updateUI];
}

@end
