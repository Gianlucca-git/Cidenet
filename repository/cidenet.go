package repository

import (
	"Cidenet/model/Logic"
	"Cidenet/model/Request_Response"
	"context"
	"database/sql"
	"errors"
	"fmt"
	"github.com/lib/pq"
	uuid "github.com/satori/go.uuid"
	"strings"
)

//CidenetManager constructs a new CidenetManager
type CidenetManager interface {
	InsertEmployees(ctx context.Context, employee *Logic.Employee) error
	GetEmployees(ctx context.Context, employee *Request_Response.SelectTEmployees) (error, *Request_Response.Employees)
	UpdateEmployees(ctx context.Context, employee *Request_Response.Employee) error
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

func (c *cidenetManager) InsertEmployees(ctx context.Context, employee *Logic.Employee) error {
	prepare, err := c.DB.PrepareContext(ctx, insertEmployees)
	if err != nil {
		return err
	}

	rows, err := prepare.QueryContext(
		ctx,
		employee.Uuid,
		strings.ToLower(employee.Name),
		strings.ToLower(employee.OthersNames),
		strings.ToLower(employee.LastName),
		strings.ToLower(employee.SecondLastName),
		employee.Countries,
		employee.IdentificationType,
		employee.IdentificationNumber,
		employee.EmailCut,
		employee.Admission,
		employee.Registration,
		employee.Department,
	)

	if err != nil {
		return err
	}
	defer func() { _ = rows.Close() }()

	var response string
	if rows.Next() {

		err = rows.Scan(&response)
		if err != nil {
			return err
		}

	}

	if response == "finished successfully" {
		return nil
	}

	return errors.New(response)
}

func (c *cidenetManager) GetEmployees(ctx context.Context, employee *Request_Response.SelectTEmployees) (error, *Request_Response.Employees) {
	prepare, err := c.DB.PrepareContext(ctx, selectEmployees)
	if err != nil {
		return err, nil
	}

	rows, err := prepare.QueryContext(
		ctx,
		employee.Search,
		pq.Array(employee.Countries),
		pq.Array(employee.IdentificationsTypes),
		pq.Array(employee.Departments),
		employee.Status,
		employee.Cursor,
		employee.Limit,
	)
	if err != nil {
		return err, nil
	}
	defer func() { _ = rows.Close() }()

	var response Request_Response.Employees
	var emp Request_Response.Employee
	var total int

	for rows.Next() {

		var othersNames sql.NullString
		err = rows.Scan(
			&total,
			&emp.Id,
			&emp.Name,
			&othersNames,
			&emp.LastName,
			&emp.SecondLastName,
			&emp.Country,
			&emp.IdentificationType,
			&emp.IdentificationNumber,
			&emp.Email,
			&emp.Department,
			&emp.Status,
		)
		if err != nil {
			return err, nil
		}

		emp.OthersNames = othersNames.String

		response.Employees = append(response.Employees, emp)
	}

	if len(response.Employees) == 0 {
		return nil, nil //No content
	}

	response.LastCursor = fmt.Sprintf("('%s','%s')", emp.Name, emp.Id)
	response.TotalRegisters = total

	return nil, &response
}

func (c *cidenetManager) UpdateEmployees(ctx context.Context, employee *Request_Response.Employee) error {
	prepare, err := c.DB.PrepareContext(ctx, UpdateEmployees)
	if err != nil {
		return err
	}

	rows, err := prepare.QueryContext(
		ctx,
		employee.Id,
		strings.ToLower(employee.Name),
		strings.ToLower(employee.OthersNames),
		strings.ToLower(employee.LastName),
		strings.ToLower(employee.SecondLastName),
		employee.CountryId,
		employee.IdentificationTypeId,
		employee.IdentificationNumber,
		employee.DepartmentId,
		employee.Status,
		uuid.NewV4().String(),
	)

	if err != nil {
		return err
	}
	defer func() { _ = rows.Close() }()

	var response string
	if rows.Next() {

		err = rows.Scan(&response)
		if err != nil {
			return err
		}

	}

	if response == "finish" {
		return nil
	}

	return errors.New(response)
}
