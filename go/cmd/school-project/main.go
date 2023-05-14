package main

import (
	"github.com/sunny0531/SchoolProject/api/server"
)

func main() {
	s := server.DebugServer()
	go s.Detect()
	s.Run()

}
