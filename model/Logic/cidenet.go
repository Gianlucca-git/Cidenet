package Logic

type (
	EmployeesRequest struct {
		Uuid                 string
		FirstName            string
		OthersNames          string
		firstLastName        string
		SecondLastName       string
		Countries            int
		IdentificationType   int
		IdentificationNumber string
		EmailCut             string
		Admission            string
		Registration         string
		Department           int
	}
)
