INSERT INTO Users(username, name, password, phoneNumber, dateCreated) VALUES
('kalsyc', 'Darren', 'darrencool', '91718716', '2020-05-04'),
('lynjaaa', 'Lynn', 'lynncool', '91718716',  '2020-05-04'),
('bakwah', 'Leewah', 'leewahcool', '91718716', '2020-05-04'),
('justning', 'Sining', 'siningcool', '91718716', '2020-05-04'),
('custtest', 'CustTest', 'custtestcool', '96567556', '2020-05-04'), -- generic customer
('managertest', 'ManagerTest', 'managercool', '96567556', '2020-05-05'), --generic manager
('stafftest', 'StaffTest', 'staffcool', '96567556', '2019-05-06'), -- staff tied to no restaurants
('staffresttest', 'StaffRestTest', 'staffrestcool', '96567556', '2020-05-01'), -- staff tied to 4 Fingers
('fullridertest', 'FullRiderTest', 'fullridercool', '96567556', '2020-05-02'), -- generic full rider
('partridertest', 'PartRiderTest', 'partridercool', '96567556', '2020-05-03'), -- generic part rider
('user0','Adrian','password0','83345098','2019-07-15'),
('user1','Noah','password1','96757050','2019-06-24'),
('user2','Adrian','password2','84305500','2019-05-24'),
('user3','Grace','password3','99139273','2019-07-28'),
('user4','Umbriel','password4','82047458','2019-06-05'),
('user5','Bert','password5','92888181','2019-08-15'),
('user6','xiaomeimei','password6','84419476','2019-07-20'),
('user7','Jill','password7','80841486','2019-07-21'),
('user8','Jill','password8','89977622','2019-07-06'),
('user9','Edie','password9','92863439','2019-08-03'),
('user10','Adrian','password10','82116235','2020-05-03'),
('user11','Ralph','password11','93249127','2019-09-14'),
('user12','Larry','password12','90558130','2019-08-16'),
('user13','Kenny','password13','88684780','2019-06-20'),
('user14','Ralph','password14','82827745','2019-06-13'),
('user15','Jill','password15','92939544','2019-06-11'),
('user16','xiaomeimei','password16','92165148','2019-06-02'),
('user17','Simon','password17','82948057','2019-09-06'),
('user18','Noah','password18','98095014','2019-05-16'),
('user19','Teresa','password19','96869590','2019-09-12'),

('user20','Simon','password20','95880241','2019-07-13'),
('user21','youngpunk','password21','88872365','2019-08-10'),
('user22','Noah','password22','95898465','2019-06-12'),
('user23','Umbriel','password23','94572486','2019-05-28'),
('user24','Iris','password24','96966378','2019-09-25'),
('user25','Queenie','password25','81565485','2019-06-27'),
('user26','Adrian','password26','89186387','2019-06-01'),
('user27','Dennis','password27','90299383','2019-06-13'),
('user28','Edie','password28','83064999','2019-07-03'),
('user29','Olivia','password29','91559454','2019-07-01'),
('user30','Vernice','password30','83086053','2019-05-09'),

('user31','Olivia','password31','99040931','2019-06-19'),
('user32','Morgan','password32','86843096','2020-04-14'),
('user33','Morgan','password33','96389371','2020-03-06'),
('user34','Winston','password34','81566501','2020-01-13'),
('user35','Edie','password35','85991587','2020-03-14'),
('user36','Noah','password36','83276052','2020-04-15'),
('user37','Iris','password37','97464041','2020-01-06'),
('user38','Grace','password38','93653549','2020-05-04'),
('user39','Zack','password39','89346964','2020-03-23'),
('user40','Bert','password40','9247133','2020-02-24'),

('user41','Kenny','password41','91922125','2020-01-27'),
('user42','Olivia','password42','81701755','2020-02-01'),
('user43','Larry','password43','96673740','2020-04-22'),
('user44','Heather','password44','82110300','2020-03-11'),
('user45','Iris','password45','90906047','2020-01-04'),
('user46','Winston','password46','85084589','2020-03-28'),
('user47','xiaomeimei','password47','93555106','2020-02-22'),
('user48','Winston','password48','82350546','2020-01-06'),
('user49','Jill','password49','92145432','2020-03-25'),
('user50','Lynette','password50','87650123','2020-05-07'),

('kfcstaff', 'KFC Staff', 'kfccool', '96567556', '2019-05-06'),
('yooganestaff', 'Yoogane Staff', 'yooganecool', '96567556', '2019-05-06'), 
('sushiteistaff', 'SushiTei Staff', 'sushiteicool', '96567556', '2019-05-06'), 
('mookatastaff', 'Ah Bear Mookata Staff', 'mookatacool', '96567556', '2019-05-06'), 
('marchestaff', 'Marche Staff', 'marchecool', '96567556', '2019-05-06'), 
('haidilaostaff', 'HaiDiLao Staff', 'haidilaocool', '96567556', '2019-05-06'), 
('4fingersstaff', '4Fingers Staff', '4fingerscool', '96567556', '2019-05-06'), 
('riristaff', 'RiRi Mala Staff', 'riricool', '96567556', '2019-05-06'), 
('caesarstaff', 'Caesar Pizza Staff', 'caesarcool', '96567556', '2019-05-06'),
('soupshackstaff', 'Bat Corona Soup Shack Staff', 'soupshackcool', '96567556', '2019-05-06'); 


INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES 
(1, '4Fingers', 15, '68 Orchard Rd #B1-07, Plaza, Singapore 238839'),
(2, 'Yoogane', 25, '3, #03-08 Gateway Dr, Westgate, Singapore 608532'),
(3, 'SushiTei', 40, '154 West Coast Rd, #01-87 West Coast Plaza, Singapore 127371'),
(4, 'KFC', 10, '500 Dover Rd, 5 Singapore Polytechnic Food Court, Singapore 139651'),
(5, 'RiRi Mala', 15, '32 New Market Road #01 42 52, Singapore 050032'),
(6, 'Ah Bear Mookata', 20, '505 W Coast Dr, #01-208, Singapore 120505'),
(7, 'Marche', 50, '50 Jurong Gateway Rd, #01-03 JEM, Singapore 608549'),
(8, 'HaiDiLao', 80, '1 Harbourfront Walk #03-09 Vivocity, Singapore 098585'),
(9, 'Caesar Pizza', 30, '16 Collyer Quay, #01-05 Income At Raffles, Singapore 049318'),
(10, 'BatCoronaSoupShack', 69, 'Wuhan Wet Market, China');

