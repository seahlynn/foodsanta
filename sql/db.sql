INSERT INTO Users(username, name, password, phoneNumber, dateCreated) VALUES
('Kalsyc', 'Darren', 'darrencool', '91718716', '2020-04-04'),
('LynnJah', 'Lynn', 'lynncool', '91718716',  '2020-04-04'),
('Bakkwa', 'Leewah', 'leewahcool', '91718716', '2020-04-04'),
('justning', 'Sining', 'siningcool', '91718716', '2020-04-04');


INSERT INTO Customers(username, points) VALUES
('Kalsyc', 0),
('LynnJah', 0),
('Bakkwa', 0),
('justning', 0);

INSERT INTO CustomerStats("username", monthid, totalNumOrders, totalCostOfOrders) VALUES ('justning', 4, 1, 13.20);

INSERT INTO Locations(username, location, dateAdded) VALUES
('justning', '21 Lower Kent Ridge Rd, Singapore 119077', '2020-04-03'),
('justning', '469 Bukit Timah Rd, Singapore 259756', '2020-04-01'),
('justning', '20 Heng Mui Keng Terrace, Singapore 119618', '2020-02-07'),
('justning', '12 Kent Ridge Dr, Singapore 119243', '2020-02-21'),
('justning', '2 College Ave West, Stephen Riady Centre, Singapore 138607', '2020-01-04');

INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (1, '4Fingers', 15, '68 Orchard Rd #B1-07, Plaza, Singapore 238839');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (2, 'Yoogane', 25, '3, #03-08 Gateway Dr, Westgate, Singapore 608532');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (3, 'SushiTei', 40, '154 West Coast Rd, #01-87 West Coast Plaza, Singapore 127371');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (4, 'KFC', 10, '500 Dover Rd, 5 Singapore Polytechnic Food Court, Singapore 139651');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (5, 'RiRi Mala', 15, '32 New Market Road #01 42 52, Singapore 050032');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (6, 'Ah Bear Mookata', 20, '505 W Coast Dr, #01-208, Singapore 120505');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (7, 'Marche', 50, '50 Jurong Gateway Rd, #01-03 JEM, Singapore 608549');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (8, 'HaiDiLao', 80, '1 Harbourfront Walk #03-09 Vivocity, Singapore 098585');
INSERT INTO Restaurants(restid, restname, minAmt, location) VALUES (9, 'Caesar Pizza', 30, '16 Collyer Quay, #01-05 Income At Raffles, Singapore 049318');

--times ordered starts at 0 an availability at 100 for all food items currently)
INSERT INTO Food(foodid, description, restid, price, availability, category, timesordered) VALUES
(1, 'soy sauce wings', 1, 12, 100, 'Korean', 0),
(2, 'spicy drumlets', 1, 12, 100, 'Korean', 0),
(3, 'army stew', 2, 8, 24, 'Korean', 0),
(4, 'kimchi pancakes', 2, 8, 100, 'Korean', 0),
(5, 'unagi sushi', 3, 6, 100, 'Japanese', 0),
(6, 'chawanmushi', 3, 3, 100, 'Japanese', 0),
(7, 'chicken katsu', 3, 8, 100, 'Japanese', 0),
(8, 'cheese fries', 4, 4.5, 2, 'FastFood', 0),
(9, 'popcorn chicken', 4.2, 8, 100, 'FastFood', 0),
(10, 'lime froyo', 4, 2, 100, 'FastFood', 0),
(11, 'zhong la mala hotpot', 5, 8, 100, 'Chinese', 0),
(12, 'da la mala hotpot', 5, 17, 100, 'Chinese', 0),
(13, 'smoked duck', 6, 2.5, 100, 'Sharing', 0),
(14, 'luncheon meat', 6, 2, 100, 'Sharing', 0),
(15, 'black pepper pork belly', 6, 2, 100, 'Sharing', 0),
(16, 'thai milk tea', 6, 3, 100, 'Beverage', 0),
(17, 'rosti', 7, 8.90, 100, 'Western', 0),
(18, 'pork knuckles', 7, 16.50, 100, 'Western', 0),
(19, 'smoked salmon pizza', 7, 22.90, 100, 'Western', 0),
(20, 'beef schnitzel', 7, 19.90, 100, 'Western', 0),
(21, 'prawn paste', 8, 12, 100, 'Chinese', 0),
(22, 'golden man tou', 8, 8, 100, 'Chinese', 0);

