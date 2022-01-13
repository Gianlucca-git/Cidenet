package router

import (
	"Cidenet/handler"
	"github.com/gorilla/mux"
	"log"
)

func SetRoutes(router *mux.Router, h handler.Handler) {
	log.Println("ENTRE")
	//router.HandleFunc("/user", f_get).Methods("GET")
	//router.HandleFunc("/user/{id}", f_get_id).Methods("GET")
	//router.HandleFunc("/user", f_post).Methods("POST")
	//router.HandleFunc("/user/{id}", f_put).Methods("PUT")
	//router.HandleFunc("/user/{id}", f_delete).Methods("DELETE")
}
