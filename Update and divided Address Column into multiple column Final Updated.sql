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
