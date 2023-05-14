package server

import (
	"bufio"
	"context"
	_ "github.com/warthog618/gpiod"
	"io"
	"os"
	"os/exec"
	"strconv"
)

func (s *Server) Detect() bool {
	if s.Cancel != nil {
		c := *s.Cancel
		c()
		s.Cancel = nil
	}
	ctx, cancel := context.WithCancel(context.Background())
	s.Cancel = &cancel
	succeed := make(chan bool)
	go s._detect(ctx, succeed)
	return <-succeed
}
func (s *Server) _detect(ctx context.Context, succeed chan bool) {
	cmd := exec.CommandContext(ctx, "python3", "workaround.py", strconv.Itoa(s.Config.Red), strconv.Itoa(s.Config.Green), strconv.Itoa(s.Config.Blue), strconv.Itoa(s.Config.Yellow))
	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()

	err := cmd.Start()
	if err != nil {
		println(err)
	}
	go func() {
		_, err := io.Copy(os.Stderr, stderr)
		if err != nil {
			println(err)
		}
	}()
	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		println(scanner.Text())
		switch scanner.Text() {
		case "succeed":
			succeed <- true
		case "failed":
			succeed <- false
		case strconv.Itoa(s.Config.Red):
			s.Count.Red += 1
		case strconv.Itoa(s.Config.Green):
			s.Count.Green += 1
		case strconv.Itoa(s.Config.Blue):
			s.Count.Blue += 1
		case strconv.Itoa(s.Config.Yellow):
			s.Count.Yellow += 1
		}
	}
}
