import settings
import os
from flask import Flask, render_template, request, session, flash, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.schema import MetaData
#from flask_login import LoginManager
from datetime import datetime

app = Flask(__name__) #Initialize FoodSanta

if settings.debug:
    app.debug = True
    app.config['SQLALCHEMY_DATABASE_URI'] = settings.URI
else:
    app.debug = False
    app.config['SQLALCHEMY_DATABASE_URI'] = settings.URI

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = b'random123456789'

db = SQLAlchemy(app)
#login_manager = LoginManager() 

@app.route('/', methods=['GET'])
def index():
    print("Root page accessed")
    if settings.test:

        return redirect('gotoprofile')
        #return render_template('test.html') 
        
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():

    print("Login page accessed")
    session.clear()

    if request.method == 'POST':
        form = request.form
        username = form["username"]
        password = form["password"]
        is_valid = is_valid_user(username, password)
        if is_valid:
            print("Login verified")
            session['username'] = username
            return redirect('rest_home')
        else:
            print("Login denied")
            flash("No such user. :(")
    return render_template('login.html')

@app.route('/rest_home', methods=['GET', 'POST'])
def rest_home():
    print("Home page for staff accessed")
    return render_template("test.html")

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    
    print("Signup page accessed")
    session.clear()

    if request.method == 'POST':
        form = request.form
        username, name, password, repassword, user_type = form["username"].strip(), form["name"].strip(), form["password"], form["repassword"], form["usertype"]

        if is_existing_user(username):
            flash("Username taken! :(")
            return render_template('signup.html')

        if password != repassword:
            flash("Passwords don't match :(")
            return render_template('signup.html')
        
        if len(username) < 4:
            flash("Username must be at least 4 characters long")
            return render_template('signup.html')
        
        if len(password) < 8:
            flash("Password cannot be shorter than 8 characters!")
            return render_template('signup.html')
        
        if not len(name):
            flash("Name cannot be blank!")
            return render_template('signup.html')
        
        register_user(username, name, password, user_type)
        return redirect('registration_success')

    return render_template('signup.html')

@app.route('/registration_success', methods=['GET'])
def registration_success():
    print("Registration successful")
    return render_template('registration_success.html')

def register_user(username, name, password, user_type):
    global db
    date = datetime.today().strftime("%d/%m/%Y")
    insert_users = f"insert into Users(username, name, password, phoneNumber, dateCreated) values ('{username}','{name}','{password}', '{98782507}' '{date}');"
    insert_type = f"insert into {user_type}(username) values ('{username}');"
    db.session.execute(insert_users)
    db.session.execute(insert_type)
    db.session.commit()

def is_existing_user(id):
    global db
    check_user_query = f"select count(*) from Users where username='{id}'"
    check_user_result = db.session.execute(check_user_query).fetchone()
    return check_user_result[0]

def is_valid_user(id, pw):
    global db
    check_user_query = f"select count(*) from Users where username='{id}' and password ='{pw}'"
    check_user_result = db.session.execute(check_user_query).fetchone()
    return check_user_result[0]


@app.route('/gotorest', methods=['GET'])
def gotorest():
    orderidquery = f"select orderid from Orders order by orderid desc limit 1"
    orderidresult = db.session.execute(orderidquery).fetchall()
    orderid = int(orderidresult[0][0]) + 1
    session['orderid'] = orderid

    query = f"select * from Restaurants"
    result = db.session.execute(query)
        
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
    return render_template('restaurants.html', restlist = restlist)

@app.route('/gotoprofile', methods=['GET'])
def gotoprofile():
    username = 'justning'

    profilequery = f"select name, phoneNumber from Users where username = '{username}'"
    profileresult = db.session.execute(profilequery)
    profile = [dict(name = row[0], number = row[1]) for row in profileresult.fetchall()]
    
    cardquery = f"select cardInfo from PaymentMethods where username='{username}'"
    cardresult = db.session.execute(cardquery)
    cardlist = [dict(card = row[0]) for row in cardresult.fetchall()]
    
    return render_template('profile.html', cardlist = cardlist, profile = profile)

