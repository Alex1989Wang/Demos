package room

import (
	"push_protocol"
)

type RoomMessage struct {
	push_protocol.Message

	RoomId uint64 `json:"room_id"` // 房间ID
}

type UserInfo struct {
	UUId         string `json:"uuid"`          // 设备token
	UId          uint64 `json:"uid"`           // 用户id
	Nick         string `json:"nick"`          // 昵称
	LogoUrl      string `json:"logo_url"`      // 头像地址
	Sex          uint32 `json:"sex"`           // 性别
	LivingStatus uint32 `json:"living_status"` // 开播状态
	ConsumeGolds uint32 `json:"consume_golds"` // 消费金币数
	Usercp       uint32 `json:"usercp"`        // 魅力值
}

type RoomInfo struct {
	Name    string `json:"name"`     // 房间名称
	AreaId  uint32 `json:"city_id"`  // 区域id
	Locked  bool   `json:"locked"`   // 是否上锁
	LogoUrl string `json:"logo_url"` // 房间logo
}

// 用户进入房间消息
type UserEnterRoomMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 用户离开房间消息
type UserLeaveRoomMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 房间信息变更信息
type RoomInfoChangedMessage struct {
	RoomMessage

	RInfo *RoomInfo `json:"rinfo"`
}

// 主持人变更
type PresenterChangedMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 主持人退出主持
type PresenterQuitMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 主持人被移除
type PresenterRemovedMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 主持位被锁定
type PresenterSeakLockedMessage struct {
	RoomMessage
}

// 主持位被解除锁定
type PresenterSeakUnlockedMessage struct {
	RoomMessage
}

// 用户直播状态改变
type UserLivingStatusChangedMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 邀请确认结果通知
type InvitationConfirmResultMessage struct {
	RoomMessage

	InviteUInfo *UserInfo `json:"invite_uinfo"` // 邀请人的用户信息(主持人)
	UInfo       *UserInfo `json:"uinfo"`        // 被邀请人的用户信息
	Confirm     uint32    `json:"confirm"`      // 用户的确认状态，0拒绝，1接受, 2没授权音视频权限
}

// 邀请确认通知
type InvitationConfirmMessage struct {
	RoomMessage
	InviteUInfo *UserInfo `json:"invite_uinfo"` // 邀请人的用户信息(主持人)
	UInfo       *UserInfo `json:"uinfo"`        // 被邀请人的用户信息
}

// 用户被踢出房间
type UserKickedMessage struct {
	RoomMessage

	OpUInfo *UserInfo `json:"op_uinfo"` // 操作者
	UInfo   *UserInfo `json:"uinfo"`
}

// 用户被禁言
type UserBanChatMessage struct {
	RoomMessage

	OpUInfo *UserInfo `json:"op_uinfo"` // 操作者
	UInfo   *UserInfo `json:"uinfo"`
}

// 用户被解除禁言
type UserUnbanChatMessage struct {
	RoomMessage

	OpUInfo *UserInfo `json:"op_uinfo"` // 操作者
	UInfo   *UserInfo `json:"uinfo"`
}

// 用户进入嘉宾队列
type UserEnterQueueMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
	Pos   int64     `json:"pos"` // 用户当前在嘉宾队列中的位置
}

// 用户退出嘉宾队列
type UserLeaveQueueMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 用户嘉宾队列位置发生变化
type UserQueuePosChangedMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
	Pos   uint32    // 当前的队列位置
}

// 用户被移除队列
type UserRemovedFromQueueMessage struct {
	RoomMessage

	UInfo *UserInfo `json:"uinfo"`
}

// 队列直播类型发生变更
type QueueLivingTypeChangedMessage struct {
	RoomMessage

	LivingType uint32 `json:"living_type"` // 当前的房间直播类型
	Sex        uint32 `json:"sex"`         // 队列的性别
}

// 队列被锁定
type QueueLockedMessage struct {
	RoomMessage
	Sex uint32 `json:"sex"`
}

// 队列被解除锁定
type QueueUnlockedMessage struct {
	RoomMessage
	Sex uint32 `json:"sex"`
}

// 公屏消息
type ScreenChatMessage struct {
	RoomMessage

	FromUInfo *UserInfo `json:"from_uinfo"` // 来源的用户信息
	Msg       string    `json:"msg"`
}

// 用户列表排行榜发生变更
type TopListChanged struct {
	RoomMessage

	Type uint32 `json:"type"` // 排行榜类型，1为金币排行，2为魅力值排行, 3, 金币魅力值排行同时变更
}
