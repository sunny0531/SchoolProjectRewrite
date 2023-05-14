package mail

import (
	"bytes"
	"fmt"
	"github.com/emersion/go-sasl"
	"github.com/emersion/go-smtp"
	"github.com/sunny0531/SchoolProject/api/types"
	"strings"
	"text/template"
)

type Mail struct {
	Sender    *string
	Password  *string
	Receivers *[]string
}

func FromConfig(c *types.Config) Mail {

	return Mail{
		Sender:    &c.Sender,
		Password:  &c.Password,
		Receivers: &c.Receiver,
	}
}
func (m Mail) Send(c types.Count) error {
	total := float64(c.Red + c.Green + c.Blue + c.Yellow)
	if total == 0 {
		auth := sasl.NewPlainClient("", *m.Sender, *m.Password)
		err := smtp.SendMail("smtp.gmail.com:587", auth, *m.Sender, *m.Receivers, strings.NewReader("No button is pressed"))
		return err
	} else {
		rp := fmt.Sprintf("%.2f", float64(c.Red)/total)
		gp := fmt.Sprintf("%.2f", float64(c.Green)/total)
		bp := fmt.Sprintf("%.2f", float64(c.Blue)/total)
		yp := fmt.Sprintf("%.2f", float64(c.Yellow)/total)
		data := map[string]interface{}{"total": total, "red": c.Red, "green": c.Green, "blue": c.Blue, "yellow": c.Yellow, "rp": rp, "gp": gp, "bp": bp, "yp": yp}
		tmpl, err := template.New("").Parse(`
Report:
Red: {{.red}} {{.rp}}
Green: {{.green}} {{.gp}}
Blue: {{.blue}} {{.bp}}
Yellow: {{.yellow}} {{.yp}}
`)
		if err != nil {
			panic(err)
		}
		var b bytes.Buffer
		err = tmpl.Execute(&b, data)
		if err != nil {
			panic(err)
		}
		auth := sasl.NewPlainClient("", *m.Sender, *m.Password)
		err = smtp.SendMail("smtp.gmail.com:587", auth, *m.Sender, *m.Receivers, strings.NewReader(b.String()))
		return err
	}
}