@app.route('/gotodelivery', methods=['GET'])
def gotodelivery():
    undeliveredOrdersQuery = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and selectedByRider = False"
    undeliveredOrdersResult = db.session.execute(undeliveredOrdersQuery)
    ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in undeliveredOrdersResult.fetchall()]

    return render_template('riders_selectUndeliveredOrders.html', ordersToPickUp = ordersToPickUp)

@app.route('/editprofile', methods=['POST'])
def editprofile():
    username = 'justning'

    contact = request.form['contact']
    cardInfo = request.form['card']
    deleteCard = request.form['delete']

    if contact != '':
        update_contact = f"update Users set phoneNumber = {contact} where username = '{username}'"
        db.session.execute(update_contact)

    if cardInfo != '':
        pmiquery = f"select paymentmethodid from PaymentMethods order by paymentmethodid desc limit 1"
        pmiresult = db.session.execute(pmiquery).fetchall()
        paymentmethodid = int(pmiresult[0][0]) + 1
        update_card = f"insert into PaymentMethods(paymentmethodid, username, cardInfo) values ({paymentmethodid}, '{username}', '{cardInfo}');"
        db.session.execute(update_card)

    if deleteCard != '':
        delete_card = f"delete from PaymentMethods where username = '{username}' and cardInfo = '{deleteCard}'"
        db.session.execute(delete_card)
    
    db.session.commit()

    return redirect('gotoprofile')

'''

Customers order from Restaurants Menu

'''

@app.route('/restresults', methods=['GET'])
def restresults():
    global db

    query = f"select * from Restaurants"
    result = db.session.execute(query)
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
    
    restid = int(request.args['chosen'])
    query = f"SELECT * FROM Food WHERE restid = {restid} and availability > 0"
    result = db.session.execute(query)
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    query = f"select R.reviewdesc, O.username from Reviews R, Orders O where R.orderid = O.orderid and O.restid = {restid}"
    result = db.session.execute(query)
    reviewlist = [dict(username= row[1], review = row[0]) for row in result.fetchall()]

    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]

    return render_template('restaurants.html', foodlist = foodlist, restlist = restlist, reviewlist = reviewlist, minAmt = minAmt)

@app.route('/addtocart', methods=['POST'])
def addtocart():
    global db

    #add record into Contains table
    foodid = int(request.form['foodid'])
    query = f"select * from Food where foodid = {foodid}"
    result = db.session.execute(query).fetchall()

    #note how to retrieve orderid and username??
    username = 'justning'
    orderid = session['orderid']
    description = result[0][1]
    check = f"select count(*) from Contains where foodid = {foodid} and orderid = {orderid}"
    checkresult = db.session.execute(check).fetchall()
    

    if checkresult[0][0]:
        qtyquery = f"select quantity from Contains where foodid = {foodid}"
        qtyresult = db.session.execute(qtyquery).fetchall()
        newqty = qtyresult[0][0] + 1
        availquery = f"select availability from Food where foodid = {foodid}"
        availresult = db.session.execute(availquery).fetchall()
        avail = availresult[0][0]

        if avail < newqty:
            flash('Sorry, this item is out of stock!')
            return redirect('backto')
  
        todo = f"update Contains set quantity = quantity + 1 where foodid = {foodid} and orderid = {orderid}"
    else:
        todo = f"insert into Contains (orderid, foodid, username, description, quantity) values ('{orderid}', {foodid}, '{username}', '{description}', 1)"
    
    db.session.execute(todo)
    db.session.commit()

    #ensures the page stays on the specific restaurant menu
    restid = f"(select restid from Food where foodid = {foodid})"
    query = f"select * from Food where restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food = row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]

    return render_template('restaurants.html', foodlist = foodlist, minAmt = minAmt)

