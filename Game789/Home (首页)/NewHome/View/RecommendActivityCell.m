//
//  RecommendActivityCell.m
//  Game789
//
//  Created by maiyou on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RecommendActivityCell.h"
#import "HGShowGameGiftCell.h"
#import "RecommendCommentCell.h"
#import "MyVoucherListModel.h"
#import "MyGetVoucherListApi.h"

@interface RecommendActivityCell ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UIImageView * backImageView;
@property(nonatomic,strong)NSArray * voucherArray;
@property(nonatomic,strong)UIView * headerView;

@end

@implementation RecommendActivityCell

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 65)];
        _headerView.backgroundColor = UIColor.whiteColor;
    }
    return _headerView;
}

/// 领取代金券
/// @param btn 按钮
- (void)receivedVoucher:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    MyVoucherListModel * model = self.voucherArray[btn.tag-10];
    if (![YYToolModel isAlreadyLogin]) return;
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    if ([YYToolModel isBlankString:dic[@"mobile"]])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
//            [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
//        });
////        [self dismissViewControllerAnimated:YES completion:nil];
//        [MBProgressHUD showToast:@"请先绑定手机号"];
//        return;
//    }
//    if (model.is_received.boolValue) return;
    
    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
    api.voucher_id = model.Id;
    api.game_id = model.game_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
     {
         if (api.success == 1)
         {
//             [MyAOPManager gameRelateStatistic:@"ClickToGetCashCoupon" GameInfo:self.dataDic[@"game_info"] Add:@{}];
             if (![request.data[@"hasSome"] boolValue])
             {
                 model.is_received = @"1";
                 btn.selected = YES;
             }
             else
             {
                 [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
             }
         }
         else
         {
             [MBProgressHUD showToast:api.error_desc toView:self];
         }
     } failureBlock:^(BaseRequest * _Nonnull request) {
         
     }];
}

/// 单个代金券按钮
/// @param data 按钮
- (UIView *)voucherWithData:(MyVoucherListModel *)data
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.voucherArray.count <= 3 ? (ScreenWidth-30-30)/3-10 : (ScreenWidth-30-45)/3-10, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"voucher_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"voucher_selected"] forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = false;
    button.selected = [data.is_received boolValue];
    [button addTarget:self action:@selector(receivedVoucher:) forControlEvents:UIControlEventTouchUpInside];
//    button.userInteractionEnabled = NO;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"领\n取";
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:10];
    label.numberOfLines = 0;
    label.textAlignment = 1;
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(button);
        make.width.mas_equalTo(button).multipliedBy(0.22);
    }];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descLabel.textColor = UIColor.whiteColor;
    descLabel.textAlignment = 1;
    NSString * type = data.use_type;
    if ([type isEqualToString:@"direct"]) {
        descLabel.text = [NSString stringWithFormat:@"仅限%@元档可用", data.amount];
    }else{
        int meet_amount = [[data.meet_amount stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        if (meet_amount == 0) {
            descLabel.text = @"任意金额可用";
        }else{
            descLabel.text = [NSString stringWithFormat:@"满%@元可用", data.meet_amount];
        }
    }
    descLabel.font = [UIFont systemFontOfSize:9];
    [button addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(label.mas_left);
            make.bottom.mas_equalTo(-9);
            make.height.mas_equalTo(9);
    }];

    NSString * amountString = data.amount;
    CGFloat fontRatio = 0.03;//基线偏移比率
    NSString * amount = [amountString componentsSeparatedByString:@"."].firstObject;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",amountString]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22 weight:UIFontWeightMedium]} range:NSMakeRange(1, amount.length)];
    [attributedString addAttributes:@{NSBaselineOffsetAttributeName:@(fontRatio * (22-10))} range:NSMakeRange(0, 1)];
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.textColor = UIColor.whiteColor;
    priceLabel.textAlignment = 1;
    priceLabel.attributedText = attributedString;
    [button addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(label.mas_left);
        make.bottom.mas_equalTo(descLabel.mas_top);
    }];
    
    return button;
}

