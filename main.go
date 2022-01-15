package main

import (
	r "Cidenet/router"
	"log"
	"net/http"
	"time"

	"Cidenet/handler"
	repo "Cidenet/repository"
	"Cidenet/service"

	"github.com/gorilla/mux"
)

const defaultPort = ":8888"

func main() {

	if err := repo.LoadSQLConnection(); err != nil {
		log.Fatal(err)
	}

	router := mux.NewRouter().StrictSlash(false) // make the paths different from each other with slash /

	server := &http.Server{
		Addr:           defaultPort,      // port
		Handler:        router,           //
		ReadTimeout:    10 * time.Second, // reading time
		WriteTimeout:   10 * time.Second, // writing time
		MaxHeaderBytes: 1 << 20,          // 1mega in bits
	}
	log.Println("listen....")
	r.SetRoutes(router, initializedHandler())

	log.Fatal(server.ListenAndServe())
}

func initializedHandler() handler.Handler {
	return handler.Handler{
		CidenetManager: handler.NewCidenetManager(service.NewCidenetManager(repo.PostgresSQL)),
	}
}
