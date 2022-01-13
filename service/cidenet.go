package service

import (
	"Cidenet/repository"
)

//CidenetManager implement methods
type CidenetManager interface {
}

// NewCidenetManager Constructs a new CidenetManager
func NewCidenetManager(t repository.Type) CidenetManager {
	return &cidenetManager{
		CidenetManager:   repository.NewCidenetManager(t),
		CidenetValidator: NewCidenetValidator(),
		Utilities:        NewUtil(),
	}
}

type cidenetManager struct {
	Utilities
	CidenetValidator
	repository.CidenetManager
}
