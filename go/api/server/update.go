package server

import (
	"github.com/gin-gonic/gin"
	"github.com/sunny0531/SchoolProject/api/types"
)

func (s *Server) update(c *gin.Context) {
	var requestBody types.Edit
	err := c.BindJSON(&requestBody)
	if err != nil {
		println(err.Error())
		c.AbortWithStatus(400)
	} else {
		switch requestBody.Colour {
		case "red":
			s.Count.Red += requestBody.Change
			c.Writer.WriteHeader(204)
		case "green":
			s.Count.Green += requestBody.Change
			c.Writer.WriteHeader(204)
		case "blue":
			s.Count.Blue += requestBody.Change
			c.Writer.WriteHeader(204)
		case "yellow":
			s.Count.Yellow += requestBody.Change
			c.Writer.WriteHeader(204)
		default:
			c.AbortWithStatus(400)
		}
	}
}
