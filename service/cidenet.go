package service

import (
	"Cidenet/model/Request_Response"
	"Cidenet/repository"
)

//CidenetManager implement methods
type CidenetManager interface {
	InsertEmployees(employee *Request_Response.EmployeesRequest) (error, *ValidationErrors)
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

func (c *cidenetManager) InsertEmployees(employee *Request_Response.EmployeesRequest) (error, *ValidationErrors) {

	existError, validationErrors := c.CidenetValidator.EmployeesRequest(employee)
	if existError {
		return BadRequest, validationErrors
	}

	existError, validationErrors = c.CidenetValidator.Employees(employee)
	if existError {
		return BadRequest, validationErrors
	}

	return nil, nil
}
