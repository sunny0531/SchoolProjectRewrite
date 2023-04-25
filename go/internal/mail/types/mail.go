package mail

import (
	"github.com/emersion/go-sasl"
	"github.com/emersion/go-smtp"
	"github.com/sunny0531/SchoolProject/api/types"
	"io"
	"strings"
)

type Mail struct {
	Message   io.Reader
	Sender    *string
	Password  *string
	Receivers *[]string
}

func FromConfig(c *types.Config) Mail {
	msg := strings.NewReader(`abc`)
	return Mail{
		Message:   msg,
		Sender:    &c.Sender,
		Password:  &c.Password,
		Receivers: &c.Receiver,
	}
}
func (m Mail) Send() error {
	auth := sasl.NewPlainClient("", *m.Sender, *m.Password)
	err := smtp.SendMail("smtp.gmail.com:587", auth, *m.Sender, *m.Receivers, m.Message)
	return err
}
