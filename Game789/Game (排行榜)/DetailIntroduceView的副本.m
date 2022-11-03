//
//  DetailIntroduceView.m
//  Game789
//
//  Created by xinpenghui on 2017/9/12.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "DetailIntroduceView.h"
#import "macro.h"

@interface DetailIntroduceView ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (assign, nonatomic) CGSize size;

@end

@implementation DetailIntroduceView

- (void)ifExpendBtnHidden:(BOOL)hidden {
    self.expandBtn.hidden = hidden;
}
- (IBAction)expandBtnPress:(id)sender {
    self.expandBtn.selected = !self.expandBtn.selected;
    NSLog(@"expand btn = %d",self.expandBtn.selected);
    CGSize size = [self getLabelSize:self.contentLabel.text];

    UIImage *image = [UIImage imageNamed:@"more_yellow"];
    UIImage *imageNew = [self image:image rotation:UIImageOrientationDown];
    if (self.expandBtn.selected) {
        //重置contentlabel frame

        [self.expandBtn setImage:imageNew forState:UIControlStateNormal];
        [self.expandBtn setTitle:@"收起" forState:UIControlStateNormal];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
        self.expandBtn.frame = CGRectMake(self.expandBtn.frame.origin.x, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+13, self.expandBtn.frame.size.width, self.expandBtn.frame.size.height);
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.expandBtn.frame.size.height+self.expandBtn.frame.origin.y+13);
        NSLog(@"self,viw = %f",self.frame.size.height);

    }
    else {
        [self.expandBtn setImage:image forState:UIControlStateNormal];
        [self.expandBtn setTitle:@"展开" forState:UIControlStateNormal];
        self.contentLabel.numberOfLines = 2;
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, 30);
        self.expandBtn.frame = CGRectMake(self.expandBtn.frame.origin.x, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+13, self.expandBtn.frame.size.width, self.expandBtn.frame.size.height);
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.expandBtn.frame.size.height+self.expandBtn.frame.origin.y+13);


    }

    [self.delegate expandPress:self.expandBtn.selected withHeight:self.frame.size.height];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;

    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);

    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);

    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();

    return newPic;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)initWithFrame:(CGRect)frame {
//    if (!self) {
//        self
//    }
//    return self;
//}

- (void)resetIntrLabelFrame {
    [self resetLabelFrame];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
}

- (void)resetLabelFrame {
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, 10, self.contentLabel.frame.size.width, self.size.height);
}
- (CGSize)getLabelSize:(NSString *)string {
    self.contentLabel.text = string;
    self.contentLabel.frame = CGRectMake(18, self.contentLabel.frame.origin.y, kScreen_width-36, self.contentLabel.frame.size.height);
    self.expandBtn.frame = CGRectMake(kScreen_width-self.expandBtn.frame.size.width-20, self.expandBtn.frame.origin.y, self.expandBtn.frame.size.width, self.expandBtn.frame.size.height);
    CGSize size = [self getTextSize:string fontSize:15 width:self.contentLabel.frame.size.width];
    NSLog(@"introduc 2 with=%fsize heigth=%f",self.contentLabel.frame.size.width,size.height);
    self.size= size;
    return size;
}

- (CGSize)getTextSize:(NSString *)text fontSize:(float)size width:(CGFloat)width{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = text;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return titleSize;
}

@end
