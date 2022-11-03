//
//  MemberInterestsContentView.m
//  Game789
//
//  Created by maiyou on 2021/9/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemberInterestsContentView.h"
#import "MemeberGiftCollectionViewCell.h"
#import "TransactionViewController.h"
#import "MyCustomerServiceController.h"

#import "AuthAlertView.h"

@interface MemberInterestsContentView ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,AuthAlertViewDelegate>

@property(nonatomic,weak)IBOutlet UIImageView * bgImageView;

@property(nonatomic,weak)IBOutlet UIImageView * imageView;
@property(nonatomic,weak)IBOutlet UILabel * gifDescLabel;

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * levelViewLeftConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * levelViewTopConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * levelViewHeightConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * levelViewBottomConstraint;

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * collectionViewHeight;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * collectionViewTop;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * collectionViewBottom;

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;

@property(nonatomic,weak)IBOutlet UILabel * objectLabel;
@property(nonatomic,weak)IBOutlet UIButton * authButton;

@end

@implementation MemberInterestsContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame = frame;
        [self.collectionView registerNib:[UINib nibWithNibName:@"MemeberGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MemeberGiftCollectionViewCell"];
    }
    return self;
}

- (void)layoutSubviews{
    self.frame = CGRectMake(self.x, self.y, ScreenWidth-60, self.height);
}

- (void)setModel:(MemberInterestsModel *)model{
    _model = model;
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_interests_%ld",model.tag]];
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    self.objectLabel.text = model.object;
    if (model.tag == 2) {
        self.levelViewTopConstraint.constant = 15;
        self.levelViewHeightConstraint.constant = 81;
        self.levelViewBottomConstraint.constant = 10;
        self.imageView.image = [UIImage imageNamed:@"member_level_bg"];
        self.gifDescLabel.hidden = true;
    }else if (model.tag == 3){
        BOOL isVip = [model.data[@"is_vip"] boolValue];
        self.levelViewTopConstraint.constant = 10;
        self.levelViewBottomConstraint.constant = 10;
        if (isVip) {
            self.levelViewHeightConstraint.constant = 66;
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"birthdayVoucher_%@",model.data[@"birthdayVoucherAmount"]]];
            self.gifDescLabel.hidden = true;
            self.levelViewLeftConstraint.constant = self.width/2-136/2;
        }else{
            self.levelViewHeightConstraint.constant = 90;
            self.imageView.image = [UIImage new];
            self.gifDescLabel.hidden = false;
        }
    }else{
        self.levelViewTopConstraint.constant = 0;
        self.levelViewHeightConstraint.constant = 0;
        self.levelViewBottomConstraint.constant = model.desc.length == 0 ? 0 : 8;
    }
    
    if (model.tag == 5) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionViewHeight.constant = 115;
        self.collectionViewTop.constant = 15;
        self.collectionViewBottom.constant = 14;
    }else{
        self.collectionViewTop.constant = 11;
        self.collectionViewHeight.constant = 0;
        self.collectionViewBottom.constant = 0;
    }
    
    if (model.tag == 3) {
        NSDictionary * member = [NSUserDefaults.standardUserDefaults objectForKey:@"member_info"];
        self.authButton.hidden = [[member objectForKey:@"isRealNameAuth"] boolValue];
        [self.authButton setTitle:@"实名认证>" forState:UIControlStateNormal];
    }else if(model.tag == 7){
        self.authButton.hidden = false;
        [self.authButton setTitle:@"低价购买氪金号>" forState:UIControlStateNormal];
    }else if(model.tag == 4){
        self.authButton.hidden = false;
        [self.authButton setTitle:@"联系客服>" forState:UIControlStateNormal];
    }else{
        self.authButton.hidden = true;
    }
    
}

- (void)onAuthSuccess{
    self.authButton.hidden = YES;
}

- (IBAction)authButtonAction:(UIButton *)sender{
    if ([sender.titleLabel.text hasPrefix:@"实名认证"]) {
        [AuthAlertView showAuthAlertViewWithDelegate:self];
    }else if ([sender.titleLabel.text hasPrefix:@"低价购买氪金号"]) {
        TransactionViewController * transaction = [[TransactionViewController alloc] init];
        [[YYToolModel getCurrentVC].navigationController pushViewController:transaction animated:YES];
    }else if ([sender.titleLabel.text hasPrefix:@"联系客服"]) {
        [[YYToolModel getCurrentVC].navigationController pushViewController:[MyCustomerServiceController new] animated:YES];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDismiss)]){
        [self.delegate onDismiss];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemeberGiftCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemeberGiftCollectionViewCell" forIndexPath:indexPath];
    cell.data = self.model.data[@"packs"][indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(102, 115);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 17.5, 0, 17.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.model.data[@"packs"] count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDismiss)]){
        [self.delegate onDismiss];
    }
    
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.maiyou_gameid = self.model.data[@"packs"][indexPath.item][@"maiyouGameid"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
