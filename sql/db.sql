INSERT INTO Users(userid, name, password, dateCreated) VALUES
(1, 'Darren', 'darrencool', '2020-04-04'),
(2, 'Lynn', 'lynncool',  '2020-04-04'),
(3, 'Leewah', 'leewahcool', '2020-04-04'),
(4, 'Sining', 'siningcool', '2020-04-04');

INSERT INTO Restaurants(restid, restname, minAmt) VALUES
(1, '4Fingers', 15),
(2, 'Yoogane', 25),
(3, 'SushiTei', 40),
(4, 'KFC', 10),
(5, 'RiRi Mala', 15),
(6, 'Ah Bear Mookata', 20),
(7, 'Marche', 50),
(8, 'HaiDiLao', 80),
(9, 'Caesar Pizza', 30),
(10, 'DinTaiFung', 40);  

--times ordered starts at 0 an availability at 100 for all food items currently)
INSERT INTO Food(foodid, description, restid, price, availability, category, timesordered) VALUES
(1, 'soy sauce wings', 1, 12, 100, 'Korean', 0),
(2, 'spicy drumlets', 1, 12, 100, 'Korean', 0),
(3, 'army stew', 2, 8, 24, 'Korean', 0),
(4, 'kimchi pancakes', 6, 8, 100, 'Korean', 0),
(5, 'unagi sushi', 3, 6, 100, 'Japanese', 0),
(6, 'chawanmushi', 3, 3, 100, 'Japanese', 0),
(7, 'chicken katsu', 3, 8, 100, 'Japanese', 0),
(8, 'cheese fries', 4, 4.5, 100, 'FastFood', 0),
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


INSERT INTO Orders(orderid, custid, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, collectedByRider, restid) VALUES 
(1, 1, '21 Lower Kent Ridge Rd, Singapore 119077', '1230', 13.80, NULL, 1, False, False, 1),
(2, 1, '469 Bukit Timah Rd, Singapore 259756', '1230', 10.80, NULL, 1, False, False, 1),
(3, 1, '20 Heng Mui Keng Terrace, Singapore 119618', '1320', 23.80, NULL, 1, False, False, 1),
(4, 1, '12 Kent Ridge Dr, Singapore 119243', '1330', 18.80, NULL, 1, False, False, 1),
(5, 1, '2 College Ave West, Stephen Riady Centre, Singapore 138607', '1350', 13.80, NULL, 1, False, False, 1),
(6, 1, '6 College Avenue East, #01-01, University Town, National University of Singapore, 138614', '1530', 14.00, NULL, 1, False, False, 1),
(7, 1, '16 #01-220, College Ave West, 138527', '1630', 13.00, NULL, 1, False, False, 1),
(8, 1, '16 Science Drive 4, Singapore 117558', '1700', 16.30, NULL, 1, False, False, 1),
(9, 1, '2 Engineering Drive 3, Singapore 117581', '1730', 14.90, NULL, 1, False, False, 1),
(10, 1, '9 Engineering Drive 1, #03-09 EA, Singapore 117575', '1750', 15.60, NULL, 1, False, False, 1),
(11, 1, '13 Computing Drive, Singapore 117417', '1800', 12.00, NULL, 1, False, False, 1),
(12, 1, '5 Arts Link, 5 The, Block AS7, Level, Shaw Foundation Building, Singapore 117570', '1830', 13.10, NULL, 1, False, False, 1),
(13, 1, '12 Kent Ridge Cresent Central Library Building, CLB01, 02, Singapore 119275', '1930', 19.80, NULL, 1, False, False, 1),
(14, 1, '3 Science Drive 2, Singapore 117543', '1945', 23.80, NULL, 1, False, False, 1);
