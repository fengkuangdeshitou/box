//
//  UserPersonalCenterView.m
//  Game789
//
//  Created by Maiyou on 2018/10/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "UserPersonalCenterView.h"

@interface UserPersonalCenterView ()

@property(nonatomic,strong)UIView * flagView;

@end

@implementation UserPersonalCenterView

- (UIView *)flagView{
    if (!_flagView) {
        _flagView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4-9, 34, 18, 3)];
        _flagView.backgroundColor = [UIColor whiteColor];
        _flagView.layer.cornerRadius = 1.5;
    }
    return _flagView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"UserPersonalCenterView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.user_icon.layer.borderColor = [UIColor colorWithHexString:@"#FAA520"].CGColor;
        self.user_icon.layer.borderWidth = 2;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewOriginImage)];
        [self.user_icon addGestureRecognizer:tap];
        
        if (!IS_IPhoneX_All)
        {
            self.userIcon_height.constant = 80;
        }
        
        [self exchangeSelectButton:[self viewWithTag:10]];
        
    }
    return self;
}

- (IBAction)exchangeSelectButton:(UIButton *)sender{
    ((UIButton *)[self viewWithTag:10]).titleLabel.font = [UIFont systemFontOfSize:15];
    ((UIButton *)[self viewWithTag:11]).titleLabel.font = [UIFont systemFontOfSize:15];
    sender.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [sender addSubview:self.flagView];
    if (self.exchangeButtonBlock) {
        self.exchangeButtonBlock(sender.tag-10);
    }
}

- (void)didselectedIndex:(NSInteger)index{
    [self exchangeSelectButton:[self viewWithTag:10+index]];
}

- (void)viewOriginImage
{
    NSMutableArray * imageArray = [NSMutableArray array];
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:self.dataDic[@"user_avatar"]];
    data.projectiveView = self.user_icon;
    data.allowSaveToPhotoAlbum = NO;
    [imageArray addObject:data];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = imageArray;
    browser.currentPage = 0;
    [browser show];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:dataDic[@"user_logo"]]];
    
    CGSize size = [YYToolModel sizeWithText:dataDic[@"nick_name"] size:CGSizeMake(MAXFLOAT, 25) font:self.user_name.font];
    self.backView_width.constant = size.width + 45 + 8;
    self.user_name.text     = dataDic[@"nick_name"];
    
    self.comment_count.text = [dataDic[@"reward_intergral_amount"] isEqualToString:@""] ? @"0金币".localized : [NSString stringWithFormat:@"%@%@", dataDic[@"reward_intergral_amount"], @"金币".localized];
    
    self.like_count.text    = [dataDic[@"like_count"] isEqualToString:@""] ? @"0次".localized : [NSString stringWithFormat:@"%@%@", dataDic[@"like_count"], @"次".localized];
    
    if ([dataDic[@"user_level"] length] > 0)
    {
        self.memberLevelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", [dataDic[@"user_level"] intValue]]];
        self.memberMark.hidden = NO;
        self.memberLevelImage.hidden = NO;
        self.memberMark.image = [UIImage imageNamed:@"hg_icon"];
        if ([dataDic[@"user_level"] intValue] == 0)
        {
            self.memberMark.hidden = YES;
        }
    }
    else
    {
        self.memberMark.hidden = YES;
        self.memberLevelImage.hidden = YES;
    }
}

@end
