-- 1757. Recyclable and Low Fat Products
-- https://leetcode.com/problems/recyclable-and-low-fat-products/

SELECT product_id
FROM Products
WHERE low_fats  = 'Y' AND recyclable = 'Y';

-- 584. Find Customer Referee
-- https://leetcode.com/problems/find-customer-referee/

SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id <> 2;

-- 595. Big Countries
-- https://leetcode.com/problems/big-countries/

SELECT name, population ,area
FROM World
WHERE area >= 3000000 OR population >=25000000;

-- 1148. Article Views I
-- https://leetcode.com/problems/article-views-i/

SELECT DISTINCT author_id as id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

-- 1683. Invalid Tweets
-- https://leetcode.com/problems/invalid-tweets/

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) >15 ;

-- 1378. Replace Employee ID With The Unique Identifier
-- https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/

SELECT uq.unique_id , em.name
FROM Employees em LEFT JOIN EmployeeUNI uq
ON em.id = uq.id;

-- 1068. Product Sales Analysis I
-- https://leetcode.com/problems/product-sales-analysis-i/

SELECT pr.product_name , sl.year, sl.price
FROM Sales sl JOIN Product pr
ON sl.product_id = pr.product_id;

-- 1581. Customer Who Visited but Did Not Make Any Transactions
-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/

SELECT vs.customer_id , COUNT(CASE WHEN transaction_id IS NULL THEN 1 END) AS count_no_trans
FROM Visits vs LEFT JOIN Transactions ts
ON vs.visit_id = ts.visit_id
GROUP BY vs.customer_id
HAVING count_no_trans >0;

-- 197. Rising Temperature
-- https://leetcode.com/problems/rising-temperature/

SELECT  DISTINCT w2.id
FROM Weather w1 CROSS JOIN Weather w2
WHERE DATEDIFF(w2.recordDate , w1.recordDate ) =1 
AND w2.temperature > w1.temperature;

-- 1661. Average Time of Process per Machine
-- https://leetcode.com/problems/average-time-of-process-per-machine/

SELECT machine_id,ROUND( AVG(each_process_time),3) AS processing_time
FROM(
    SELECT machine_id,process_id, 
    SUM(CASE
        WHEN activity_type ='start' THEN -timestamp ELSE timestamp END) AS each_process_time
FROM Activity 
GROUP BY machine_id,process_id) AS processing_time
GROUP BY machine_id;

-- 577. Employee Bonus
-- https://leetcode.com/problems/employee-bonus/

SELECT em.name , bs.bonus
FROM Employee em LEFT JOIN Bonus bs
ON em.empId = bs.empId
WHERE bs.bonus <1000 OR bs.bonus IS NULL; 

-- 1280. Students and Examinations
-- https://leetcode.com/problems/students-and-examinations/

SELECT st.student_id , st.student_name, sb.subject_name , COUNT(ex.subject_name ) AS attended_exams
FROM Students st CROSS JOIN Subjects sb
LEFT JOIN Examinations ex
ON st.student_id = ex.student_id AND sb.subject_name  = ex.subject_name 
GROUP BY st.student_id , st.student_name,  sb.subject_name 
ORDER BY st.student_id ,  sb.subject_name ;

-- 570. Managers with at Least 5 Direct Reports
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/

SELECT name 
FROM Employee
WHERE id IN  (
    SELECT managerId  FROM Employee
    GROUP BY managerId 
    HAVING COUNT(*)>=5
);

-- OR

SELECT mg.name
FROM Employee em INNER JOIN Employee mg
ON em.managerId = mg.id
GROUP BY mg.id
HAVING COUNT(em.id) >=5;

-- 1934. Confirmation Rate
-- https://leetcode.com/problems/confirmation-rate/

SELECT sg.user_id, IFNULL(ROUND(AVG(CASE WHEN action ='confirmed' THEN 1 ELSE 0 END),2),0) AS confirmation_rate
FROM Signups sg LEFT JOIN Confirmations cf
ON sg.user_id = cf.user_id
GROUP BY sg.user_id;

