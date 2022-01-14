package service

import (
	"Cidenet/model/Request_Response"
	"time"
)

type CidenetValidator interface {
	EmployeesRequest(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors)
	Employees(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors)
}

func NewCidenetValidator() CidenetValidator {
	return &cidenetValidator{
		Utilities: NewUtil(),
	}
}

type cidenetValidator struct {
	Utilities
}

//EmployeesRequest validate that the required fields arrive
func (v *cidenetValidator) EmployeesRequest(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors) {
	var newErrors ValidationErrors
	var existError bool

	if len(employee.FirstName) == 0 {
		newErrors.FirstName = Required
		existError = true
	}
	if len(employee.FirstLastName) == 0 {
		newErrors.FirstLastName = Required
		existError = true
	}
	if len(employee.SecondLastName) == 0 {
		newErrors.SecondLastName = Required
		existError = true
	}
	if employee.Countries == 0 {
		newErrors.Countries = Required
		existError = true
	}
	if employee.IdentificationType == 0 {
		newErrors.IdentificationType = Required
		existError = true
	}
	if len(employee.Admission) == 0 {
		newErrors.Admission = Required
		existError = true
	}
	if len(employee.RegistrationDate) == 0 {
		newErrors.RegistrationDate = Required
		existError = true
	}
	if len(employee.RegistrationHours) == 0 {
		newErrors.RegistrationHours = Required
		existError = true
	}

	return existError, &newErrors
}

//Employees validate that the fields are in the correct format
func (v *cidenetValidator) Employees(employee *Request_Response.EmployeesRequest) (bool, *ValidationErrors) {
	var newErrors ValidationErrors
	var existError bool

	if ok := v.Utilities.RegularExpression(employee.FirstName, "upper"); len(employee.FirstName) > 20 || !ok {
		newErrors.FirstName = Format
		existError = true
	}

	if ok := v.Utilities.RegularExpression(employee.FirstLastName, "upper"); len(employee.FirstLastName) > 20 || !ok {
		newErrors.FirstLastName = Format
		existError = true
	}
	if ok := v.Utilities.RegularExpression(employee.SecondLastName, "upper"); len(employee.SecondLastName) > 20 || !ok {
		newErrors.SecondLastName = Format
		existError = true
	}
	if len(employee.OthersNames) > 0 {
		if ok := v.Utilities.RegularExpression(employee.OthersNames, "upper&space"); len(employee.OthersNames) > 50 || !ok {
			newErrors.OthersNames = Format
			existError = true
		}
	}

	// validate dates
	if ok := v.Utilities.RegularExpression(employee.Admission, "yyyy-mm-dd"); !ok {
		newErrors.Admission = Format
		existError = true
	} else {

		timeInput, err := time.Parse(yyyy_mm_dd, employee.Admission)
		if err != nil {
			panic(err)
		}
		if timeInput.After(time.Now()) {
			newErrors.Admission = UnderflowDate
			existError = true
		}
	}

	if ok := v.Utilities.RegularExpression(employee.RegistrationDate, "yyyy-mm-dd"); !ok {
		newErrors.RegistrationDate = Format
		existError = true
	}
	if ok := v.Utilities.RegularExpression(employee.RegistrationHours, "hh:mm"); !ok {
		newErrors.RegistrationHours = Format
		existError = true
	}

	return existError, &newErrors
}
