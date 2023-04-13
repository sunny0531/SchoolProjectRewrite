package server

import (
	"github.com/gin-gonic/gin"
	"github.com/sunny0531/SchoolProject/api/types"
)

type Server struct {
	Config  types.Config
	Router  *gin.Engine
	Address string
	Count   types.Count
}

func DebugServer() *Server {
	return &Server{
		Router:  gin.Default(),
		Address: "localhost:8080",
	}
}
func (s *Server) Run() {
	s.Count.Red = 100
	s.Router.GET("/count", func(c *gin.Context) {
		c.JSON(200, s.Count)
	})
	s.Router.PUT("/reset", func(c *gin.Context) {
		s.Count = types.EmptyCount()
		c.Writer.WriteHeader(204)
	})
	s.Router.POST("/update", func(c *gin.Context) {
		var requestBody types.Edit
		err := c.BindJSON(&requestBody)
		if err != nil {
			println(err.Error())
			c.AbortWithStatus(400)
		}
		switch requestBody.Colour {
		case "red":
			s.Count.Red += requestBody.Change
		case "green":
			s.Count.Green += requestBody.Change
		case "blue":
			s.Count.Blue += requestBody.Change
		case "yellow":
			s.Count.Yellow += requestBody.Change
		}
		c.Writer.WriteHeader(204)
	})
	err := s.Router.Run(s.Address)
	if err != nil {
		panic(err)
	}
}