INSERT INTO RestaurantStaff(username, restid) VALUES
('stafftest', NULL),
('kfcstaff', 4),
('yooganestaff', 2), 
('sushiteistaff', 3), 
('mookatastaff', 6), 
('marchestaff', 7), 
('haidilaostaff', 8), 
('4fingersstaff', 1), 
('riristaff', 5), 
('caesarstaff', 9),
('soupshackstaff', 10);

INSERT INTO FDSManagers(username) VALUES
('managertest');

INSERT INTO Customers(username) VALUES
('kalsyc'),
('lynjaaa'),
('justning'),
('custtest'),
('user0'),
('user1'),
('user2'),
('user3'),
('user4'),
('user5'),
('user6'),
('user7'),
('user8'),
('user9'),
('user10'),
('user11'),
('user12'),
('user13'),
('user14'),
('user15'),
('user16'),
('user17'),
('user18'),
('user19'),
('user20'),
('user50');

INSERT INTO DeliveryRiders(username) VALUES
('fullridertest'),
('partridertest'),
('bakwah'),
('user31'),
('user32'),
('user33'),
('user34'),
('user35'),
('user36'),
('user37'),
('user38'),
('user39'),
('user40'),
('user41'),
('user42'),
('user43'),
('user44'),
('user45'),
('user46'),
('user47'),
('user48'),
('user49');

INSERT INTO FullTimeRiders(username) VALUES
('bakwah'),
('fullridertest'),
('user31'),
('user32'),
('user33'),
('user34'),
('user35'),
('user36'),
('user37'),
('user38'),
('user39'),
('user40');

INSERT INTO PartTimeRiders(username) VALUES
('partridertest'),
('user41'),
('user42'),
('user43'),
('user44'),
('user45'),
('user46'),
('user47'),
('user48'),
('user49');

<<<<<<< HEAD

=======
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES 
(1, '4Fingers', 15, '68 Orchard Rd #B1-07, Plaza, Singapore 238839'),
(2, 'Yoogane', 25, '3, #03-08 Gateway Dr, Westgate, Singapore 608532'),
(3, 'SushiTei', 40, '154 West Coast Rd, #01-87 West Coast Plaza, Singapore 127371'),
(4, 'KFC', 10, '500 Dover Rd, 5 Singapore Polytechnic Food Court, Singapore 139651'),
(5, 'RiRi Mala', 15, '32 New Market Road #01 42 52, Singapore 050032'),
(6, 'Ah Bear Mookata', 20, '505 W Coast Dr, #01-208, Singapore 120505'),
(7, 'Marche', 50, '50 Jurong Gateway Rd, #01-03 JEM, Singapore 608549'),
(8, 'HaiDiLao', 80, '1 Harbourfront Walk #03-09 Vivocity, Singapore 098585'),
(9, 'Caesar Pizza', 30, '16 Collyer Quay, #01-05 Income At Raffles, Singapore 049318');

INSERT INTO RestaurantStaff(username, restid) VALUES
('staffresttest', 1),
('user21', 1),
('user22', 2),
('user23', 3),
('user24', 4),
('user25', 5),
('user26', 6),
('user27', 7),
('user28', 8),
('user29', 9);

INSERT INTO Locations(username, location, dateAdded) VALUES
('justning', '21 Lower Kent Ridge Rd, Singapore 119077', '2020-04-03'),
('justning', '469 Bukit Timah Rd, Singapore 259756', '2020-04-01'),
('justning', '20 Heng Mui Keng Terrace, Singapore 119618', '2020-02-07'),
('justning', '12 Kent Ridge Dr, Singapore 119243', '2020-02-21'),
('justning', '2 College Ave West, Stephen Riady Centre, Singapore 138607', '2020-01-04'),
('kalsyc', '21 Lower Kent Ridge Rd, Singapore 119077', '2020-04-03'),
('kalsyc', '469 Bukit Timah Rd, Singapore 259756', '2020-04-01'),
('kalsyc', '20 Heng Mui Keng Terrace, Singapore 119618', '2020-02-07'),
('user0', 'Bishan St 21 Blk 108B #12-733', '2020-03-07'),
('user1', 'Canberra Link Blk 108B #11-733', '2020-02-08'),
('user2', 'Woodlands St 13 Blk 108B #10-733', '2020-04-07'),
('user3', 'Serangoon Ave 3 Blk 108B #9-733', '2020-05-07'),
('user4', 'Lor Ah Soo Rd Blk 108B #8-733', '2020-02-07'),
('user5', 'Pasir Ris Drive 10 Blk 108B #7-733', '2020-01-07'),
('user6', 'Toa Payoh Lorong 6 Blk 108B #6-733', '2020-03-07'),
('user6', 'Bedok St 31 Blk 108B #5-733', '2020-02-11'),
('user7', 'Ang Mo Kio Ave 4 Blk 108B #4-733', '2020-01-21'),
('user7', 'Toa Payoh Lorong 4 Blk 108B #3-733', '2020-03-13');

INSERT INTO Food(foodid, description, restid, price, dailylimit, availability, category, timesordered) VALUES
(1, 'soy sauce wings', 1, 12, 100, 100, 'Korean', 0),
(2, 'spicy drumlets', 1, 12, 100, 100, 'Korean', 0),
(39, 'Combo A', 1, 12, 100, 100, 'Combo', 0),
(40, 'Combo B', 1, 13, 100, 100, 'Combo', 0),
(41, 'Combo C', 1, 14, 100, 100, 'Combo', 0),
(42, 'Combo D', 1, 15, 100, 100, 'Combo', 0),
(43, 'Combo E', 1, 25, 100, 100, 'Combo', 0),
(44, 'Combo F', 1, 55, 100, 100, 'Combo', 0),

