//
//  CSBlueprintController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 18..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CSBlueprintView.h"
#import "CSBlueprintController.h"
#import "PropertyTVController.h"
#import "StringSettingViewController.h"
#import "CSAppDelegate.h"
#import "CSMainViewController.h"

@implementation CSBlueprintController

- (id)init
{
    self = [super init];
    if (self) {
        self.view = [[CSBlueprintView alloc] init];
        [self.view setClipsToBounds:YES];

        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddRequest:) name:NOTI_PUT_GEAR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runRequest:) name:NOTI_RUN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRequest:) name:NOTI_STOP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionLinkRequest:) name:NOTI_ACTION_LINK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alphaResetRequest:) name:NOTI_RESET_ALPHA object:nil];
        if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizingPopoverView) name:NOTI_CHANGE_POPOVER object:nil];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bluePaper.png"]]];
        USERCONTEXT.wallpaperIndex = 1; // default paper

        xButton = nil;
        modifyView = nil;
        propertyPopoverController = nil;
        propertyNaviController = nil;

        NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"run" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &runSoundID);
        fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"objectDrop" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &putSoundID);
        fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"delSound" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &delSoundID);

        UISwipeGestureRecognizer *openReco = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu:)];
        [openReco setDirection:UISwipeGestureRecognizerDirectionUp];
        [self.view addGestureRecognizer:openReco];
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

