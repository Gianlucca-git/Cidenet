package service

import (
	"encoding"
	"encoding/base64"
	"encoding/json"
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
	Normalize(str string) (*string, error)
	// RegularExpression Dictionary of regular expressions that returns a Boolean evaluating the selected expression
	RegularExpression(str string, typeExpression string) (bool, error)
	// EncodeCursor encode strings to base64
	EncodeCursor(list []string) string
	// DecodeCursor decode cursor base64 to string
	DecodeCursor(encodedCursor string) (string, error)
}

// NewUtil constructs a new Util
func NewUtil() Utilities {
	return utilities{}
}

type utilities struct{}

const (
	format = "2006-01-02T15-04-05"

	ContentTypeTxt = "text/plain"
	//ContentTypeDocx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
	//ContentTypeDoc  = "application/msword"
	//ContentTypeXlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
	//ContentTypeXls  = "application/vnd.ms-excel"
	//ContentTypePdf  = "application/pdf"
	//ContentTypeJpg  = "image/jpg"
	//ContentTypeJpeg = "image/jpeg"
	//ContentTypePng  = "image/png"
)

func (u utilities) Normalize(str string) (*string, error) {

	var normalizer = transform.Chain(norm.NFD, runes.Remove(runes.In(unicode.Mn)), norm.NFC)

	s, _, err := transform.String(normalizer, str)
	if err != nil {
		return nil, err
	}

	r := strings.ToLower(s)
	return &r, err
}

func (u utilities) RegularExpression(str string, typeExpression string) (bool, error) {

	switch typeExpression {

	case "letter&spaces":
		expression, err := regexp.Compile(`[A-Za-z ]`)
		return expression.MatchString(str), err

	case "dateSimple":
		// DD-MM-YYYY only
		expression, err := regexp.Compile(`(0?[1-9]|[12][0-9]|3[01])(-)(0?[1-9]|1[012])(-)((19|20)\d\d)`)
		return expression.MatchString(str), err
	}

	return false, nil
}

func (u utilities) EncodeCursor(list []string) string { //prepare tuple for store function

	var lastCursor string
	oneTime := true
	for _, value := range list {

		if oneTime {
			lastCursor = fmt.Sprintf("('%s'", value)
			oneTime = false

		} else {
			lastCursor = fmt.Sprintf("%s,'%s'", lastCursor, value)
		}
	}
	lastCursor = fmt.Sprintf("%s)", lastCursor)

	return base64.StdEncoding.EncodeToString([]byte(lastCursor))
}

func (u utilities) DecodeCursor(encodedCursor string) (string, error) {
	cursor, err := base64.StdEncoding.DecodeString(encodedCursor)
	if err != nil {
		return "", err
	}

	return string(cursor), nil
}

//----------------------------------          utilities WEB SOCKETS           ------------------------------------

func NewBinaryMarshaller(content interface{}) encoding.BinaryMarshaler {
	return &binaryMarshaller{
		Content: content,
	}
}

type binaryMarshaller struct {
	Content interface{}
}

func (b *binaryMarshaller) MarshalBinary() ([]byte, error) {
	return json.Marshal(b.Content)
}

//----------------------------------        end utilities WEB SOCKETS           ------------------------------------
