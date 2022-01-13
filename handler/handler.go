package handler

type Handler struct {
	CidenetManager CidenetManager
}

func New() Handler {
	return Handler{}
}