- (void)viewDidAppear:(BOOL)animated
{
    if( nil == iView && [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
    {
        iView = [[CSShowLineView alloc] initWithFrame:self.view.bounds];
        [iView setUserInteractionEnabled:NO];
        [self.view addSubview:iView];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
           (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

#pragma mark -

-(void) getAddRequest:(NSNotification*)noti
{
    UIWindow *win = ((CSAppDelegate*)[UIApplication sharedApplication].delegate).window;

    NSUInteger getCode = [[noti userInfo][@"tag"] integerValue];
    cView = ((UIView*)[noti userInfo][@"cell"]);
    [cView setClipsToBounds:YES];
    [cView setBackgroundColor:[UIColor whiteColor]];
    CGRect startFrame = [cView convertRect:cView.bounds toView:win];

//    [self.view addSubview:cView];
    [win addSubview:cView];

    [cView setFrame:startFrame];
    NSLog(@"start frame:%f,%f",startFrame.origin.x,startFrame.origin.y);

    switch (getCode)
    {
        case CS_LABEL:
            newObj = [[CSLabel alloc] initGear];  break;
        case CS_NUMLABEL:
            newObj = [[CSNumLabel alloc] initGear];  break;
//        case CS_MASKEDLABEL:
//            newObj = [[CSMaskedLabel alloc] initGear];  break;
        case CS_TEXTFIELD:
            newObj = [[CSTextField alloc] initGear];     break;
        case CS_BTNTEXTFIELD:
            newObj = [[CSBtnTextField alloc] initGear];  break;
        case CS_SWITCH:
            newObj = [[CSSwitch alloc] initGear];        break;
        case CS_BUTTON:
            newObj = [[CSButton alloc] initGear];        break;
        case CS_TOGGLEBTN:
            newObj = [[CSToggleButton alloc] initGear];   break;
        case CS_TOUCHBTN:
            newObj = [[CSTouchButton alloc] initGear];    break;
        case CS_FLIPCNT:
            newObj = [[CSFlipCounter alloc] initGear];    break;
        case CS_SLIDER:
            newObj = [[CSSlider alloc] initGear];         break;
        case CS_PROGRESS:
            newObj = [[CSProgressBar alloc] initGear];  break;
        case CS_TABLE:
            newObj = [[CSTable alloc] initGear];         break;
        case CS_RSSTABLE:
            newObj = [[CSRssTable alloc] initGear];      break;
        case CS_BULB:
            newObj = [[CSBulb alloc] initGear];          break;
        case CS_ALERT:
            newObj = [[CSAlert alloc] initGear];         break;
        case CS_TEXTALERT:
            newObj = [[CSTextAlert alloc] initGear];     break;
        case CS_RECT:
            newObj = [[CSRect alloc] initGear];          break;
        case CS_NOT:
            newObj = [[CSNot alloc] initGear];           break;
        case CS_AND:
            newObj = [[CSAnd alloc] initGear];           break;
        case CS_OR:
            newObj = [[CSOr alloc] initGear];           break;
        case CS_XOR:
            newObj = [[CSXor alloc] initGear];          break;
        case CS_NAND:
            newObj = [[CSNand alloc] initGear];         break;
        case CS_NOR:
            newObj = [[CSNor alloc] initGear];          break;
        case CS_XNOR:
            newObj = [[CSXnor alloc] initGear];         break;
        case CS_TEE:
            newObj = [[CSTee alloc] initGear];          break;
        case CS_MAIL:
            newObj = [[CSMailComposer alloc] initGear]; break;
        case CS_TWITSEND:
            newObj = [[CSTwitComposer alloc] initGear]; break;
        case CS_FBSEND:
            newObj = [[CSFBSend alloc] initGear]; break;
        case CS_WEIBOSEND:
            newObj = [[CSWeiboComposer alloc] initGear]; break;
        case CS_ALBUM:
            newObj = [[CSAlbum alloc] initGear]; break;
        case CS_NUMCOMP:
            newObj = [[CSNumComp alloc] initGear]; break;
        case CS_STRCOMP:
            newObj = [[CSStrComp alloc] initGear]; break;
        case CS_CALC:
            newObj = [[CSCalc alloc] initGear]; break;
        case CS_ATOF:
            newObj = [[CSAtof alloc] initGear];  break;
        case CS_IMAGE:
            newObj = [[CSImage alloc] initGear]; break;
        case CS_WEBVIEW:
            newObj = [[CSWeb alloc] initGear]; break;
        case CS_MAPVIEW:
            newObj = [[CSMapView alloc] initGear];  break;
        case CS_LINE_H:
            newObj = [[CSHLine alloc] initGear];  break;
        case CS_LINE_V:
            newObj = [[CSVLine alloc] initGear];  break;
        case CS_TICK:
            newObj = [[CSTick alloc] initGear];  break;
        case CS_RAND:
            newObj = [[CSRand alloc] initGear];  break;
        case CS_ABS:
            newObj = [[CSAbs alloc] initGear]; break;
        case CS_NOW:
            newObj = [[CSTime alloc] initGear]; break;
        case CS_ACLOMETER:
            newObj = [[CSAccelero alloc] initGear]; break;
        case CS_STRCAT:
            newObj = [[CSLinkStr alloc] initGear]; break;
        case CS_TWTABLE:
            newObj = [[CSTwitTable alloc] initGear]; break;
        case CS_STACK:
            newObj = [[CSStack alloc] initGear]; break;
        case CS_QUEUE:
            newObj = [[CSQueue alloc] initGear]; break;
        case CS_RADDEG:
            newObj = [[CSRadDeg alloc] initGear]; break;
        case CS_TRI:
            newObj = [[CSTrigonometric alloc] initGear]; break;
        case CS_NOTE:
            newObj = [[CSNote alloc] initGear]; break;
        case CS_CLOCK:
            newObj = [[CSClock alloc] initGear]; break;
        case CS_PLAY:
            newObj = [[CSPlay alloc] initGear]; break;
        case CS_CAMERA:
            newObj = [[CSCamera alloc] initGear]; break;
        case CS_BTOOTH:
            newObj = [[CSBToothPeer alloc] initGear]; break;
        case CS_STOREVIEW:
            newObj = [[CSStoreView alloc] initGear]; break;
        default:
            return;
    }

    [newObj setInfo:[noti userInfo][@"name"]];

    // 새 객체의 크기가, 아이폰에서 너무 큰 경우라면 크기를 줄여 준다. 적당히...
    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() && newObj.isResizable )
    {
        CGFloat width = newObj.csView.frame.size.width;
        CGFloat height = newObj.csView.frame.size.height;
        if( width > 200 ) width /= 2.0;
        if( height > 200 ) height /= 2.0;
        [newObj.csView setFrame:CGRectMake(0, 0, width, height)];
    }

    // 새로 추가된 녀석을 화면에 보이게 하고, 수정 모드로 놓자.
    CGRect toFrame = newObj.csView.frame;

    // setup the path of the animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;

    CGPoint endPoint;
    // 낙하 위치를 찾음.
    if( 0 == [USERCONTEXT.gearsArray count] )
         endPoint = self.view.center;
    else {
        UIView *lobjView = ((CSGearObject*)[USERCONTEXT.gearsArray lastObject]).csView;
        CGFloat x = lobjView.frame.origin.x + lobjView.frame.size.width + newObj.csView.center.x + 15;
        CGFloat y = lobjView.center.y;
        if( self.view.frame.size.width < (x + newObj.csView.frame.size.width) ){
            x = lobjView.center.x;
            y = lobjView.frame.origin.y + lobjView.frame.size.height + newObj.csView.center.y + 15;
            if( self.view.frame.size.height < (y + newObj.csView.frame.size.height) ){
                x = 20.0 + newObj.csView.center.x;
                y = 20.0 + newObj.csView.center.y;
            }
        }
        endPoint = CGPointMake(x, y);
    }

    // update new position.
    newObj.csView.center = endPoint;

    [UIView animateWithDuration:0.6f animations:^{
        CGRect newRect = CGRectMake(endPoint.x - (toFrame.size.width/2), endPoint.y - (toFrame.size.height/2), toFrame.size.width, toFrame.size.height);
        [cView setFrame:newRect];
        [cView setAlpha:0.6];
    } completion:^(BOOL finished) {
        [cView removeFromSuperview];
        cView = nil;
        [self addNewGear:newObj];
    }];
}

// Put new gears on the blueprint
-(void) addNewGear:(id) gearObj
{
    // Make a default shape
    UIView *aV = ((CSGearObject*)gearObj).csView;


    [((CSGearObject*)gearObj) setTapGR: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)] ];
    [USERCONTEXT.gearsArray addObject:gearObj];

    // Put the view on the screen
    [aV setTag:((CSGearObject*)gearObj).csMagicNum];

    if( NO == ((CSGearObject*)gearObj).isUIObj
       || [aV isKindOfClass:[UITableView class]]
       || [aV isKindOfClass:[MKMapView class]]
       || [aV isKindOfClass:[UIWebView class]]
       || [aV isKindOfClass:[UITextView class]] )
        for( UIView* sv in aV.subviews )  // 사용자 반응 중지.
            [sv setUserInteractionEnabled:NO];

    // Gesture Recognizer Backup
    ((CSGearObject*)gearObj).gestureArray = [((CSGearObject*)gearObj).csView gestureRecognizers];
    for( UIGestureRecognizer *gr in [((CSGearObject*)gearObj).csView gestureRecognizers] )
        [((CSGearObject*)gearObj).csView removeGestureRecognizer:gr];

    // 탭 제스쳐 인식자를 놓는다.
    [((CSGearObject*)gearObj).csView addGestureRecognizer:((CSGearObject*)gearObj).tapGR];

    [self.view addSubview:aV];

    // 약간 움찔하는 동작.
    [aV setFrame:CGRectMake(aV.frame.origin.x+4, aV.frame.origin.y+4,
                            aV.frame.size.width-8, aV.frame.size.height-8)];
    [UIView animateWithDuration:0.1 animations:^(void){
        [aV setFrame:CGRectMake(aV.frame.origin.x-4, aV.frame.origin.y-4,
                                aV.frame.size.width+8, aV.frame.size.height+8)];
    }];

    // 지금 추가된 객체는 에디팅 모드로 설정한다.
    [self setEditModeGearOfMagicNum:aV.tag];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound(putSoundID);
}

// 청사진에 객체를 제거한다.
-(void) deleteGear:(NSUInteger)magicNum
{
    NSNumber *nsMagicNum = @(magicNum);

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

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
        [iView setNeedsDisplay];
}

#pragma mark -

-(void) deleteAllGear
{
    for( CSGearObject *g in USERCONTEXT.gearsArray )
        [g.csView removeFromSuperview];

    [USERCONTEXT.gearsArray removeAllObjects];

    modifyView = nil;
    modifyMagicNum = 0;

    [xButton removeFromSuperview]; xButton = nil;
    [propButton removeFromSuperview];
    [sizeButton removeFromSuperview];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
        [iView setNeedsDisplay];
}

-(void) putAllGearsToView
{
    NSUInteger idx = 0;

    // 순서를 지키기 위해서 의도적으로 index 를 사용.
    for( idx = 0; idx < [USERCONTEXT.gearsArray count]; idx++ )
    {
        CSGearObject *g = (USERCONTEXT.gearsArray)[idx];
        [self.view insertSubview:g.csView atIndex:idx];
        // 기어 뷰 를 설계도에 놓는다.
        [g.csView setTag:g.csMagicNum];
        [g setTapGR: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)]];
        [g.csView addGestureRecognizer:g.tapGR];

        if( NO == g.isUIObj || [g.csView isKindOfClass:[UITableView class]] || [g.csView isKindOfClass:[UITextView class]] )
        {
            for( UIView* sv in ((UIView*)(g.csView)).subviews )  // 사용자 반응 중지.
                [sv setUserInteractionEnabled:NO];
        }

    }
}

