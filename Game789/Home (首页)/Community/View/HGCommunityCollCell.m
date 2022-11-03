//
//  HGCommunityCollCell.m
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGCommunityCollCell.h"

@interface HGCommunityCollCell ()
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *chatPic;
@property (weak, nonatomic) IBOutlet UILabel *chatTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitleOne;
@property (weak, nonatomic) IBOutlet UILabel *subTitleTwo;
@property (weak, nonatomic) IBOutlet UILabel *subTitleThree;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountOne;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountTwo;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountThree;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountFour;

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, strong) NSMutableArray *peopleNumArray;
@end

@implementation HGCommunityCollCell
- (NSArray *)viewArray {
    if (!_viewArray) {
        _viewArray = @[self.viewOne, self.viewTwo, self.viewThree, self.viewFour];
    }
    return _viewArray;
}
- (NSArray *)labelArray {
    if (!_labelArray) {
        _labelArray = @[self.peopleCountOne, self.peopleCountTwo, self.peopleCountThree, self.peopleCountFour];
    }
    return _labelArray;
}
- (NSMutableArray *)peopleNumArray {
    if (!_peopleNumArray) {
        _peopleNumArray = [NSMutableArray array];
    }
    return _peopleNumArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGCommunityCollCell" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.chatPic yy_setImageWithURL:[NSURL URLWithString:dataDic[@"iconSmall"]] placeholder:MYGetImage(@"placehold_bg_image1")];
    self.chatTitle.text = [NSString stringWithFormat:@"%@", dataDic[@"name"]];
    NSString * labels = dataDic[@"labels"];
    if ([labels rangeOfString:@","].location != NSNotFound) {
        NSArray *lab = [labels componentsSeparatedByString:@","];
        if (lab.count == 1) {
            self.subTitleOne.text = [NSString stringWithFormat:@" %@ ", lab[0]];
            self.subTitleOne.hidden = NO;
            self.subTitleTwo.hidden = YES;
            self.subTitleThree.hidden = YES;
        }else if (lab.count == 2){
            self.subTitleOne.text = [NSString stringWithFormat:@" %@ ", lab[0]];
            self.subTitleTwo.text = [NSString stringWithFormat:@" %@ ", lab[1]];
            self.subTitleOne.hidden = NO;
            self.subTitleTwo.hidden = NO;
            self.subTitleThree.hidden = YES;
        }else{
            self.subTitleOne.text = [NSString stringWithFormat:@" %@ ", lab[0]];
            self.subTitleTwo.text = [NSString stringWithFormat:@" %@ ", lab[1]];
            self.subTitleThree.text = [NSString stringWithFormat:@" %@ ", lab[2]];
            self.subTitleOne.hidden = NO;
            self.subTitleTwo.hidden = NO;
            self.subTitleThree.hidden = NO;
        }
    }else{
        self.subTitleOne.hidden = YES;
        self.subTitleTwo.hidden = YES;
        self.subTitleThree.hidden = YES;
    }
    
    

    
    if(self.peopleNumArray.count >0)[self.peopleNumArray removeAllObjects];
    NSString *numStr = [NSString stringWithFormat:@"%@", dataDic[@"current_number"]];
   NSString *tempStr = @"";
    for (int i = 0; i < numStr.length; i++) {
        tempStr = [numStr substringWithRange:NSMakeRange(i, 1)];
        [self.peopleNumArray addObject:tempStr];
    }
    
    for (int i = 0; i < 4; i++) {
        UIView *tempView = self.viewArray[i];
        UILabel *tempLabel = self.labelArray[i];
        if (i < self.peopleNumArray.count) {
            tempView.hidden = NO;
            tempLabel.text = [NSString stringWithFormat:@"%@", self.peopleNumArray[i]];
        }else {
            tempView.hidden = YES;
        }
    }
    
    UIView *tempView = self.viewArray[self.peopleNumArray.count - 1];
    [self.groupLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_right).offset(7);
    }];
}

- (IBAction)joinChatAction:(id)sender {
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
