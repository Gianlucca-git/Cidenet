package router

import (
	"Cidenet/handler"
	"github.com/gorilla/mux"
)

func SetRoutes(router *mux.Router, handler handler.Handler) {

	router.HandleFunc("/employees", handler.CidenetManager.InsertEmployees).Methods("POST")
	router.HandleFunc("/employees", handler.CidenetManager.GetEmployees).Methods("GET")
	router.HandleFunc("/employees/{employee_id}", handler.CidenetManager.UpdateEmployees).Methods("PATCH")

}
