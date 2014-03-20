//
//  CSMakeCode.m
//  AppSlate
//
//  Created by Taehan Kim on 2014. 1. 7..
//  Copyright (c) 2014년 ChocolateSoft. All rights reserved.
//

#import "CSMakeCode.h"
#import "CSGearObject.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIBAlertView.h"

#define MAIN_COMMENT    @"// This code is auto-generated on AppSlate.\n// You should move it to your Xcode project and modify.\n// NOTE: This code is not perfact to use on XCode, also not optimized code.\n//   Please use it for save your little time.\n// "

@implementation CSMakeCode

- (id) initWithControllerName:(NSString*)name
{
    if( !(self = [super init]) ) return nil;

    if( nil == name || 1 >= [name length] ) return nil;

    fileName = name;

    mainDoc = [[NSMutableString alloc] initWithString:NSLocalizedString(MAIN_COMMENT,@"main comment")];
    [mainDoc appendString:[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]];
    return self;
}

- (NSString *) generate
{
    if( NO == [self makeGearsNames] )
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Sorry..." message:NSLocalizedString(@"Button Text Field, Flip Counter, RSS Table, and Twitter Table are not converted to Objective-C code.",@"Coding Fail Message")
                                                cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm") otherButtonTitles: nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            ;
        }];
        return @"Developer: Taehan Kim <blade.kim@gmail.com>\n";
    }

    [self makeImports];
    [self makeInterface];
    [self makeViewDidLoad];

    [self makeDelegateCodes];
    [self makeActionCodes];

    [mainDoc appendString:@"@end\n"];

    return mainDoc;
}

#pragma mark -

// Set all the gears instance name for variable on code
- (BOOL) makeGearsNames
{
    // reset whole names
    for( CSGearObject *g in USERCONTEXT.gearsArray )
        [g setVarName:nil];

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( NO == [g setDefaultVarName:nil] )
            return NO;  // Not supported gear.
    }
    return  YES;
}

- (void) makeImports
{
    NSMutableSet *imports = [[NSMutableSet alloc] init];
    BOOL isDone;

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        NSArray *lines = [g importLinesCode];
        isDone = NO;

        for( NSString *im in lines ){
            for( NSString *doneIms in imports ){
                if( [doneIms isEqualToString:im] ) isDone = YES;
            }

            if( NO == isDone ) {
                [imports addObject:im];

                // import 가 처음 등록되는 시점에, 별도 파일 요구. 특별히 제작된 class 를 사용해야 하는 경우 그 내용을 하나에 다 때려넣자.
                // 맨 알이 space 로 시작하는 customClass 는 삽입하지 않음.
                if( ![[g customClass] hasPrefix:@" "] )
                    [mainDoc appendString: [g customClass] ];
            }
        }
    }

    if( [mainDoc hasSuffix:@"\n\n"] )
        [mainDoc appendString:@"//-------------- please split here --------------------\n"];

    // OK. Inserts lines about imports.
    [mainDoc appendString:@"\n\n\n#import<Foundation/Foundation.h>\n"];
    for( NSString *im in imports )
    {
        [mainDoc appendFormat:@"#import %@\n", im];
    }
    [mainDoc appendString:@"\n"];
}

- (void) makeInterface
{
    [mainDoc appendFormat:@"@interface %@()",fileName];

    NSMutableString *delegateStr = [[NSMutableString alloc] init];
    for( CSGearObject *g in USERCONTEXT.gearsArray ) {
        if( nil != [g delegateName] && NSNotFound == [delegateStr rangeOfString:[g delegateName]].location )
        {
            if( [delegateStr length] > 0 ) [delegateStr appendString:@","];
            [delegateStr appendString:[g delegateName]];
        }
    }
    if( [delegateStr length] )
        [mainDoc appendFormat:@"<%@>",delegateStr];
    [mainDoc appendString:@"\n{\n"];

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
/// TODO: 조건확인       if( ![g isHiddenGear] )
        if( nil != [g sdkClassName] )
            [mainDoc appendFormat:@"    %@ *%@;\n",[g sdkClassName],[g getVarName] ];
    }

    [mainDoc appendString:@"}\n@end\n\n"];
}

