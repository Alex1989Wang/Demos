package room

const (
	USER_ENTER_ROOM            = 1  // 用户进入房间
	USER_LEAVE_ROOM            = 2  // 用户退出房间
	ROOM_INFO_CHANGED          = 3  // 房间信息变更
	PRESENTER_CHANGED          = 4  // 主持人变更
	PRESENTER_SEAT_LOCKED      = 6  // 主持位被锁定
	PRESENTER_SEAT_UNLOCKED    = 7  // 主持位被解除锁定
	PRESENTER_QUIT             = 8  // 退出主持
	USER_LIVING_STATUS_CHANGED = 9  // 用户直播状态发生变更
	INVITATION_CONFIRM_RESULT  = 10 // 邀请确认通知
	USER_KICKED                = 11 // 用户被踢出房间
	USER_BAN_CHAT              = 12 // 用户被禁言
	USER_UNBAN_CHAT            = 13 // 用户被解除禁言
	USER_ENTER_QUEUE           = 14 // 用户加入队列
	USER_LEAVE_QUEUE           = 15 // 用户退出队列
	USER_QUEUE_POS_CHANGED     = 16 // 用户在队列的位置发生变化
	USER_REMOVED_FROM_QUEUE    = 17 // 用户被从队列移除
	QUEUE_LIVING_TYPE_CHANGED  = 18 // 队列直播类型发生变更
	QUEUE_LOCKED               = 19 // 队列被锁定
	QUEUE_UNLOCKED             = 20 // 队列被解除锁定
	SCREEN_CHAT_MESSAGE        = 21 // 公屏消息
	TOPLIST_CHANGED            = 22 // 用户列表排行榜发生变更
	INVITATION_CONFIRM         = 24 // 邀请确认通知
	PRESENTER_REMOVED          = 25 // 主持人被移除
)
