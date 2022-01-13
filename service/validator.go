package service

//CidenetValidator implement methods to validate cidenet fields
type CidenetValidator interface {
}

//NewCidenetValidator constructs a new CidenetValidator
func NewCidenetValidator() CidenetValidator {
	return cidenetValidator{}
}

type cidenetValidator struct{}