(23, 'kimchi', 2, 4, 100, 100, 'Korean', 0),
(24, 'Pork belly', 2, 15, 50, 50, 'Korean', 0),
(25, 'Tteok', 2, 8, 200, 200, 'Korean', 0),
(26, 'Kimbap', 2, 10, 200, 200, 'Korean', 0),
(27, 'Barley Tea', 2, 3, 200, 200, 'Beverage', 0),
(28, 'Ramyeon', 2, 14, 200, 200, 'Korean', 0),
(3, 'army stew', 2, 8, 24, 24, 'Korean', 0),
(4, 'kimchi pancakes', 2, 8, 8, 100, 'Korean', 0),

(5, 'unagi sushi', 3, 6, 100, 100, 'Sushi', 0),
(6, 'chawanmushi', 3, 3, 100, 100, 'Japanese', 0),
(7, 'chicken katsu', 3, 8, 100, 100, 'Japanese', 0),
(30, 'uni sushi', 3, 12, 20, 20, 'Sushi', 0),
(31, 'seafood nabe', 3, 18, 20, 20, 'Japanese', 0),
(32, 'green tea', 3, 2, 200, 200, 'Japanese', 0),
(33, 'Tempura', 3, 16, 50, 50, 'Japanese', 0),
(34, 'Soba', 3, 15, 50, 50, 'Japanese', 0),
(35, 'Oyakodon', 3, 16, 50, 50, 'Japanese', 0),
(36, 'Anago Sushi', 3, 2, 100, 100, 'Sushi', 0),
(37, 'Salmon Nigiri', 3, 4, 100, 100, 'Sushi', 0),
(38, 'Otoro Nigiri', 3, 5, 60, 60, 'Sushi', 0),

(8, 'cheese fries', 4, 4.5, 2, 2, 'FastFood', 0),
(9, 'popcorn chicken', 4, 8, 100, 100, 'FastFood', 0),
(10, 'lime froyo', 4, 2, 100, 100, 'FastFood', 0),

(11, 'zhong la mala hotpot', 5, 8, 100, 100, 'Chinese', 0),
(12, 'da la mala hotpot', 5, 17, 100, 100, 'Chinese', 0),

(13, 'smoked duck', 6, 2.5, 100, 100, 'Sharing', 0),
(14, 'luncheon meat', 6, 2, 100, 100, 'Sharing', 0),
(15, 'black pepper pork belly', 6, 2, 100, 100, 'Sharing', 0),
(16, 'thai milk tea', 6, 3, 100, 100, 'Beverage', 0),

(17, 'rosti', 7, 8.90, 100, 100, 'Western', 0),
(18, 'pork knuckles', 7, 16.50, 100, 100, 'Western', 0),
(19, 'smoked salmon pizza', 7, 22.90, 100, 100, 'Western', 0),
(20, 'beef schnitzel', 7, 19.90, 100, 100, 'Western', 0),
(47, 'sauerkraut', 7, 5.50, 100, 100, 'Western', 0),
(48, 'Munich Beer', 7, 10.90, 100, 100, 'Beer', 0),
(49, 'Lobster Bisque', 7, 8.90, 100, 100, 'Soup', 0),

(21, 'prawn paste', 8, 12, 100, 100, 'Chinese', 0),
(22, 'golden man tou', 8, 8, 100, 100, 'Chinese', 0);

INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES 
(2, 'justning', '469 Bukit Timah Rd Singapore 259756', '04/05/2020 1230', 10.80, NULL, 4, True, True, 1, True),
(3, 'kalsyc', '20 Heng Mui Keng Terrace Singapore 119618', '04/05/2020 1320', 23.80, NULL, 1, True, True, 1, True),
(4, 'kalsyc', '12 Kent Ridge Dr Singapore 119243', '04/05/2020 1330', 18.80, NULL, 1, True, True, 1, True),
(5, 'kalsyc', '2 College Ave West Stephen Riady Centre Singapore 138607', '04/05/2020 1350', 13.80, NULL, 1, True, True, 1, True),
(7, 'justning', '16 #01-220 College Ave West 138527', '04/05/2020 1630', 13.00, NULL, 100, True, True, 1, True),
(8, 'kalsyc', '16 Science Drive 4 Singapore 117558', '04/05/2020 1700', 16.30, NULL, 1, True, True, 1, True), 
(9, 'kalsyc', '2 Engineering Drive 3 Singapore 117581', '04/05/2020 1730', 14.90, NULL, 1, True, True, 1, True),
(10, 'kalsyc', '9 Engineering Drive 1 #03-09 EA Singapore 117575', '04/05/2020 1750', 15.60, NULL, 1, True, True, 1, True),
(11, 'justning', '13 Computing Drive Singapore 117417', '05/05/2020 2100', 133.00, NULL, 101, True, True, 1, True),
(12, 'kalsyc', '5 Arts Link 5 The Block AS7 Level Shaw Foundation Building Singapore 117570', '04/01/2020 1830', 13.10, NULL, 1, True, True, 1, True),
(13, 'justning', '12 Kent Ridge Cresent Central Library Building CLB01 02 Singapore 119275', '02/05/2020 1930', 19.80, NULL, 102, True, True, 1, True),
(14, 'user0', '3 Science Drive 2 Singapore 117543', '05/05/2020 1945', 20, NULL, 6, True, True, 3, True),
(15, 'user1', '3 Science Drive 2 Singapore 117543', '06/05/2020 2145', 20, NULL, 7, True, True, 3, True),
(16, 'user2', '3 Science Drive 2 Singapore 117543', '05/05/2020 1445', 20, NULL, 8, True, True, 3, True),
(17, 'user3', '3 Science Drive 2 Singapore 117543', '07/05/2020 1345', 20, NULL, 9, True, True, 3, True),
(18, 'user0', '3 Science Drive 2 Singapore 117543', '08/04/2020 1245', 20, NULL, 6, True, True, 3, True),
(19, 'user0', '3 Science Drive 2 Singapore 117543', '09/03/2020 1145', 20, NULL, 6, True, True, 3, True),
(20, 'user1', '3 Science Drive 2 Singapore 117543', '11/03/2020 1045', 20, NULL, 7, True, True, 3, True),
(21, 'user2', '3 Science Drive 2 Singapore 117543', '01/05/2020 1945', 20, NULL, 8, True, True, 3, True),
(22, 'user3', '3 Science Drive 2 Singapore 117543', '02/05/2020 1845', 20, NULL, 9, True, True, 3, True),
(23, 'user4', '3 Science Drive 2 Singapore 117543', '03/05/2020 1745', 20, NULL, 10, True, True, 3, True),
(24, 'user5', '3 Science Drive 2 Singapore 117543', '05/05/2020 1645', 20, NULL, 11, True, True, 3, True),
(25, 'user6', '3 Science Drive 2 Singapore 117543', '06/05/2020 1545', 40, NULL, 12, True, True, 3, True),
(26, 'user7', '3 Science Drive 2 Singapore 117543', '08/02/2020 1445', 40, NULL, 13, True, True, 3, True),
(27, 'user8', '3 Science Drive 2 Singapore 117543', '09/02/2020 1345', 55.80, NULL, 14, True, True, 3, True),
(28, 'user9', '3 Science Drive 2 Singapore 117543', '14/03/2020 1245', 26.80, NULL, 15, True, True, 3, True),
(29, 'kalsyc', '3 Science Drive 2 Singapore 117543', '14/04/2020 1145', 27.80, NULL, 1, True, True, 3, True),
(30, 'kalsyc', '3 Science Drive 2 Singapore 117543', '24/01/2020 1045', 25.80, NULL, 1, True, True, 3, True),
(31, 'kalsyc', '3 Science Drive 2 Singapore 117543', '25/02/2020 1905', 24.80, NULL, 1, True, True, 3, True),
(32, 'kalsyc', '3 Science Drive 2 Singapore 117543', '06/03/2020 2005', 23.80, NULL, 1, True, True, 3, True),
(33, 'kalsyc', '3 Science Drive 2 Singapore 117543', '07/01/2020 1225', 22.80, NULL, 1, True, True, 3, True),
(34, 'kalsyc', '3 Science Drive 2 Singapore 117543', '03/04/2020 1325', 22.80, NULL, 1, True, True, 3, True),
(35, 'kalsyc', '3 Science Drive 2 Singapore 117543', '01/04/2020 1355', 21.80, NULL, 1, True, True, 3, True),
(36, 'kalsyc', '3 Science Drive 2 Singapore 117543', '01/04/2020 1355', 21.80, NULL, 1, True, True, 3, True),
(37, 'kalsyc', '3 Science Drive 2 Singapore 117543', '07/05/2020 1815', 13.80, NULL, 1, False, True, 4, False),
(38, 'lynjaaa', '3 Science Drive 2 Singapore 117543', '07/05/2020 1855', 25.80, NULL, 1, False, True, 4, False);

INSERT INTO Contains(orderid, foodid, quantity) VALUES
(2, 2, 1),
(3, 2, 1),
(3, 3, 1),
(4, 2, 2),
(5, 3, 1),
(6, 40, 1),
(7, 39, 1),
(8, 41, 1),
(9, 42, 1),
(10, 43, 1),
(11, 44, 1),
(11, 41, 2),
(11, 40, 3),
(12, 39, 1),
(13, 39, 1),
(14, 5, 1),
(15, 5, 1),
(16, 5, 1),
(17, 5, 1),
(17, 6, 2),
(18, 7, 2),
(23, 30, 3),
(24, 31, 4),
(25, 30, 3),
(28, 30, 3),
(34, 38, 5),
(18, 5, 1),
(19, 5, 1),
(20, 5, 1),
(21, 5, 1),
(22, 5, 1),
(23, 5, 1),
(24, 5, 1),
(25, 5, 1),
(26, 5, 1),
(27, 5, 1),
(28, 5, 1),
(29, 5, 1),
(30, 5, 1),
(31, 5, 1),
(32, 5, 1),
(33, 5, 1),
(34, 5, 1),
(35, 5, 1),
(37, 8, 1),
(37, 9, 1),
(37, 10, 2),
(38, 8, 5),
(38, 9, 3),
(38, 10, 2);

INSERT INTO PaymentMethods(paymentmethodid, username, cardInfo) VALUES
(100, 'justning', 'dbs card'),
(101, 'justning', 'ocbc card'),
(102, 'justning', 'uob card'),
(103, 'justning', 'stanchart card'),
(104, 'user0', 'uob card'),
(105, 'user1', 'dbs card'),
(106, 'user2', 'paylah debit'),
(107, 'user3', 'american express card');

INSERT INTO MonthlyWorkSchedule(mwsid, username, mnthStartDay, wkStartDay, day1, day2, day3, day4, day5) VALUES
(1, 'user31', '2019-10-19', 1, 3, 0, 0, 2, 2),

(2, 'user31', '2019-11-19', 1, 2, 1, 3, 2, 1),

(3, 'user31', '2019-12-19', 1, 2, 1, 3, 2, 1),

(4, 'user31', '2020-01-02', 1, 3, 0, 0, 2, 2),
(5, 'user34', '2020-01-02', 1, 3, 3, 3, 3, 3),
(6, 'user37', '2020-01-02', 1, 3, 0, 0, 2, 2),

(7, 'user31', '2020-02-02', 1, 2, 1, 3, 2, 1),
(8, 'user34', '2020-02-02', 1, 3, 0, 0, 2, 2),
(9, 'user37', '2020-02-02', 1, 2, 1, 3, 2, 1),
(10, 'user40', '2020-02-02', 1, 3, 0, 0, 2, 2),

