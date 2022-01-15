package handler

import (
	"Cidenet/model/Request_Response"
	"Cidenet/service"
	"encoding/json"
	"net/http"
)

type CidenetManager interface {
	InsertEmployees(w http.ResponseWriter, r *http.Request)
	GetEmployees(w http.ResponseWriter, r *http.Request)
}

func NewCidenetManager(manager service.CidenetManager) CidenetManager {
	return &cidenetManager{
		CidenetManager: manager,
	}
}

type cidenetManager struct {
	service.CidenetManager
}

func (c *cidenetManager) InsertEmployees(w http.ResponseWriter, r *http.Request) {
	defer func() {
		err := r.Body.Close()
		if err != nil {
			Response(err.Error(), http.StatusInternalServerError, w)
		}
	}()

	var employee Request_Response.Employee
	err := json.NewDecoder(r.Body).Decode(&employee)
	if err != nil {
		Response(err.Error(), http.StatusInternalServerError, w)
		return
	}

	err, validationErrors := c.CidenetManager.InsertEmployees(r.Context(), &employee)
	if err == service.BadRequest {

		var errorStruct service.ErrorResponse
		errorStruct.Error = *validationErrors
		Response(errorStruct, http.StatusBadRequest, w)
		return
	}
	if err == service.InternalServerError {

		var errorStruct service.ErrorResponse
		errorStruct.Error = *validationErrors
		Response(errorStruct, http.StatusInternalServerError, w)
		return
	}

	Response(nil, http.StatusCreated, w)

}

func (c *cidenetManager) GetEmployees(w http.ResponseWriter, r *http.Request) {
	defer func() {
		err := r.Body.Close()
		if err != nil {
			Response(err.Error(), http.StatusInternalServerError, w)
		}
	}()

	var request Request_Response.SelectTEmployees
	queryParams := r.URL.Query()
	request.Search = queryParams.Get("search")
	request.Countries = queryParams["countries"]
	request.IdentificationsTypes = queryParams["identifications_types"]
	request.Departments = queryParams["departments"]
	request.Status = queryParams.Get("status")
	request.Cursor = queryParams.Get("cursor")
	request.Limit = queryParams.Get("limit")

	err, validationErrors, response := c.CidenetManager.GetEmployees(r.Context(), &request)
	if err == service.BadRequest {

		var errorStruct service.ErrorResponse
		errorStruct.Error = *validationErrors
		Response(errorStruct, http.StatusBadRequest, w)
		return
	}
	if err == service.InternalServerError {

		var errorStruct service.ErrorResponse
		errorStruct.Error = *validationErrors
		Response(errorStruct, http.StatusInternalServerError, w)
		return
	}
	if response == nil {
		Response(nil, http.StatusNoContent, w)
	}

	Response(response, http.StatusOK, w)
}

func Response(resp interface{}, statusCode int, w http.ResponseWriter) {
	response, err := json.Marshal(resp)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		panic("error")
	}
	w.WriteHeader(statusCode)
	_, _ = w.Write(response)
}
