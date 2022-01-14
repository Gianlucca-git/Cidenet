package service

import "errors"

const ( //alphabetize constants
	Required      = "the field is required"
	Format        = "the format is incorrect"
	UnderflowDate = "the date is greater than today"
)

var (
	BadRequest = errors.New("bad request")
)

type ErrorResponse struct {
	Error ValidationErrors `json:"error"`
}

type ValidationErrors struct {
	FirstName            string `json:"first_name,omitempty"`
	OthersNames          string `json:"others_names,omitempty"`
	FirstLastName        string `json:"first_last_name,omitempty"`
	SecondLastName       string `json:"second_last_name,omitempty"`
	Countries            string `json:"countries,omitempty"`
	IdentificationType   string `json:"identification_type,omitempty"`
	IdentificationNumber string `json:"identification_number,omitempty"`
	Admission            string `json:"admission,omitempty"`
	RegistrationDate     string `json:"registration_date,omitempty"`
	RegistrationHours    string `json:"registration_hours,omitempty"`
	Department           string `json:"department,omitempty"`
}