@app.route('/viewcart', methods=['POST', 'GET'])
def viewcart():
    global db

    orderid = session['orderid']
    username = 'justning'

    restidquery = f"select distinct F.restid from Food F, Contains C where C.orderid = {orderid} and F.foodid = C.foodid"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]
    
    #for cart 
    orderquery = f"select C.description, F.price, C.quantity, F.foodid from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid}"
    orderresult = db.session.execute(orderquery)
    orderlist = [dict(food = row[0], price = row[1], quantity = row[2], foodid = row[3]) for row in orderresult.fetchall()]

    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid}"
    totalresult = db.session.execute(totalquery).fetchall()
    totalprice = totalresult[0][0]

    #to find amount away from minimum order
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]
    difference = '{0:.2f}'.format(float(minAmt) -float(totalprice))

    if float(difference) <= 0:
        difference = 0

    #for customer details
    custquery = f"select U.name, U.phoneNumber, L.location from Users U, Locations L where U.username = '{username}' and L.username = '{username}' limit 1"
    custresult = db.session.execute(custquery)
    custdetails = [dict(name = row[0], number = row[1], location = row[2]) for row in custresult.fetchall()]
    
    #locationlist
    locationquery = f"select location from Locations where username = '{username}'"
    locationresult = db.session.execute(locationquery)
    locationlist = [dict(location = row[0]) for row in locationresult.fetchall()]

    #paymentlist
    paymentquery = f"select cardInfo from PaymentMethods where username = '{username}'"
    paymentresult = db.session.execute(paymentquery)
    paymentlist = [dict(method = row[0]) for row in paymentresult.fetchall()]

    return render_template('cart.html', orderlist = orderlist, totalprice = totalprice, custdetails = custdetails, locationlist = locationlist, paymentlist = paymentlist, difference = difference)

@app.route('/deletefromcart', methods=['POST'])
def deletefromcart():
    global db

    orderid = session['orderid']
    username = 'justning'
    foodid = int(request.form['foodid'])
    quantityquery = f"select quantity from Contains where foodid = {foodid} and orderid = {orderid}"
    result = db.session.execute(quantityquery).fetchall()
    quantity = int(result[0][0])

    if quantity == 1:
        todo = f"delete from Contains where foodid = {foodid} and orderid = {orderid}"
    else :
        newquantity = quantity - 1
        todo = f"update Contains set quantity = {newquantity} where foodid = {foodid} and orderid = {orderid}"

    db.session.execute(todo)
    db.session.commit()
    return redirect('viewcart')

@app.route('/backto', methods=['POST', 'GET'])
def backto():

    orderid = session['orderid']
    #ensures the page stays on the specific restaurant menu

    randomfoodid = f"(select foodid from Contains where username = 'justning' and orderid = {orderid} limit 1)"
    restid = f"(select restid from Food where foodid = {randomfoodid})"
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food = row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    return render_template('restaurants.html', foodlist = foodlist)

@app.route('/placeorder', methods=['POST'])
def placeorder():

    orderid = session['orderid']
    username = 'justning'
    location = request.form['location']
    cardInfo = request.form['payment']

    checkCartquery = f"select count(*) from Contains where orderid = {orderid}"
    checkCartresult = db.session.execute(checkCartquery).fetchall()
    checkCart = checkCartresult[0][0]


    if (checkCart == 0):
        flash("Your cart is empty, there is nothing to order!")
        return redirect('viewcart')

    if location == '':
        flash("Location cannot be blank!")
        return redirect('viewcart')

    if cardInfo == '':
        flash("Card cannot be blank!")
        return redirect('viewcart')

    ordercreatedtime = datetime.now().strftime("%d/%m/%Y %H%M") 
    # for totalCost
    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid}"
    totalresult = db.session.execute(totalquery).fetchall()
    totalprice = totalresult[0][0]

    fdspromoid = 'null'
    paymentmethodquery = f"select paymentmethodid from PaymentMethods where username = '{username}' and cardInfo = '{cardInfo}'"
    paymentresult = db.session.execute(paymentmethodquery).fetchall()
    paymentmethodid = paymentresult[0][0]
    preparedbyrest = False
    selectedByRider = False

    randomfoodid = f"(select foodid from Contains where username = '{username}' and orderid = {orderid} limit 1)"
    restidquery = f"(select restid from Food where foodid = {randomfoodid})"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]

    #to check if it hits restuarant's minimum order amount
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]
    difference = '{0:.2f}'.format(float(minAmt) -float(totalprice))
    
    if (totalprice < minAmt):
        flash("You are $" + difference + " away from the minimum order amount!")
        return redirect('viewcart')

    todo = f"insert into Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) values ('{orderid}', '{username}', '{location}', '{ordercreatedtime}', {totalprice}, {fdspromoid}, {paymentmethodid}, {preparedbyrest}, {selectedByRider}, {restid}, False)"
    deliveryFee = 5
    addDelivery = f"insert into Delivers(orderid, username, rating, location, deliveryFee, timeDepartToRestaurant, timeArrivedAtRestaurant, timeOrderDelivered, paymentmethodid) values ({orderid}, '{username}', null, '{location}', {deliveryFee}, null, null, null, {paymentmethodid})"

    db.session.execute(todo)
    db.session.execute(addDelivery)
    db.session.commit()

    return redirect('orderstatus')

