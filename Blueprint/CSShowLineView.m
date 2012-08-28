//
//  CSShowLineView.m
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 14..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSShowLineView.h"

@implementation CSShowLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = CSCLEAR;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);

    for( CSGearObject *gO in USERCONTEXT.gearsArray ){
        CGPoint sp = gO.csView.center;
        
        for( NSDictionary *destDic in [gO getActionList] ){
            CSGearObject *dg = [USERCONTEXT getGearWithMagicNum:[destDic[@"mNum"] integerValue]];
            if( nil != dg ){
                CGPoint dp = dg.csView.center;
                CGContextMoveToPoint(context, sp.x + 0.5, sp.y + 0.5);
                CGContextAddLineToPoint(context, dp.x + 0.5, dp.y + 0.5);
            }
        }
    }

    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
