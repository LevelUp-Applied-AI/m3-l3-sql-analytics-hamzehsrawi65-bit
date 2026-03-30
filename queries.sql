-- Q1 — Employee Directory with Departments
SELECT
    e.emp_id,
    e.name AS employee_name,
    d.name AS department_name,
    e.title,
    e.salary,
    e.hire_date
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.name ASC, e.salary DESC;


-- Q2 — Department Salary Analysis
SELECT
    d.dept_id,
    d.name AS department_name,
    SUM(e.salary) AS total_salary_expenditure
FROM departments d
JOIN employees e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.name
HAVING SUM(e.salary) > 150000
ORDER BY total_salary_expenditure DESC;


-- Q3 — Highest-Paid Employee per Department
WITH ranked_employees AS (
    SELECT
        e.emp_id,
        e.name AS employee_name,
        d.name AS department_name,
        e.salary,
        ROW_NUMBER() OVER (
            PARTITION BY e.dept_id
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM employees e
    JOIN departments d
        ON e.dept_id = d.dept_id
)
SELECT
    emp_id,
    employee_name,
    department_name,
    salary
FROM ranked_employees
WHERE salary_rank = 1
ORDER BY department_name;


-- Q4 — Project Staffing Overview
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(pa.emp_id) AS assigned_employees,
    COALESCE(SUM(pa.hours_allocated), 0) AS total_hours_allocated
FROM projects p
LEFT JOIN project_assignments pa
    ON p.project_id = pa.project_id
GROUP BY p.project_id, p.name
ORDER BY p.project_id;


-- Q5 — Above-Average Departments
WITH department_avg AS (
    SELECT
        d.dept_id,
        d.name AS department_name,
        AVG(e.salary) AS department_average_salary
    FROM departments d
    JOIN employees e
        ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.name
),
company_avg AS (
    SELECT AVG(salary) AS company_average_salary
    FROM employees
)
SELECT
    da.department_name,
    ROUND(da.department_average_salary, 2) AS department_average_salary,
    ROUND(ca.company_average_salary, 2) AS company_average_salary
FROM department_avg da
CROSS JOIN company_avg ca
WHERE da.department_average_salary > ca.company_average_salary
ORDER BY da.department_average_salary DESC;


-- Q6 — Running Salary Total
SELECT
    e.emp_id,
    e.name AS employee_name,
    d.name AS department_name,
    e.hire_date,
    e.salary,
    SUM(e.salary) OVER (
        PARTITION BY e.dept_id
        ORDER BY e.hire_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_salary_total
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.name, e.hire_date;


-- Q7 — Unassigned Employees
SELECT
    e.emp_id,
    e.name AS employee_name,
    e.title,
    e.salary
FROM employees e
LEFT JOIN project_assignments pa
    ON e.emp_id = pa.emp_id
WHERE pa.assignment_id IS NULL
ORDER BY e.emp_id;


-- Q8 — Hiring Trends
WITH monthly_hires AS (
    SELECT
        EXTRACT(YEAR FROM hire_date) AS hire_year,
        EXTRACT(MONTH FROM hire_date) AS hire_month,
        COUNT(*) AS hire_count
    FROM employees
    GROUP BY EXTRACT(YEAR FROM hire_date), EXTRACT(MONTH FROM hire_date)
)
SELECT
    hire_year,
    hire_month,
    hire_count
FROM monthly_hires
ORDER BY hire_year, hire_month;


-- Q9 — Schema Design: Employee Certifications

-- 1) CREATE TABLE DDL
CREATE TABLE IF NOT EXISTS certifications (
    certification_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    issuing_org VARCHAR(255),
    level VARCHAR(50) CHECK (level IN ('Beginner', 'Intermediate', 'Advanced'))
);

CREATE TABLE IF NOT EXISTS employee_certifications (
    id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    certification_id INT NOT NULL,
    certification_date DATE NOT NULL,
    CONSTRAINT fk_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_certification
        FOREIGN KEY (certification_id)
        REFERENCES certifications(certification_id)
        ON DELETE CASCADE
);

-- 2) INSERT sample certifications
INSERT INTO certifications (name, issuing_org, level)
VALUES
    ('AWS Cloud Practitioner', 'Amazon Web Services', 'Beginner'),
    ('Google Data Analytics', 'Google', 'Intermediate'),
    ('PMP', 'Project Management Institute', 'Advanced')
ON CONFLICT DO NOTHING;

-- 3) INSERT employee-certification records
-- Assumption: emp_id values 1..5 exist in the seeded data.
INSERT INTO employee_certifications (emp_id, certification_id, certification_date)
VALUES
    (1, 1, '2024-01-15'),
    (2, 2, '2024-02-10'),
    (3, 3, '2024-03-05'),
    (4, 1, '2024-04-12'),
    (5, 2, '2024-05-20')
ON CONFLICT DO NOTHING;

-- 4) Query employees with certifications
SELECT
    e.name AS employee_name,
    c.name AS certification_name,
    c.issuing_org,
    ec.certification_date
FROM employee_certifications ec
JOIN employees e
    ON ec.emp_id = e.emp_id
JOIN certifications c
    ON ec.certification_id = c.certification_id
ORDER BY e.name, ec.certification_date;