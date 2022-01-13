package handler

import (
	"Cidenet/service"
)

type CidenetManager interface {
}

func NewCidenetManager(manager service.CidenetManager) CidenetManager {
	return &cidenetManager{
		CidenetManager: manager,
	}
}

type cidenetManager struct {
	service.CidenetManager
}