- (void) makeViewDidLoad
{
    [mainDoc appendFormat:@"@implementation %@\n\n",fileName]; // open implementation

    [mainDoc appendString:@"-(void) viewDidLoad\n{\n"];

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        // viewdidLoad 에서 초기화 코드를 삽입하지 않는 경우.
        if( [[g customClass] isEqualToString:NO_FIRST_ALLOC] )
        {
            continue;
        }
        
        // 클래스 명이 정해지지 않으면 init 관련 코드는 작성하지 않는다.
        if( nil == [g sdkClassName] )
            continue;

        // initWithFrame 을 사용하는 초기화 코드를 삽입하는 경우
        else if( nil == [g customClass] && ![g isHiddenGear] )
        {
            [mainDoc appendFormat:@"    %@ = [[%@ alloc] initWithFrame:CGRectMake(%d,%d,%d,%d)];\n",[g getVarName],[g sdkClassName],(int)g.csView.frame.origin.x,(int)g.csView.frame.origin.y,(int)g.csView.frame.size.width,(int)g.csView.frame.size.height];
            if( 1.0 != g.csView.alpha )
                [mainDoc appendFormat:@"    [%@ setAlpha:%f];\n",[g getVarName],g.csView.alpha];

            // 만일 tableView 라면 Cell 클래스 등록을 하자
            if( nil != [g sdkClassName] && [[g sdkClassName] hasPrefix:@"UITableVi"] )
                [mainDoc appendFormat:@"    [%@ registerClass:[UITableViewCell class] forCellReuseIdentifier:@\"%@CellId\"];\n",[g getVarName],[g getVarName]];
        }
        // custom class 가 추가되고, 그 클래스를 초기화 하는 코드를 삽입하는 경우
        else
        {
            // 만일 customClass 가 한줄짜리 코드라면 그것을 init 루틴으로 사용한다. 그렇지 않으면 기본 init 한다.
            if( [[g customClass] hasSuffix:@";\n"] ){
                [mainDoc appendString:[g customClass]];
            } else {
                [mainDoc appendString:[NSString stringWithFormat:@"    %@ = [[%@ alloc] init];\n",[g getVarName],[g sdkClassName]]];
            }
            if( ![g isHiddenGear] )
                [mainDoc appendFormat:@"    [%@ setFrame:CGRectMake(%d,%d,%d,%d)];\n",[g getVarName],(int)g.csView.frame.origin.x,(int)g.csView.frame.origin.y,(int)g.csView.frame.size.width,(int)g.csView.frame.size.height];
        }

        //
        for( NSDictionary *property in [g getPropertiesList] )
        {
            // Action property & Alpha are not conerned
            if( [property[@"name"] hasPrefix:@">"] || [property[@"name"] isEqualToString:@"Alpha"] ) continue;

            // 만일 원래 Obj-c SDK 에 없는 메소드라면 추가하지 않는다. (work cont.)
            if( nil != [g sdkClassName] &&
               ([[g sdkClassName] hasPrefix:@"UI"] || [[g sdkClassName] hasPrefix:@"NS"])&&
               ![NSClassFromString( [g sdkClassName] ) instancesRespondToSelector:[property[@"selector"] pointerValue]] ) continue;

            NSString *type = property[@"type"];
            const char *sel_name_c = sel_getName([property[@"selector"] pointerValue]);
            [mainDoc appendString:[NSString stringWithFormat:@"    [%@ %@",[g getVarName],@(sel_name_c)]];

            // 각 type 에 맞게 설정하는 값을 기입하고 괄호를 닫아주자.
            if( [type isEqualToString:P_TXT] )
            {
                NSString *sText = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                [mainDoc appendString:[NSString stringWithFormat:@"@\"%@\"",sText]];
            } else if( [type isEqualToString:P_COLOR] )
            {
                UIColor *sColor = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                if( [sColor isEqual:CSCLEAR] )
                    [mainDoc appendString:@"[UIColor clearColor]"];
                else {
                    const CGFloat* components = CGColorGetComponents(sColor.CGColor);
                    if( 2 == CGColorGetNumberOfComponents(sColor.CGColor) ) {
                        if( 0.0 == components[0] )
                            [mainDoc appendString:@"[UIColor blackColor]"];
                        else if( 1.0 == components[0] )
                            [mainDoc appendString:@"[UIColor whiteColor]"];
                        else
                            [mainDoc appendFormat:@"[UIColor colorWithRed:%.1f green:%.1f blue:%.1f alpha:1.0]",components[0],components[0],components[0]];
                    } else
                        [mainDoc appendFormat:@"[UIColor colorWithRed:%.1f green:%.1f blue:%.1f alpha:1.0]",components[0],components[1],components[2]];
                }
            } else if( [type isEqualToString:P_NUM] )
            {
                NSNumber *sNum = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                NSNumberFormatter *numF = [[NSNumberFormatter alloc] init];
                [numF setMaximumIntegerDigits:10];
                [numF setMaximumFractionDigits:7];
                [mainDoc appendString:[numF stringFromNumber:sNum]];
            } else if( [type isEqualToString:P_ALIGN] )
            {
                NSNumber *alignNum = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                switch( alignNum.integerValue ){
                    case 0:
                        [mainDoc appendString:@"NSTextAlignmentLeft"]; break;
                    case 1:
                        [mainDoc appendString:@"NSTextAlignmentCenter"]; break;
                    case 2:
                        [mainDoc appendString:@"NSTextAlignmentRight"]; break;
                }
            } else if( [type isEqualToString:P_FONT] )
            {
                UIFont *sFont = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                [mainDoc appendFormat:@"[UIFont fontWithName:@\"%@\" size:%d]",sFont.fontName,(NSUInteger)sFont.pointSize];
            } else if( [type isEqualToString:P_BOOL] )
            {
                NSNumber *bNum = objc_msgSend((id)g,[property[@"getSelector"] pointerValue]);
                ([bNum boolValue]) ? [mainDoc appendString:@"YES"] : [mainDoc appendString:@"NO"] ;
            } // P_CELL & P_IMG ?
            [mainDoc appendString:@"];\n"];  // close.
        }
        if( nil != [g delegateName] )
            [mainDoc appendFormat:@"    [%@ setDelegate:self];\n",[g getVarName]];

        if( nil != [g addTargetCode] )
            [mainDoc appendString:[g addTargetCode]];

        // 눈에 보이는 기어라면 addSubview 한다.
        if( ![g isHiddenGear] ) {
            [mainDoc appendFormat:@"    [self.view addSubview:%@];\n",[g getVarName]];
        }

        [mainDoc appendString:@"\n"];
    }

    [mainDoc appendString:@"}\n\n"];
}

