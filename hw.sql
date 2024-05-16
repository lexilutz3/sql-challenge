DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    emp_no VARCHAR,
    emp_title_id VARCHAR,
    birth_date DATE,
    first_name VARCHAR,
    last_name VARCHAR,
    sex VARCHAR,
    hire_date DATE,
    PRIMARY KEY (emp_no)
);

ALTER TABLE Employees
RENAME COLUMN emp_title_id TO title_id;

ALTER TABLE Employees
    ADD CONSTRAINT fk_title_id FOREIGN KEY (title_id) REFERENCES Titles(title_id),
    ADD CONSTRAINT fk_emp_no_salaries FOREIGN KEY (emp_no) REFERENCES Salaries(emp_no);
	
SELECT * FROM Employees;

SELECT emp_no, COUNT(*) AS count
FROM Employees
GROUP BY emp_no
HAVING COUNT(*) > 1;

COPY Employees
FROM '/Users/cillian/Downloads/Starter_Code 5/data/employees.csv'
DELIMITER ','
CSV HEADER;

---

DROP TABLE IF EXISTS Titles;
CREATE TABLE Titles (
    title_id VARCHAR,
    title VARCHAR,
    PRIMARY KEY (title_id)
);

SELECT * FROM Titles;

SELECT title_id, COUNT(*) AS count
FROM Titles
GROUP BY title_id
HAVING COUNT(*) > 1;

COPY Titles
FROM '/Users/cillian/Downloads/Starter_Code 5/data/titles.csv'
DELIMITER ','
CSV HEADER;

---

DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
    dept_no VARCHAR,
    dept_name VARCHAR,
    PRIMARY KEY (dept_no)
);

SELECT * FROM Departments;

SELECT dept_no, COUNT(*) AS count
FROM Departments
GROUP BY dept_no
HAVING COUNT(*) > 1;

COPY Departments
FROM '/Users/cillian/Downloads/Starter_Code 5/data/departments.csv'
DELIMITER ','
CSV HEADER;

---

DROP TABLE IF EXISTS Dept_Manager;
CREATE TABLE Dept_Manager (
    dept_no VARCHAR,
    emp_no VARCHAR,
    PRIMARY KEY (emp_no)
);

ALTER TABLE Dept_Manager
	ADD CONSTRAINT fk_emp_no_dept_manager FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	ADD CONSTRAINT fk_dept_no FOREIGN KEY (dept_no) REFERENCES Departments(dept_no);


SELECT * FROM Dept_Manager;

SELECT emp_no COUNT(*) AS count
FROM Dept_Manager
GROUP BY emp_no
HAVING COUNT(*) > 1;

COPY Dept_Manager
FROM '/Users/cillian/Downloads/Starter_Code 5/data/dept_manager.csv'
DELIMITER ','
CSV HEADER;

---

DROP TABLE IF EXISTS Dept_Emp;
CREATE TABLE Dept_Emp (
    emp_no VARCHAR,
    dept_no VARCHAR,
	PRIMARY KEY (emp_no, dept_no)
);

ALTER TABLE Dept_Emp
	ADD CONSTRAINT fk_emp_no_dept_emp FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
    ADD CONSTRAINT fk_dept_no_dept_emp FOREIGN KEY (dept_no) REFERENCES Departments(dept_no);

SELECT * FROM Dept_Emp;

SELECT emp_no, dept_no, COUNT(*) AS count
FROM Dept_Emp
GROUP BY emp_no, dept_no
HAVING COUNT(*) > 1;

COPY Dept_Emp
FROM '/Users/cillian/Downloads/Starter_Code 5/data/dept_emp.csv'
DELIMITER ','
CSV HEADER;

---

DROP TABLE IF EXISTS Salaries;
CREATE TABLE Salaries (
    emp_no VARCHAR,
    salary INT,
    PRIMARY KEY (emp_no)
);

ALTER TABLE Salaries
	ADD CONSTRAINT fk_emp_no_salaries FOREIGN KEY (emp_no) REFERENCES Employees(emp_no);

SELECT * FROM Salaries;

SELECT emp_no, COUNT(*) AS count
FROM Salaries
GROUP BY emp_no
HAVING COUNT(*) > 1;

COPY Salaries
FROM '/Users/cillian/Downloads/Starter_Code 5/data/salaries.csv'
DELIMITER ','
CSV HEADER;

---

ALTER TABLE Employees DROP CONSTRAINT IF EXISTS fk_title_id;
ALTER TABLE Employees DROP CONSTRAINT IF EXISTS fk_emp_no_salaries;

ALTER TABLE Salaries DROP CONSTRAINT IF EXISTS fk_emp_no_salaries;

ALTER TABLE Dept_Emp DROP CONSTRAINT IF EXISTS fk_emp_no_dept_emp;

ALTER TABLE Dept_Manager DROP CONSTRAINT IF EXISTS fk_emp_no_dept_manager;
ALTER TABLE Dept_Manager DROP CONSTRAINT IF EXISTS fk_dept_no;

-

ALTER TABLE Dept_Manager
ADD CONSTRAINT fk_emp_no_dept_manager FOREIGN KEY (emp_no) REFERENCES Employees(emp_no);

ALTER TABLE Employees
ADD CONSTRAINT fk_title_id FOREIGN KEY (title_id) REFERENCES Titles(title_id);

ALTER TABLE Employees
ADD CONSTRAINT fk_emp_no_salaries FOREIGN KEY (emp_no) REFERENCES Salaries(emp_no);

ALTER TABLE Salaries
ADD CONSTRAINT fk_emp_no_salaries FOREIGN KEY (emp_no) REFERENCES Employees(emp_no);

ALTER TABLE Dept_Emp
ADD CONSTRAINT fk_emp_no_dept_emp FOREIGN KEY (emp_no) REFERENCES Employees(emp_no);

ALTER TABLE Dept_Manager
ADD CONSTRAINT fk_dept_no FOREIGN KEY (dept_no) REFERENCES Departments(dept_no);


----------------

---List the employee number, last name, first name, sex, and salary of each employee.

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM Employees
JOIN Salaries ON employees.emp_no = salaries.emp_no;

---List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM Employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

---List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT departments.dept_name, dept_manager.dept_no, dept_manager.emp_no, employees.first_name, employees.last_name
FROM Dept_Manager
JOIN Departments ON dept_manager.dept_no = departments.dept_no
JOIN Employees ON dept_manager.emp_no = employees.emp_no;

---List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT employees.first_name, employees.last_name, dept_emp.emp_no, departments.dept_name, dept_emp.dept_no
FROM Dept_Emp
JOIN Departments ON dept_emp.dept_no = departments.dept_no
JOIN Employees ON dept_emp.emp_no = employees.emp_no;

---List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT first_name, last_name, sex
FROM Employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

---List each employee in the Sales department, including their employee number, last name, and first name.

SELECT employees.first_name, employees.last_name, dept_emp.emp_no, departments.dept_name
FROM Dept_Emp
JOIN Employees ON dept_emp.emp_no = employees.emp_no
JOIN Departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

---List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT employees.first_name, employees.last_name, dept_emp.emp_no, departments.dept_name
FROM Dept_Emp
JOIN Employees ON dept_emp.emp_no = employees.emp_no
JOIN Departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development';

---List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT (*) AS counts
FROM Employees
GROUP BY last_name
ORDER BY counts DESC;