(11, 'user31', '2020-03-02', 1, 3, 0, 0, 2, 2),
(12, 'user33', '2020-03-02', 1, 2, 1, 3, 2, 1),
(13, 'user34', '2020-03-02', 1, 2, 1, 3, 2, 1),
(14, 'user35', '2020-03-02', 1, 3, 0, 0, 2, 2),
(15, 'user37', '2020-03-02', 1, 2, 1, 3, 2, 1),
(16, 'user39', '2020-03-02', 1, 3, 0, 0, 2, 2),
(17, 'user40', '2020-03-02', 1, 2, 1, 3, 2, 1),

(18, 'user31', '2020-04-02', 1, 3, 3, 3, 3, 3),
(19, 'user33', '2020-04-02', 1, 1, 0, 1, 2, 3),
(20, 'user34', '2020-04-02', 1, 3, 3, 3, 3, 3),
(21, 'user35', '2020-04-02', 1, 1, 0, 1, 2, 3),
(22, 'user36', '2020-04-02', 1, 1, 0, 1, 2, 3),
(23, 'user37', '2020-04-02', 1, 3, 3, 3, 3, 3),
(24, 'user39', '2020-04-02', 1, 3, 3, 3, 3, 3),
(25, 'user40', '2020-04-02', 1, 1, 0, 1, 2, 3),

(26, 'fullridertest', '2020-05-01', 1, 3, 3, 3, 3, 3),
(27, 'user31', '2020-05-02', 1, 2, 1, 3, 2, 1),
(28, 'user32', '2020-05-03', 1, 3, 0, 0, 2, 2),
(29, 'user33', '2020-05-04', 1, 1, 0, 1, 2, 3),
(30, 'user34', '2020-05-04', 1, 2, 1, 3, 2, 1),
(31, 'user35', '2020-05-04', 1, 3, 0, 0, 2, 2),
(32, 'user36', '2020-05-04', 1, 1, 0, 1, 2, 3),
(33, 'user37', '2020-05-04', 1, 2, 1, 3, 2, 1),
(34, 'user38', '2020-05-04', 1, 1, 0, 1, 2, 3),
(35, 'user39', '2020-05-04', 1, 2, 1, 3, 2, 1),
(36, 'user40', '2020-05-04', 1, 3, 0, 0, 2, 2);

/*
INSERT INTO FixedWeeklySchedule(fwsid, mwsid, day1, day2, day3, day4, day5) VALUES
(1, 1, 0, 1, 2, 3, 0);
*/

INSERT INTO WeeklyWorkSchedule(wwsid, username, startDate) VALUES
(1, 'user45', '2020-01-06'),
(2, 'user45', '2020-01-13'),
(3, 'user45', '2020-01-20'),
(4, 'user45', '2020-01-27'),
(5, 'user45', '2020-02-03'),
(6, 'user45', '2020-02-10'),
(7, 'user45', '2020-02-17'),
(8, 'user45', '2020-02-24'),
(9, 'user45', '2020-03-02'),
(10, 'user45', '2020-03-09'),
(11, 'user45', '2020-03-16'),
(12, 'user45', '2020-03-23'),
(13, 'user45', '2020-03-30'),
(14, 'user45', '2020-04-06'),
(15, 'user45', '2020-04-13'),
(16, 'user45', '2020-04-20'),
(17, 'user45', '2020-04-27'),
(18, 'user45', '2020-05-04'),
(19, 'user48', '2020-01-13'),
(20, 'user48', '2020-01-20'),
(21, 'user48', '2020-01-27'),
(22, 'user48', '2020-02-03'),
(23, 'user48', '2020-02-10'),
(24, 'user48', '2020-02-17'),
(25, 'user48', '2020-02-24'),
(26, 'user48', '2020-03-02'),
(27, 'user48', '2020-03-09'),
(28, 'user48', '2020-03-16'),
(29, 'user48', '2020-03-23'),
(30, 'user48', '2020-03-30'),
(31, 'user48', '2020-04-06'),
(32, 'user48', '2020-04-13'),
(33, 'user48', '2020-04-20'),
(34, 'user48', '2020-04-27'),
(35, 'user48', '2020-05-04'),
(36, 'user41', '2020-02-03'),
(37, 'user41', '2020-02-10'),
(38, 'user41', '2020-02-17'),
(39, 'user41', '2020-02-24'),
(40, 'user41', '2020-03-02'),
(41, 'user41', '2020-03-09'),
(42, 'user41', '2020-03-16'),
(43, 'user41', '2020-03-23'),
(44, 'user41', '2020-03-30'),
(45, 'user41', '2020-04-06'),
(46, 'user41', '2020-04-13'),
(47, 'user41', '2020-04-20'),
(48, 'user41', '2020-04-27'),
(49, 'user41', '2020-05-04'),
(50, 'user42', '2020-02-03'),
(51, 'user42', '2020-02-10'),
(52, 'user42', '2020-02-17'),
(53, 'user42', '2020-02-24'),
(54, 'user42', '2020-03-02'),
(55, 'user42', '2020-03-09'),
(56, 'user42', '2020-03-16'),
(57, 'user42', '2020-03-23'),
(58, 'user42', '2020-03-30'),
(59, 'user42', '2020-04-06'),
(60, 'user42', '2020-04-13'),
(61, 'user42', '2020-04-20'),
(62, 'user42', '2020-04-27'),
(63, 'user42', '2020-05-04'),
(64, 'user47', '2020-02-24'),
(65, 'user47', '2020-03-02'),
(66, 'user47', '2020-03-09'),
(67, 'user47', '2020-03-16'),
(68, 'user47', '2020-03-23'),
(69, 'user47', '2020-03-30'),
(70, 'user47', '2020-04-06'),
(71, 'user47', '2020-04-13'),
(72, 'user47', '2020-04-20'),
(73, 'user47', '2020-04-27'),
(74, 'user47', '2020-05-04'),
(75, 'user44', '2020-03-16'),
(76, 'user44', '2020-03-23'),
(77, 'user44', '2020-03-30'),
(78, 'user44', '2020-04-06'),
(79, 'user44', '2020-04-13'),
(80, 'user44', '2020-04-20'),
(81, 'user44', '2020-04-27'),
(82, 'user44', '2020-05-04'),
(83, 'user49', '2020-03-30'),
(84, 'user49', '2020-04-06'),
(85, 'user49', '2020-04-13'),
(86, 'user49', '2020-04-20'),
(87, 'user49', '2020-04-27'),
(88, 'user49', '2020-05-04'),
(89, 'user46', '2020-03-30'),
(90, 'user46', '2020-04-06'),
(91, 'user46', '2020-04-13'),
(92, 'user46', '2020-04-20'),
(93, 'user46', '2020-04-27'),
(94, 'user46', '2020-05-04'),
(95, 'user43', '2020-04-27'),
(96, 'user43', '2020-05-04'),
(97, 'partridertest', '2020-05-04');

