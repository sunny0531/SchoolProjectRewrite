package server

import (
	"github.com/warthog618/gpio"
	"os"
	"os/signal"
)

func (s *Server) Detect() {
	defer gpio.Close()
	err := gpio.Open()
	if err != nil {
		panic(err)
	}
	red := gpio.NewPin(s.Config.Red)
	green := gpio.NewPin(s.Config.Green)
	blue := gpio.NewPin(s.Config.Blue)
	yellow := gpio.NewPin(s.Config.Yellow)
	err1 := setup([]*gpio.Pin{red, green, blue, yellow}, s)
	if err1 != nil {
		panic(err1)
	}
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		gpio.Close()
	}()
}
func setup(pins []*gpio.Pin, s *Server) error {
	for _, p := range pins {
		p.Input()
		p.PullDown()
		err := p.Watch(gpio.EdgeRising, func(pin *gpio.Pin) {
			switch pin.Pin() {
			case s.Config.Red:
				s.Count.Red += 1
			case s.Config.Green:
				s.Count.Green += 1
			case s.Config.Blue:
				s.Count.Blue += 1
			case s.Config.Yellow:
				s.Count.Yellow += 1
			}
		})
		if err != nil {
			return err
		}
	}
	return nil
}
