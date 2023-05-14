package main

import (
	"github.com/sunny0531/SchoolProject/api/server"
)

func main() {
	s := server.DebugServer()
	s.Detect()
	s.Run()

}
