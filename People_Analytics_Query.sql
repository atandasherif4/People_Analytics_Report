/*Here are SQL queries used to answer question and extract insights*/

--View of the dataset
SELECT *
FROM people_analytics;

--Number of Distinct employees
SELECT COUNT(employee_id)
FROM people_analytics;

--Number of columns
SELECT count(*)
FROM information_schema.columns
WHERE table_name = 'people_analytics';

--Distinct Department
SELECT DISTINCT(department)
FROM people_analytics;

--Dsitinct Sub_departments
SELECT DISTINCT(sub_department)
FROM people_analytics;

--Distinct Sub-division of department
SELECT DISTINCT department, sub_department
FROM people_analytics
GROUP BY department, sub_department
ORDER BY department;

--Distinct Job_level
SELECT DISTINCT(job_level)
FROM people_analytics;

--Distinct Gender
SELECT DISTINCT(gender)
FROM people_analytics;

-- Distinct Sexual Orientation
SELECT DISTINCT(sexual_orientation)
FROM people_analytics;

--Distinct Race
SELECT DISTINCT(race)
FROM people_analytics;

--Distinct Education 
SELECT DISTINCT(education)
FROM people_analytics;

--Distinct Age
SELECT DISTINCT(age)
FROM people_analytics;

--Distinct Location
SELECT DISTINCT(location)
FROM people_analytics;

--Distinct Location City
SELECT DISTINCT(location_city)
FROM people_analytics;

--Distinct Marital_Status
SELECT DISTINCT(marital_status)
FROM people_analytics;

--Distinct Employment_Status
SELECT DISTINCT(employment_status)
FROM people_analytics;

--Number of Termnination by type
SELECT term_type, COUNT(*)
FROM people_analytics
WHERE term_type IN ('Voluntary', 'Involuntary')
group by term_type;

--Termination_percentage to the nearest whole number
WITH term_count AS (
  SELECT COUNT(*) AS num_term
FROM people_analytics
WHERE active_status = '0'
  )
  
SELECT CEIL(num_term*100.0/4831) as term_perc
FROM term_count;

/*Both hire date and termination date are not in the appropiate data type. 
So they will be changed into the expected data type which is date format*/

--For hire_date
ALTER TABLE people_analytics 
ALTER COLUMN hire_date TYPE DATE 
using to_date(hire_date, 'DD-MM-YYYY');

--For term_date
ALTER TABLE people_analytics 
ALTER COLUMN term_date TYPE DATE
using to_date(term_date, 'DD-MM-YYYY');

--Distinct year in hire_date
SELECT DISTINCT(EXTRACT ('year' FROM hire_date)) as hiring_date
FROM people_analytics
order by hiring_date;


--Distinct year in term_date
SELECT DISTINCT(EXTRACT ('year' FROM term_date)) as terming_date
FROM people_analytics
order by terming_date;

/*Insight one:
Calculating the Annual attrition rate over time. 

The formular is given as Annual Attrition rate  = Separation * 100  / Average number of employee.
Where Separation - Number of employees that were terminated (either voluntary or involuntary)
and Average number of employee = (Number of employee at the beginning of the year + Number of employee at the end of the year)/2


Writing two CTEs to get separation (for voluntary and involuntary type) for each year starting from january to december. 
I will be doing this one after the other and then creating a table for it. 
Separation - Number of employees that were terminated voluntarily
*/

WITH separation_voluntary AS (
  SELECT COUNT(*) AS sep
  FROM people_analytics
  WHERE active_status = '0'
  AND hire_date BETWEEN '2012-01-01' AND '2012-12-31'
  AND term_type = 'Voluntary'
  )
--The code above was repeated all through till 2021 and recoreded using Ms. Excel. Also, the neccessary calculations in percenatge were done in Ms. Excel*/

--Viewing the temporary table created
SELECT *
from separation_voluntary;

--Separation - Number of employees that were terminated Involuntarily
WITH separation_involuntary AS (
  SELECT COUNT(*) AS sep
  FROM people_analytics
  WHERE active_status = '0'
  AND hire_date BETWEEN '2012-01-01' AND '2012-12-31'
  AND term_type = 'Involuntary'
  )
------The code above was repeated all through till 2021 and recoreded using Ms. Excel. Also, the neccessary calculations in percenatge were done in Ms. Excel*/


--Viewing the temporary table created
SELECT *
from separation_involuntary;

--Here is the number of employee at the begging of the year in the company.
WITH emp_per_year AS (
  SELECT count(employee_id) AS count_emp
  FROM people_analytics
  WHERE hire_date BETWEEN '2021-01-01' AND '2021-12-31'
  )
----The code above was repeated all through till 2021 and recoreded using Ms. Excel. Also, the neccessary calculations in percenatge were done in Ms. Excel*/

--Viewing the temporary table created.
SELECT *
from emp_per_year;
 
/*On getting the number of separation and the average number of employee. Therefore the Annual attrition can be gotten.This was completed in Excel.
The visualization can be found in the report.*/


/*Insight 2:
Analyze gender diversity in the organization's hiring practices. 
This could involve calculating the sum of new hires who are male versus female each year, 
and visualizing the results to identify any trends or disparities in hiring by gender.
*/

--Writing a query to extract distinct year from hire_date(i.e from 2012 to 2021)