-- 620. Not Boring Movies
-- https://leetcode.com/problems/not-boring-movies/

SELECT *
FROM Cinema
WHERE id%2<>0 AND description <> 'boring'
ORDER BY rating DESC;

-- 1251. Average Selling Price
-- https://leetcode.com/problems/average-selling-price/

SELECT pr.product_id, IFNULL(ROUND(SUM(units*price)/SUM(units),2),0) AS average_price
FROM Prices pr LEFT JOIN UnitsSold us
ON pr.product_id = us.product_id AND 
 us.purchase_date BETWEEN pr.start_date AND pr.end_date
 GROUP BY pr.product_id;

-- 1075. Project Employees I
-- https://leetcode.com/problems/project-employees-i/

SELECT pr.project_id, ROUND(AVG(experience_years),2) AS average_years 
FROM  Project  pr LEFT JOIN Employee em
ON pr.employee_id = em.employee_id
GROUP BY pr.project_id;

-- 1633. Percentage of Users Attended a Contest
-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/

SELECT contest_id, ROUND(100.0*COUNT(user_id)/(SELECT COUNT(user_id) FROM Users),2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC , contest_id;

-- 1211. Queries Quality and Percentage
-- https://leetcode.com/problems/queries-quality-and-percentage/

SELECT query_name, ROUND(AVG(rating/position),2) AS quality,
        ROUND(100.0* AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END ),2) AS poor_query_percentage 
FROM Queries
GROUP BY query_name ;

-- 1193. Monthly Transactions I
--  https://leetcode.com/problems/monthly-transactions-i/

SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country,COUNT(*) AS trans_count,
        COUNT(CASE WHEN state ='approved' THEN 1 END ) AS approved_count,
         SUM(amount) AS trans_total_amount ,
        SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM Transactions 
GROUP BY DATE_FORMAT(trans_date, '%Y-%m') , country ;

-- 1174. Immediate Food Delivery II
-- https://leetcode.com/problems/immediate-food-delivery-ii/

SELECT ROUND(100.0*AVG(order_date=customer_pref_delivery_date ),2) AS immediate_percentage 
FROM Delivery
WHERE (customer_id ,order_date) IN (
    SELECT customer_id ,MIN(order_date)
    FROM Delivery
    GROUP BY customer_id
);

-- 550. Game Play Analysis IV
-- https://leetcode.com/problems/game-play-analysis-iv/

SELECT ROUND(COUNT(day1.player_id)/(SELECT COUNT(DISTINCT player_id) FROM Activity),2) AS fraction
FROM Activity day1 JOIN Activity day2
ON day1.player_id = day2.player_id AND 
    DATEDIFF(day2.event_date,day1.event_date) =1
WHERE (day1.player_id ,day1.event_date) IN (
    SELECT player_id , MIN(event_date) FROM Activity GROUP BY player_id
);

-- 2356. Number of Unique Subjects Taught by Each Teacher
-- https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/

SELECT teacher_id , COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id ;

-- 1141. User Activity for the Past 30 Days I
-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/

SELECT activity_date  AS day , COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date  BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

-- 1070. Product Sales Analysis III
--  https://leetcode.com/problems/product-sales-analysis-iii/

SELECT  product_id, year AS first_year ,quantity,price
FROM Sales
WHERE (product_id,year) IN (
    SELECT product_id , MIN(year)
    FROM Sales
    GROUP BY product_id
);

-- 596. Classes With at Least 5 Students
-- https://leetcode.com/problems/classes-with-at-least-5-students/

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >=5;

-- 1729. Find Followers Count
-- https://leetcode.com/problems/find-followers-count/

SELECT user_id , COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id;

-- 619. Biggest Single Number
-- https://leetcode.com/problems/biggest-single-number/

SELECT MAX(num) AS num
FROM (SELECT num 
FROM MyNumbers
GROUP BY num
HAVING COUNT(num) =1 ) AS uq_num ;

-- 1045. Customers Who Bought All Products
-- https://leetcode.com/problems/customers-who-bought-all-products/

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT( product_key) FROM Product
);

-- 1731. The Number of Employees Which Report to Each Employee
-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/

