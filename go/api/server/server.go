package server

import (
	"context"
	"errors"
	"github.com/emersion/go-smtp"
	"github.com/gin-gonic/gin"
	"github.com/sunny0531/SchoolProject/api/types"
	mail "github.com/sunny0531/SchoolProject/internal/mail/types"
	"log"
)

type Server struct {
	Config  *types.Config
	Router  *gin.Engine
	Address string
	Count   types.Count
	Mail    mail.Mail
	cancel  *context.CancelFunc
}

func DebugServer() *Server {
	c := types.ConfigFromFile("config.json")
	return &Server{
		Router:  gin.Default(),
		Address: "0.0.0.0:8080",
		Config:  &c,
		Mail:    mail.FromConfig(&c),
	}
}
func (s *Server) Run() {
	s.Router.GET("/count", func(c *gin.Context) {
		c.JSON(200, s.Count)
	})
	s.Router.PUT("/reset", func(c *gin.Context) {
		s.Count = types.EmptyCount()
		c.Writer.WriteHeader(204)
	})
	s.Router.GET("/setting", func(c *gin.Context) {
		c.JSON(200, s.Config)
	})
	s.Router.PUT("/setting", func(c *gin.Context) {
		var requestBody types.Config
		err := c.BindJSON(&requestBody)
		if err != nil {
			c.AbortWithStatus(400)
		} else {
			*s.Config = requestBody

			cancelFunc := *s.cancel
			cancelFunc()
			s.Detect()
			c.Writer.WriteHeader(204)
		}

	})
	s.Router.POST("/mail", func(c *gin.Context) {
		println(*s.Mail.Sender)
		err := s.Mail.Send(s.Count)
		var e *smtp.SMTPError
		if err != nil && errors.As(err, &e) {
			if e.Code == 535 {
				c.AbortWithStatusJSON(500, types.MailError{Error: "Username and Password not accepted"})
			}
		} else if err != nil {
			log.Println(err)
			c.AbortWithStatus(500)
		} else {
			c.Writer.WriteHeader(204)
		}

	})
	s.Router.POST("/update", s.update)
	s.Router.PUT("/update", func(c *gin.Context) {
		var requestBody types.Count
		err := c.BindJSON(&requestBody)
		if err != nil {
			c.AbortWithStatus(400)
		} else {
			s.Count = requestBody
			c.Writer.WriteHeader(204)
		}

	})
	err := s.Router.Run(s.Address)
	if err != nil {
		panic(err)
	}
}
