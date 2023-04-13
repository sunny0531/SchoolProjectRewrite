package types

type Count struct {
	Red    int `json:"red"`
	Green  int `json:"green"`
	Blue   int `json:"blue"`
	Yellow int `json:"yellow,omitempty"`
}

func EmptyCount() Count {
	return Count{
		Red:    0,
		Green:  0,
		Blue:   0,
		Yellow: 0,
	}
}