// delegate protocols 관련 필요한 메소드들이 추가되어야 하는 것들을 처리한다.
-(void) makeDelegateCodes
{
    NSMutableArray *dmCodeLines = [[NSMutableArray alloc] initWithCapacity:30];
    int i;

    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( nil == [g delegateCodes] ) continue;  // 추가될 필요 없으면 skip

        NSMutableArray *gDelegateCodes = [[NSMutableArray alloc] initWithArray:[g delegateCodes]];
// TODO: 여기 버그 수정.
        while( [gDelegateCodes count] )
        {
            // 앞에 추가된 같은 delegate 메소드가 있다. 내용만 추가해야 한다.
            for( i = 0; i < dmCodeLines.count ; i ++ ) {
                if( [dmCodeLines[i] isEqualToString:gDelegateCodes[0]] )
                {
                    [(NSMutableString*)(dmCodeLines[i+1]) appendString:gDelegateCodes[1]];
                    break;
                }
            }
            if( dmCodeLines.count == i ){
                // 처음 관련 코드들을 추가해야 한다. 프로토콜 등 모두 추가한다.
                [dmCodeLines addObject:(NSString*)gDelegateCodes[0]];
                [dmCodeLines addObject:[[NSMutableString alloc] initWithString:(NSString*)gDelegateCodes[1]] ];
                [dmCodeLines addObject:(NSString*)gDelegateCodes[2]];
            }
            [gDelegateCodes removeObjectsInRange:NSMakeRange(0, 3)]; // 추가된 것은 제거.
        }
//    go_next:;
    }

    if( [dmCodeLines count] )
    {
        [mainDoc appendString:@"#pragma mark - Delegates\n\n"];
        for( NSString *strs in dmCodeLines )
            [mainDoc appendString:strs];
    }
}

-(void) makeActionCodes
{
    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        NSString *ac = [g actionCode];
        if( nil == ac ) continue;  // 추가될 필요 없으면 skip

        [mainDoc appendString:ac];
    }
}

@end
