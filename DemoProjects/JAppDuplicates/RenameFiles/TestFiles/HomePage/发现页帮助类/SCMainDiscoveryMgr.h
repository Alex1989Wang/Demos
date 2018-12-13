//
//  PCMainDiscoveryMgr.h
//  SelfieCamera
//
//  Created by Cc on 2016/11/17.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCMainDiscoveryMgr : NSObject

// 返回nil表示使用内置
- (NSString *)pGotDiscovertLink;

@end

/*
 
 NSLocale *locale = [NSLocale currentLocale];

 NSArray *countryArray = [NSLocale ISOCountryCodes];
 for (NSString *countryCode in countryArray)
 {
     NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
     PGLogDebug(@"countryCode = %@,  displayNameString = %@", countryCode, displayNameString);
 }
 
 countryCode = AC,  displayNameString = 阿森松岛
 countryCode = AD,  displayNameString = 安道尔
 countryCode = AE,  displayNameString = 阿拉伯联合酋长国
 countryCode = AF,  displayNameString = 阿富汗
 countryCode = AG,  displayNameString = 安提瓜和巴布达
 countryCode = AI,  displayNameString = 安圭拉
 countryCode = AL,  displayNameString = 阿尔巴尼亚
 countryCode = AM,  displayNameString = 亚美尼亚
 countryCode = AO,  displayNameString = 安哥拉
 countryCode = AQ,  displayNameString = 南极洲
 countryCode = AR,  displayNameString = 阿根廷
 countryCode = AS,  displayNameString = 美属萨摩亚
 countryCode = AT,  displayNameString = 奥地利
 countryCode = AU,  displayNameString = 澳大利亚
 countryCode = AW,  displayNameString = 阿鲁巴
 countryCode = AX,  displayNameString = 奥兰群岛
 countryCode = AZ,  displayNameString = 阿塞拜疆
 countryCode = BA,  displayNameString = 波斯尼亚和黑塞哥维那
 countryCode = BB,  displayNameString = 巴巴多斯
 countryCode = BD,  displayNameString = 孟加拉国
 countryCode = BE,  displayNameString = 比利时
 countryCode = BF,  displayNameString = 布基纳法索
 countryCode = BG,  displayNameString = 保加利亚
 countryCode = BH,  displayNameString = 巴林
 countryCode = BI,  displayNameString = 布隆迪
 countryCode = BJ,  displayNameString = 贝宁
 countryCode = BL,  displayNameString = 圣巴泰勒米
 countryCode = BM,  displayNameString = 百慕大
 countryCode = BN,  displayNameString = 文莱
 countryCode = BO,  displayNameString = 玻利维亚
 countryCode = BQ,  displayNameString = 荷兰加勒比区
 countryCode = BR,  displayNameString = 巴西
 countryCode = BS,  displayNameString = 巴哈马
 countryCode = BT,  displayNameString = 不丹
 countryCode = BV,  displayNameString = 布维岛
 countryCode = BW,  displayNameString = 博茨瓦纳
 countryCode = BY,  displayNameString = 白俄罗斯
 countryCode = BZ,  displayNameString = 伯利兹
 countryCode = CA,  displayNameString = 加拿大
 countryCode = CC,  displayNameString = 科科斯（基林）群岛
 countryCode = CD,  displayNameString = 刚果（金）
 countryCode = CF,  displayNameString = 中非共和国
 countryCode = CG,  displayNameString = 刚果（布）
 countryCode = CH,  displayNameString = 瑞士
 countryCode = CI,  displayNameString = 科特迪瓦
 countryCode = CK,  displayNameString = 库克群岛
 countryCode = CL,  displayNameString = 智利
 countryCode = CM,  displayNameString = 喀麦隆
 countryCode = CN,  displayNameString = 中国
 countryCode = CO,  displayNameString = 哥伦比亚
 countryCode = CP,  displayNameString = 克利珀顿岛
 countryCode = CR,  displayNameString = 哥斯达黎加
 countryCode = CU,  displayNameString = 古巴
 countryCode = CV,  displayNameString = 佛得角
 countryCode = CW,  displayNameString = 库拉索
 countryCode = CX,  displayNameString = 圣诞岛
 countryCode = CY,  displayNameString = 塞浦路斯
 countryCode = CZ,  displayNameString = 捷克共和国
 countryCode = DE,  displayNameString = 德国
 countryCode = DG,  displayNameString = 迪戈加西亚岛
 countryCode = DJ,  displayNameString = 吉布提
 countryCode = DK,  displayNameString = 丹麦
 countryCode = DM,  displayNameString = 多米尼克
 countryCode = DO,  displayNameString = 多米尼加共和国
 countryCode = DZ,  displayNameString = 阿尔及利亚
 countryCode = EA,  displayNameString = 休达及梅利利亚
 countryCode = EC,  displayNameString = 厄瓜多尔
 countryCode = EE,  displayNameString = 爱沙尼亚
 countryCode = EG,  displayNameString = 埃及
 countryCode = EH,  displayNameString = 西撒哈拉
 countryCode = ER,  displayNameString = 厄立特里亚
 countryCode = ES,  displayNameString = 西班牙
 countryCode = ET,  displayNameString = 埃塞俄比亚
 countryCode = FI,  displayNameString = 芬兰
 countryCode = FJ,  displayNameString = 斐济
 countryCode = FK,  displayNameString = 福克兰群岛
 countryCode = FM,  displayNameString = 密克罗尼西亚
 countryCode = FO,  displayNameString = 法罗群岛
 countryCode = FR,  displayNameString = 法国
 countryCode = GA,  displayNameString = 加蓬
 countryCode = GB,  displayNameString = 英国
 countryCode = GD,  displayNameString = 格林纳达
 countryCode = GE,  displayNameString = 格鲁吉亚
 countryCode = GF,  displayNameString = 法属圭亚那
 countryCode = GG,  displayNameString = 根西岛
 countryCode = GH,  displayNameString = 加纳
 countryCode = GI,  displayNameString = 直布罗陀
 countryCode = GL,  displayNameString = 格陵兰
 countryCode = GM,  displayNameString = 冈比亚
 countryCode = GN,  displayNameString = 几内亚
 countryCode = GP,  displayNameString = 瓜德罗普
 countryCode = GQ,  displayNameString = 赤道几内亚
 countryCode = GR,  displayNameString = 希腊
 countryCode = GS,  displayNameString = 南乔治亚岛和南桑威齐群岛
 countryCode = GT,  displayNameString = 危地马拉
 countryCode = GU,  displayNameString = 关岛
 countryCode = GW,  displayNameString = 几内亚比绍
 countryCode = GY,  displayNameString = 圭亚那
 countryCode = HK,  displayNameString = 香港（中国）
 countryCode = HM,  displayNameString = 赫德岛和麦克唐纳群岛
 countryCode = HN,  displayNameString = 洪都拉斯
 countryCode = HR,  displayNameString = 克罗地亚
 countryCode = HT,  displayNameString = 海地
 countryCode = HU,  displayNameString = 匈牙利
 countryCode = IC,  displayNameString = 加纳利群岛
 countryCode = ID,  displayNameString = 印度尼西亚
 countryCode = IE,  displayNameString = 爱尔兰
 countryCode = IL,  displayNameString = 以色列
 countryCode = IM,  displayNameString = 曼岛
 countryCode = IN,  displayNameString = 印度
 countryCode = IO,  displayNameString = 英属印度洋领地
 countryCode = IQ,  displayNameString = 伊拉克
 countryCode = IR,  displayNameString = 伊朗
 countryCode = IS,  displayNameString = 冰岛
 countryCode = IT,  displayNameString = 意大利
 countryCode = JE,  displayNameString = 泽西岛
 countryCode = JM,  displayNameString = 牙买加
 countryCode = JO,  displayNameString = 约旦
 countryCode = JP,  displayNameString = 日本
 countryCode = KE,  displayNameString = 肯尼亚
 countryCode = KG,  displayNameString = 吉尔吉斯斯坦
 countryCode = KH,  displayNameString = 柬埔寨
 countryCode = KI,  displayNameString = 基里巴斯
 countryCode = KM,  displayNameString = 科摩罗
 countryCode = KN,  displayNameString = 圣基茨和尼维斯
 countryCode = KP,  displayNameString = 朝鲜
 countryCode = KR,  displayNameString = 韩国
 countryCode = KW,  displayNameString = 科威特
 countryCode = KY,  displayNameString = 开曼群岛
 countryCode = KZ,  displayNameString = 哈萨克斯坦
 countryCode = LA,  displayNameString = 老挝
 countryCode = LB,  displayNameString = 黎巴嫩
 countryCode = LC,  displayNameString = 圣卢西亚
 countryCode = LI,  displayNameString = 列支敦士登
 countryCode = LK,  displayNameString = 斯里兰卡
 countryCode = LR,  displayNameString = 利比里亚
 countryCode = LS,  displayNameString = 莱索托
 countryCode = LT,  displayNameString = 立陶宛
 countryCode = LU,  displayNameString = 卢森堡
 countryCode = LV,  displayNameString = 拉脱维亚
 countryCode = LY,  displayNameString = 利比亚
 countryCode = MA,  displayNameString = 摩洛哥
 countryCode = MC,  displayNameString = 摩纳哥
 countryCode = MD,  displayNameString = 摩尔多瓦
 countryCode = ME,  displayNameString = 黑山
 countryCode = MF,  displayNameString = 法属圣马丁
 countryCode = MG,  displayNameString = 马达加斯加
 countryCode = MH,  displayNameString = 马绍尔群岛
 countryCode = MK,  displayNameString = 马其顿
 countryCode = ML,  displayNameString = 马里
 countryCode = MM,  displayNameString = 缅甸
 countryCode = MN,  displayNameString = 蒙古
 countryCode = MO,  displayNameString = 澳门（中国）
 countryCode = MP,  displayNameString = 北马里亚纳群岛
 countryCode = MQ,  displayNameString = 马提尼克
 countryCode = MR,  displayNameString = 毛里塔尼亚
 countryCode = MS,  displayNameString = 蒙特塞拉特
 countryCode = MT,  displayNameString = 马耳他
 countryCode = MU,  displayNameString = 毛里求斯
 countryCode = MV,  displayNameString = 马尔代夫
 countryCode = MW,  displayNameString = 马拉维
 countryCode = MX,  displayNameString = 墨西哥
 countryCode = MY,  displayNameString = 马来西亚
 countryCode = MZ,  displayNameString = 莫桑比克
 countryCode = NA,  displayNameString = 纳米比亚
 countryCode = NC,  displayNameString = 新喀里多尼亚
 countryCode = NE,  displayNameString = 尼日尔
 countryCode = NF,  displayNameString = 诺福克岛
 countryCode = NG,  displayNameString = 尼日利亚
 countryCode = NI,  displayNameString = 尼加拉瓜
 countryCode = NL,  displayNameString = 荷兰
 countryCode = NO,  displayNameString = 挪威
 countryCode = NP,  displayNameString = 尼泊尔
 countryCode = NR,  displayNameString = 瑙鲁
 countryCode = NU,  displayNameString = 纽埃
 countryCode = NZ,  displayNameString = 新西兰
 countryCode = OM,  displayNameString = 阿曼
 countryCode = PA,  displayNameString = 巴拿马
 countryCode = PE,  displayNameString = 秘鲁
 countryCode = PF,  displayNameString = 法属波利尼西亚
 countryCode = PG,  displayNameString = 巴布亚新几内亚
 countryCode = PH,  displayNameString = 菲律宾
 countryCode = PK,  displayNameString = 巴基斯坦
 countryCode = PL,  displayNameString = 波兰
 countryCode = PM,  displayNameString = 圣皮埃尔和密克隆群岛
 countryCode = PN,  displayNameString = 皮特凯恩群岛
 countryCode = PR,  displayNameString = 波多黎各
 countryCode = PS,  displayNameString = 巴勒斯坦领土
 countryCode = PT,  displayNameString = 葡萄牙
 countryCode = PW,  displayNameString = 帕劳
 countryCode = PY,  displayNameString = 巴拉圭
 countryCode = QA,  displayNameString = 卡塔尔
 countryCode = RE,  displayNameString = 留尼汪
 countryCode = RO,  displayNameString = 罗马尼亚
 countryCode = RS,  displayNameString = 塞尔维亚
 countryCode = RU,  displayNameString = 俄罗斯
 countryCode = RW,  displayNameString = 卢旺达
 countryCode = SA,  displayNameString = 沙特阿拉伯
 countryCode = SB,  displayNameString = 所罗门群岛
 countryCode = PC,  displayNameString = 塞舌尔
 countryCode = SD,  displayNameString = 苏丹
 countryCode = SE,  displayNameString = 瑞典
 countryCode = SG,  displayNameString = 新加坡
 countryCode = SH,  displayNameString = 圣赫勒拿
 countryCode = SI,  displayNameString = 斯洛文尼亚
 countryCode = SJ,  displayNameString = 斯瓦尔巴特和扬马延
 countryCode = SK,  displayNameString = 斯洛伐克
 countryCode = SL,  displayNameString = 塞拉利昂
 countryCode = SM,  displayNameString = 圣马力诺
 countryCode = SN,  displayNameString = 塞内加尔
 countryCode = SO,  displayNameString = 索马里
 countryCode = SR,  displayNameString = 苏里南
 countryCode = SS,  displayNameString = 南苏丹
 countryCode = ST,  displayNameString = 圣多美和普林西比
 countryCode = SV,  displayNameString = 萨尔瓦多
 countryCode = SX,  displayNameString = 荷属圣马丁
 countryCode = SY,  displayNameString = 叙利亚
 countryCode = SZ,  displayNameString = 斯威士兰
 countryCode = TA,  displayNameString = 特里斯坦-达库尼亚群岛
 countryCode = TC,  displayNameString = 特克斯和凯科斯群岛
 countryCode = TD,  displayNameString = 乍得
 countryCode = TF,  displayNameString = 法属南部领地
 countryCode = TG,  displayNameString = 多哥
 countryCode = TH,  displayNameString = 泰国
 countryCode = TJ,  displayNameString = 塔吉克斯坦
 countryCode = TK,  displayNameString = 托克劳
 countryCode = TL,  displayNameString = 东帝汶
 countryCode = TM,  displayNameString = 土库曼斯坦
 countryCode = TN,  displayNameString = 突尼斯
 countryCode = TO,  displayNameString = 汤加
 countryCode = TR,  displayNameString = 土耳其
 countryCode = TT,  displayNameString = 特立尼达和多巴哥
 countryCode = TV,  displayNameString = 图瓦卢
 countryCode = TW,  displayNameString = 台湾
 countryCode = TZ,  displayNameString = 坦桑尼亚
 countryCode = UA,  displayNameString = 乌克兰
 countryCode = UG,  displayNameString = 乌干达
 countryCode = UM,  displayNameString = 美国本土外小岛屿
 countryCode = US,  displayNameString = 美国
 countryCode = UY,  displayNameString = 乌拉圭
 countryCode = UZ,  displayNameString = 乌兹别克斯坦
 countryCode = VA,  displayNameString = 梵蒂冈
 countryCode = VC,  displayNameString = 圣文森特和格林纳丁斯
 countryCode = VE,  displayNameString = 委内瑞拉
 countryCode = VG,  displayNameString = 英属维京群岛
 countryCode = VI,  displayNameString = 美属维京群岛
 countryCode = VN,  displayNameString = 越南
 countryCode = VU,  displayNameString = 瓦努阿图
 countryCode = WF,  displayNameString = 瓦利斯和富图纳
 countryCode = WS,  displayNameString = 萨摩亚
 countryCode = XK,  displayNameString = 科索沃
 countryCode = YE,  displayNameString = 也门
 countryCode = YT,  displayNameString = 马约特
 countryCode = ZA,  displayNameString = 南非
 countryCode = ZM,  displayNameString = 赞比亚
 countryCode = ZW,  displayNameString = 津巴布韦
 */