INSERT INTO DailyWorkShift(dwsid, wwsid, day, startHour, duration) VALUES
(1, 1, 0, 10, 4),
(2, 1, 0, 15, 4),
(3, 1, 0, 20, 2),
(4, 2, 0, 10, 4),
(5, 2, 0, 15, 4),
(6, 2, 0, 20, 2),
(7, 3, 0, 10, 4),
(8, 3, 0, 15, 4),
(9, 3, 0, 20, 2),
(10, 4, 0, 10, 4),
(11, 4, 0, 15, 4),
(12, 4, 0, 20, 2),
(13, 5, 0, 10, 4),
(14, 5, 0, 15, 4),
(15, 5, 0, 20, 2),
(16, 6, 0, 10, 4),
(17, 6, 0, 15, 4),
(18, 6, 0, 20, 2),
(19, 7, 0, 10, 4),
(20, 7, 0, 15, 4),
(21, 7, 0, 20, 2),
(22, 8, 0, 10, 4),
(23, 8, 0, 15, 4),
(24, 8, 0, 20, 2),
(25, 9, 0, 10, 4),
(26, 9, 0, 15, 4),
(27, 9, 0, 20, 2),
(28, 10, 0, 10, 4),
(29, 10, 0, 15, 4),
(30, 10, 0, 20, 2),
(31, 11, 0, 10, 4),
(32, 11, 0, 15, 4),
(33, 11, 0, 20, 2),
(34, 12, 0, 10, 4),
(35, 12, 0, 15, 4),
(36, 12, 0, 20, 2),
(37, 13, 0, 10, 4),
(38, 13, 0, 15, 4),
(39, 13, 0, 20, 2),
(40, 14, 0, 10, 4),
(41, 14, 0, 15, 4),
(42, 14, 0, 20, 2),
(43, 15, 0, 10, 4),
(44, 15, 0, 15, 4),
(45, 15, 0, 20, 2),
(46, 16, 0, 10, 4),
(47, 16, 0, 15, 4),
(48, 16, 0, 20, 2),
(49, 17, 0, 10, 4),
(50, 17, 0, 15, 4),
(51, 17, 0, 20, 2),
(52, 18, 0, 10, 4),
(53, 18, 0, 15, 4),
(54, 18, 0, 20, 2),

(55, 19, 1, 10, 4),
(56, 19, 1, 15, 4),
(57, 19, 1, 20, 2),
(58, 20, 1, 10, 4),
(59, 20, 1, 15, 4),
(60, 20, 1, 20, 2),
(61, 21, 1, 10, 4),
(62, 21, 1, 15, 4),
(63, 21, 1, 20, 2),
(64, 22, 1, 10, 4),
(65, 22, 1, 15, 4),
(66, 22, 1, 20, 2),
(67, 23, 1, 10, 4),
(68, 23, 1, 15, 4),
(69, 23, 1, 20, 2),
(70, 24, 1, 10, 4),
(71, 24, 1, 15, 4),
(72, 24, 1, 20, 2),
(73, 25, 1, 10, 4),
(74, 25, 1, 15, 4),
(75, 25, 1, 20, 2),
(76, 26, 1, 10, 4),
(77, 26, 1, 15, 4),
(78, 26, 1, 20, 2),
(79, 27, 1, 10, 4),
(80, 27, 1, 15, 4),
(81, 27, 1, 20, 2),
(82, 28, 1, 10, 4),
(83, 28, 1, 15, 4),
(84, 28, 1, 20, 2),
(85, 29, 1, 10, 4),
(86, 29, 1, 15, 4),
(87, 29, 1, 20, 2),
(88, 30, 1, 10, 4),
(89, 30, 1, 15, 4),
(90, 30, 1, 20, 2),
(91, 31, 1, 10, 4),
(92, 31, 1, 15, 4),
(93, 31, 1, 20, 2),
(94, 32, 1, 10, 4),
(95, 32, 1, 15, 4),
(96, 32, 1, 20, 2),
(97, 33, 1, 10, 4),
(98, 33, 1, 15, 4),
(99, 33, 1, 20, 2),
(100, 34, 1, 10, 4),
(101, 34, 1, 15, 4),
(102, 34, 1, 20, 2),
(103, 35, 1, 10, 4),
(104, 35, 1, 15, 4),
(105, 35, 1, 20, 2),

