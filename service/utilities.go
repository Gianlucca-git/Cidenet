package service

import (
	"fmt"
	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
	"regexp"
	"strings"
	"unicode"
)

// Utilities is utilities for development
type Utilities interface {
	// Normalize Function that normalizes a string, substituting uppercase letters for lowercase letters and removing tilde
	Normalize(str string, typeExpression string) (string, error)
	// RegularExpression Dictionary of regular expressions that returns a Boolean evaluating the selected expression
	RegularExpression(str string, typeExpression string) bool
}

// NewUtil constructs a new Util
func NewUtil() Utilities {
	return &utilities{}
}

type utilities struct{}

const (
	yyyy_mm_dd = "2006-01-02"
)

func (u *utilities) Normalize(str string, typeExpression string) (string, error) {

	switch typeExpression {

	case "space":
		return strings.Replace(str, " ", "", -1), nil

	case "chars":

		var normalizer = transform.Chain(norm.NFD, runes.Remove(runes.In(unicode.Mn)), norm.NFC)
		s, _, err := transform.String(normalizer, str)
		if err != nil {
			return "", err
		}
		return s, nil
	}

	return "", nil
}

func (u *utilities) RegularExpression(str string, typeExpression string) bool {

	switch typeExpression {

	case "upper":
		expression, _ := regexp.Compile(fmt.Sprintf(`[A-Z]{%d}`, len(str)))
		return expression.MatchString(str)

	case "upper&space":
		expression, _ := regexp.Compile(fmt.Sprintf(`[A-Z\s]{%d}`, len(str)))
		return expression.MatchString(str)

	case "document":
		expression, _ := regexp.Compile(`^([a-zA-Z0-9/-]+)$`)
		return expression.MatchString(str)

	case "yyyy-mm-dd":
		expression, _ := regexp.Compile(`^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$`)
		return expression.MatchString(str)

	case "hh:mm":
		expression, _ := regexp.Compile(`^([0-1]?\d|2[0-3])(?::([0-5]?\d))?(?::([0-5]?\d))?$`)
		return expression.MatchString(str)
	}

	return false
}
