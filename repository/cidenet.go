package repository

import (
	"database/sql"
)

//CidenetManager constructs a new CidenetManager
type CidenetManager interface {
}

func NewCidenetManager(repository Type) CidenetManager {
	switch repository {
	case PostgresSQL:
		return &cidenetManager{DB: NewSQLConnection()}
	}

	return nil
}

type cidenetManager struct {
	*sql.DB
}