SELECT mg.employee_id, mg.name,
    COUNT(em.employee_id) AS reports_count, 
    ROUND(AVG(em.age)) AS average_age 
FROM Employees em JOIN Employees mg
ON em.reports_to = mg.employee_id
GROUP BY mg.employee_id
ORDER BY mg.employee_id;

-- 1789. Primary Department for Each Employee
-- https://leetcode.com/problems/primary-department-for-each-employee/

SELECT employee_id , department_id
FROM Employee
WHERE primary_flag ='Y' OR employee_id IN (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(*) =1
);

-- 610. Triangle Judgement
-- https://leetcode.com/problems/triangle-judgement/

SELECT x,y,z,
      CASE WHEN x+y >z AND y+z>x AND z+x>y THEN 'Yes' ELSE 'No' END AS triangle
FROM Triangle; 

-- 180. Consecutive Numbers
-- https://leetcode.com/problems/consecutive-numbers/
 
 SELECT DISTINCT lg1.num AS  ConsecutiveNums 
FROM Logs lg1 JOIN Logs lg2
ON lg1.id = lg2.id -1
JOIN Logs lg3
ON lg2.id = lg3.id -1
WHERE lg1.num = lg2.num AND lg2.num=lg3.num ;

-- OR 

WITH cte_num AS (
    SELECT num,
    lead(num,1) over() num1,
    lead(num,2) over() num2
    FROM logs
)
SELECT DISTINCT num ConsecutiveNums 
FROM cte_num 
WHERE (num=num1) AND (num=num2) ;

-- 1164. Product Price at a Given Date 
-- https://leetcode.com/problems/product-price-at-a-given-date/

SELECT product_id, FIRST_VALUE(new_price) OVER(PARTITION  BY product_id ORDER BY change_date DESC ) as price
FROM Products
WHERE change_date <='2019-08-16'
-- GROUP BY product_id
UNION 
SELECT product_id, 10 as price
FROM Products
WHERE product_id NOT IN
(
SELECT product_id
FROM Products
WHERE change_date <='2019-08-16'
GROUP BY product_id
)
GROUP BY product_id ;

-- 1204. Last Person to Fit in the Bus
-- https://leetcode.com/problems/last-person-to-fit-in-the-bus/

WITH cte_cumm_weight AS (SELECT person_name , SUM(weight) OVER(ORDER BY turn) AS cumm_weight
FROM Queue )
SELECT person_name
FROM cte_cumm_weight
WHERE cumm_weight<=1000
ORDER BY cumm_weight DESC
LIMIT 1;

-- 1907. Count Salary Categories 
-- https://leetcode.com/problems/count-salary-categories/

WITH cte_labelled AS(SELECT  category, COUNT(category) AS accounts_count
from (SELECT case
when income<20000 then 'Low Salary' 
when income >= 20000 and income <= 50000 then 'Average Salary'
when income > 50000 then 'High Salary'
end as category
from Accounts ) as Acc
GROUP BY category) , cte_all_category AS(
    SELECT 'High Salary' AS category
    UNION 
    SELECT 'Average Salary' AS category
    Union
    SELECT 'Low Salary' AS category
)

SELECT ct.category ,COALESCE(SUM(accounts_count ),0) AS accounts_count 
FROM cte_all_category ct LEFT OUTER JOIN cte_labelled lb
ON ct.category =lb.category
GROUP BY ct.category;

-- 1978. Employees Whose Manager Left the Company 
-- https://leetcode.com/problems/employees-whose-manager-left-the-company/

SELECT employee_id 
FROM Employees
WHERE salary <30000 AND manager_id IS NOT NULL 
AND manager_id NOT IN (SELECT employee_id FROM Employees) 
ORDER BY employee_id;

-- 626. Exchange Seats
-- https://leetcode.com/problems/exchange-seats/

SELECT CASE WHEN id%2<>0 AND id+1 IN (SELECT id FROM Seat) THEN id+1
            WHEN id%2<>0 AND id+1 NOT IN (SELECT id FROM Seat) THEN id
            ELSE id-1 END AS id,
            student
