package Request_Response

type (
	EmployeesRequest struct {
		FirstName            string `json:"first_name"`
		OthersNames          string `json:"others_names"`
		FirstLastName        string `json:"first_last_name"`
		SecondLastName       string `json:"second_last_name"`
		Countries            int    `json:"countries"`
		IdentificationType   int    `json:"identification_type"`
		IdentificationNumber string `json:"identification_number"`
		Admission            string `json:"admission"`
		RegistrationDate     string `json:"registration_date"`
		RegistrationHours    string `json:"registration_hours"`
		Department           int    `json:"department"`
	}
)