#pragma mark - Run and Stop

-(void) runRequest:(NSNotification*)noti
{
    // 전체 부품들에서 제스쳐 인식자들을 제거한다.
    for( CSGearObject *gO in USERCONTEXT.gearsArray ){
        [gO.csView removeGestureRecognizer:gO.tapGR];
        gO.tapGR = nil;
        [gO.csView setUserInteractionEnabled:YES];
//        [gO.csView.layer setShadowOpacity:0.0];

        // Restore Gesture Recognizers
        for( UIGestureRecognizer *gr in gO.gestureArray )
            [gO.csView addGestureRecognizer:gr];
        gO.gestureArray = nil;

        // NOTE: 세 가지 경우에 대해서 처리 하지 않음.
        if( NO == gO.isUIObj
           || [gO.csView isKindOfClass:[UITableView class]]
           || [gO.csView isKindOfClass:[MKMapView class]]
           || [gO.csView isKindOfClass:[UIWebView class]]
           || [gO.csView isKindOfClass:[UITextView class]] )
            for( UIView* sv in ((UIView*)(gO.csView)).subviews )  // 사용자 반응 활성화.
                [sv setUserInteractionEnabled:YES];

        // Hidden Style 처리.
        if( [gO isHiddenGear] &&
           [[NSUserDefaults standardUserDefaults] boolForKey:@"HIDE_SET"] )
            [gO.csView setAlpha:0.47];

        // 예외 처리.
        if( [gO.csView isKindOfClass:[UIWebView class]] )
            [((UIWebView*)(gO.csView)).scrollView setScrollEnabled:YES];
        else if( [gO.csView isKindOfClass:[MKMapView class]] )
            [((MKMapView*)gO.csView) setScrollEnabled:YES];
        else if( [gO.csView isKindOfClass:[UITextView class]] )
            [((UITextView*)gO.csView) setEditable:YES];
        else if( CS_CLOCK == gO.csCode )
            [(CSClock*)gO turnOnClock];
    }

    // 에디트 모드로 있던 하나의 객체를 해제한다.
    [self removeModifyMode];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound(runSoundID);

    // 실행한다.
    USERCONTEXT.imRunning = YES;
}

