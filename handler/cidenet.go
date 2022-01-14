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
	//w.Header().Set("Content-Type", "application/json")
	defer func() {
		err := r.Body.Close()
		if err != nil {
			Response(err.Error(), http.StatusInternalServerError, w)
		}
	}()

	var employee Request_Response.EmployeesRequest
	err := json.NewDecoder(r.Body).Decode(&employee)
	if err != nil {
		Response(err.Error(), http.StatusInternalServerError, w)
		return
	}

	err, validationErrors := c.CidenetManager.InsertEmployees(&employee)
	if err == service.BadRequest {

		var errorStruct service.ErrorResponse
		errorStruct.Error = *validationErrors
		Response(errorStruct, http.StatusBadRequest, w)
		return
	}

	Response(employee, 200, w)

}

func (c *cidenetManager) GetEmployees(w http.ResponseWriter, r *http.Request) {
	defer func() {
		err := r.Body.Close()
		if err != nil {
			Response(err.Error(), http.StatusInternalServerError, w)
		}
	}()

	Response("{'Gian':'saluda'}", 200, w)
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
