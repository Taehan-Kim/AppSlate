//
//  PollTableCell.m
//  handpoll
//
//  Created by 태한 김 on 11. 4. 15..
//  Copyright 2011 Chocolate Soft. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "TTableCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation TTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 10)];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [dateLabel setFont:CS_FONT(9)];
        [dateLabel setTextColor:[UIColor grayColor]];
        [dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:dateLabel];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 9, self.frame.size.width-20, 11)];
        [nameLabel setFont:CS_BOLD_FONT(12)];
        [nameLabel setBackgroundColor:CSCLEAR];
        [self addSubview:nameLabel];

        tText = [[UITextView alloc] initWithFrame:CGRectMake(50, nameLabel.frame.size.height+10, nameLabel.frame.size.width-50, self.frame.size.height - (nameLabel.frame.size.height+10))];
        [tText setFont:CS_FONT(15)];
        [tText setUserInteractionEnabled:NO];
        [tText setEditable:NO];
        [tText setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self insertSubview:tText atIndex:0];

        profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 40, 40)];
        [profileImg.layer setShadowOffset:CGSizeMake(2, 2)];
        [profileImg.layer setShadowOpacity:0.7];
        [profileImg.layer setShadowRadius:4.0];
        [profileImg.layer setShadowColor:[UIColor blackColor].CGColor];
        [self addSubview:profileImg];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [super setSelected:NO animated:animated];
}

#pragma -

//  데이터를 받아서 셀 화면에 표시될 수 있도록 각 요소별 값을 할당한다.
-(void) setCellData:(NSDictionary*)pData
{
    if( nil == pData ) return;

    [tText setText:pData[@"text"]];
    [nameLabel setText:pData[@"user"][@"name"]];
    [dateLabel setText:[pData[@"created_at"] substringToIndex:16]]; // temp

    [profileImg setImageWithURL:[NSURL URLWithString:pData[@"user"][@"profile_image_url"]]];

    // 만일 검색 결과라면 정보가 약간 다르므로.
    if( ![nameLabel.text length] ){
        [nameLabel setText:pData[@"from_user"]];
        [profileImg setImageWithURL:[NSURL URLWithString:pData[@"profile_image_url"]]];
    }
}

-(void) drawRect:(CGRect)rect
{
    [self setNeedsLayout];
}

@end