- (void)setStyle:(RecommendStyle)style{
    _style = style;
    if (style != RecommendStyleGifs) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.tableView.tableHeaderView = header;
    }
}

- (void)setVoucherslist:(NSArray *)voucherslist{
    _voucherslist = voucherslist;
    if (voucherslist.count == 0) {
        return;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
    if (!_headerView) {
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * dic in voucherslist)
        {
            MyVoucherListModel * voucherModel = [[MyVoucherListModel alloc] initWithDictionary:dic];
            [array addObject:voucherModel];
        }
        self.voucherArray = array;
        if (self.voucherArray.count > 0) {
            UIScrollView * scrollView = [[UIScrollView alloc] init];
            if (self.voucherArray.count > 3) {
                scrollView.frame = CGRectMake(15, 0, ScreenWidth-30-30-25, 50);
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWidth-30-30, 0, 15, scrollView.height);
                [button setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(moreVouchersClick) forControlEvents:UIControlEventTouchUpInside];
                [self.headerView addSubview:button];
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreVouchersClick)];
                [scrollView addGestureRecognizer:tap];
            }
            else
            {
                scrollView.frame = CGRectMake(15, 0, ScreenWidth-30-30, 50);
            }
            scrollView.showsHorizontalScrollIndicator = false;
            [self.headerView addSubview:scrollView];
            
            for (int i=0; i<self.voucherArray.count; i++)
            {
                UIView * view = [self voucherWithData:self.voucherArray[i]];
                view.tag = i+10;
                view.frame = CGRectMake((view.width+10)*i, 0, view.width, view.height);
                view.backgroundColor = BackColor;
                [scrollView addSubview:view];
            }
            scrollView.contentSize = CGSizeMake(self.voucherArray.count * (ScreenWidth-30-30-20)/3, 0);
            
            self.headerView.frame = CGRectMake(0, 0, ScreenWidth-30, 65);
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, 0, 1);
        }
    }
    self.tableView.tableHeaderView = self.headerView;
}

- (void)moreVouchersClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTuGameDetail" object:nil];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * image = self.backImageView.image;
    CGFloat top = image.size.height/2;
    CGFloat left = image.size.width/2;
    CGFloat bottom = image.size.height/2;
    CGFloat right = image.size.width/2;
    self.backImageView.image  = [self.backImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendActivityCell" bundle:nil] forCellReuseIdentifier:@"RecommendActivityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGShowGameGiftCell" bundle:nil] forCellReuseIdentifier:@"HGShowGameGiftCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCommentCell" bundle:nil] forCellReuseIdentifier:@"RecommendCommentCell"];
    
}

- (IBAction)gameDetail:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTuGameDetail" object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == RecommendStyleActivity){
        static NSString * cellIdentifity = @"RecommendStyleActivityCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifity];
        }
        NSDictionary * obj = self.dataArray[indexPath.section];
        cell.textLabel.text = obj[@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.style == RecommendStyleGifs){
        static NSString *reuseID = @"HGShowGameGiftCell";
        HGShowGameGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.dataDic = self.dataArray[indexPath.section];
//        cell.receiveGiftAction = ^(NSString * _Nonnull giftId) {
//            self.isCellBtnReceive = YES;
//            self.giftSelectedIndex = indexPath.row;
//            [self receiveGift:giftId];
//        };
        cell.roundeView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        cell.giftCodeView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        cell.vc = self.vc;
        cell.contentView.backgroundColor = UIColor.whiteColor;
        return cell;
    }else if (self.style == RecommendStyleComment){
        RecommendCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCommentCell" forIndexPath:indexPath];
        cell.data = self.dataArray[indexPath.section];
        return cell;
    }
    else{
        RecommendActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTextCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == RecommendStyleActivity) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTuGameDetail" object:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == RecommendStyleActivity) {
        return 28;
    }else if (self.style == RecommendStyleGifs) {
        return 99;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.style == RecommendStyleComment && section < self.dataArray.count-1) {
        return 15;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
