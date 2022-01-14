package router

import (
	"Cidenet/handler"
	"github.com/gorilla/mux"
)

func SetRoutes(router *mux.Router, handler handler.Handler) {

	router.HandleFunc("/employees", handler.CidenetManager.InsertEmployees).Methods("POST")
	router.HandleFunc("/employees", handler.CidenetManager.GetEmployees).Methods("GET")

	//router.HandleFunc("/user/{id}", f_get_id).Methods("GET")
	//router.HandleFunc("/user", f_post).Methods("POST")
	//router.HandleFunc("/user/{id}", f_put).Methods("PUT")
	//router.HandleFunc("/user/{id}", f_delete).Methods("DELETE")
}
