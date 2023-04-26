package server

import (
	"context"
	"github.com/warthog618/gpiod"
	_ "github.com/warthog618/gpiod"
	"github.com/warthog618/gpiod/device/rpi"
	"strconv"
)

func (s *Server) Detect() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	s.cancel = &cancel
	s._detect(ctx)
}
func (s *Server) _detect(ctx context.Context) {
	println("hi")
	c, _ := gpiod.NewChip("gpiochip0")
	defer c.Close()

	for _, e := range []int{s.Config.Red, s.Config.Green, s.Config.Blue, s.Config.Yellow} {
		println(rpi.MustPin("j8p" + strconv.Itoa(e)))
		t, err := c.RequestLine(rpi.MustPin("j8p"+strconv.Itoa(e)), gpiod.WithEventHandler(func(event gpiod.LineEvent) {
			println(event.Offset)
			switch event.Offset {

			case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Red)):
				s.Count.Red += 1
			case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Green)):
				s.Count.Green += 1
			case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Blue)):
				s.Count.Blue += 1
			case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Yellow)):
				s.Count.Yellow += 1
			}
		}))
		a, _ := t.Info()
		println(a.Consumer)
		if err != nil {
			panic(err)
		}

		defer func(t *gpiod.Line) {
			err := t.Close()
			if err != nil {
				panic(err)
			}
		}(t)
		/*
			info, err := c.WatchLineInfo(rpi.MustPin("j8p"+strconv.Itoa(e)), func(event gpiod.LineInfoChangeEvent) {
				println(event.Info.Offset)
				switch event.Info.Offset {

				case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Red)):
					s.Count.Red += 1
				case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Green)):
					s.Count.Green += 1
				case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Blue)):
					s.Count.Blue += 1
				case rpi.MustPin("j8p" + strconv.Itoa(s.Config.Yellow)):
					s.Count.Yellow += 1
				}
			})
			println(info.Name)
			if err != nil {
				panic(err)
			}
		*/
	}

	select {
	case <-ctx.Done():
		err := c.Close()
		if err != nil {
			panic(err)
		}
	}
}
