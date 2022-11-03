//
//  GameModel.m
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (NSArray *)game_classify_typeArray{
    if ([self.game_classify_type containsString:@" "]) {
        if ([self.game_classify_type hasPrefix:@" "]) {
            self.game_classify_type = [self.game_classify_type substringFromIndex:1];
        }
        return [self.game_classify_type componentsSeparatedByString:@" "];
    }else{
        if (self.game_classify_type.length > 0) {
            return @[self.game_classify_type];
        }else{
            return @[];
        }
    }
}

- (CGFloat)cellHeight{
    CGFloat gameNameHeight = 0;
    CGFloat discountx = 0;
    CGFloat bottom_lableHeitht = 0;
    CGFloat additional = 0;
    CGFloat ocp_width = 0;
    if (self.listType.intValue == 7) {
        discountx = ScreenWidth-15-5;
    }
    else
    {
        if (self.game_species_type.intValue == 2) {
            discountx = ScreenWidth-15-53-5;
        }else{
            discountx = ScreenWidth-15-5;
        }
    }
    
//    BOOL is_ocp = [self.is_ocp boolValue];
//    if (is_ocp){
//        ocp_width = 69 + 5;
//    }
    
    if (self.top_lable.length == 0) {
        gameNameHeight = [self.game_name boundingRectWithSize:CGSizeMake(discountx-ocp_width-123, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }else{
        gameNameHeight = [[NSString stringWithFormat:@"%@%@",self.top_lable,self.game_name] boundingRectWithSize:CGSizeMake(discountx-ocp_width-123, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }
    if (self.bottom_lable.count > 0) {
        bottom_lableHeitht = 16;
    }
    if (self.top_lable.length > 0 && self.bottom_lable.count > 0) {
        additional = 5;
    }
    CGFloat totalHeight = gameNameHeight+5.5+14+14+6.5+bottom_lableHeitht < 80 ? 80 : gameNameHeight+5.5+14+14+6.5+bottom_lableHeitht + additional;
    return totalHeight;
}

- (CGFloat)hallCellHeight{
    CGFloat gameNameHeight = 0;
    CGFloat discountx = 0;
    CGFloat bottom_lableHeitht = 0;
    CGFloat additional = 0;
    if (self.game_species_type.intValue == 2) {
        discountx = ScreenWidth-15-53-5;
    }else{
        discountx = ScreenWidth-15-5;
    }
    
    if (self.top_lable.length == 0) {
        gameNameHeight = [self.game_name boundingRectWithSize:CGSizeMake(discountx-92-64-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }else{
        gameNameHeight = [[NSString stringWithFormat:@"%@%@",self.top_lable,self.game_name] boundingRectWithSize:CGSizeMake(discountx-92-64-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }
    if (self.bottom_lable.count > 0) {
        bottom_lableHeitht = 16;
    }
    if (self.top_lable.length > 0 && self.bottom_lable.count > 0) {
        additional = 5;
    }
    CGFloat totalHeight = gameNameHeight+5.5+14+14+6.5+bottom_lableHeitht + additional;
    return totalHeight;
}

- (CGFloat)rankingCellHeight{
    CGFloat gameNameHeight = 0;
    CGFloat discountx = 0;
    CGFloat bottom_lableHeitht = 0;
    CGFloat additional = 0;
    CGFloat ranking_width = 20;
    if (self.game_species_type.intValue == 2) {
        discountx = ScreenWidth-15-53-5;
    }else{
        discountx = ScreenWidth-15-5;
    }
    
    if (self.top_lable.length == 0) {
        gameNameHeight = [self.game_name boundingRectWithSize:CGSizeMake(discountx-123-ranking_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }else{
        gameNameHeight = [[NSString stringWithFormat:@"%@%@",self.top_lable,self.game_name] boundingRectWithSize:CGSizeMake(discountx-123-ranking_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]} context:nil].size.height;
    }
    if (self.bottom_lable.count > 0) {
        bottom_lableHeitht = 16;
    }
    if (self.top_lable.length > 0 && self.bottom_lable.count > 0) {
        additional = 5;
    }
    CGFloat totalHeight = gameNameHeight+5.5+14+14+6.5+bottom_lableHeitht < 80 ? 80 : gameNameHeight+5.5+14+14+6.5+bottom_lableHeitht + additional;
    return totalHeight;
}

@end