FROM Seat
ORDER BY id;

-- 1341. Movie Rating
-- https://leetcode.com/problems/movie-rating/

(SELECT name AS results
FROM MovieRating mr JOIN Users us
ON mr.user_id = us.user_id
GROUP BY mr.user_id
ORDER BY COUNT(movie_id) DESC ,name
LIMIT 1)
UNION ALL
(
SELECT title
FROM MovieRating mr JOIN Movies mv
ON mr.movie_id = mv.movie_id
WHERE created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY mr.movie_id
ORDER BY AVG(rating) DESC, title ASC
LIMIT 1) 

-- 1321. Restaurant Growth
-- https://leetcode.com/problems/restaurant-growth/

SELECT visited_on, SUM(amount) OVER(ORDER BY visited_on
                    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
        ROUND(AVG(amount) OVER(ORDER BY visited_on
                    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount 
FROM(
    SELECT visited_on , SUM(amount) AS amount
FROM Customer
GROUP BY visited_on 
ORDER BY visited_on ) AS single_trans
LIMIT 100 offset 6; 

-- 602. Friend Requests II: Who Has the Most Friends
-- https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/

WITH cte_all AS(
    SELECT requester_id AS id FROM RequestAccepted 
    UNION ALL
    SELECT accepter_id FROM RequestAccepted 
)
SELECT id ,COUNT(*) AS num
FROM cte_all
GROUP BY id
ORDER BY num DESC
LIMIT 1;

-- 585. Investments in 2016
-- https://leetcode.com/problems/investments-in-2016/

SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) >1
) AND (lat,lon) IN ( 
    SELECT lat,lon
    FROM Insurance
    GROUP BY lat,lon
    HAVING COUNT(*) =1
) ;

-- 185. Department Top Three Salaries
-- https://leetcode.com/problems/department-top-three-salaries/

WITH cte_emp_rank AS (SELECT dept.name AS Department , emp.name AS Employee, salary,
        DENSE_RANK() OVER(PARTITION BY dept.id ORDER BY salary DESC) as rnk
FROM Employee emp JOIN Department dept
ON emp.departmentId = dept.id
)
SELECT Department , Employee, salary AS Salary
FROM cte_emp_rank
WHERE rnk <=3;

-- 1667. Fix Names in a Table
-- https://leetcode.com/problems/fix-names-in-a-table/

SELECT user_id , CONCAT(UPPER(SUBSTRING(name,1,1)),LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id;

-- 1527. Patients With a Condition
-- https://leetcode.com/problems/patients-with-a-condition/

SELECT *
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';

-- 196. Delete Duplicate Emails
-- https://leetcode.com/problems/delete-duplicate-emails/

DELETE p1 
FROM Person p1 JOIN Person p2 
    ON p1.email = p2.email 
    AND p1.id > p2.id;

-- 176. Second Highest Salary
-- https://leetcode.com/problems/second-highest-salary/

SELECT IFNULL(MAX(salary),null) AS SecondHighestSalary 
FROM Employee
WHERE salary NOT IN (SELECT MAX(salary) FROM Employee);

-- 1484. Group Sold Products By The Date
-- https://leetcode.com/problems/group-sold-products-by-the-date/

SELECT sell_date, COUNT(DISTINCT product) AS num_sold, 
        GROUP_CONCAT(DISTINCT product ORDER BY product)  as products
FROM Activities 
GROUP BY sell_date
ORDER BY sell_date;

-- 1327. List the Products Ordered in a Period
-- https://leetcode.com/problems/list-the-products-ordered-in-a-period/

SELECT pr.product_name ,SUM(unit) AS unit
FROM Orders od JOIN Products pr
ON od.product_id = pr.product_id
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY pr.product_name
HAVING SUM(unit) >=100
ORDER BY unit DESC;

-- 1517. Find Users With Valid E-Mails
-- https://leetcode.com/problems/find-users-with-valid-e-mails/

SELECT *
FROM Users
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9._-]*@leetcode\\.com$'
 AND mail LIKE BINARY '%@leetcode.com';