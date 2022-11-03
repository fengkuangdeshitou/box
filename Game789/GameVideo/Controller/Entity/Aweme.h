//
//  Aweme.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "MyBaseModel.h"
#import "Video.h"
#import "User.h"
#import "Music.h"


@protocol Aweme;

@class Video_text;
@class Risk_infos;
@class Cha_list;
@class Statistics;
@class Video_labels;
@class Descendants;
@class Status;
@class Aweme_share_info;
@class Label_top;
@class Text_extra;

@interface Aweme :MyBaseModel
@property (nonatomic , strong) User              * author;
@property (nonatomic , strong) Music              * music;
@property (nonatomic , assign) BOOL              cmt_swt;
@property (nonatomic , copy) NSArray<Video_text *>              * video_text;
@property (nonatomic , strong) Risk_infos              * risk_infos;
@property (nonatomic , assign) NSInteger              is_top;
@property (nonatomic , copy) NSString              * region;
@property (nonatomic , assign) NSInteger              user_digged;
@property (nonatomic , copy) NSArray<Cha_list *>              * cha_list;
@property (nonatomic , assign) BOOL              is_ads;
@property (nonatomic , assign) NSInteger              bodydance_score;
@property (nonatomic , assign) BOOL              law_critical_country;
@property (nonatomic , assign) NSInteger              author_user_id;
@property (nonatomic , assign) NSInteger              create_time;
@property (nonatomic , strong) Statistics              * statistics;
@property (nonatomic , copy) NSArray<Video_labels *>              * video_labels;
@property (nonatomic , copy) NSString              * sort_label;
@property (nonatomic , strong) Descendants              * descendants;
@property (nonatomic , copy) NSArray<Geofencing *>              * geofencing;
@property (nonatomic , assign) BOOL              is_relieve;
@property (nonatomic , strong) Status              * status;
@property (nonatomic , assign) NSInteger              vr_type;
@property (nonatomic , assign) NSInteger              aweme_type;
@property (nonatomic , copy) NSString              * aweme_id;
@property (nonatomic , strong) Video              * video;
@property (nonatomic , assign) BOOL              is_pgcshow;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , assign) NSInteger              is_hash_tag;
@property (nonatomic , strong) Aweme_share_info              * share_info;
@property (nonatomic , copy) NSString              * share_url;
@property (nonatomic , assign) NSInteger              scenario;
@property (nonatomic , strong) Label_top              * label_top;
@property (nonatomic , assign) NSInteger              rate;
@property (nonatomic , assign) BOOL              can_play;
@property (nonatomic , assign) BOOL              is_vr;
@property (nonatomic , copy) NSArray<Text_extra *>              * text_extra;


//自己的数据
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *game_download_num;
@property (nonatomic, copy) NSString *game_name;
@property (nonatomic, strong) NSDictionary *gama_size;
@property (nonatomic, strong) NSDictionary *game_image;
@property (nonatomic, copy) NSString *comment_topic_id;
@property (nonatomic, copy) NSString *cp_channel_id;
@property (nonatomic, copy) NSString *cp_game_id;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *down_type;
@property (nonatomic, strong) NSDictionary *gama_url;
@property (nonatomic, copy) NSString *game_attribute;
@property (nonatomic, copy) NSString *game_classify_type;
@property (nonatomic, copy) NSString *game_comment_num;
@property (nonatomic, copy) NSString *game_desc;
@property (nonatomic, copy) NSString *game_species_type;
@property (nonatomic, copy) NSString *game_trade_num;
@property (nonatomic, strong) NSArray *game_ur_list;
@property (nonatomic, copy) NSString *has_voucher;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *is_give_first_recharge;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *maiyou_gameid;
@property (nonatomic, copy) NSString *package_name;
@property (nonatomic, copy) NSString *reserved_total;
@property (nonatomic, copy) NSString *screen_orientation;
@property (nonatomic, copy) NSString *starting_time;
@property (nonatomic, copy) NSString *vip_ios_url;
@property (nonatomic, assign) BOOL videoIsLiked;
@property (nonatomic, assign) NSInteger videoLikeNum;
@property (nonatomic, assign) NSInteger videoShareNum;
@property (nonatomic, strong) NSArray * commentArray;
@property (nonatomic, copy) NSString *video_img_url;
@property (nonatomic, copy) NSString *liketime;
@property (nonatomic, copy) NSString *howManyPlay;

@end

@interface Video_text :MyBaseModel
@end

@interface Risk_infos :MyBaseModel
@property (nonatomic , assign) BOOL              warn;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) BOOL              risk_sink;
@property (nonatomic , assign) NSInteger              type;
@end

@interface Cha_list :MyBaseModel
@property (nonatomic , strong) User              * author;
@property (nonatomic , assign) NSInteger              user_count;
@property (nonatomic , copy) NSString              * schema;
@property (nonatomic , assign) NSInteger              sub_type;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , assign) BOOL              is_pgcshow;
@property (nonatomic , copy) NSString              * cha_name;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * cid;
@end

@interface Statistics :MyBaseModel
@property (nonatomic , assign) NSInteger              digg_count;
@property (nonatomic , copy) NSString              * aweme_id;
@property (nonatomic , assign) NSInteger              share_count;
@property (nonatomic , assign) NSInteger              play_count;
@property (nonatomic , assign) NSInteger              comment_count;
@end

@interface Video_labels :MyBaseModel
@end

@interface Descendants :MyBaseModel
@property (nonatomic , copy) NSString              * notify_msg;
@property (nonatomic , copy) NSArray<NSString *>              * platforms;
@end


@interface Status :MyBaseModel
@property (nonatomic , assign) BOOL              allow_share;
@property (nonatomic , assign) NSInteger              private_status;
@property (nonatomic , assign) BOOL              is_delete;
@property (nonatomic , assign) BOOL              with_goods;
@property (nonatomic , assign) BOOL              is_private;
@property (nonatomic , assign) BOOL              with_fusion_goods;
@property (nonatomic , assign) BOOL              allow_comment;
@end

@interface Aweme_share_info :MyBaseModel
@property (nonatomic , copy) NSString              * share_weibo_desc;
@property (nonatomic , copy) NSString              * share_title;
@property (nonatomic , copy) NSString              * share_url;
@property (nonatomic , copy) NSString              * share_desc;
@end

@interface Label_top :MyBaseModel
@property (nonatomic , copy) NSArray<NSString *>              * url_list;
@property (nonatomic , copy) NSString              * uri;
@end

@interface Text_extra :MyBaseModel
@end
