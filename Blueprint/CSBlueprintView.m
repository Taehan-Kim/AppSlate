//
//  CSBlueprintView.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 5..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSBlueprintView.h"
#import "PropertyLinkTVController.h"
#import "TSPopoverController.h"

@implementation CSBlueprintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        newP = CGPointZero;
        popTip = nil;
        pointedObj = nil;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if( 0 != newP.x )
        draw1PxStroke(UIGraphicsGetCurrentContext(), linkStartPoint, newP, [UIColor orangeColor].CGColor, 4.0);
}

// 액션 -> 프로퍼티 연결 작업을 시작하도록 요구가 주어졌다. 연결 표시 손잡이를 보여주고 움직일 수 있도록 세팅한다.
-(void) startActionLink:(NSDictionary*) userInfo
{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionLinkDragGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    actionGear = userInfo[@"theGear"];
    actionIndex = ((NSNumber*)userInfo[@"theActionIndex"]).integerValue;

    // handle 을 보여주자.
    actionHandle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [actionHandle.layer setBackgroundColor:[UIColor orangeColor].CGColor];
    [actionHandle.layer setCornerRadius:20.0];
    [actionHandle.layer setBorderColor:[UIColor redColor].CGColor];
    [actionHandle.layer setBorderWidth:1.0];
    [actionHandle setClipsToBounds:YES];
    [actionHandle setAlpha:1.0];
    [actionHandle setCenter:actionGear.csView.center];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-cross.png"]];
    [arrow setFrame:CGRectMake(5, 5, 30, 30)];
    [actionHandle addSubview:arrow];
    [self addSubview:actionHandle];

    [UIView animateWithDuration:0.15 animations:^(){
        [actionHandle setFrame:CGRectOffset(actionHandle.frame, -3, 0)];
    } completion:^(BOOL complete){
        [UIView animateWithDuration:0.15 animations:^(){
            [actionHandle setFrame:CGRectOffset(actionHandle.frame, 6, 0)];
        } completion:^(BOOL complete){
            [UIView animateWithDuration:0.15 animations:^(){
                [actionHandle setFrame:CGRectOffset(actionHandle.frame, -3, 0)];
            }];
        }];
    }];

    linkStartPoint = actionHandle.center;
}

#pragma mark -

// 액션을 연결하기 위해 handle 을 드래깅 하는 경우 발생하는 동작을 처리하는 제스쳐 인식자.
-(void) actionLinkDragGesture:(UIPanGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
        [recognizer state] == UIGestureRecognizerStateChanged )
    {
        newP = [recognizer locationInView:self];
        [actionHandle setCenter:newP];

//        [self setNeedsDisplayInRect:CGRectMake(linkStartPoint.x,linkStartPoint.y,newP.x,newP.y)];
        [self setNeedsDisplay];

        // 이동하면서, 연결 될 수 있는 객체의 이름을 보여주도록 함.
        if( nil == popTip ){
            for( CSGearObject *g in USERCONTEXT.gearsArray ){
                if( CGRectContainsPoint(g.csView.frame, newP) ){
                    popTip = [[CMPopTipView alloc] initWithMessage:g.info];
                    [popTip setDelegate:self];
                    [popTip presentPointingAtView:g.csView inView:self animated:YES];
                    pointedObj = g;
                    return;
                }
            }
        }
        if( nil != popTip ){
            for( CSGearObject *g in USERCONTEXT.gearsArray ){
                if( CGRectContainsPoint(g.csView.frame, newP) ){
                    if( [g isEqual:pointedObj] )
                        return;
                    else {   // 맞닿아 있는 객체 사이를 손가락 끝이 이동한 경우.
                        [popTip setMessage:g.info];
                        [popTip presentPointingAtView:g.csView inView:self animated:NO];
                        pointedObj = g;
                    }
                }
            }
            [popTip dismissAnimated:YES];
            popTip = nil;
            pointedObj = nil;
        }
    }
    if( [recognizer state] == UIGestureRecognizerStateEnded ||
       [recognizer state] == UIGestureRecognizerStateCancelled ||
       [recognizer state] == UIGestureRecognizerStateFailed )
    {
        [self removeGestureRecognizer:panGestureRecognizer];
        panGestureRecognizer = nil;
        [actionHandle removeFromSuperview];
        newP = CGPointZero;
        [self setNeedsDisplay];
        [popTip dismissAnimated:YES];

        // 지정되어 있는 객체가 있는지 확인하자.
        if( nil == pointedObj ) return;
        
        // 연결 선택용 목록 보이기.
        PropertyLinkTVController *plc = [[PropertyLinkTVController alloc] initWithStyle:UITableViewStylePlain];
        [plc setDestinationGear:pointedObj
                     actionGear:actionGear actionIndex:actionIndex];

        if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        {
            USERCONTEXT.pop = [[TSPopoverController alloc] initWithContentViewController:plc];
            [(TSPopoverController*)USERCONTEXT.pop setPreferredContentSize:CGSizeMake(200, 220)];
            [(TSPopoverController*)USERCONTEXT.pop showPopoverWithRect:pointedObj.csView.frame];
        } else {
            USERCONTEXT.pop = [[UIPopoverController alloc] initWithContentViewController:plc];
            [(UIPopoverController*)USERCONTEXT.pop setPopoverContentSize:CGSizeMake(200, 220)];
            [(UIPopoverController*)USERCONTEXT.pop presentPopoverFromRect:pointedObj.csView.frame
                                 inView:self
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    popTip = nil;
}


@end