-(void) stopRequest:(NSNotification*)noti
{
    if( YES == USERCONTEXT.imRunning )
    {
        // 전체 부품들에 기본적인 Tap 제스쳐 인식자들을 붙인다.
        for( CSGearObject *gO in USERCONTEXT.gearsArray ){
            // 원래 제스쳐 인식자들은 다시 백업 후 제거한다.
            gO.gestureArray = gO.csView.gestureRecognizers;
            for( UIGestureRecognizer *gr in gO.csView.gestureRecognizers )
                [gO.csView removeGestureRecognizer:gr];

            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)];
            [gO setTapGR:tapGR];
            [gO.csView addGestureRecognizer:tapGR];
            
            // NOTE: 네 가지 경우에 대해서 처리 하지 않음.
            if( NO == gO.isUIObj
               || [gO.csView isKindOfClass:[UITableView class]]
               || [gO.csView isKindOfClass:[MKMapView class]]
               || [gO.csView isKindOfClass:[UIWebView class]]
               || [gO.csView isKindOfClass:[UITextView class]] )
            {
                for( UIView* sv in ((UIView*)(gO.csView)).subviews )  // 사용자 반응 중지.
                    [sv setUserInteractionEnabled:NO];
            }

            // Hidden Style 처리.
            if( [gO isHiddenGear] )
                [gO.csView setAlpha:1.0];
            // 예외 처리.
            if( [gO.csView isKindOfClass:[UIWebView class]] )
                [((UIWebView*)(gO.csView)).scrollView setScrollEnabled:NO];
            else if( [gO.csView isKindOfClass:[MKMapView class]] )
                [((MKMapView*)gO.csView) setScrollEnabled:NO];
            else if( [gO.csView isKindOfClass:[UITextView class]] )
                [((UITextView*)gO.csView) setEditable:NO];
            else if( CS_CLOCK == gO.csCode )
                [(CSClock*)gO turnOffClock];

            if( [gO respondsToSelector:@selector(removeAll)] )
                [gO performSelector:@selector(removeAll)];
        }

        USERCONTEXT.imRunning = NO;
    }

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
    {
        if( nil == iView ){
            iView = [[CSShowLineView alloc] initWithFrame:self.view.bounds];
            [iView setUserInteractionEnabled:NO];
            [self.view addSubview:iView];
        }
        [iView setNeedsDisplay];
    }
    else {
        if( nil != iView ){
            [iView removeFromSuperview];
            iView = nil;
        }
    }
}