(106, 36, 2, 10, 4),
(107, 36, 2, 15, 4),
(108, 36, 2, 20, 2),
(109, 37, 2, 10, 4),
(110, 37, 2, 15, 4),
(111, 37, 2, 20, 2),
(112, 38, 2, 10, 4),
(113, 38, 2, 15, 4),
(114, 38, 2, 20, 2),
(115, 39, 2, 10, 4),
(116, 39, 2, 15, 4),
(117, 39, 2, 20, 2),
(118, 40, 2, 10, 4),
(119, 40, 2, 15, 4),
(120, 40, 2, 20, 2),
(121, 41, 2, 10, 4),
(122, 41, 2, 15, 4),
(123, 41, 2, 20, 2),
(124, 42, 2, 10, 4),
(125, 42, 2, 15, 4),
(126, 42, 2, 20, 2),
(127, 43, 2, 10, 4),
(128, 43, 2, 15, 4),
(139, 43, 2, 20, 2),
(130, 44, 2, 10, 4),
(131, 44, 2, 15, 4),
(132, 44, 2, 20, 2),
(133, 45, 2, 10, 4),
(134, 45, 2, 15, 4),
(135, 45, 2, 20, 2),
(136, 46, 2, 10, 4),
(137, 46, 2, 15, 4),
(138, 46, 2, 20, 2),
(149, 47, 2, 10, 4),
(140, 47, 2, 15, 4),
(141, 47, 2, 20, 2),
(142, 48, 2, 10, 4),
(143, 48, 2, 15, 4),
(144, 48, 2, 20, 2),
(145, 49, 2, 10, 4),
(146, 49, 2, 15, 4),
(147, 49, 2, 20, 2),

(150, 50, 3, 10, 4),
(151, 50, 3, 15, 4),
(152, 50, 3, 20, 2),
(151, 51, 3, 10, 4),
(152, 51, 3, 15, 4),
(153, 51, 3, 20, 2),
(154, 52, 3, 10, 4),
(155, 52, 3, 15, 4),
(156, 52, 3, 20, 2),
(157, 53, 3, 10, 4),
(158, 53, 3, 15, 4),
(159, 53, 3, 20, 2),
(160, 54, 3, 10, 4),
(161, 54, 3, 15, 4),
(162, 54, 3, 20, 2),
(163, 55, 3, 10, 4),
(164, 55, 3, 15, 4),
(165, 55, 3, 20, 2),
(166, 56, 3, 10, 4),
(167, 56, 3, 15, 4),
(168, 56, 3, 20, 2),
(169, 57, 3, 10, 4),
(170, 57, 3, 15, 4),
(171, 57, 3, 20, 2),
(172, 58, 3, 10, 4),
(173, 58, 3, 15, 4),
(174, 58, 3, 20, 2),
(175, 59, 3, 10, 4),
(176, 59, 3, 15, 4),
(177, 59, 3, 20, 2),
(178, 60, 3, 10, 4),
(179, 60, 3, 15, 4),
(180, 60, 3, 20, 2),
(181, 61, 3, 10, 4),
(182, 61, 3, 15, 4),
(183, 61, 3, 20, 2),
(184, 62, 3, 10, 4),
(185, 62, 3, 15, 4),
(186, 62, 3, 20, 2),
(187, 63, 3, 10, 4),
(188, 63, 3, 15, 4),
(189, 63, 3, 20, 2),

(190, 64, 4, 10, 4),
(191, 64, 4, 15, 4),
(192, 64, 4, 20, 2),
(193, 65, 4, 10, 4),
(194, 65, 4, 15, 4),
(195, 65, 4, 20, 2),
(196, 66, 4, 10, 4),
(197, 66, 4, 15, 4),
(198, 66, 4, 20, 2),
(199, 67, 4, 10, 4),
(200, 67, 4, 15, 4),
(201, 67, 4, 20, 2),
(202, 68, 4, 10, 4),
(201, 68, 4, 15, 4),
(204, 68, 4, 20, 2),
(205, 69, 4, 10, 4),
(206, 69, 4, 15, 4),
(207, 69, 4, 20, 2),
(208, 70, 4, 10, 4),
(209, 70, 4, 15, 4),
(210, 70, 4, 20, 2),
(211, 71, 4, 10, 4),
(212, 71, 4, 15, 4),
(213, 71, 4, 20, 2),
(214, 72, 4, 10, 4),
(215, 72, 4, 15, 4),
(216, 72, 4, 20, 2),
(217, 73, 4, 10, 4),
(218, 73, 4, 15, 4),
(219, 73, 4, 20, 2),
(220, 74, 4, 10, 4),
(221, 74, 4, 15, 4),
(222, 74, 4, 20, 2),

(223, 75, 5, 10, 4),
(224, 75, 5, 15, 4),
(225, 75, 5, 20, 2),
(226, 76, 5, 10, 4),
(227, 76, 5, 15, 4),
(228, 76, 5, 20, 2),
(229, 77, 5, 10, 4),
(230, 77, 5, 15, 4),
(231, 77, 5, 20, 2),
(232, 78, 5, 10, 4),
(233, 78, 5, 15, 4),
(234, 78, 5, 20, 2),
(235, 79, 5, 10, 4),
(236, 79, 5, 15, 4),
(237, 79, 5, 20, 2),
(238, 80, 5, 10, 4),
(239, 80, 5, 15, 4),
(240, 80, 5, 20, 2),
(241, 81, 5, 10, 4),
(242, 81, 5, 15, 4),
(243, 81, 5, 20, 2),
(244, 82, 5, 10, 4),
(245, 82, 5, 15, 4),
(246, 82, 5, 20, 2),

(247, 83, 6, 10, 4),
(248, 83, 6, 15, 4),
(249, 83, 6, 20, 2),
(250, 84, 6, 10, 4),
(251, 84, 6, 15, 4),
(252, 84, 6, 20, 2),
(253, 85, 6, 10, 4),
(254, 85, 6, 15, 4),
(255, 85, 6, 20, 2),
(256, 86, 6, 10, 4),
(257, 86, 6, 15, 4),
(258, 86, 6, 20, 2),
(259, 87, 6, 10, 4),
(260, 87, 6, 15, 4),
(261, 87, 6, 20, 2),
(262, 88, 6, 10, 4),
(263, 88, 6, 15, 4),
(264, 88, 6, 20, 2),

(265, 89, 0, 10, 4),
(266, 89, 1, 15, 4),
(267, 89, 2, 20, 2),
(268, 90, 0, 10, 4),
(269, 90, 1, 15, 4),
(270, 90, 2, 20, 2),
(271, 91, 0, 10, 4),
(272, 91, 1, 15, 4),
(273, 91, 2, 20, 2),
(274, 92, 0, 10, 4),
(275, 92, 1, 15, 4),
(276, 92, 2, 20, 2),
(277, 93, 0, 10, 4),
(278, 93, 1, 15, 4),
(279, 93, 2, 20, 2),
(270, 94, 0, 10, 4),
(281, 94, 1, 15, 4),
(282, 94, 2, 20, 2),

