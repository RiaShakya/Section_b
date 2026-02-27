 create database moviedb1;
use moviedb1;

create table if not exists Movie(
mId int primary key,
Title varchar(255),
Year date,
Director varchar(255)
);

/*INSERT INTO Movie (mId, Title, Year, Director) VALUES
(101, 'Inception', '2010-01-01', 'Christopher Nolan'),
(102, 'Titanic', '1997-01-01', 'James Cameron'),
(103, 'The Dark Knight', '2008-01-01', 'Christopher Nolan'),
(104, 'Avatar', '2009-01-01', 'James Cameron'),
(105, 'Interstellar', '2014-01-01', 'Christopher Nolan'),
(106, 'Gladiator', '2000-01-01', 'Ridley Scott'),
(107, 'Jurassic Park', '1993-01-01', 'Steven Spielberg'),
(108, 'The Avengers', '2012-01-01', 'Joss Whedon'),
(109, 'The Matrix', '1999-01-01', 'The Wachowskis'),
(110, 'Parasite', '2019-01-01', 'Bong Joon-ho');*/

create table if not exists User(
uId int primary key, 
Name varchar(255)
);

/*INSERT INTO User (uId, Name) VALUES
(201, 'Alice Johnson'),
(202, 'Bob Smith'),
(203, 'Charlie Brown'),
(204, 'David Wilson'),
(205, 'Emma Davis'),
(206, 'Frank Miller'),
(207, 'Grace Taylor'),
(208, 'Hannah Anderson'),
(209, 'Ian Thomas'),
(210, 'Julia Roberts');*/

CREATE TABLE IF NOT EXISTS Ratings (
	mId INT,                     
    uId INT,
    Rating DECIMAL(2,1),         
    RatingDate DATE,             
    PRIMARY KEY (mId, uId),      
    FOREIGN KEY (mId) REFERENCES Movie(mId),
    FOREIGN KEY (uId) REFERENCES User(uId)
);

/*INSERT INTO Ratings (mId, uId, Rating, RatingDate) VALUES
(101, 201, 4.5, '2019-03-15'),
(102, 202, 3.8, '2020-06-22'),
(103, 203, 5.0, '2021-01-10'),
(104, 204, 4.2, '2022-08-05'),
(105, 205, 3.5, '2023-11-12'),
(106, 206, 4.8, '2018-07-19'),
(107, 207, 4.0, '2017-02-28'),
(108, 208, 3.9, '2021-09-03'),
(109, 209, 4.7, '2020-12-25'),
(110, 210, 5.0, '2019-05-30');*/

#Q1. FInd the title and year of movies that were created after the year 2000.

/*select Title, Year from Movie
where Year > 2000-01-01;

-- select * from Movie;

#Q2. Find the Title, mId and rating of movie that were created before the year 2000 and rating > 2

select Title, mId from
Movie where Year < 2000-01-01;
 
select M.ttile, M.mid R.rating from Movie M join Rating R on M.mid = R.mid
where M.year < 2000 and R.rating >2;

#Q3. Sort all of the movies by descending rating.

select M.Title, M.mId, R.Rating from Movie M
join Ratings R on M.mId = R.mId
order by R.rating desc; */

#Q4. Find all movies that have the exact same rating

select mId, Rating, count(*) as total from
Ratings group by mId, Rating
having count(*) >1;

-- select * from Ratings;

#Q5. Create a query that looks for a movie's ID, title, director but only if it has rating above 4

select distinct M.mId, M.Title, M.Director , R.Rating from 
Movie M join Ratings R on M.mId = R.mId
where R.Rating > 4;
