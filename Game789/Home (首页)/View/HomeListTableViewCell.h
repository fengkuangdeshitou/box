//
//  HomeListTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol HomeListTableViewCellDelegate <NSObject>


@end

@interface HomeListTableViewCell : BaseTableViewCell
// 1:热门推荐；2：排行榜；3：新游榜; 4：转移充值 5：首页b面专题游戏下载 6:今日首发 7:搜索 8：一周top10; 999:cell底部加10
@property (nonatomic , copy)NSString * listType;
@property (nonatomic , strong)NSIndexPath * indexPath;
/**  10今日开服；20即将开服；30历史开服，需要显示开服时间  */
@property (nonatomic , copy) NSString * kaifuType;
@property (weak, nonatomic) IBOutlet UILabel *rankIndext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankIndex_right;

@property (weak, nonatomic) id <HomeListTableViewCellDelegate> delegate;
// 下载按钮点击事件
@property (nonatomic, copy) void(^downloadBtnClick)(NSDictionary *dic);
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)loadProjectColor;

@end
