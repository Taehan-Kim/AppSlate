//
//  TTableCell.h
//  handpoll
//
//  Created by 태한 김 on 11. 4. 15..
//  Copyright 2011 Chocolate Soft. All rights reserved.
//
//  첫 번째 탭인 인기있는 투표들 목록에서 사용될 셀 객체
//  혹은 일반적인 투표 목록에 사용됨.

#import <UIKit/UIKit.h>

@interface TTableCell : UITableViewCell
{
    UILabel  *dateLabel;
    UILabel  *nameLabel;
    UITextView  *tText;

    UIImageView *profileImg;
}

-(void) setCellData:(NSDictionary*)pData;

@end

#if 0

{
    "coordinates": null,
    "favorited": false,
    "created_at": "Fri Jul 16 16:55:52 +0000 2010",
    "truncated": false,
    "entities": {
        "urls": [
                 {
                     "expanded_url": null,
                     "url": "http://bit.ly/libraryman",
                     "indices": [
                                 78,
                                 102
                                 ]
                 }
                 ],
        "hashtags": [
        
        ],
        "user_mentions": [
                          {
                              "name": "Cal Henderson",
                              "id": 6104,
                              "indices": [
                                          108,
                                          115
                                          ],
                              "screen_name": "iamcal"
                          }
                          ]
    },
    "text": "Anything is possible when you're in the library... with a celestial sandwich: http://bit.ly/libraryman (via @iamcal)",
    "annotations": null,
    "contributors": null,
    "id": 18700688341,
    "geo": null,
    "in_reply_to_user_id": null,
    "place": {
        "name": "San Francisco",
        "country_code": "US",
        "country": "The United States of America",
        "attributes": {
            
        },
        "url": "http://api.twitter.com/1/geo/id/5a110d312052166f.json",
        "id": "5a110d312052166f",
        "bounding_box": {
            "coordinates": [
                            [
                             [
                              -122.51368188,
                              37.70813196
                              ],
                             [
                              -122.35845384,
                              37.70813196
                              ],
                             [
                              -122.35845384,
                              37.83245301
                              ],
                             [
                              -122.51368188,
                              37.83245301
                              ]
                             ]
                            ],
            "type": "Polygon"
        },
        "full_name": "San Francisco, CA",
        "place_type": "city"
    },
    "in_reply_to_screen_name": null,
    "user": {
        "name": "Daniel Burka",
        "profile_sidebar_border_color": "a655ec",
        "profile_background_tile": true,
        "profile_sidebar_fill_color": "f1ccff",
        "created_at": "Mon Jan 15 15:22:14 +0000 2007",
        "profile_image_url": "http://a3.twimg.com/profile_images/74260755/2009-square-small_normal.jpg",
        "location": "San Francisco",
        "profile_link_color": "5a0d91",
        "follow_request_sent": false,
        "url": "http://deltatangobravo.com",
        "favourites_count": 92,
        "contributors_enabled": false,
        "utc_offset": -28800,
        "id": 635543,
        "profile_use_background_image": true,
        "profile_text_color": "0C3E53",
        "protected": false,
        "followers_count": 9950,
        "lang": "en",
        "notifications": false,
        "time_zone": "Pacific Time (US & Canada)",
        "verified": false,
        "profile_background_color": "BADFCD",
        "geo_enabled": true,
        "description": "Director of design at Tiny Speck. Ex-Creative director at Digg. CSS. Design. UX. Climbing. Cycling. Chilaquiles mmm.",
        "friends_count": 219,
        "statuses_count": 806,
        "profile_background_image_url": "http://a3.twimg.com/profile_background_images/4444585/back.png",
        "following": true,
        "screen_name": "dburka"
    },
    "source": "web",
    "in_reply_to_status_id": null
},

#endif
