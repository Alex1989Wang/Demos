package push_protocol

// Push消息定义
type Message struct {
	Category string `json:"category"`
	Type     int    `json:"type"`
}
