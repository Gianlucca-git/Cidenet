//Package repository contains all
package repository

import (
	"database/sql"
	"fmt"
	"sync"
)

var (
	once          sync.Once
	sqlConnection *sql.DB
)

//NewSQLConnection returns a new sql connection (connection is a singleton)
func NewSQLConnection() *sql.DB {
	return sqlConnection
}

//LoadSQLConnection load default sql connection
func LoadSQLConnection() error {
	var err error

	once.Do(func() {
		err = loadSQLConnection()
	})

	return err
}

func loadSQLConnection() error {
	sqlConnection = BD()
	return nil
}

type connection struct {
	db  *sql.DB
	err error
}

func (c connection) Connection() interface{} {
	return c.db
}

func (c connection) Close() error {
	if c.err != nil {
		return c.err
	}

	return c.db.Close()
}

func (c connection) Error() error {
	if c.err != nil {
		return c.err
	}

	c.err = c.db.Ping()
	return c.err
}

func BD() *sql.DB {
	/*
			host: 'bhe1o4gbdndj06xzaufj-mysql.services.clever-cloud.com',
		    user: 'ujlakyrkypsopo9y',
		    password: 'JHWjIqZt3Tzr1ptaV2wr',
		    database: 'bhe1o4gbdndj06xzaufj'
	*/
	fmt.Println("Comienzo BD")
	bd, err := sql.Open("mysql", "ujlakyrkypsopo9y:JHWjIqZt3Tzr1ptaV2wr@tcp(bhe1o4gbdndj06xzaufj-mysql.services.clever-cloud.com:3306)/bhe1o4gbdndj06xzaufj")
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("Conectado a BD")
	return bd
}