-(void) removeModifyMode
{
    [xButton removeFromSuperview]; xButton = nil;
    [propButton removeFromSuperview];
    [sizeButton removeFromSuperview];
    // 이전의 뷰에서 gesture recognizer 없애기.
    if( nil != modifyView )
        [modifyView removeGestureRecognizer:dragReco];
    
    modifyMagicNum = 0;
    modifyView = nil;
}

#pragma mark - Action Linking

-(void) actionLinkRequest:(NSNotification*)noti
{
    // 프로퍼티 팝오버 창을 닫자.
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
        [propertyPopoverController dismissPopoverAnimated:YES];
    else
        [propertyNaviController dismissViewControllerAnimated:YES completion:nil];

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

    // Animation Effect
    [xButton setTransform:CGAffineTransformMakeScale(0, 0)];
    [propButton setTransform:CGAffineTransformMakeScale(0, 0)];
    [sizeButton setTransform:CGAffineTransformMakeScale(0, 0)];
    [UIView animateWithDuration:0.3 animations:^{
        [xButton setTransform:CGAffineTransformMakeScale(1, 1)];
        [propButton setTransform:CGAffineTransformMakeScale(1, 1)];
        [sizeButton setTransform:CGAffineTransformMakeScale(1, 1)];
    }];

    CSGearObject *mGear = [USERCONTEXT getGearWithMagicNum:magicNum];
    UIView *targetView = mGear.csView;
    if( [targetView isKindOfClass:[UIWebView class]] )
        [((UIWebView*)targetView).scrollView setScrollEnabled:NO];
    else if( [targetView isKindOfClass:[MKMapView class]] )
        [((MKMapView*)targetView) setScrollEnabled:NO];
    else if( [targetView isKindOfClass:[UITextView class]] )
        [((UITextView*)targetView) setEditable:NO];
 
    // 이전의 뷰에서 gesture recognizer 없애기.
    [targetView removeGestureRecognizer:dragReco];
///         [gv.layer setShadowColor:[UIColor clearColor].CGColor];

    // 목적하는 객체 화면에 제어 버튼들을 붙인다.
    [xButton setFrame:CGRectMake(0, 0, 30, 30)];
    [propButton setFrame:CGRectMake(0, 0, 30, 30)];
    [sizeButton setFrame:CGRectMake(0, 0, 30, 30)];

    [xButton setFrame:CGRectOffset(xButton.frame, targetView.frame.origin.x-15, targetView.frame.origin.y-15)];
    [xButton setTag:targetView.tag];   // magic number 를 동일하게 해줌.
    [propButton setFrame:CGRectOffset(xButton.frame, 32, 0)];
    [propButton setTag:targetView.tag];  // magic number 를 동일하게 해줌.
    [sizeButton setFrame:CGRectOffset(sizeButton.frame, targetView.frame.origin.x+targetView.frame.size.width-15, targetView.frame.origin.y+targetView.frame.size.height-15)];

    [self.view bringSubviewToFront:xButton];
    [self.view bringSubviewToFront:propButton];
    [self.view bringSubviewToFront:sizeButton];

    [targetView addGestureRecognizer:dragReco];

    if( NO == mGear.isUIObj && ( [mGear.csView isKindOfClass:[UITableView class]] || [mGear.csView isKindOfClass:[UITextView class]] ) )
    {
        for( UIView* sv in targetView.subviews )  // 사용자 반응 중지.
            [sv setUserInteractionEnabled:NO];
    }
    // 크기 조절이 불가능한 부품들이 있다.
    if( [[USERCONTEXT getGearWithMagicNum:magicNum] isResizable] )
        [sizeButton setAlpha:1.0];
    else
        [sizeButton setAlpha:0.0]; // 그런 경우, 크기 조절 앵커는 사라진다.

//            [gv.layer setMasksToBounds:NO];
//            [gv.layer setShadowColor:[UIColor blackColor].CGColor];
//            [gv.layer setShadowOffset:CGSizeMake(1, 1)];
//            [gv.layer setShadowOpacity:1.0];
//            [gv.layer setShadowRadius:15.0];

    modifyView = targetView;
    modifyMagicNum = magicNum;
}

