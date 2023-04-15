package mail

import (
	"github.com/emersion/go-sasl"
	"github.com/emersion/go-smtp"
	"github.com/sunny0531/SchoolProject/api/types"
	"io"
	"strings"
)

type Mail struct {
	Auth      sasl.Client
	Message   io.Reader
	Sender    string
	Receivers []string
}

func FromConfig(c types.Config) Mail {
	auth := sasl.NewPlainClient("", c.Sender, c.Password)
	msg := strings.NewReader(`abc`)
	return Mail{
		Auth:      auth,
		Message:   msg,
		Sender:    c.Sender,
		Receivers: c.Receiver,
	}
}
func (m Mail) Send() error {
	err := smtp.SendMail("smtp.gmail.com:587", m.Auth, m.Sender, m.Receivers, m.Message)
	return err
}
