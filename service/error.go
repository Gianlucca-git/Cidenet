package service

import "errors"

const ( //alphabetize constants
	Required         = "the field is required"
	Format           = "the format is incorrect"
	UnderflowDate    = "the date is greater than today"
	OverflowDate     = "the current date is more than a month ago"
	RegistrationDate = "the registration date cannot be less than the admission date"
	IntegerPositive  = "must be greater than zero"
)

var (
	BadRequest          = errors.New("bad request")
	InternalServerError = errors.New("internal server error")
)

type ErrorResponse struct {
	Error ValidationErrors `json:"error"`
}

type ValidationErrors struct {
	Name                 string `json:"name,omitempty"`
	OthersNames          string `json:"others_names,omitempty"`
	LastName             string `json:"last_name,omitempty"`
	SecondLastName       string `json:"second_last_name,omitempty"`
	CountryId            string `json:"country_id,omitempty"`
	IdentificationTypeId string `json:"identification_type_id,omitempty"`
	IdentificationNumber string `json:"identification_number,omitempty"`
	Admission            string `json:"admission,omitempty"`
	RegistrationDate     string `json:"registration_date,omitempty"`
	RegistrationHours    string `json:"registration_hours,omitempty"`
	DepartmentId         string `json:"department_id,omitempty"`

	Status string `json:"status,omitempty"`
	Limit  string `json:"limit,omitempty"`

	DataBase string `json:"data_base,omitempty"`
}
