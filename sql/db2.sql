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

('user50','Lynette','password50','87650123','2020-05-07');

INSERT INTO RestaurantStaff(username) VALUES
('stafftest');

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
(10, 'Subway', 10, '3155 Commonwealth Ave W, Singapore 129588');

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
(3, 'Combo A', 1, 12, 100, 100, 'Combo', 0),
(4, 'Combo B', 1, 13, 100, 100, 'Combo', 0),
(5, 'Combo C', 1, 14, 100, 100, 'Combo', 0),
(6, 'Combo D', 1, 15, 100, 100, 'Combo', 0),
(7, 'Combo E', 1, 25, 100, 100, 'Combo', 0),
(8, 'Combo F', 1, 55, 100, 100, 'Combo', 0),

(9, 'kimchi', 2, 4, 100, 100, 'Korean', 0),
(10, 'Pork belly', 2, 15, 50, 50, 'Korean', 0),
(11, 'Tteok', 2, 8, 200, 200, 'Korean', 0),
(12, 'Kimbap', 2, 10, 200, 200, 'Korean', 0),
(13, 'Barley Tea', 2, 3, 200, 200, 'Beverage', 0),
(14, 'Ramyeon', 2, 14, 200, 200, 'Korean', 0),
(15, 'army stew', 2, 8, 24, 24, 'Korean', 0),
(16, 'kimchi pancakes', 2, 8, 8, 100, 'Korean', 0),

(17, 'unagi sushi', 3, 6, 100, 100, 'Sushi', 0),
(18, 'chawanmushi', 3, 3, 100, 100, 'Japanese', 0),
(19, 'chicken katsu', 3, 8, 100, 100, 'Japanese', 0),
(20, 'uni sushi', 3, 12, 20, 20, 'Sushi', 0),
(21, 'seafood nabe', 3, 18, 20, 20, 'Japanese', 0),
(22, 'green tea', 3, 2, 200, 200, 'Japanese', 0),
(23, 'Tempura', 3, 16, 50, 50, 'Japanese', 0),
(24, 'Soba', 3, 15, 50, 50, 'Japanese', 0),
(25, 'Oyakodon', 3, 16, 50, 50, 'Japanese', 0),
(26, 'Anago Sushi', 3, 2, 100, 100, 'Sushi', 0),
(27, 'Salmon Nigiri', 3, 4, 100, 100, 'Sushi', 0),
(28, 'Otoro Nigiri', 3, 5, 60, 60, 'Sushi', 0),

(29, 'cheese fries', 4, 4.5, 2, 2, 'FastFood', 0),
(30, 'popcorn chicken', 4, 8, 100, 100, 'FastFood', 0),
(31, 'lime froyo', 4, 2, 100, 100, 'FastFood', 0),
(32, 'zinger meal', 4, 9, 120, 120, 'FastFood', 0),
(33, 'snackers box', 4, 4.50, 150, 150, 'FastFood', 0),
(34, '2pcs chicken', 4, 8, 80, 40, 'FastFood', 0),
(35, 'mushroom burger', 4, 7.50, 80, 40, 'FastFood', 0),
(36, 'pepsi', 4, 2, 100, 100, 'FastFood', 0),

(37, 'zhong la mala hotpot', 5, 8, 100, 100, 'Chinese', 0),
(38, 'da la mala hotpot', 5, 17, 100, 100, 'Chinese', 0),
(39, 'xiao la mala hotpot', 5, 8, 100, 100, 'Chinese', 0),
(40, 'wei la mala hotpot', 5, 8, 100, 100, 'Chinese', 0),
(41, 'shiitake mushroom', 5, 1.50, 100, 100, 'Chinese', 0),
(42, 'pork belly', 5, 2, 100, 100, 'Chinese', 0),
(43, 'chicken', 5, 2, 100, 100, 'Chinese', 0),
(44, 'lotus root', 5, 1, 100, 100, 'Chinese', 0),
(45, 'broccoli', 5, 1, 100, 100, 'Chinese', 0),
(46, 'enoki mushroom', 5, 1, 100, 100, 'Chinese', 0),
(47, 'prawn', 5, 2, 100, 100, 'Chinese', 0),