@app.route('/orderstatus', methods=['POST', 'GET'])
def orderstatus():

    username = 'justning'
    inprogressquery = f"select restName, orderCreatedTime, selectedByRider, timeArrivedAtRestaurant from Orders O, Delivers D, Restaurants R where D.orderid = O.orderid and O.username = '{username}' and O.delivered = False and R.restid = O.restid"
    progressresult = db.session.execute(inprogressquery)
    orderlist = [dict(rest = row[0], timeordered = row[1], orderpicked = row[2], pickedup = row[3]) for row in progressresult.fetchall()]

    finishedquery = f"select R.restName, O.totalCost, D.timeOrderDelivered, O.orderid from Orders O, Delivers D, Restaurants R where D.orderid = O.orderid and O.username = '{username}' and R.restid = O.restid and O.delivered = True"
    finishedresult = db.session.execute(finishedquery)
    finishedlist = [dict(rest = row[0], total = row[1], received = row[2], orderid = row[3]) for row in finishedresult.fetchall()]
    
    return render_template('orderstatus.html', orderlist = orderlist, finishedlist = finishedlist)

@app.route('/submitreview', methods=['POST'])
def submitreview():

    username = 'justning'
    review = request.form['review']
    orderid = int(request.form['orderid'])
    checkquery = f"select count(*) from Reviews where orderid = {orderid}"
    checkresult = db.session.execute(checkquery).fetchall()
    check = checkresult[0][0]
    
    if (check != 0):
        flash("You have already submitted a review for this order!")
        return redirect('orderstatus')

    if review != '':
        reviewToPost = f"insert into Reviews values ({orderid}, '{review}')"
        db.session.execute(reviewToPost)
        db.session.commit()

    flash('Review submitted!')
    return redirect('orderstatus')

@app.route('/neworder', methods=['POST'])
def neworder():
    return redirect('gotorest')

'''
Riders select existing undelivered orders to pick up and deliver

'''
 
@app.route('/getUndeliveredOrders', methods=['POST', 'GET'])
def getUndeliveredOrders():
    global db

    # orders available for pick up are displayed in a table with orderid, restaurant location and customer location
    undeliveredOrdersQuery = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and selectedByRider = False"
    undeliveredOrdersResult = db.session.execute(undeliveredOrdersQuery)
    ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in undeliveredOrdersResult.fetchall()]

    # rider has selected a certain order to deliver, stored as deliveringOrderId
    chosenOrderId = int(request.args['chosenOrder'])
    session['deliveringOrderId'] = chosenOrderId

    # display order chosen
    chosenOrderQuery = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and selectedByRider = False and orderid = {chosenOrderId}"
    chosenOrderResult = db.session.execute(chosenOrderQuery)

    chosenOrderInfo = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in chosenOrderResult.fetchall()]
    
    return render_template('riders_selectUndeliveredOrders.html', chosenOrderInfo = chosenOrderInfo, ordersToPickUp = ordersToPickUp)

