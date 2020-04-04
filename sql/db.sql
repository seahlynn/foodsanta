insert into Users(userid, name, password, dateCreated) values
(1, 'Darren', 'darrencool', '2020-04-04'),
(2, 'Lynn', 'lynncool',  '2020-04-04'),
(3, 'Leewah', 'leewahcool', '2020-04-04'),
(4, 'Sining', 'siningcool', '2020-04-04');

insert into Restaurants(restid, restname, minAmt) values
(1, '4Fingers', 15),
(2, 'Yoogane', 25),
(3, 'SushiTei', 40),
(4, 'KFC', 10),
(5, 'RiRi Mala', 15),
(6, 'Ah Bear Mookata', 20),
(7, 'Marche', 50),
(8, 'HaiDiLao', 80);    

--times ordered starts at 0 an availability at 100 for all food items currently)
insert into Food(foodid, description, restid, price, availability, category, timesordered) values
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





