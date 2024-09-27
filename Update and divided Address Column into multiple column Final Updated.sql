SELECT * FROM bakery.customer_sweepstakes;

#ALTER TABLE customer_sweepstakes RENAME COLUMN `ï»¿sweepstake_id` TO `sweepstake_id`;


SELECT customer_id, COUNT(customer_id) 
FROM bakery.customer_sweepstakes
GROUP BY (customer_id )
HAVING COUNT(customer_id)  > 1 ;


SELECT customer_id, ROW_num
FROM(
SELECT customer_id, 
ROW_NUMBER () OVER( PARTITION BY customer_id ORDER BY customer_id) AS Row_num
FROM bakery.customer_sweepstakes) AS table_row
WHERE Row_num > 1
;


DELETE FROM customer_sweepstakes
WHERE sweepstake_id IN ( 

		SELECT sweepstake_id
		FROM(
			SELECT sweepstake_id, 
			ROW_NUMBER () OVER( PARTITION BY customer_id ORDER BY customer_id) AS Row_num
			FROM bakery.customer_sweepstakes) AS table_row 
			WHERE Row_num > 1 ); 




# Standardizing the table inclues, phone, birth_date, Are you ovefr 18?

SELECT *
FROM customer_sweepstakes;

SELECT phone, REGEXP_REPLACE(phone,'[-()-/]', '')
FROM customer_sweepstakes;

# We removed all the charachter from the phone column , Now we will update the table

UPDATE customer_sweepstakes
SET phone = REGEXP_REPLACE(phone,'[-()-/]', '');

# Now we will bifurcate more like adding - after 3,3,4 characters in phone column

#We divided all the number now we will add '-' after 3,3,4 character

SELECT phone, SUBSTR(phone,'1','3'), '-',  SUBSTR(phone,'4','3'), '-',  SUBSTR(phone,'7','4')
FROM customer_sweepstakes;


# Now we will add all the columns using CONCAT

SELECT phone, CONCAT(SUBSTR(phone,'1','3'), '-',  SUBSTR(phone,'4','3'), '-',  SUBSTR(phone,'7','4'))
FROM customer_sweepstakes;


# Now we will drop the NULL values or the Blanks values

SELECT phone, CONCAT(SUBSTR(phone,'1','3'), '-',  SUBSTR(phone,'4','3'), '-',  SUBSTR(phone,'7','4'))
FROM customer_sweepstakes
WHERE phone <> ''; # '' This is blank or if there was a null then we put WHERE phone IS NULL

# We removed the Blanks spaces now the CONCAT column looks good, Now we will update this column

# After all this we will update the table

UPDATE customer_sweepstakes
SET phone = CONCAT(SUBSTR(phone,'1','3'), '-',  SUBSTR(phone,'4','3'), '-',  SUBSTR(phone,'7','4'))
WHERE phone <> '';

SELECT *
FROM customer_sweepstakes;


SELECT * FROM bakery.customer_sweepstakes;

# Now we will update birth_date column

SELECT birth_date, 
CASE
	WHEN STR_TO_DATE(birth_date,'%m/%d/%Y') IS NOT NULL THEN STR_TO_DATE(birth_date,'%m/%d/%Y')
    WHEN STR_TO_DATE(birth_date,'%m/%d/%Y') IS NULL THEN STR_TO_DATE(birth_date,'%Y/%d/%m')
END
FROM bakery.customer_sweepstakes;

UPDATE customer_sweepstakes
SET birth_date = CASE
	WHEN STR_TO_DATE(birth_date,'%m/%d/%Y') IS NOT NULL THEN STR_TO_DATE(birth_date,'%m/%d/%Y')
    WHEN STR_TO_DATE(birth_date,'%m/%d/%Y') IS NULL THEN STR_TO_DATE(birth_date,'%Y/%d/%m')
END;

# This is also not working either so we will only change what is required just sweep_id 9 and 11
# we will do that using Substring

SELECT birth_date,CONCAT( SUBSTRING(birth_date, 9,2),'/',SUBSTRING(birth_date, 6,2),'/', SUBSTRING(birth_date, 1,4))
FROM bakery.customer_sweepstakes
WHERE sweepstake_id IN (9,11);

# Now we will update the table

UPDATE customer_sweepstakes
SET birth_date = CONCAT( SUBSTRING(birth_date, 9,2),'/',SUBSTRING(birth_date, 6,2),'/', SUBSTRING(birth_date, 1,4))
WHERE sweepstake_id IN (9,11);



SELECT * 
FROM bakery.customer_sweepstakes
;

#ALTER TABLE customer_sweepstakes RENAME COLUMN `Under Age` TO `Under_Age`;

SELECT Under_Age,
	CASE
    WHEN Under_Age = 'Yes' THEN 'Y'
    WHEN Under_Age = 'Y' THEN 'Y'
    WHEN Under_Age = 'No' THEN 'N'
    WHEN Under_Age = 'N' THEN 'N'
    END
FROM bakery.customer_sweepstakes
;

# Now we will update this in the table

UPDATE customer_sweepstakes
SET Under_Age = CASE
    WHEN Under_Age = 'Yes' THEN 'Y'
    WHEN Under_Age = 'Y' THEN 'Y'
    WHEN Under_Age = 'No' THEN 'N'
    WHEN Under_Age = 'N' THEN 'N'
    END;


# Now we will be seperating the address column, because later maybe we want state or city different so that we can compare things

SELECT * 
FROM bakery.customer_sweepstakes
;


SELECT address,
SUBSTRING_INDEX(address, ',','1') AS Street,
SUBSTRING_INDEX(SUBSTRING_INDEX(address, ',','2'),',','-1') AS City,
SUBSTRING_INDEX(address, ',','-1') AS State
FROM customer_sweepstakes
;

ALTER TABLE customer_sweepstakes
ADD COLUMN Street VARCHAR(50) AFTER address,
ADD COLUMN City VARCHAR(50) AFTER Street,
ADD COLUMN State VARCHAR(50) AFTER City;

# I did a mistake here that's why I am dropping the columns and then I'll add the column same process
ALTER TABLE customer_sweepstakes
DROP COLUMN Street,
DROP COLUMN City,
DROP COLUMN State;

ALTER TABLE customer_sweepstakes
ADD COLUMN Street VARCHAR(50) AFTER address,
ADD COLUMN City VARCHAR(50) AFTER Street,
ADD COLUMN State VARCHAR(50) AFTER City;


# Now we will add values inside the Null values of Street, City, State

UPDATE customer_sweepstakes
SET Street = SUBSTRING_INDEX(address, ',','1')
;

UPDATE customer_sweepstakes
SET City = SUBSTRING_INDEX(SUBSTRING_INDEX(address, ',','2'),',','-1')
;

UPDATE customer_sweepstakes
SET State = SUBSTRING_INDEX(address, ',','-1')
;

# We did all the state name upper case because some rows were not properly formated
SELECT State, UPPER(State) 
FROM bakery.customer_sweepstakes
;

# Then we will update the Table

UPDATE customer_sweepstakes
SET State = UPPER(State);

# We will trim some spaces  from city, state
SELECT City, TRIM(City)
FROM bakery.customer_sweepstakes
;
 
# Now we will update the table

UPDATE customer_sweepstakes
SET City = TRIM(City);

SELECT State, TRIM(State)
FROM bakery.customer_sweepstakes
;

UPDATE customer_sweepstakes
SET State = TRIM(State);

SELECT * 
FROM bakery.customer_sweepstakes
;
