//
//  MyBuyVipAlertView.m
//  Game789
//
//  Created by Maiyou001 on 2022/4/8.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyBuyVipAlertView.h"
#import "MyBuyVipCell.h"
#import "PayAlertView.h"
#import "MyBuyInputCollectionViewCell.h"
#import "MyBuyInputAPI.h"

@interface MyBuyVipAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel1;
@property (weak, nonatomic) IBOutlet UILabel *showLabel2;
@property (weak, nonatomic) IBOutlet UILabel *showLabel3;
@property (weak, nonatomic) IBOutlet UILabel *showLabel4;
@property (weak, nonatomic) IBOutlet UILabel *showLabel5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation MyBuyVipAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyBuyVipAlertView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.inputView.layer.cornerRadius = 8;
        self.inputView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        self.inputView.layer.borderWidth = 0.5;
        self.imageView.image = MYGetImage(@"AppIcon60x60");
        self.showName.text = [NSString stringWithFormat:@"%@至尊版", [DeviceInfo shareInstance].appDisplayName];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.receiveBtn.bounds;
        gradient.colors = @[(id)[UIColor colorWithHexString:@"#3A62FF"].CGColor, (id)[UIColor colorWithHexString:@"#559CFF"].CGColor];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1.0);
        [self.receiveBtn.layer addSublayer:gradient];
        self.receiveBtn.layer.masksToBounds = YES;
        self.receiveBtn.layer.cornerRadius = 24.5;
        
        self.indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"MyBuyVipCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyBuyVipCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MyBuyInputCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyBuyInputCollectionViewCell"];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString * lineTips = dataDic[@"lineTips"];
    NSString * showTips = dataDic[@"showTips"];
    
    NSString * text = [NSString stringWithFormat:@"%@%@", lineTips, showTips];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSDictionary * dic = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"], NSFontAttributeName:[UIFont systemFontOfSize:13], NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSDictionary * dic1 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#DC2D2D"], NSFontAttributeName:[UIFont systemFontOfSize:13]};
    
    [str addAttributes:dic range:NSMakeRange(0, lineTips.length)];
    [str addAttributes:dic1 range:NSMakeRange(lineTips.length, showTips.length)];
    
    self.showLabel1.text = dataDic[@"comment1"];
    self.showLabel2.attributedText = str;
    self.showLabel3.text = dataDic[@"comment2"];
    self.showLabel4.text = dataDic[@"bottomTips"];
    self.showLabel5.text = dataDic[@"useDesc"];
    
    
    self.dataArray = dataDic[@"items"];
    [self.collectionView reloadData];

    NSDictionary * dic2 = self.dataArray[self.indexPath.item];
    [self.receiveBtn setTitle:dic2[@"submitButtonTitle"] forState:0];
    
    if (self.dataArray.count < 3)
    {
        self.collectionView_right.constant = (kScreenW - 149 * self.dataArray.count - (self.dataArray.count - 1) * 15) / 2;
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self.vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dataDic = self.dataArray[indexPath.item];
    if([dataDic[@"type"] isEqualToString:@"buy"]){
        static NSString *cellIndentifer = @"MyBuyVipCell";
        MyBuyVipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        if (self.indexPath == indexPath)
        {
            cell.layer.borderColor = [UIColor colorWithHexString:@"#E33923"].CGColor;
        }
        else
        {
            cell.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        }
        cell.dataDic = dataDic;
        return cell;
    }else{
        static NSString *cellIndentifer = @"MyBuyInputCollectionViewCell";
        MyBuyInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        if (self.indexPath == indexPath){
            cell.titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#e33923"].CGColor;
        }else{
            cell.titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        }
        cell.titleLabel.layer.borderWidth = 1.5;
        cell.titleLabel.text = dataDic[@"buttonTitle"];
        return cell;
    }
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(149, 140);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    NSDictionary * dic2 = self.dataArray[indexPath.item];
    [self.receiveBtn setTitle:dic2[@"submitButtonTitle"] forState:0];
    [collectionView reloadData];
    if(indexPath.row == 2){
        self.inputHeight.constant = 44;
    }else{
        self.inputHeight.constant = 0;
    }
//    MyBuyVipCell *cell = (MyBuyVipCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    MyBuyVipCell *cell1 = (MyBuyVipCell *)[collectionView cellForItemAtIndexPath:self.indexPath];
//    if (self.indexPath != indexPath)
//    {
//        cell1.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
//        cell.layer.borderColor = [UIColor colorWithHexString:@"#E33923"].CGColor;
//
//        NSDictionary * dic2 = self.dataArray[indexPath.item];
//        [self.receiveBtn setTitle:dic2[@"submitButtonTitle"] forState:0];
//
//        self.indexPath = indexPath;
//    }
}

- (IBAction)receiveBtnClick:(id)sender
{
    NSDictionary * dic = self.dataArray[self.indexPath.row];
    if([dic[@"type"] isEqualToString:@"code"]){
        if(self.input.text.length == 0){
            return;
        }
        MyBuyInputAPI * api = [[MyBuyInputAPI alloc] init];
        api.input = self.input.text;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if(request.success){
                [NSNotificationCenter.defaultCenter postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
                [self.vc dismissViewControllerAnimated:true completion:^{
                    [MBProgressHUD showToast:@"兑换成功" toView:[YYToolModel getCurrentVC].view];
                }];
            }else{
                [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }];
    }else{
        WEAKSELF
        [self.vc dismissViewControllerAnimated:YES completion:^{
            PayAlertView * webView = [[PayAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            webView.url = [NSString stringWithFormat:@"%@&amount=%@&version=20220408", weakSelf.supremePayUrl, dic[@"price"]];
            [UIApplication.sharedApplication.keyWindow addSubview:webView];
        }];
    }
}

@end
