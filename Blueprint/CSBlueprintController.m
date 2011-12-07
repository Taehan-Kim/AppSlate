//
//  CSBlueprintController.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 18..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSBlueprintController.h"

@implementation CSBlueprintController

- (id)init
{
    self = [super init];
    if (self) {
        gearsArray = [[NSMutableArray alloc] initWithCapacity:50];

        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddRequest:) name:NOTI_PUT_GEAR object:nil];

        [self.view setBackgroundColor:CS_RGB(0, 180, 200)];

        xButton = nil;
        modifyView = nil;
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

    switch (getCode)
    {
        case CS_LABEL:
            [self addNewGear:[[CSLabel alloc] initGear]];
            break;
        case CS_LAMP:
            break;
        case CS_TEXTFIELD:
            [self addNewGear:[[CSTextField alloc] initGear]];
            break;
        default:
            break;
    }

    // 새로 추가된 녀석을 화면에 보이게 하고, 수정 모드로 놓자.
    
}

// 청사진에 새로운 객체를 추가한다.
-(void) addNewGear:(id) gearObj
{
    [gearsArray addObject:gearObj];

    // 형상을 만든다. TODO:상세하게.
    ((CSGearObject*)gearObj).csFrame = CGRectOffset(((CSGearObject*)gearObj).csFrame,
                self.view.frame.size.width / 2 - ((CSGearObject*)gearObj).csFrame.size.width / 2,
                self.view.frame.size.height / 2 - ((CSGearObject*)gearObj).csFrame.size.height / 2);

    UIView *aV = [[UIView alloc] initWithFrame:((CSGearObject*)gearObj).csFrame];
    [aV setBackgroundColor:[UIColor whiteColor]];
    [aV setTag:((CSGearObject*)gearObj).csMagicNum];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditGear:)];
    [aV addGestureRecognizer:tapGR];
    [self.view addSubview:aV];

    // 지금 추가된 객체는 에디팅 모드로 설정한다.
    [self setEditModeGearOfMagicNum:aV.tag];
}

// 청사진에 객체를 제거한다.
-(void) deleteGear:(NSUInteger)magicNum
{
    NSNumber *nsMagicNum = NSNUM(magicNum);

    for( CSGearObject *g in gearsArray )
    {
        if( g.csMagicNum == magicNum ){
            [gearsArray removeObject:g];
            break;
        }
    }

    for( CSGearObject *g in gearsArray )
            // 연결된 다른 곳의 링크를 정리!
        [g unlinkActionMCode:nsMagicNum];

    // 형상을 삭제한다.
//    for( UIView *aV in self.view.subviews )
//        if( aV.tag == magicNum )
//            [aV removeFromSuperview];
    [modifyView removeFromSuperview];
    modifyView = nil;

    // 다른 Gear 를 수정 모드로 놓는다.
    if( 0 < [gearsArray count] )
        [self setEditModeGearOfMagicNum:((CSGearObject*)[gearsArray lastObject]).csMagicNum];
}

#pragma mark - User Editing

// 고유넘버의 객체를 수정 모드로 설정한다.
-(void) setEditModeGearOfMagicNum:(NSUInteger)magicNum
{
    if( nil == xButton ){
        xButton = [[UIButton alloc] init];
        [xButton setBackgroundImage:[UIImage imageNamed:@"editbtn_x.png"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(xButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        sizeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editbtn_size.png"]];
        sizeButton = [[UIView alloc] init];
        [sizeButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"editbtn_size.png"]]];

        dragReco = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGear:)];
        [dragReco setMaximumNumberOfTouches:1];

        sizeReco = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeGear:)];
        [sizeReco setMaximumNumberOfTouches:1];
        [sizeButton addGestureRecognizer:sizeReco];

        [self.view addSubview:xButton];
        [self.view addSubview:sizeButton];
    }

    // 이전의 뷰에서 gesture recognizer 없애기.
    for( UIView *gv in self.view.subviews ){
        if( gv.tag == modifyMagicNum ){
            [gv removeGestureRecognizer:dragReco];
            break;
        }
    }

    // 목적하는 객체 화면에 제어 버튼들을 붙인다.
    for( UIView *gv in self.view.subviews )
    {
        if( gv.tag == magicNum )
        {
            [xButton setFrame:CGRectMake(0, 0, 30, 30)];
            [sizeButton setFrame:CGRectMake(0, 0, 30, 30)];

            [xButton setFrame:CGRectOffset(xButton.frame, gv.frame.origin.x-15, gv.frame.origin.y-15)];
            [xButton setTag:gv.tag];   // magic number 를 동일하게 해줌.
            [sizeButton setFrame:CGRectOffset(sizeButton.frame, gv.frame.origin.x+gv.frame.size.width-15, gv.frame.origin.y+gv.frame.size.height-15)];

            [self.view bringSubviewToFront:xButton];
            [self.view bringSubviewToFront:sizeButton];

            [gv addGestureRecognizer:dragReco];

            modifyView = gv;
            break;
        }
    }
    modifyMagicNum = magicNum;
}

-(void) xButtonAction:(id)sender
{
//    NSUInteger magic_num = ((UIButton*)sender).tag;
//    ((UIButton*)sender).tag = 0; // 버튼의 magic num 은 제거해야 view 와 함께 삭제되는 것을 피할 수 있다.
//    [self deleteGear:magic_num];
    [self deleteGear:((UIButton*)sender).tag];
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
