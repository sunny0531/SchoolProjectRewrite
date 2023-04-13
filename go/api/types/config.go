package types

import "os"

type Config struct {
	Receiver []string `json:"receiver"`
	Sender   string   `json:"sender"`
	Password string   `json:"password"`
	File     os.File  `json:"-"`
}
