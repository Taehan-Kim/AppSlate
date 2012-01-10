//
//  CSBlueprintController.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 18..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSBlueprintView.h"
#import "CSBlueprintController.h"
#import "PropertyTVController.h"
#import "StringSettingViewController.h"

@implementation CSBlueprintController

- (id)init
{
    self = [super init];
    if (self) {
        self.view = [[CSBlueprintView alloc] init];

        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddRequest:) name:NOTI_PUT_GEAR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runRequest:) name:NOTI_RUN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRequest:) name:NOTI_STOP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionLinkRequest:) name:NOTI_ACTION_LINK object:nil];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bluePaper.png"]]];

        xButton = nil;
        modifyView = nil;
        propertyPopoverController = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

-(void) getAddRequest:(NSNotification*)noti
{
    NSUInteger getCode = [[[noti userInfo] objectForKey:@"tag"] integerValue];
    cView = ((UIView*)[[noti userInfo] objectForKey:@"cell"]);
    CGRect startFrame = [self.view convertRect:cView.frame fromView:cView];

    [cView setFrame:startFrame];
    [self.view addSubview:cView];

    switch (getCode)
    {
        case CS_LABEL:
            newObj = [[CSLabel alloc] initGear];
            break;
        case CS_LAMP:
            break;
        case CS_TEXTFIELD:
            newObj = [[CSTextField alloc] initGear];
            break;
        default:
            break;
    }

    // 새로 추가된 녀석을 화면에 보이게 하고, 수정 모드로 놓자.
    CGRect toFrame = newObj.csView.frame;

    // setup the path of the animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;

    CGPoint endPoint = self.view.center;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, cView.frame.origin.x, cView.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, cView.frame.origin.y, endPoint.x, cView.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);

    // setup scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
    [resizeAnimation setToValue:[NSValue valueWithCGRect:toFrame]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;

    CAAnimationGroup *group = [CAAnimationGroup animation]; 
    [group setValue:@"_drop" forKey:@"name"];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    [group setAnimations:[NSArray arrayWithObjects: pathAnimation, resizeAnimation,nil]];
    group.duration = 0.5f;
    group.delegate = self;
    [group setValue:cView forKey:@"imageViewBeingAnimated"];
    
    [cView.layer addAnimation:group forKey:@"curveAnimation"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if( [[theAnimation valueForKey:@"name"] isEqualToString:@"_drop"] ){
        [cView removeFromSuperview];
        cView = nil;
        [self addNewGear:newObj];
    }
}

// 청사진에 새로운 객체를 추가한다.
-(void) addNewGear:(id) gearObj
{
    [((CSGearObject*)gearObj) setTapGR: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)] ];
    [USERCONTEXT.gearsArray addObject:gearObj];

    // 형상을 만든다.
    UIView *aV = ((CSGearObject*)gearObj).csView;
    aV.frame = CGRectOffset(aV.frame,
                self.view.frame.size.width / 2 - aV.frame.size.width / 2,
                self.view.frame.size.height / 2 - aV.frame.size.height / 2);

    // 기어 뷰 를 설계도에 놓는다.
    [aV setTag:((CSGearObject*)gearObj).csMagicNum];
    [((CSGearObject*)gearObj).csView addGestureRecognizer:((CSGearObject*)gearObj).tapGR];
    [self.view addSubview:aV];

    // 지금 추가된 객체는 에디팅 모드로 설정한다.
    [self setEditModeGearOfMagicNum:aV.tag];
}

// 청사진에 객체를 제거한다.
-(void) deleteGear:(NSUInteger)magicNum
{
    NSNumber *nsMagicNum = NSNUM(magicNum);

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( g.csMagicNum == magicNum ){
            [USERCONTEXT.gearsArray removeObject:g];
            break;
        }
    }

    for( CSGearObject *g in USERCONTEXT.gearsArray )
            // 연결된 다른 곳의 링크를 정리!
        [g unlinkActionMCode:nsMagicNum];

    // 형상을 삭제한다.
    [modifyView removeFromSuperview];
    modifyView = nil;

    // 다른 Gear 를 수정 모드로 놓는다.
    if( 0 < [USERCONTEXT.gearsArray count] )
        [self setEditModeGearOfMagicNum:((CSGearObject*)[USERCONTEXT.gearsArray lastObject]).csMagicNum];
    else {
        // 부품이 하나도 없다. 컨트롤 버튼들도 사라져라.
        [xButton removeFromSuperview]; xButton = nil;
        [propButton removeFromSuperview];
        [sizeButton removeFromSuperview];
    }
}

