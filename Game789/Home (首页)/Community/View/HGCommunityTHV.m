//
//  HGCommunityTHV.m
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGCommunityTHV.h"
#import "HGCOmmunityChatListVC.h"
#import "HGCommunityCollCell.h"

@interface HGCommunityTHV ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *upView;  //最上边推荐群聊的backView
@property (weak, nonatomic) IBOutlet UIView *collectBackView;
@property (nonatomic, strong) UICollectionView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *tagBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagBackViewHeight;
@property (nonatomic, strong) NSMutableArray *groupArray;

@end

@implementation HGCommunityTHV
- (UICollectionView *)scrollView {
    if (!_scrollView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(278, 124);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        _scrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.collectBackView.width, self.collectBackView.height) collectionViewLayout:layout];
        [_scrollView registerClass:[HGCommunityCollCell class] forCellWithReuseIdentifier:@"cell"];
        _scrollView.contentInset = UIEdgeInsetsMake(0, 15, 0, 45);
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGCommunityTHV" owner:self options:nil].firstObject;
        self.frame = frame;
        
//        [self prepareBaisc];

    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSMutableArray *themeArray = [NSMutableArray array];
    NSArray *themelistArray = dataDic[@"list"];
    //游戏圈子数据
    for (NSDictionary *dic in themelistArray) {
        [themeArray addObject:dic[@"themename"]];
    }
    
    NSArray *tempArray = dataDic[@"grouplist"];
    self.groupArray = [[NSMutableArray alloc]initWithArray:tempArray];
    [self prepareBaisc:themeArray];
}

- (void)prepareBaisc:(NSArray *)themeArray{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatListAction)];
    [self.upView addGestureRecognizer:tap];
    
    [self.collectBackView addSubview:self.scrollView];

    [self.tagBackView addSubview:[self tagView:themeArray]];
    self.view_height = 20 + 22 + self.tagBackViewHeight.constant ;
}


//标签action
- (void)BtnClick:(UIButton *)sender {
    NSDictionary * tagItem = self.dataDic[@"list"][sender.tag-100];
    NSLog(@"tagItem=%@",tagItem);
    if (self.delegate && [self.delegate respondsToSelector:@selector(community:didSelectedItem:)]) {
        [self.delegate community:self didSelectedItem:tagItem];
    }
}

//跳转群聊
- (void)chatListAction
{
    HGCOmmunityChatListVC* info = [HGCOmmunityChatListVC new];
    info.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
}

- (void)joinChat:(NSDictionary *)dic {
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
//    [YYBaseApi yy_Post:Post_GroupAddUser parameters:@{@"id":dic[@"groupid"]} swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//        NSInteger errorCode = resultObject[@"success"];
//        self.chatRoomInfoModel = [SC_ChatRoomInfoModel mj_objectWithKeyValues:dic];
//        self.chatRoomInfoModel.roomNotify = dic[@"roomNotify"];
//        self.chatRoomInfoModel.roomRule = dic[@"roomRule"];
//
//        EMChatViewController *vc = [[EMChatViewController alloc] initWithConversationId:self.chatRoomInfoModel.easemobgroupid type:EMConversationTypeGroupChat createIfNotExist:YES];
//        vc.fromVC = @"HGCommunityTHV";
//        vc.chatRoomInfoModel = self.chatRoomInfoModel;
//        vc.chatRoomName = self.chatRoomInfoModel.name;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//    } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//    } Hud:YES];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.groupArray[indexPath.row];
    [self joinChat:dic];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGCommunityCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = self.groupArray[indexPath.row];
    cell.dataDic = dic;
    return cell;
}

- (UIView *)tagView:(NSArray *)array {
    UIView *tempView = [[UIView alloc]init];
    for (int i = 0; i < array.count; i ++) {
        NSString *name = [NSString stringWithFormat:@"#%@#",array[i]];
        static UIButton *recordBtn = nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width -30, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        CGFloat BtnW = rect.size.width + 16;
        CGFloat BtnH = rect.size.height + 8;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = BtnH/2;
        if (i == 0) {
            btn.frame =CGRectMake(0, 0, BtnW, BtnH);
        } else{
            CGFloat yuWidth = self.frame.size.width - 30 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+7, BtnW, BtnH);
            }
        }
        btn.backgroundColor = MAIN_COLOR;
        [btn setTitleColor:ColorWhite forState:UIControlStateNormal];
        [btn setTitle:name forState:UIControlStateNormal];
        [tempView addSubview:btn];
        NSLog(@"btn.frame.origin.y  %f", btn.frame.origin.y);
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30,CGRectGetMaxY(btn.frame)+15);
        recordBtn = btn;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == array.count - 1) {
            tempView.frame = CGRectMake(0, 20, kScreenW - 30, btn.y + btn.height + 20);
            self.tagBackViewHeight.constant = tempView.height + 20;
        }
    }
    return tempView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