-(void) xButtonAction:(id)sender
{
    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound(delSoundID);

    UIView *v = [USERCONTEXT getGearWithMagicNum:((UIButton*)sender).tag].csView;
    [UIView animateWithDuration:0.3 animations:^(){
        [v setAlpha:0.3];
        [v setCenter:v.frame.origin];
        [v setTransform:CGAffineTransformMakeScale(0.0001, 0.0001)];
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
        [self deleteGear:((UIButton*)sender).tag];
    }];
}

-(void) propButtonAction:(id)sender
{
    // iPad ==================
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
    {
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
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:((UIButton*)sender).tag];
        if( nil != gObj ){
            [tview setSelectedGear:gObj];
            [propertyPopoverController presentPopoverFromRect:((UIView*)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else // iPhone =============
    {
        PropertyTVController *controller = [[PropertyTVController alloc] initWithStyle:UITableViewStylePlain];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeiPhonePopover:)];
//        [rightBtn setTintColor:[UIColor darkGrayColor]];
        controller.navigationItem.rightBarButtonItem = rightBtn;

        propertyNaviController = [[UINavigationController alloc] initWithRootViewController:controller];
        [propertyNaviController.navigationBar setTranslucent:NO];

        // 해당 객체를 선택해주고, 목록에 내용이 표시될 수 있도록 준비해줌.
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:((UIButton*)sender).tag];
        if( nil != gObj ){
            UIViewController *win = ((CSAppDelegate*)[UIApplication sharedApplication].delegate).mainViewController;

            [controller setSelectedGear:gObj];
            propertyNaviController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [win presentViewController:propertyNaviController animated:YES completion:nil];
        }
    }
}