#pragma mark - Run and Stop

-(void) runRequest:(NSNotification*)noti
{
    // 전체 부품들에서 제스쳐 인식자들을 제거한다.
    for( CSGearObject *gO in USERCONTEXT.gearsArray ){
        [gO.csView removeGestureRecognizer:gO.tapGR];
        [gO.csView.layer setShadowOpacity:0.0];
    }

    // 에디트 모드로 있던 하나의 객체를 해제한다.
    [xButton removeFromSuperview]; xButton = nil;
    [propButton removeFromSuperview];
    [sizeButton removeFromSuperview];

    // TODO: 실행한다.
}

-(void) stopRequest:(NSNotification*)noti
{
    // 전체 부품들에 기본적인 Tap 제스쳐 인식자들을 붙인다.
    for( CSGearObject *gO in USERCONTEXT.gearsArray ){
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)];
        [gO setTapGR:tapGR];
        [gO.csView addGestureRecognizer:tapGR];
    }

}

#pragma mark - Action Linking

-(void) actionLinkRequest:(NSNotification*)noti
{
    // 프로퍼티 팝오버 창을 닫자.
    [propertyPopoverController dismissPopoverAnimated:YES];

    // 제스쳐 인식자를 사용해서 선 긋기를 시작하자.
    [((CSBlueprintView*)self.view) startActionLink:noti.userInfo];
}

#pragma mark - User Editing

// 고유넘버의 객체를 수정 모드로 설정한다.
-(void) setEditModeGearOfMagicNum:(NSUInteger)magicNum
{
    if( nil == xButton ){
        xButton = [[UIButton alloc] init];
        [xButton setBackgroundImage:[UIImage imageNamed:@"editbtn_x.png"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(xButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        propButton = [[UIButton alloc] init];
        [propButton setBackgroundImage:[UIImage imageNamed:@"editbtn_prop.png"] forState:UIControlStateNormal];
        [propButton addTarget:self action:@selector(propButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        sizeButton = [[UIView alloc] init];
        [sizeButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"editbtn_size.png"]]];

        dragReco = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGear:)];
        [dragReco setMaximumNumberOfTouches:1];

        sizeReco = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeGear:)];
        [sizeReco setMaximumNumberOfTouches:1];
        [sizeButton addGestureRecognizer:sizeReco];

        [self.view addSubview:xButton];
        [self.view addSubview:propButton];
        [self.view addSubview:sizeButton];
    }

    // 이전의 뷰에서 gesture recognizer 없애기.
    for( UIView *gv in self.view.subviews ){
        if( gv.tag == modifyMagicNum ){
            [gv removeGestureRecognizer:dragReco];
            [gv.layer setShadowColor:[UIColor clearColor].CGColor];
            break;
        }
    }

    // 목적하는 객체 화면에 제어 버튼들을 붙인다.
    for( UIView *gv in self.view.subviews )
    {
        if( gv.tag == magicNum )
        {
            [xButton setFrame:CGRectMake(0, 0, 30, 30)];
            [propButton setFrame:CGRectMake(0, 0, 30, 30)];
            [sizeButton setFrame:CGRectMake(0, 0, 30, 30)];

            [xButton setFrame:CGRectOffset(xButton.frame, gv.frame.origin.x-15, gv.frame.origin.y-15)];
            [xButton setTag:gv.tag];   // magic number 를 동일하게 해줌.
            [propButton setFrame:CGRectOffset(xButton.frame, 32, 0)];
            [propButton setTag:gv.tag];  // magic number 를 동일하게 해줌.
            [sizeButton setFrame:CGRectOffset(sizeButton.frame, gv.frame.origin.x+gv.frame.size.width-15, gv.frame.origin.y+gv.frame.size.height-15)];

            [self.view bringSubviewToFront:xButton];
            [self.view bringSubviewToFront:propButton];
            [self.view bringSubviewToFront:sizeButton];

            [gv addGestureRecognizer:dragReco];

            modifyView = gv;

            [gv.layer setMasksToBounds:NO];
            [gv.layer setShadowColor:[UIColor blackColor].CGColor];
            [gv.layer setShadowOffset:CGSizeMake(1, 1)];
            [gv.layer setShadowOpacity:1.0];
            [gv.layer setShadowRadius:15.0];
            break;
        }
    }
    modifyMagicNum = magicNum;
}

