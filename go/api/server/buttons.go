package server

import (
	"bufio"
	"context"
	_ "github.com/warthog618/gpiod"
	"io"
	"os"
	"os/exec"
	"strconv"
	"syscall"
)

func (s *Server) Detect() {
	if s.Cancel != nil {
		c := *s.Cancel
		c()
	}
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	s.Cancel = &cancel
	go s._detect(ctx)
}
func (s *Server) _detect(ctx context.Context) {
	cmd := exec.CommandContext("python3", "workaround.py", strconv.Itoa(s.Config.Red), strconv.Itoa(s.Config.Green), strconv.Itoa(s.Config.Blue), strconv.Itoa(s.Config.Yellow))
	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()

	err := cmd.Start()
	if err != nil {
		panic(err)
	}
	defer func(Process *os.Process, sig os.Signal) {
		println("stop")
		err := Process.Signal(sig)
		if err != nil {
			panic(err)
		}
	}(cmd.Process, syscall.SIGTERM)
	go func() {
		_, err := io.Copy(os.Stderr, stderr)
		if err != nil {
			panic(err)
		}
	}()

	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		println(scanner.Text())
		switch scanner.Text() {
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