@app.route('/processOrderSelectedForDelivery', methods=['POST', 'GET'])
def processOrderSelectedForDelivery():
    global db

    deliveringOrderId = session['deliveringOrderId']

    # update order 
    updateOrderStatus = f'update Orders set selectedByRider = True where orderid = {deliveringOrderId}'
    db.session.execute(updateOrderStatus)
    db.session.commit()

    # add into delivery table
    username = 'justning'
    chosenOrderQuery = f"select custLocation from Orders where preparedByRest = False and selectedByRider = True and orderid = {deliveringOrderId}"
    chosenOrderResult = db.session.execute(chosenOrderQuery).fetchall()
    custLocation = str(chosenOrderResult[0][0])

    currentTime = datetime.now().strftime("%d/%m/%Y %H%M")
    deliveryFee = 3 # to be edited later
    # maybe can change to update Delivers instead of insert into
    addDelivery = f"insert into Delivers(orderid, username, rating, location, deliveryFee, timeDepartToRestaurant, timeArrivedAtRestaurant, timeOrderDelivered, paymentmethodid) values ({deliveringOrderId}, '{username}', null, '{custLocation}', 3, '{currentTime}', null, null, null)"
    db.session.execute(addDelivery)
    db.session.commit()

    return redirect('collectFromRestaurant')

@app.route('/collectFromRestaurant', methods=['GET'])
def collectFromRestaurant():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = 'justning'

    # retrieve restaurant address to display
    restLocationQuery = f'select location from Restaurants where restid in (select distinct restid from Orders where Orders.orderid = {deliveringOrderId})'
    restLocationResult = db.session.execute(restLocationQuery).fetchall()
    restLocation = restLocationResult[0][0]

    return render_template('riders_orderToCollectAtRestaurant.html', restLocation = restLocation)

@app.route('/collectedFromRestaurant', methods=['POST'])
def collectedFromRestaurant():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = 'justning'
    currentTime = datetime.now().strftime("%d/%m/%Y %H%M")
    
    # handle functionality of button
    # 1. update the timeArrivedAtRestaurant
    # 2. move to the next page 
    updateDeliveryStatus = f"update Delivers set timeArrivedAtRestaurant = '{currentTime}' where orderid = {deliveringOrderId}"
    db.session.execute(updateDeliveryStatus)
    db.session.commit()

    return redirect('deliverToCustomer')

@app.route('/deliverToCustomer', methods=['GET'])    
def deliverToCustomer():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = 'justning'

    custLocationQuery = f'select custLocation from Orders where Orders.orderid = {deliveringOrderId}'
    custLocationResult = db.session.execute(custLocationQuery).fetchall()
    custLocation = custLocationResult[0][0]

    return render_template('riders_orderToDeliverToCustomer.html', custLocation = custLocation)

@app.route('/orderDelivered', methods=['POST', 'GET'])
def orderDelivered():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = 'justning'
    currentTime = datetime.today().strftime("%d/%m/%Y %H%M")

    # update delivery
    updateDeliveryStatus = f"update Delivers set timeOrderDelivered = '{currentTime}' where orderid = {deliveringOrderId}"
    updateOrdersDelivered = f"update Orders set delivered = True where orderid = {deliveringOrderId}"
    db.session.execute(updateOrdersDelivered)
    db.session.execute(updateDeliveryStatus)
    db.session.commit()

    # update rider stats
    # check if rider has stats or not
    checkRiderStatsExistQuery = f"select count(*) from RiderStats where username = '{username}' and month = 4"
    checkResult = db.session.execute(checkRiderStatsExistQuery).fetchall()

    if (checkResult[0][0]):
        updateRiderStats = f"update RiderStats set totalOrders = totalOrders + 1 where username = '{username}'"
    else: # by right, rider's stats should be added when the rider takes up his shift
        updateRiderStats = f"insert into RiderStats (username, totalOrders, totalHours, totalSalary, month, year) values ('{username}', 1, null, null, 4, 2020)"    

    db.session.execute(updateRiderStats)
    db.session.commit()

    # check current rider stats
    numOrdersQuery = f"select distinct totalOrders from RiderStats where username = '{username}' and month = 4"
    numOrdersResult = db.session.execute(numOrdersQuery).fetchall()
    numOrders = numOrdersResult[0][0]

    return render_template('riders_deliveryCompleted.html', numOrders = numOrders)    

@app.route('/newDelivery', methods=['POST'])
def newDelivery():
    return redirect('gotodelivery')
    
#Check if server can be run, must be placed at the back of this file
if __name__ == '__main__':
    app.run()

"""
For Testing
"""
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