package service

import (
	"Cidenet/model/Logic"
	"Cidenet/model/Request_Response"
	"Cidenet/repository"
	"context"
	"fmt"
	uuid "github.com/satori/go.uuid"
	"strconv"
)

//CidenetManager implement methods
type CidenetManager interface {
	InsertEmployees(ctx context.Context, employee *Request_Response.Employee) (error, *ValidationErrors)
	GetEmployees(ctx context.Context, employee *Request_Response.SelectTEmployees) (error, *ValidationErrors, *Request_Response.Employees)
	UpdateEmployees(ctx context.Context, employee *Request_Response.Employee) (error, *ValidationErrors)
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

func (c *cidenetManager) InsertEmployees(ctx context.Context, employee *Request_Response.Employee) (error, *ValidationErrors) {

	existError, validationErrors := c.CidenetValidator.InsertEmployees(employee)
	if existError {
		return BadRequest, validationErrors
	}

	existError, validationErrors = c.CidenetValidator.InsertEmployees(employee)
	if existError {
		return BadRequest, validationErrors
	}

	var emp Logic.Employee
	emp.Uuid = uuid.NewV4().String()
	emp.Name = employee.Name
	emp.OthersNames = employee.OthersNames
	emp.LastName = employee.LastName
	emp.SecondLastName = employee.SecondLastName
	emp.Countries = employee.CountryId
	emp.IdentificationType = employee.IdentificationTypeId
	emp.IdentificationNumber = employee.IdentificationNumber
	emp.EmailCut, _ = c.Utilities.Normalize(employee.LastName, "space")
	emp.EmailCut = fmt.Sprintf("%v.%v", employee.Name, emp.EmailCut)
	emp.Admission = employee.Admission
	emp.Registration = fmt.Sprintf("%v %v:00.000000", employee.RegistrationDate, employee.RegistrationHours)
	emp.Department = employee.DepartmentId

	err := c.CidenetManager.InsertEmployees(ctx, &emp)
	if err != nil {
		validationErrors.DataBase = err.Error()
		return InternalServerError, validationErrors
	}

	return nil, nil
}

func (c *cidenetManager) GetEmployees(ctx context.Context, employee *Request_Response.SelectTEmployees) (error, *ValidationErrors, *Request_Response.Employees) {
	existError, validationErrors := c.CidenetValidator.GetEmployeesRequest(employee)
	if existError {
		return BadRequest, validationErrors, nil
	}

	limit, err := strconv.Atoi(employee.Limit)
	if err != nil {
		validationErrors.Limit = err.Error()
		return InternalServerError, validationErrors, nil
	}
	if limit <= 0 {
		validationErrors.Limit = IntegerPositive
		return BadRequest, validationErrors, nil
	}

	employee.LimitInt = limit

	err, response := c.CidenetManager.GetEmployees(ctx, employee)
	if err != nil {
		validationErrors.DataBase = err.Error()
		return InternalServerError, validationErrors, nil
	}

	return nil, nil, response
}

func (c *cidenetManager) UpdateEmployees(ctx context.Context, employee *Request_Response.Employee) (error, *ValidationErrors) {

	existError, validationErrors := c.CidenetValidator.UpdateEmployees(employee)
	if existError {
		return BadRequest, validationErrors
	}

	err := c.CidenetManager.UpdateEmployees(ctx, employee)
	if err != nil {

		if err.Error() == "no update" {
			validationErrors.DataBase = err.Error()
			return nil, validationErrors
		}

		validationErrors.DataBase = err.Error()
		return InternalServerError, validationErrors
	}

	return nil, nil
}
