package types

import (
	"encoding/json"
	"os"
)

type Config struct {
	Receiver []string `json:"receiver"`
	Sender   string   `json:"sender"`
	Password string   `json:"password"`
	File     os.File  `json:"-"`
}

func ConfigFromFile(filename string) Config {
	body, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	var v Config
	err2 := json.Unmarshal(body, &v)
	if err2 != nil {
		panic(err2)
	}
	return v
}