-- order 1 has 3 items: cheese fries from kfc, soy sauce wings from four fingers, lime froyo from kfc


--- INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid) VALUES (1, 1, '21 Lower Kent Ridge Rd, Singapore 119077', '04/07/2020 1230', 13.80, NULL, 1, False, False, 1);

INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (2, 'justning', '469 Bukit Timah Rd Singapore 259756', '04/07/2020 1230', 10.80, NULL, 1, False, True, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (3, 'Kalsyc', '20 Heng Mui Keng Terrace Singapore 119618', '04/07/2020 1320', 23.80, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (4, 'Kalsyc', '12 Kent Ridge Dr Singapore 119243', '04/07/2020 1330', 18.80, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (5, 'Kalsyc', '2 College Ave West Stephen Riady Centre Singapore 138607', '04/07/2020 1350', 13.80, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (6, 'Kalsyc', '6 College Avenue East #01-01 University Town National University of Singapore 138614', '04/07/2020 1530', 14.00, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (7, 'justning', '16 #01-220 College Ave West 138527', '04/07/2020 1630', 13.00, NULL, 1, False, True, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (8, 'Kalsyc', '16 Science Drive 4 Singapore 117558', '04/07/2020 1700', 16.30, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (9, 'Kalsyc', '2 Engineering Drive 3 Singapore 117581', '04/07/2020 1730', 14.90, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (10, 'Kalsyc', '9 Engineering Drive 1 #03-09 EA Singapore 117575', '04/07/2020 1750', 15.60, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (11, 'justning', '13 Computing Drive Singapore 117417', '03/02/2020 1800', 12.00, NULL, 1, False, False, 1, True);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (12, 'Kalsyc', '5 Arts Link 5 The Block AS7 Level Shaw Foundation Building Singapore 117570', '04/07/2020 1830', 13.10, NULL, 1, False, False, 1, False);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (13, 'justning', '12 Kent Ridge Cresent Central Library Building CLB01 02 Singapore 119275', '02/01/2020 1930', 19.80, NULL, 1, False, False, 1, True);
INSERT INTO Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) VALUES (14, 'Kalsyc', '3 Science Drive 2 Singapore 117543', '04/07/2020 1945', 23.80, NULL, 1, False, False, 1, False);

INSERT INTO PaymentMethods(paymentmethodid, username, cardInfo) VALUES
(1, 'justning', 'dbs card'),
(2, 'justning', 'ocbc card'),
(3, 'justning', 'uob card'),
(4, 'justning', 'stanchart card');

INSERT INTO DeliveryRiders(username) VALUES ('justning');

INSERT INTO Delivers(orderid, username, rating, location, deliveryFee, timeDepartToRestaurant, timeArrivedAtRestaurant, timeOrderDelivered, paymentmethodid) VALUES
(2, 'justning', 4,  '469 Bukit Timah Rd Singapore 259756', 5, '04/07/2020 1240', '04/07/2020 1300', '04/07/2020 1320', 1),
(7, 'justning', 3,  '16 #01-220 College Ave West 138527', 5, '04/07/2020 1640', '04/07/2020 1650', '04/07/2020 1715', 1),
(11, 'justning', 3,  '13 Computing Drive Singapore 117417', 5, '03/02/2020 1805', '03/02/2020 1815', '03/02/2020 1830', 1),
(13, 'justning', 3,  '16 #01-220 College Ave West 138527', 5, '02/01/2020 1650', '02/01/2020 1715', '02/01/2020 1730', 1);
