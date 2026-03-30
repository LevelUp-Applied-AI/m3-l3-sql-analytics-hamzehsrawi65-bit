# KPI Brief — Levant Tech Solutions

## 1) Department Salary Expenditure
**Definition:** Total salary expenditure per department, calculated using the employees and departments tables with `SUM(salary)` grouped by department.  
**Current value:** Use the output of Q2 to identify departments with salary expenditure above 150,000.  
**Interpretation:** This KPI shows which departments have the highest payroll cost and helps management monitor budget concentration across teams.

## 2) Project Staffing Ratio
**Definition:** Number of assigned employees per project, calculated from the projects and project_assignments tables using `COUNT(emp_id)` per project.  
**Current value:** Use the output of Q4 for the staffing count of each project.  
**Interpretation:** This KPI indicates whether projects are lightly staffed, fully staffed, or potentially overstaffed.

## 3) Total Allocated Project Hours
**Definition:** Sum of `hours_allocated` for each project, calculated from the project_assignments table and grouped by project.  
**Current value:** Use the output of Q4 for the total hours allocated to each project.  
**Interpretation:** This KPI helps track project workload and can highlight projects that may require more resources or closer monitoring.

## 4) Above-Average Department Salary
**Definition:** Average salary by department compared with the overall company average salary, calculated using Q5.  
**Current value:** Use the output of Q5 to identify departments whose average salary exceeds the company-wide average.  
**Interpretation:** This KPI highlights departments with above-average compensation, which may reflect specialized talent demand or higher seniority levels.

## 5) Employee Utilization Coverage
**Definition:** Percentage of employees assigned to at least one project, calculated by comparing assigned employees to total employees using the employees and project_assignments tables.  
**Current value:** Calculate as:  
`(COUNT(DISTINCT pa.emp_id) * 100.0 / COUNT(DISTINCT e.emp_id))`  
from employees and project_assignments.  
**Interpretation:** This KPI measures how much of the workforce is actively engaged in project work and can reveal idle capacity.