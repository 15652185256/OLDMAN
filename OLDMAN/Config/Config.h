//
//  Config.h
//  MVVMTest
//

//

#ifndef MVVMTest_Config_h
#define MVVMTest_Config_h

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

//页面尺寸
#define WIDTH [UIScreen mainScreen].bounds.size.width    //屏幕宽度
#define HEIGHT [UIScreen mainScreen].bounds.size.height  //屏幕高度

//页面缩放比例
#define Than_column     MIN(WIDTH/375, 1)
#define PAGESIZE(number)   Than_column*number


//自定义颜色
#define CREATECOLOR(ONE,TWO,THREE,FOUR) [UIColor colorWithRed:ONE/255.0 green:TWO/255.0 blue:THREE/255.0 alpha:FOUR]



//页面背景
#define View_Background_Color CREATECOLOR(246, 246, 246, 1)

//头部 尾部 背景色
#define Nav_Tabbar_backgroundColor CREATECOLOR(86.0, 173.0, 216.0, 1)

//分割线颜色
#define Line_View_color CREATECOLOR(214.0, 214.0, 214.0, 1)


//列表高度
#define cell_Height (46.0)

//列表 字体 大小
#define  cell_text_font (18.0)

                                       
//题目 颜色
#define Title_text_color CREATECOLOR(51.0, 51.0, 51.0, 1)

//题目 字体大小
#define Title_text_font (20.0)


//题目 与 填空之间间隔
#define Title_Field_WH (5.0)


//填空 颜色
#define Field_text_color CREATECOLOR(153.0, 153.0, 153.0, 1)

//填空 字体大小
#define Field_text_font (16.0)

//填空 高度
#define Field_HE (39.0)



//答案 字体 颜色
#define Answer_text_color CREATECOLOR(121.0, 121.0, 121.0, 1)

//答案 字体 大小
#define Answer_text_font (18.0)


//必填项 字体 颜色
#define Tag_text_color CREATECOLOR(202.0, 52.0, 48.0, 1)

//必填项 字体 大小
#define Tag_text_font (15.0)



//返回按钮 宽度
#define Return_button_width (50.0)



//多选按钮 大小
#define Q_CHECK_ICON_WH (26.0)

//单选按钮 大小
#define Q_RADIO_ICON_WH (26.0)


//单选题 间隔
#define Q_RADIO_WH  (Q_RADIO_ICON_WH+Q_ICON_HE)



//选择题 上下间隔
#define Q_ICON_HE (10.0)

//题目行间距
#define Answer_HE (4.0)


//底部高度
#define Tabbar_HE (46.0)


//目前生活状况 特殊选项 字体颜色
#define MuQianZK_xuanXiang_Label_color CREATECOLOR(205.0, 155.0, 53.0, 1)












//登录
#define ISLOGIN @"isLogin"       //是否登录

#define UserName @"userName"     //用户名
#define PassWord @"passWord"     //密码

//#define ADDRESS @"ADDRESS"       //地址
//#define BIRTH_DATE @"BIRTH_DATE" //生日
//#define CARDID @"CARDID"         //身份证
//
//#define DOC_NAME @"DOC_NAME"     //标示 名字
//
//#define EMAIL @"EMAIL"           //邮箱
//#define GENDER @"GENDER"         //性别
//
//#define PHONE @"PHONE"           //手机
//#define QQ @"QQ"                 //QQ
//
//#define TEL @"TEL"               //固定电话

#define doc_id @"DOC_ID"         //标示 ID
#define idenity @"IDENTITY"     //角色




//推送 appKey
#define pushAppKey @"4ace39a1d52a72ada50eda64"




//测试 域名 路径
//#define Http @"http://test.oldman.yykhc.com:8080/assessment/assessmentController/"

//域名 路径
#define Http @"http://oldman.yykhc.com:8080/assessment/assessmentController/"

//#define Http @"http://182.92.172.181:8080/assessment/assessmentController/"

//#define Http @"http://192.168.3.170:8080/assessment/AssessmentController/"

//#define Http @"http://muzegroup.ngrok.cc/assessment/AssessmentController/"



//版本信息
#define GetIosVersion  Http@"getIosVersion.do"

//版本更新 下载地址
#define VersionUpdateDownloadAddress @"https://itunes.apple.com/cn/app/lao-nian-ren-ping-gu/id1084264948?l=en&mt=8"




//登录接口
#define LoginHttp  Http@"login.do"


//忘记密码
#define ForgetPasswordHttp  Http@"forgetPassword.do"


//注意事项
#define MattersNeedAttentionHttp Http@"mattersNeedAttention.do"


//查询个人信息  未开始
#define getStartGrxxHttp   Http@"getStartGrxx.do"


//查询个人信息  进行中
#define getRunningGrxxHttp  Http@"getRunningGrxx.do"


//查询其他状态
#define getgrxxHttp  Http@"getRunningInfo.do"

//查询个人信息  已完成
//#define getCompleteGrxxHttp  Http@"assessment/AssessmentController/getCompleteGrxx.do"



//状态查询
#define selectStateHttp  Http@"getAssessmentState.do"


//个人上传信息状态修改
#define updateProcessStateHttp  Http@"updateProcessState.do"


//查询各个采集评估或者建议需求的信息
#define selectResultHttp  Http@"queryAssessmentResult.do"


//上传各个采集评估或者建议需求的信息
#define insertResultHttp  Http@"addAssessmentResult.do"





//身份信息查询
#define getUserInfoHttp   Http@"getUserInfo.do"

//身份信息修改
#define updateUserInfoHttp   Http@"updateUserInfo.do"




//获取地区信息
#define getAreaHttp  Http@"getArea.do"

//获取对应的地址信息
#define getAreaByCurrentCodeHttp  Http@"getAreaByCurrentCode.do"




//获取采集初审终审信息
#define getServiceUserHttp  Http@"getServiceUser.do"

//更新医生签名
#define updateDocSignatureHttp  Http@"updateDocSignature.do"



//查询功能等级评估结果
#define getGradeAssessmentResultHttp  Http@"getGradeAssessmentResult.do"



//获取采集人数
#define getUserCountWithCollectionHttp  Http@"getUserCountWithCollection.do"


//获取评估人数
#define getUserCountWithAssessmentHttp  Http@"getUserCountWithAssessment.do"


//采集小项进展结果
#define getUserStateForCollectionHttp  Http@"getUserStateForCollection.do"

//评估小项进展结果
#define getUserStateForAssessmentHttp  Http@"getUserStateForAssessment.do"

//需求小项进展结果
#define getUserStateForXuqiuHttp  Http@"getUserStateForXuqiu.do"

//建议小项进展结果
#define getUserStateForJianyiHttp  Http@"getUserStateForJianyi.do"


//回复
#define receiveAppMessageHttp  Http@"receiveAppMessage.do"




//查询未分发信息
#define getNotDistributeForAppHttp  Http@"getNotDistributeForApp.do"

//分发用户
#define distributeByDocIdHttp  Http@"distributeByDocId.do"


#endif
