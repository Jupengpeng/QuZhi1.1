//
//  Define.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-1.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#ifndef KnowledgeAndWisdom_Define_h
#define KnowledgeAndWisdom_Define_h

#define kScreenSize [UIScreen mainScreen].bounds.size
#define myBlue [UIColor colorWithRed:0 green:0.6f blue:1 alpha:0.95]

#define kRowheight (kScreenSize.width*1.78-70)/6+10
#define previousType @"previousPop"
#define rootType @"rootPop"
//今日热闹接口：
//http://news-at.zhihu.com/api/4/stories/latest?client=0
#define kFirstScrollUrl @"http://news-at.zhihu.com/api/4/stories/latest?client=0"

//%@是日期
//http://news-at.zhihu.com/api/4/stories/before/20150628?client=0
#define kFirstPageUrl @"http://news-at.zhihu.com/api/4/stories/before/%@?client=0"

#define kDate @"20150703"

//进入界面图片接口：
//http://news-at.zhihu.com/api/4/start-image/640*960?client=0
//%@为屏幕分辨率
#define kCover @"http://news-at.zhihu.com/api/4/start-image/%@?client=0"



//提示登录接口：
//http://news-at.zhihu.com/api/4/notifications/count

//新闻分类描述
//http://news-at.zhihu.com/api/4/themes
#define kTypeUrl @"http://news-at.zhihu.com/api/4/themes"
//今日热闹详情页
//http://news-at.zhihu.com/api/4/story/4831703

#define kStoryDetailUrl @"http://news-at.zhihu.com/api/4/story/%d"
//%d为id
#define kWebViewUrl @"http://daily.zhihu.com/story/%d"

//今日热闹详情页评论个数
//http://news-at.zhihu.com/api/4/story-extra/4831703

#define kcommentsCountUrl @"http://news-at.zhihu.com/api/4/story-extra/%d"

//新闻通用接口
#define kNewsUrl @"http://news-at.zhihu.com/api/4/theme/%d"
//以前的新闻通用接口
#define kNewsBeforeUrl @"http://news-at.zhihu.com/api/4/theme/%d/before/%d"

#define kLongCommentsUrl @"http://news-at.zhihu.com/api/4/story/%d/long-comments"
#define kShotCommentsUrl @"http://news-at.zhihu.com/api/4/story/%d/short-comments"

//日常心理学界面 %d = 13
#define DailyId 13
//电影日报界面%d = 3
#define MovieId 3
//用户推荐日报学界面%d =12
#define UserRecId 12
//不许无聊界面%d =11
#define InterestingId 11
//设计日报界面%d =4
#define DesignId 4
//大公司日报界面%d =5
#define CompanyId 5
//财经日报界面%d =6
#define FinanceId 6
//互联网安全%d =10
#define InternetId 10
//开始游戏%d =9
#define GameId 9
//音乐日报%d =7
#define MusicId 7
//动漫日报%d 1
#define AnimationId 2
//体育日报%d =8
#define SportsId 8



//国家地理
//主页接口
//
//http://dili.bdatu.com/jiekou/main/p1.html
#define kPicHomeUrl @"http://dili.bdatu.com/jiekou/main/p%@.html"
//详情
//http://dili.bdatu.com/jiekou/album/a871.html

#define kPicDetailUrl @"http://dili.bdatu.com/jiekou/album/a%@.html"

//
//
//根视图控制器 跳转
//self.view.window  present…

#ifndef __UpLine__
//变参宏
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#endif
