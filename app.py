import settings
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.schema import MetaData

app = Flask(__name__) #Initialize FoodSanta


if settings.debug:
    app.debug = True
    app.config['SQLALCHEMY_DATABASE_URI'] = settings.URI
else:
    app.debug = False
    app.config['SQLALCHEMY_DATABASE_URI'] = settings.URI

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

@app.route('/')
def index():
    if settings.test:
        #query = f"select orderid, (select Restaurants.location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and collectedByRider = False"
        #result = db.session.execute(query)

        #ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in result.fetchall()]

        # select a certain order to form the next page 
        #return render_template('riders_getUndeliveredOrders.html', ordersToPickUp=ordersToPickUp)

        query = f"select * from Restaurants"
        result = db.session.execute(query)
        
        restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
        return render_template('restaurants.html', restlist = restlist)

    return render_template('index.html')

@app.route('/test_submit', methods=['POST'])
def test_submit():
    global db
    if request.method == 'POST':
        name = request.form['name']
        score = int(request.form['score'])
    query = f"select count(*) from TestingSetup TS where TS.memberName = '{name}'"
    result = db.session.execute(query).fetchall()
    if result[0][0]:
        return render_template('test.html') #Name has already been added
    data = f"insert into TestingSetup (memberName, ricePurityScore) values ('{name}', {score})"
    db.session.execute(data)
    db.session.commit()
    return render_template('testsuccess.html')

@app.route('/restresults', methods=['GET'])
def restresults():
    global db

    query = f"select * from Restaurants"
    result = db.session.execute(query)
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
    
    restid = int(request.args['chosen'])
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    return render_template('restaurants.html', foodlist=foodlist, restlist=restlist)

@app.route('/addtocart', methods=['POST'])
def addtocart():
    global db

    #add record into Contains table
    foodid = int(request.form['foodid'])
    query = f"select * from Food where foodid = {foodid}"
    result = db.session.execute(query).fetchall()
    userid = 1
    orderid = 1 
    description = result[0][1]
    check = f"select count(*) from Contains where foodid = {foodid} and orderid = 1"
    checkresult = db.session.execute(check).fetchall()
    todo = f""

    if result[0][0]:
        todo = f"update Contains set quantity = quantity + 1 where foodid = {foodid} and orderid = 1"
    else:
        todo = f"insert into Contains (orderid, foodid, userid, description, quantity) values ('{orderid}', {foodid}, {userid}, '{description}', 1)"
    
    db.session.execute(todo)
    db.session.commit()

    #ensures the page stays on the specific restaurant menu
    restid = f"(select restid from Food where foodid = {foodid})"
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    return render_template('restaurants.html', foodlist = foodlist)

@app.route('/viewcart', methods=['POST'])
def viewcart():
    global db
    query = f"select C.description, F.price, C.quantity from Contains C, Food F where C.foodid = F.foodid and orderid = 1"
    result = db.session.execute(query)

    orderlist = [dict(food = row[0], price = row[1], quantity = row[2]) for row in result.fetchall()]

    return render_template('cart.html', orderlist = orderlist)

# Riders: to see and select undelivered orders 
@app.route('/getUndeliveredOrders', methods=['GET'])
def getUndeliveredOrders():
    global db

    query = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation, from Orders where preparedByRest = False and collectedByRider = False"
    result = db.session.execute(query)

    ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in result.fetchall()]

    # select a certain order to form the next page 
    return render_template('riders_getUndeliveredOrders.html', ordersToPickUp=ordersToPickUp)


#Check if server can be run, must be placed at the back of this file
if __name__ == '__main__':
    app.run()