(48, 'smoked duck', 6, 2.5, 100, 100, 'Sharing', 0),
(49, 'luncheon meat', 6, 2, 100, 100, 'Sharing', 0),
(50, 'black pepper pork belly', 6, 2, 100, 100, 'Sharing', 0),
(51, 'thai milk tea', 6, 3, 100, 100, 'Beverage', 0),
(52, 'plain pork belly', 6, 2, 100, 100, 'Sharing', 0),
(53, 'lotus root', 6, 1, 100, 100, 'Sharing', 0),
(54, 'chicken', 6, 2, 100, 100, 'Sharing', 0),
(55, 'shiitake mushroom', 6, 1, 100, 100, 'Sharing', 0),

(92, 'rosti', 7, 8.90, 100, 100, 'Western', 0),
(56, 'pork knuckles', 7, 16.50, 100, 100, 'Western', 0),
(57, 'smoked salmon pizza', 7, 22.90, 100, 100, 'Western', 0),
(58, 'hawaiian pizza', 7, 22.90, 100, 100, 'Western', 0),
(93, 'beef schnitzel', 7, 19.90, 100, 100, 'Western', 0),
(59, 'sauerkraut', 7, 5.50, 100, 100, 'Western', 0),
(60, 'Munich Beer', 7, 10.90, 100, 100, 'Beer', 0),
(61, 'Lobster Bisque', 7, 8.90, 100, 100, 'Soup', 0),

(62, 'prawn paste', 8, 12, 100, 100, 'Chinese', 0),
(63, 'golden man tou', 8, 8, 100, 100, 'Chinese', 0),
(64, 'prawn dumpling', 8, 10, 100, 100, 'Chinese', 0),
(65, 'pork belly', 8, 16, 150, 150, 'Chinese', 0),
(66, 'xiao long bao', 8, 14, 200, 200, 'Chinese', 0),
(67, 'konjac noodles', 8, 5, 300, 300, 'Chinese', 0),
(68, 'rice', 8, 5, 200, 200, 'Chinese', 0),
(69, 'fruit tea', 8, 17, 100, 100, 'Chinese', 0),
(70, 'beancurd', 8, 4, 200, 200, 'Chinese', 0),
(71, 'fruit platter', 8, 14, 200, 200, 'Chinese', 0),
(72, 'bamboo shoot tips', 8, 7, 200, 200, 'Chinese', 0),

(73, 'diavola pizza', 9, 21, 50, 50, 'Western', 0),
(74, 'funghi pizza', 9, 19, 50, 50, 'Western', 0),
(75, 'hawaiian pizza', 9, 20, 50, 50, 'Western', 0),
(76, 'saefood pizza', 9, 27, 50, 50, 'Western', 0),
(77, 'parma ham pizza', 9, 26, 50, 50, 'Western', 0),
(78, 'bbq pizza', 9, 21, 50, 50, 'Western', 0),
(79, 'margherita pizza', 9, 19, 50, 50, 'Western', 0),
(80, 'veggie pizza', 9, 18, 50, 50, 'Western', 0),
(81, 'buffalo pizza', 9, 21, 50, 50, 'Western', 0),
(82, 'cheese pizza', 9, 18, 50, 50, 'Western', 0),

(83, 'tuna sub', 10, 5.8, 60, 60, 'Western', 0),
(84, 'chicken and bacon sub', 10, 6.8, 60, 60, 'Western', 0),
(85, 'steak and cheese sub', 10, 5.8, 60, 60, 'Western', 0),
(86, 'italian bmt sub', 10, 5.8, 60, 60, 'Western', 0),
(87, 'cold cut sub', 10, 7.8, 60, 60, 'Western', 0),
(88, 'blt sub', 10, 6.8, 60, 60, 'Western', 0),
(89, 'chicken teriyaki sub', 10, 5.0, 60, 60, 'Western', 0),
(90, 'meatball sub', 10, 6.5, 60, 60, 'Western', 0),
(91, 'vegetable sub', 10, 4.8, 60, 60, 'Western', 0);

INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES 
(2, 'justning', '469 Bukit Timah Rd Singapore 259756', '04/05/2020 1230', 10.80, NULL, 4, True, True, 1, True),
(3, 'kalsyc', '20 Heng Mui Keng Terrace Singapore 119618', '04/05/2020 1320', 23.80, NULL, 1, True, True, 1, False),
(4, 'kalsyc', '12 Kent Ridge Dr Singapore 119243', '04/05/2020 1330', 18.80, NULL, 1, True, True, 1, True),
(5, 'kalsyc', '2 College Ave West Stephen Riady Centre Singapore 138607', '04/05/2020 1350', 13.80, NULL, 1, True, True, 1, True),
(7, 'justning', '16 #01-220 College Ave West 138527', '04/05/2020 1630', 13.00, NULL, 100, True, True, 1, True),
(8, 'kalsyc', '16 Science Drive 4 Singapore 117558', '04/05/2020 1700', 16.30, NULL, 1, True, True, 1, True), 
(9, 'kalsyc', '2 Engineering Drive 3 Singapore 117581', '04/05/2020 1730', 14.90, NULL, 1, True, True, 1, True),
(10, 'kalsyc', '9 Engineering Drive 1 #03-09 EA Singapore 117575', '04/05/2020 1750', 15.60, NULL, 1, True, True, 1, True),
(11, 'justning', '13 Computing Drive Singapore 117417', '05/05/2020 2100', 133.00, NULL, 101, True, True, 1, True),
(12, 'kalsyc', '5 Arts Link 5 The Block AS7 Level Shaw Foundation Building Singapore 117570', '04/01/2020 1830', 13.10, NULL, 1, True, True, 1, True),
(13, 'justning', '12 Kent Ridge Cresent Central Library Building CLB01 02 Singapore 119275', '02/05/2020 1930', 19.80, NULL, 102, True, True, 1, True),
(14, 'user0', '3 Science Drive 2 Singapore 117543', '05/05/2020 1945', 20, NULL, 6, True, False, 3, False),
(15, 'user1', '3 Science Drive 2 Singapore 117543', '06/05/2020 2145', 20, NULL, 7, True, False, 3, False),
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
(35, 'kalsyc', '3 Science Drive 2 Singapore 117543', '01/04/2020 1355', 21.80, NULL, 1, True, True, 3, True);

INSERT INTO Contains(orderid, foodid, quantity) VALUES
(2, 2, 1),
(3, 2, 1),
(3, 3, 1),
(4, 2, 2),
(5, 3, 1),
(6, 4, 1),
(7, 5, 1),
(8, 7, 1),
(9, 4, 1),
(10, 8, 1),
(11, 1, 1),
(11, 2, 2),
(11, 5, 3),
(12, 5, 1),
(13, 3, 1),

(14, 17, 1),
(15, 18, 1),
(16, 21, 1),
(17, 21, 1),
(17, 22, 2),
(18, 26, 2),
(23, 27, 3),
(24, 26, 4),
(25, 25, 3),
(28, 24, 3),
(34, 23, 5),
(18, 18, 1),
(19, 18, 1),
(20, 17, 1),
(21, 25, 1),
(22, 25, 1),
(23, 25, 1),
(24, 28, 1),
(25, 19, 1),
(26, 19, 1),
(27, 19, 1),
(28, 20, 1),
(29, 19, 1),
(30, 19, 1),
(31, 20, 1),
(32, 20, 1),
(33, 20, 1),
(34, 19, 1),
(35, 19, 1);

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

INSERT INTO WeeklyWorkSchedule(wwsid, username, startDate, wwsHours) VALUES
(1, 'partridertest', '2020-04-27', 12),
(2,  'user41', '2020-04-28', 12),
(3,  'user48', '2020-04-29', 12),
(4,  'user43', '2020-04-30', 12);

INSERT INTO DailyWorkShift(dwsid, wwsid, day, startHour, duration) VALUES
(1, 1, 0, 10, 4),
(2, 1, 0, 18, 4),
(3, 1, 1, 10, 4),

(4, 2, 2, 13, 4),
(5, 2, 2, 18, 4),
(6, 2, 3, 10, 4),

(7, 3, 3, 10, 4),
(8, 3, 4, 18, 4),
(9, 3, 5, 10, 4),

(10, 4, 4, 10, 4),
(11, 4, 4, 18, 4),
(12, 4, 5, 10, 4);

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

INSERT INTO HoursPerMonth(username, month, hours) VALUES
('user31', '01/01/2020', 80),
('bakwah', '01/01/2020', 65),
('user32', '01/01/2020', 102),
('user48', '01/01/2020', 34),
('user31', '01/02/2020', 50),
('user32', '01/02/2020', 76),
('user49', '01/03/2020', 32),
('user48', '01/03/2020', 100),
('user31', '01/04/2020', 80),
('bakwah', '01/04/2020', 65),
('user32', '01/04/2020', 102),
('user48', '01/04/2020', 34);


INSERT INTO RestaurantPromo(fdspromoid, restid) VALUES
(5, 1),
(6, 5);



