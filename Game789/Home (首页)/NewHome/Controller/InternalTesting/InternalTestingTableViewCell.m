//
//  InternalTestingTableViewCell.m
//  Game789
//
//  Created by maiyou on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "InternalTestingTableViewCell.h"
#import "TestingAPI.h"

@interface InternalTestingTableViewCell ()

@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * gamename;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property(nonatomic,weak)IBOutlet UILabel * number;
@property(nonatomic,weak)IBOutlet UIButton * join;
@property(nonatomic,weak)IBOutlet UIView * giftView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * contentHeight;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * content1Height;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * content2Height;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * content3Height;

@property(nonatomic,strong)CAGradientLayer * gradient1;
@property(nonatomic,strong)CAGradientLayer * gradient2;
@property(nonatomic,strong)CAGradientLayer * gradient3;

@end

@implementation InternalTestingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gradient1 = [CAGradientLayer layer];
    self.gradient1.startPoint = CGPointMake(0.5, 0);
    self.gradient1.endPoint = CGPointMake(0.5, 1);
    self.gradient1.cornerRadius = 12.5;
    self.gradient2 = [CAGradientLayer layer];
    self.gradient2.startPoint = CGPointMake(0.5, 0);
    self.gradient2.endPoint = CGPointMake(0.5, 1);
    self.gradient2.cornerRadius = 12.5;

    self.gradient3 = [CAGradientLayer layer];
    self.gradient3.startPoint = CGPointMake(0.5, 0);
    self.gradient3.endPoint = CGPointMake(0.5, 1);
    self.gradient3.cornerRadius = 12.5;


}

- (void)setModel:(GameModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.game_image[@"thumb"]] placeholderImage:MYGetImage(@"game_icon")];
    self.gamename.text = model.game_name;
    NSString * game_classify_type = [model.game_classify_type substringFromIndex:1];
    self.desc.text = [NSString stringWithFormat:@"%@｜%@人在玩",game_classify_type,model.howManyPlay];
    self.number.text = model.bate_test_total;
    self.contentHeight.constant = model.bate_list.count * 92;
    [self.join setImage:[UIImage imageNamed:model.bate_has_joined ? @"test_join" : @"add_test"] forState:UIControlStateNormal];
    self.content1Height.constant = 0;
    self.content2Height.constant = 0;
    self.content3Height.constant = 0;

    for (int i=0; i<model.bate_list.count; i++) {
        NSDictionary * item = model.bate_list[i];
        NSString * type = item[@"type"];
        if ([type isEqualToString:@"welfare"]) {
            [self setData:item tag:10];
            self.content1Height.constant = 87;
        }else if([type isEqualToString:@"voucher"]){
            [self setData:item tag:11];
            self.content2Height.constant = 87;
        }else if([type isEqualToString:@"gift"]){
            [self setData:item tag:12];
            self.content3Height.constant = 87;
        }
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:model.nameRemark];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", model.nameRemark];
    self.nameRemark.hidden = isNameRemark;
}

- (void)setData:(NSDictionary *)item tag:(NSInteger)tag{
    UIView * view = [self.giftView viewWithTag:tag];
    UILabel * title = [view viewWithTag:100];
    UILabel * desc = [view viewWithTag:200];
    UIImageView * imageView = [view viewWithTag:300];
    UIImageView * icon = [view viewWithTag:400];
    UIButton * button = [view viewWithTag:500];
    
    if (tag == 10) {
        if (![item[@"is_received"] boolValue]) {
            self.gradient1.colors = @[(id)[UIColor colorWithHexString:@"#FFB658"].CGColor,(id)[UIColor colorWithHexString:@"#F85320"].CGColor];
            [button setTitle:@"领取" forState:UIControlStateNormal];
        }else{
            self.gradient1.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
            [button setTitle:@"已领" forState:UIControlStateNormal];
        }
        self.gradient1.frame = button.bounds;
        [button.layer insertSublayer:self.gradient1 atIndex:0];
    }else if (tag == 11){
        if (![item[@"is_received"] boolValue]) {
            self.gradient2.colors = @[(id)[UIColor colorWithHexString:@"#FFB658"].CGColor,(id)[UIColor colorWithHexString:@"#F85320"].CGColor];
            [button setTitle:@"领取" forState:UIControlStateNormal];
        }else{
            self.gradient2.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
            [button setTitle:@"已领" forState:UIControlStateNormal];
        }
        self.gradient2.frame = button.bounds;
        [button.layer insertSublayer:self.gradient2 atIndex:0];
    }else if (tag == 12){
        if (![item[@"is_received"] boolValue]) {
            self.gradient3.colors = @[(id)[UIColor colorWithHexString:@"#FFB658"].CGColor,(id)[UIColor colorWithHexString:@"#F85320"].CGColor];
            [button setTitle:@"领取" forState:UIControlStateNormal];
        }else{
            self.gradient3.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
            [button setTitle:@"已领" forState:UIControlStateNormal];
        }
        self.gradient3.frame = button.bounds;
        [button.layer insertSublayer:self.gradient3 atIndex:0];
    }
    
    icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_icon%ld",tag]];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"testing_%ld",tag]];
    desc.text = item[@"content"];
    title.text = tag == 10 ? @"内测员福利" : (tag == 11 ? @"内测员专属券" : @"内测员特权礼包");
    
}