-(void) xButtonAction:(id)sender
{
    [self deleteGear:((UIButton*)sender).tag];
}

-(void) propButtonAction:(id)sender
{
    //
    if (!propertyPopoverController) {
        PropertyTVController *controller = [[PropertyTVController alloc] initWithStyle:UITableViewStylePlain];

        UINavigationController *naviCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
        propertyPopoverController = [[UIPopoverController alloc] initWithContentViewController:naviCtrl];
        [propertyPopoverController setPopoverContentSize:CGSizeMake(320, 480)];
    }

    // Root 로 이동한다.
    [((UINavigationController*)(propertyPopoverController.contentViewController)) popToRootViewControllerAnimated:NO];

    PropertyTVController *tview = (PropertyTVController*)((UINavigationController*)(propertyPopoverController.contentViewController)).topViewController;

    // 해당 객체를 선택해주고, 목록에 내용이 표시될 수 있도록 준비해줌.
    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( g.csMagicNum == ((UIButton*)sender).tag ){
            [tview setSelectedGear:g];
            [propertyPopoverController presentPopoverFromRect:((UIView*)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            return;
        }
    }

    // 만일 여기로 온다면, 매직 넘버를 찾지 못했다는 것. 문제가 있는 경우다.
    // TODO: Error Handling
}

-(void) moveGear:(UIPanGestureRecognizer*)recognizer
{
    static CGPoint startPoint;

    if ([recognizer state] == UIGestureRecognizerStateBegan )
	{
        startPoint = [recognizer translationInView:self.view];
    }
    if( [recognizer state] == UIGestureRecognizerStateChanged )
    {
        CGPoint newP = [recognizer translationInView:self.view];
        CGFloat dx = newP.x - startPoint.x;
        CGFloat dy = newP.y - startPoint.y;
        [recognizer.view setFrame:CGRectOffset(recognizer.view.frame, dx, dy)];
        startPoint = newP;

        [xButton setFrame:CGRectOffset(xButton.frame, dx, dy)];
        [propButton setFrame:CGRectOffset(propButton.frame, dx, dy)];
        [sizeButton setFrame:CGRectOffset(sizeButton.frame, dx, dy)];
    }
}

-(void) resizeGear:(UIPanGestureRecognizer*)recognizer
{
    static CGPoint startPoint;
    
    if ([recognizer state] == UIGestureRecognizerStateBegan )
	{
        startPoint = [recognizer translationInView:self.view];
    }
    if( [recognizer state] == UIGestureRecognizerStateChanged )
    {
        CGPoint newP = [recognizer translationInView:self.view];

        CGFloat dx = newP.x - startPoint.x;
        CGFloat dy = newP.y - startPoint.y;

        // 너무 작아지면 안되고, 당연히 마이너스 크기가 되어도 안되니까...
        if( (modifyView.frame.origin.x+MINSIZE) > (sizeButton.frame.origin.x+dx+15) ) dx = 0;
        if( (modifyView.frame.origin.y+MINSIZE) > (sizeButton.frame.origin.y+dy+15) ) dy = 0;

        startPoint = newP;

        [sizeButton setFrame:CGRectOffset(sizeButton.frame, dx, dy)];

        [modifyView setFrame:CGRectMake(modifyView.frame.origin.x,
                                        modifyView.frame.origin.y,
                                        sizeButton.frame.origin.x-modifyView.frame.origin.x+15,
                                        sizeButton.frame.origin.y-modifyView.frame.origin.y+15)];
    }
}

-(void) changeEditGear:(UITapGestureRecognizer*)recognizer
{
    [self setEditModeGearOfMagicNum:recognizer.view.tag];
}

@end