WITH year_format AS (
  SELECT employee_id,
  hire_date,
  term_date,
  gender,
  CASE 
  WHEN hire_date BETWEEN '2012-01-01' AND '2012-12-31' THEN '2012'
  WHEN hire_date BETWEEN '2013-01-01' AND '2013-12-31' THEN '2013'
  WHEN hire_date BETWEEN '2014-01-01' AND '2014-12-31' THEN '2014'
  WHEN hire_date BETWEEN '2015-01-01' AND '2015-12-31' THEN '2015'
  WHEN hire_date BETWEEN '2016-01-01' AND '2016-12-31' THEN '2016'
  WHEN hire_date BETWEEN '2017-01-01' AND '2017-12-31' THEN '2017'
  WHEN hire_date BETWEEN '2018-01-01' AND '2018-12-31' THEN '2018'
  WHEN hire_date BETWEEN '2019-01-01' AND '2019-12-31' THEN '2019'
  WHEN hire_date BETWEEN '2020-01-01' AND '2020-12-31' THEN '2020'
  ELSE '2021'
 END AS year_column 
FROM people_analytics
	)
    
SELECt year_column,
	   gender,
       count(*)
FROM year_format
GROUP BY year_column, gender
ORDER BY year_column,gender;



 /* Insight 3: 
Explore the relationship between employee salary and gender and education*/
 
SELECT DISTINCT(education),
	   gender,
  	   CEIL(AVG((salary))) AS average_salary
FROM people_analytics
GROUP BY education, gender
ORDER BY 1,2;
  
/*Insight 4:
Distribution of employee ages across the organization. 
*/

SELECT age AS age_distribution
FROM people_analytics;

/*Insight 5:
Investigate trends in employee headcount over time. 
*/

WITH year_format AS (
  SELECT employee_id,
  hire_date,
  term_date,
  department,
  gender,
  CASE 
  WHEN hire_date BETWEEN '2012-01-01' AND '2012-12-31' THEN '2012'
  WHEN hire_date BETWEEN '2013-01-01' AND '2013-12-31' THEN '2013'
  WHEN hire_date BETWEEN '2014-01-01' AND '2014-12-31' THEN '2014'
  WHEN hire_date BETWEEN '2015-01-01' AND '2015-12-31' THEN '2015'
  WHEN hire_date BETWEEN '2016-01-01' AND '2016-12-31' THEN '2016'
  WHEN hire_date BETWEEN '2017-01-01' AND '2017-12-31' THEN '2017'
  WHEN hire_date BETWEEN '2018-01-01' AND '2018-12-31' THEN '2018'
  WHEN hire_date BETWEEN '2019-01-01' AND '2019-12-31' THEN '2019'
  WHEN hire_date BETWEEN '2020-01-01' AND '2020-12-31' THEN '2020'
  ELSE '2021'
 END AS year_column 
FROM people_analytics
	)
  
SELECT DISTINCT(year_column),
	   COUNT(employee_id) AS employee_headcount
FROM year_format
GROUP BY year_column;

/*Insight6:
Average employee tenure per year: see meaning in notes.
*/

WITH year_format1 AS (
  SELECT DISTINCT(employee_id),
  hire_date,
  term_date,
  department,
  gender,
  tenure,
  active_status,
  CASE 
  WHEN hire_date BETWEEN '2012-01-01' AND '2012-12-31' THEN '2012'
  WHEN hire_date BETWEEN '2013-01-01' AND '2013-12-31' THEN '2013'
  WHEN hire_date BETWEEN '2014-01-01' AND '2014-12-31' THEN '2014'
  WHEN hire_date BETWEEN '2015-01-01' AND '2015-12-31' THEN '2015'
  WHEN hire_date BETWEEN '2016-01-01' AND '2016-12-31' THEN '2016'
  WHEN hire_date BETWEEN '2017-01-01' AND '2017-12-31' THEN '2017'
  WHEN hire_date BETWEEN '2018-01-01' AND '2018-12-31' THEN '2018'
  WHEN hire_date BETWEEN '2019-01-01' AND '2019-12-31' THEN '2019'
  WHEN hire_date BETWEEN '2020-01-01' AND '2020-12-31' THEN '2020'
  ELSE '2021'
  END AS year_column 
FROM people_analytics
WHERE active_status = '1'
	),

	year_format2 AS (
  SELECT DISTINCT(employee_id),
         (tenure/12.0) AS tenure_in_years,
         active_status
  FROM people_analytics
  WHERE active_status = '1'
    )
     
SELECT DISTINCT(year_column),
	   ROUND(AVG(tenure_in_years) OVER (PARTITION BY year_column ORDER BY year_column),1) AS avg_employee_tenure
FROM year_format1
JOIN year_format2
	ON year_format1.employee_id = year_format2.employee_id;   

/*Insight 7:
Total number of employee by department
*/

SELECT department, COUNT(*) as number_of_employees
FROM people_analytics
GROUP BY department
ORDER BY 2 DESC;


/*Speaking of company's information
creating a table for number of employees, department, sub-department.
The columns were calculated individually and put together in the table below */

create table company_info (
  department INT,
  sub_department INT,
  job_level INT,
  no_employee INT,
  termination_perc INT
	)
  
INSERT INTO company_info
VALUES (12, 32, 4, 4831, 18)

--Viewing the table created.
SELECT *
from company_info;

--Obtaining information about the termination of employee

--Reason for those who left voluntarily and their number 
SELECT term_reason,
       COUNT(*)
FROM people_analytics
WHERE active_status = '0'
AND term_type = 'Voluntary'
group by 1;

----Reason for those who left involuntarily and their number 
SELECT term_reason,
       COUNT(*)
FROM people_analytics
WHERE active_status = '0'
AND term_type = 'Involuntary'
group by 1;