- (void) closeiPhonePopover:(UIBarButtonItem*)btn
{
    [propertyNaviController dismissViewControllerAnimated:YES completion:nil];
}

- (void) resizingPopoverView
{
    UIViewController *tv = ((UINavigationController*)(propertyPopoverController.contentViewController)).presentingViewController;
    [propertyPopoverController setPopoverContentSize:tv.preferredContentSize animated:YES];
}

-(void) moveGear:(UIPanGestureRecognizer*)recognizer
{
    static CGPoint startPoint;

    // 실행 모드라면 움직이지 않게 하자. (마지막 하나가 움직일 수 있는 상태가 됨)
    // GestureRecognizer 를 없애는 것 보다 여기서 체크하는게 싸게 먹힌다.
    if( 0 == modifyMagicNum ) return;

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
    if( [recognizer state] == UIGestureRecognizerStateEnded &&
       [[NSUserDefaults standardUserDefaults] boolForKey:@"GRID_SET"] )
    {
        CGFloat dx = roundf( recognizer.view.frame.origin.x / 10 ) * 10;
        CGFloat dy = roundf( recognizer.view.frame.origin.y / 10 ) * 10;

        [recognizer.view setFrame:CGRectMake(dx, dy, recognizer.view.frame.size.width, recognizer.view.frame.size.height)];

        [xButton setCenter:CGPointMake(dx, dy)];
        [propButton setCenter:CGPointMake(xButton.center.x+32, dy)];
        [sizeButton setCenter:CGPointMake(recognizer.view.frame.size.width+dx, recognizer.view.frame.size.height+dy)];
    }

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
        [iView setNeedsDisplay];
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
    if( [recognizer state] == UIGestureRecognizerStateEnded &&
        [[NSUserDefaults standardUserDefaults] boolForKey:@"GRID_SET"] )
    {
        CGFloat dx = roundf( sizeButton.frame.origin.x / 10 ) * 10;
        CGFloat dy = roundf( sizeButton.frame.origin.y / 10 ) * 10;

        [sizeButton setFrame:CGRectMake(dx, dy, sizeButton.frame.size.width, sizeButton.frame.size.height)];
        [modifyView setFrame:CGRectMake(modifyView.frame.origin.x,
                                        modifyView.frame.origin.y,
                                        sizeButton.frame.origin.x-modifyView.frame.origin.x+15,
                                        sizeButton.frame.origin.y-modifyView.frame.origin.y+15)];
        startPoint = sizeButton.frame.origin;
    }

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"] )
        [iView setNeedsDisplay];
}

-(void) changeEditGear:(UITapGestureRecognizer*)recognizer
{
    [self setEditModeGearOfMagicNum:recognizer.view.tag];
}

-(void) openMenu:(UISwipeGestureRecognizer*)recognizer
{
    if( [recognizer state] == UIGestureRecognizerStateEnded &&
       recognizer.direction == UISwipeGestureRecognizerDirectionUp &&
       !USERCONTEXT.imRunning )
    {
        [[(CSAppDelegate*)([UIApplication sharedApplication].delegate) mainViewController] openMenuFolder:nil];
    }
}

#pragma mark -

-(void) alphaResetRequest:(NSNotification*)noti
{
    for( CSGearObject *g in USERCONTEXT.gearsArray ){
        if( 0.0 == g.csView.alpha )
            [g.csView setAlpha:0.5];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"reset" message:@"All items alpha value 0 is changed to 0.5"
                                                   delegate:nil cancelButtonTitle:nil
                                          otherButtonTitles:@"Confirm", nil];
    [alert show];
}

//-(void) drawLines
//{
//    UIView *iView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [iView setUserInteractionEnabled:NO];
//    [self.view addSubview:iView];
//}

@end
