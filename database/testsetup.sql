-- STRICTLY FOR TESTING PURPOSES --
DROP TABLE IF EXISTS TestingSetup CASCADE;

--Table for setup in order to add input
create table TestingSetup (
    memberName varchar(50),
    ricePurityScore integer,
    primary key (memberName)
);

--Test Input
insert into TestingSetup (memberName, ricePurityScore) values
('Arthur Best Friend', 30),
('Kalsyc', 80),
('LynnJa', 50),
('BakKwa', 60);