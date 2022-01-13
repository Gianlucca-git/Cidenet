package service

import (
	"errors"
)

const ( //alphabetize constants
	Connection         = "Connection Id is required."
	Date               = "Date format is incorrect."
	FieldOrder         = "Field Order is incorrect."
	LimitRequired      = "limit is required."
	LimitInteger       = "The limit must be of type integer."
	LimitDifferentZero = "The limit must be an integer greater to zero."
	Order              = "Order is different to 'ascendant' or 'descendant'."
	State              = "State is different to 'all', 'select' or 'exception'."
	TokenNull          = "Token is null."
	TokenUser          = "User information is not in the Token."
	TokenRole          = "Role information is not in the Token."
	TokenGovernment    = "Government entity information is not in the Token."
	DownloadJson       = "Download is null"
)

type ValidationErrors struct {
	Connection         string `json:"connection,omitempty"`
	Date               string `json:"date,omitempty"`
	DownloadJson       string `json:"download-json,omitempty"`
	FieldOrder         string `json:"field_order,omitempty"`
	LimitRequired      string `json:"limit_required,omitempty"`
	LimitInteger       string `json:"limit_integer,omitempty"`
	LimitDifferentZero string `json:"limit_different-zero,omitempty"`
	Order              string `json:"order,omitempty"`
	State              string `json:"state,omitempty"`
	TokenNull          string `json:"token_null,omitempty"`
	TokenUser          string `json:"token_user,omitempty"`
	TokenRole          string `json:"token_role,omitempty"`
	TokenGovernment    string `json:"token_government,omitempty"`
}

var (

	// ErrRepository is returned when occurs an error with the repository
	ErrRepository = errors.New("unexpected error occurred with the repository")
	// ErrValidation is returned when occurs a validate error
	ErrValidation = errors.New("invalid fields")
	//ErrTooManyFiles is returned when not support too many files
	//ErrTooManyFiles = errors.New("too many files")
	//ErrInvalidFile is returned whe the file is invalid
	//ErrInvalidFile = errors.New("invalid file")
	//ErrFilesNotFound is returned when the format file is wrong
	//ErrFilesNotFound = errors.New("files not found")
	//ErrUrlParam returned when the url param is wrong
	//ErrUrlParam = errors.New("url param not found")
	// ErrWriteCsv returned hen the write file is wrong
	//ErrWriteCsv = errors.New("error writing record to csv")
	// ErrService is returned when occurs an error with the service
	//ErrService = errors.New("unexpected error occurred with the service")
)

// WrappedError use to wrap two errors in one
func WrappedError(err, details error) error {
	return wrappedError{error: err, details: details}
}

type wrappedError struct {
	error
	details error
}

func (e wrappedError) Error() string {
	return e.details.Error()
}

//Unwrap is used when comparing this wrappedError with errors.Is
func (e wrappedError) Unwrap() error {
	return e.error
}
