package Request_Response

type (
	EmployeesRequest struct {
		Name                 string `json:"name"`
		OthersNames          string `json:"others_names"`
		LastName             string `json:"last_name"`
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