(283, 95, 3, 10, 4),
(284, 95, 4, 15, 4),
(285, 95, 5, 20, 2),
(286, 96, 3, 10, 4),
(287, 96, 4, 15, 4),
(288, 96, 5, 20, 2),

(289, 97, 0, 10, 4),
(290, 97, 2, 15, 4),
(291, 97, 4, 20, 2);

INSERT INTO Delivers(orderid, username, rating, location, deliveryFee, timeDepartToRestaurant, timeArrivedAtRestaurant, timeOrderDelivered) VALUES
(2, 'fullridertest', 4,  '469 Bukit Timah Rd Singapore 259756', 5, '04/07/2020 1240', '04/07/2020 1300', '04/07/2020 1320'),
(7, 'user48', 3,  '16 #01-220 College Ave West 138527', 5, '04/07/2020 1640', '04/07/2020 1650', '04/07/2020 1715'),
(11, 'fullridertest', 3,  '13 Computing Drive Singapore 117417', 5, '03/02/2020 1805', '03/02/2020 1815', '03/02/2020 1830'),
(13, 'bakwah', 3,  '16 #01-220 College Ave West 138527', 5, '02/01/2020 1650', '02/01/2020 1715', '02/01/2020 1730'),
(14, NULL, NULL, '3 Science Drive 2 Singapore 117543', 5, NULL, NULL, NULL),
(15, 'user33', NULL, '3 Science Drive 2 Singapore 117543', 5, NULL, NULL, NULL);

INSERT INTO FDSPromo(fdspromoid, description, type, value, minAmnt, appliedto, startTime, endTime, points) VALUES
(1, '10% off all orders this Circuit Breaker', 'percentoff', 10, 0, 'total', '18/04/2020', '05/04/2020', 0),
(2, '25% off all orders this Valentine Day', 'percentoff', 25, 0, 'total', '14/02/2020', '28/02/2020', 30),
(3, '$5 off all orders for the month of May, minimum order of $50', 'amountoff', 5, 50, 'total', '01/05/2020', '31/05/2020', 40),
(4, '5% off all delivery for the month of May', 'percentoff',  5, 0, 'delivery', '01/05/2020', '31/05/2020', 25),
(5, '5% off all orders for from 4Fingers', 'percentoff', 5, 0, 'total', '01/05/2020', '31/05/2020', 12),
(6, '5% off all orders for from RIRIMALA', 'percentoff', 5, 0, 'total', '01/05/2020', '31/05/2020', 12),
(7, '$5 off all orders for CCB', 'amountoff', 5, 0, 'total', '01/06/2020', '15/06/2020', 0);

INSERT INTO DeliveryPromo(deliverypromoid, description, amount, points) values 
(1, '$1 off delivery', 1, 10),
(2, '$2 off delivery', 2, 20),
(3, '$3 off delivery', 3, 30),
(4, '$4 off delivery', 4, 40);

INSERT INTO AllStats(month, year, totalNewCust, totalNumOrders, totalCostOfOrders) values
(1, 2020, 20, 50, 654),
(2, 2020, 34, 62, 722),
(3, 2020, 18, 47, 443),
(4, 2020, 22, 53, 528);

INSERT INTO CustomerStats(username, month, year, totalNumOrders, totalCostOfOrders) values
('justning', 1, 2020, 2, 54),
('justning', 2, 2020, 6, 134),
('lynjaaa', 1, 2020, 1, 25),
('kalsyc', 1, 2020, 4, 89),
('justning', 3, 2020, 7, 154),
('justning', 4, 2019, 6, 204),
('lynjaaa', 2, 2020, 0, 0),
('kalsyc', 2, 2020, 7, 160),
('justning', 5, 2019, 8, 54),
('justning', 6, 2019, 9, 134),
('lynjaaa', 3, 2020, 1, 25),
('kalsyc', 3, 2020, 4, 89),
('justning', 6, 2020, 3, 134),
('lynjaaa', 4, 2020, 1, 25);

INSERT INTO RiderStats(month, year, username, totalOrders, totalSalary) values
(1, 2020, 'user31', 34, 970),
(1, 2020, 'bakwah', 23, 765),
(1, 2020, 'user32', 40, 1280),
(1, 2020, 'user48', 13, 405),
(2, 2020, 'user31', 21, 605),
(2, 2020, 'user32', 32, 920),
(3, 2020, 'user49', 11, 375),
(3, 2020, 'user48', 38, 1190),
(4, 2020, 'user31', 34, 970),
(4, 2020, 'user32', 40, 1280),
(4, 2020, 'user48', 13, 405),

(5, 2020, 'fullridertest', 40, 1280),
(5, 2020, 'user31', 21,  605),
(5, 2020, 'user32', 21,  605),
(5, 2020, 'user33', 32, 920),
(5, 2020, 'user34', 34, 970),
(5, 2020, 'user35', 40, 1280),
(5, 2020, 'user36', 21,  605),
(5, 2020, 'user37', 34, 970),
(5, 2020, 'user38', 40, 1280),
(5, 2020, 'user39', 21,  605),
(5, 2020, 'user40', 34, 970),
(5, 2020, 'partridertest', 12, 380),
(5, 2020, 'user41', 21, 605),
(5, 2020, 'user42', 23, 765),
(5, 2020, 'user43', 23, 765),
(5, 2020, 'user45', 21, 605),
(5, 2020, 'user46', 21, 605),
(5, 2020, 'user47', 23, 765),
(5, 2020, 'user48', 11, 375),
(5, 2020, 'user49', 13, 405);
INSERT INTO RestaurantPromo(fdspromoid, restid) VALUES
(5, 1),
(6, 5);



