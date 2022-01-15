package repository

const (
	insertEmployees = "SELECT * FROM insert_employees($1::uuid,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)"
	selectEmployees = "SELECT * FROM select_employees($1,$2,$3,$4,$5,$6,$7)"
)
