package service

import (
	"Cidenet/model/Logic"
	"Cidenet/model/Request_Response"
	"Cidenet/repository"
	"fmt"
	uuid "github.com/satori/go.uuid"
	"log"
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

	var emp Logic.Employee
	emp.Uuid = uuid.NewV4().String()
	emp.Name = employee.Name
	emp.OthersNames = employee.OthersNames
	emp.LastName = employee.LastName
	emp.SecondLastName = employee.SecondLastName
	emp.Countries = employee.Countries
	emp.IdentificationType = employee.IdentificationType
	emp.IdentificationNumber = employee.IdentificationNumber
	emp.EmailCut, _ = c.Utilities.Normalize(employee.LastName, "space")
	emp.EmailCut = fmt.Sprintf("%v.%v", employee.Name, emp.EmailCut)
	emp.Admission = employee.Admission
	emp.Registration = fmt.Sprintf("%v %v:00.000000", employee.RegistrationDate, employee.RegistrationHours)
	emp.Department = employee.Department

	log.Println("LOGIC ", emp)
	return nil, nil
}