- (IBAction)receiveAction:(UIButton *)sender{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    if (!self.model.bate_has_joined) {
        [MBProgressHUD showToast:@"请先点击加入内测员" toView:YYToolModel.getCurrentVC.view];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"已领"]) {
        [MBProgressHUD showToast:@"您已领取过" toView:YYToolModel.getCurrentVC.view];
        return;
    }
    NSInteger tag = [[sender superview] superview].tag;
    JoinTestingAPI * api = [[JoinTestingAPI alloc] init];
    api.type = tag == 10 ? @"welfare" : (tag == 11 ? @"voucher" : @"gift");
    api.isShow = true;
    if (tag == 12) {
        NSArray * giftArray = [self.model.bate_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS[c] 'gift'",@"type"]];
        api.packid = [NSString stringWithFormat:@"%@",giftArray[0][@"packid"]];
    }
    api.maiyou_gameid = self.model.maiyou_gameid;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            if (tag == 10) {
                self.gradient1.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
            }else if (tag == 11){
                self.gradient2.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
                [MBProgressHUD showToast:@"领取成功，可前往我的代金券处查看" toView:YYToolModel.getCurrentVC.view];
            }else{
                self.gradient3.colors = @[(id)[UIColor colorWithHexString:@"#D8D8D8"].CGColor,(id)[UIColor colorWithHexString:@"#AEAEAE"].CGColor];
                [MBProgressHUD showToast:@"领取成功，可前往我的礼包处查看" toView:YYToolModel.getCurrentVC.view];
            }
            [sender setTitle:@"已领" forState:UIControlStateNormal];
            NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithDictionary:self.model.bate_list[tag-10]];
            [data setValue:@"1" forKey:@"is_received"];
            NSMutableArray * array = [[NSMutableArray alloc] initWithArray:self.model.bate_list];
            [array replaceObjectAtIndex:tag-10 withObject:data];
            self.model.bate_list = array;
            self.model.bate_has_joined = true;
            [self.join setImage:[UIImage imageNamed:self.model.bate_has_joined ? @"test_join" : @"add_test"] forState:UIControlStateNormal];
        }else{
            [MBProgressHUD showToast:request.error_desc toView:YYToolModel.getCurrentVC.view];

        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:YYToolModel.getCurrentVC.view];

    }];
}

- (IBAction)joinAction:(id)sender{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    if (self.model.bate_has_joined) {
        GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
        detail.maiyou_gameid = self.model.maiyou_gameid;
        [YYToolModel.getCurrentVC.navigationController pushViewController:detail animated:true];
        return;
    }
    [MyAOPManager relateStatistic:@"ClickToBeInternalTestPeople" Info:@{@"game_name":self.model.game_name}];
    JoinTestingAPI * api = [[JoinTestingAPI alloc] init];
    api.type = @"add";
    api.isShow = true;
    api.maiyou_gameid = self.model.maiyou_gameid;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
//        self.model.bate_test_total = [NSString stringWithFormat:@"%d",[self.model.bate_test_total intValue] + 1];
//        self.number.text = self.model.bate_test_total;
//        self.model.bate_has_joined = true;
//        [self.join setImage:[UIImage imageNamed:self.model.bate_has_joined ? @"test_join" : @"add_test"] forState:UIControlStateNormal];
        if (request.success) {
            JoinTestingAPI * api = [[JoinTestingAPI alloc] init];
            api.type = @"welfare";
            api.isShow = true;
            api.maiyou_gameid = self.model.maiyou_gameid;
            [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTetingData" object:nil];
            } failureBlock:^(BaseRequest * _Nonnull request) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTetingData" object:nil];
            }];
        }else{
            [MBProgressHUD showToast:request.error_desc toView:YYToolModel.getCurrentVC.view];

        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:YYToolModel.getCurrentVC.view];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
