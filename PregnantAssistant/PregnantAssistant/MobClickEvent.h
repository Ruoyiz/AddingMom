//
//  MobClickEvent.h
//  PregnantAssistant
//
//  Created by D on 15/4/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#pragma once

static NSString *Jump_warmtime = @"Jump warmtime";
static NSString *Jump_secret_PA = @"Jump secret PA";
static NSString *Jump_secret_User = @"Jump secret User";

//大框架：
static NSString *adco_display = @"adco_display";
static NSString *tool_display = @"tool_display";
static NSString *lightforum_display = @"lightforum_display";
static NSString *misc_display = @"misc_display";

//看看：
//频道列表载入（事件名为contentList_load_n,  n为频道编号，包括1，2，3）
#define contentList_load_1              @"contentList_load_1"
#define contentList_load_7              @"contentList_load_7"
#define contentList_load_8              @"contentList_load_8"

#define search_click                    @"search_click"
#define search_load                     @"search_load"
#define search_media_load               @"search_media_load"
#define search_content_normal_load      @"search_content_normal_load"

static NSString *contentList_load_2 =   @"contentList_load_2";
static NSString *contentList_load_3 =   @"contentList_load_3";

static NSString *adco_content_normal_collect = @"adco_content_normal_collect";
static NSString *adco_content_video_collect = @"adco_content_video_collect";
static NSString *adco_content_normal_share = @"adco_content_normal_share";
static NSString *adco_content_video_share = @"adco_content_video_share";
static NSString *adco_content_normal_view = @"adco_content_normal_view";
static NSString *adco_content_video_view = @"adco_content_video_view";
static NSString *adco_content_normal_cancel_collecting = @"adco_content_normal_cancel_collecting";
static NSString *adco_content_video_cancel_collecting = @"adco_content_video_cancel_collecting";


//工具：
static NSString *duedate_notice_display = @"duedate_notice_display";
static NSString *duedate_notice_backward = @"duedate_notice_backward";
static NSString *duedate_notice_forward = @"duedate_notice_forward";
static NSString *tool_sort_display = @"tool_sort_display";
static NSString *tool_collect = @"tool_collect";
static NSString *tool_cancel_collecting = @"tool_cancel_collecting";

static NSString *shengaotizhong_more = @"shengaotizhong_more";
static NSString *shengaotizhong_wenzhang = @"shengaotizhong_wenzhang";
static NSString *shengaotizhong_shengaoquxian = @"shengaotizhong_shengaoquxian";
static NSString *shengaotizhong_tizhongquxian = @"shengaotizhong_tizhongquxian";
static NSString *shengaotizhong_tianjia1 = @"shengaotizhong_tianjia1";
static NSString *shengaotizhong_tianjia2 = @"shengaotizhong_tianjia2";
static NSString *shengaotizhong_dianjishuju = @"shengaotizhong_dianjishuju";

//秘密：
static NSString *lightforum_hot_display = @"lightforum_hot_display";
static NSString *lightforum_all_display = @"lightforum_all_display";
static NSString *lightforum_entry_share = @"lightforum_entry_share";
static NSString *lightforum_entry_view = @"lightforum_entry_view";

//push：
//秘密的push点击（push_lightforum_click_t_n, n 根据实际推的t值，包括1，2，3，4，100）

//static NSString *adco_content_normal_share = @"adco_content_normal_share";
//看看文章的push点击（push_adco_content_normal_click）
static NSString *push_adco_content_normal_click = @"push_adco_content_normal_click";
//看看视频的push点击（push_adco_content_video_click）
static NSString *push_adco_content_video_click = @"push_adco_content_video_click";

static NSString *tab_kankan = @"tab_kankan";
static NSString *tab_mimi = @"tab_mimi";
static NSString *tab_gongju = @"tab_gongju";
static NSString *tab_gengduo = @"tab_gengduo";

static NSString *yuerxiangqing_feed = @"yuerxiangqing_feed";
static NSString *yuerxiangqing_tab_top = @"yuerxiangqing_tab_top";

static NSString *yuerwenjuandiaocha = @"yuerwenjuandiaocha";
static NSString *yueryimiaotixing = @"yueryimiaotixing";

//收藏身高体重	collect_shengaotizhong
//收藏问卷调查	collect_wenjuandiaocha
//收藏疫苗提醒	collect_yimiaotixing


//static NSString *yimiaotixing_addHIB = @"yimiaotixing_addHIB";
//static NSString *yimiaotixing_addwulian = @"yimiaotixing_addwulian";
//static NSString *yimiaotixing_addlunzhuang = @"yimiaotixing_addlunzhuang";
//
//static NSString *yimiaotixing_add7jia = @"yimiaotixing_add7jia";
//static NSString *yimiaotixing_addliugan = @"yimiaotixing_addliugan";
//static NSString *yimiaotixing_addshuidou = @"yimiaotixing_addshuidou";
//static NSString *yimiaotixing_add23jia = @"yimiaotixing_add23jia";
//
//static NSString *yimiaotixing_delHIB = @"tab_kankan";
//static NSString *yimiaotixing_delwulian = @"tab_kankan";
//static NSString *yimiaotixing_dellunzhuang = @"tab_kankan";
//static NSString *yimiaotixing_del7jia = @"tab_kankan";
//static NSString *yimiaotixing_delliugan = @"tab_kankan";
//static NSString *yimiaotixing_delshuidou = @"tab_kankan";
//static NSString *yimiaotixing_del23jia = @"tab_kankan";

static NSString *yimiaotixing_zhishitixing = @"yimiaotixing_zhishitixing";
static NSString *yimiaotixing_zifeiyimiao = @"yimiaotixing_zifeiyimiao";
static NSString *yimiaotixing_yimiaoxiangqing = @"yimiaotixing_yimiaoxiangqing";

#define adco_content_normal_comment_load  @"adco_content_normal_comment_load"
#define adco_content_normal_load @"adco_content_normal_load_duration"
#define media_load @"media_load"
#define media_rss_1 @"media_rss_1"
#define media_rss_0 @"media_rss_0"
#define media_share @"media_share"
#define media_rss_list_load @"media_rss_list_load"
#define media_add @"media_add"
#define media_search @"media_search"


