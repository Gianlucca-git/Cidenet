package main

import (
	"log"
	"net/http"
	"time"

	"Cidenet/handler"
	repo "Cidenet/repository"
	r "Cidenet/router"
	"Cidenet/service"

	"github.com/gorilla/mux"
)

const defaultPort = "8888"

func main() {

	if err := repo.LoadSQLConnection(); err != nil {
		log.Fatal(err)
	}

	router := mux.NewRouter().StrictSlash(false) // hace las rutas diferentes entre si con slash /

	server := &http.Server{
		Addr:           ":8888",          // puerto
		Handler:        router,           //
		ReadTimeout:    10 * time.Second, // tiempo de lectura
		WriteTimeout:   10 * time.Second, // tiempo de escritura
		MaxHeaderBytes: 1 << 20,          // 1mega en bits
	}
	log.Println("listen....")
	log.Fatal(server.ListenAndServe())

	r.SetRoutes(router, initializedHandler())

}

func initializedHandler() handler.Handler {
	return handler.Handler{
		CidenetManager: handler.NewCidenetManager(service.NewCidenetManager(repo.PostgresSQL)),
	}
}
