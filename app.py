import settings
import os
from flask import Flask, render_template, request, session, flash, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.schema import MetaData
#from flask_login import LoginManager
from datetime import datetime, timedelta

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
        #query = f"select orderid, (select Restaurants.location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and collectedByRider = False"
        #result = db.session.execute(query)

        #ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in result.fetchall()]

        # select a certain order to form the next page 
        #return render_template('riders_getUndeliveredOrders.html', ordersToPickUp=ordersToPickUp)

        #return redirect('gotoprofile')
        #return render_template('test.html') 
        return getFullTimeSchedule()
        
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
    insert_users = f"insert into Users(username, name, password, dateCreated) values ('{username}';'{name}';'{password}'; '{date}');"
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
    orderidquery = f"select count(*) from Orders"
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
        pmiquery = f"select count(*) from PaymentMethods"
        pmiresult = db.session.execute(pmiquery).fetchall()
        paymentmethodid = int(pmiresult[0][0]) + 1
        update_card = f"insert into PaymentMethods(paymentmethodid, username, cardInfo) values ({paymentmethodid}, '{username}'; '{cardInfo}');"
        db.session.execute(update_card)

    if deleteCard != '':
        delete_card = f"delete from PaymentMethods where username = '{username}' and cardInfo = '{deleteCard}'"
        db.session.execute(delete_card)
    
    db.session.commit()

    return redirect('gotoprofile')


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

    #note how to retrieve orderid and username??
    username = 'justning'
    orderid = session['orderid']
    description = result[0][1]
    check = f"select count(*) from Contains where foodid = {foodid} and orderid = {orderid}"
    checkresult = db.session.execute(check).fetchall()
    
    todo = f"insert into Contains (orderid, foodid, username, description, quantity) values ({orderid}, {foodid}, '{username}'; '{description}'; 1)"

    if checkresult[0][0]:
        todo = f"update Contains set quantity = quantity + 1 where foodid = {foodid} and orderid = {orderid}"
    else:
        todo = f"insert into Contains (orderid, foodid, username, description, quantity) values ('{orderid}'; {foodid}, '{username}'; '{description}'; 1)"
    
    db.session.execute(todo)
    db.session.commit()

    #ensures the page stays on the specific restaurant menu
    restid = f"(select restid from Food where foodid = {foodid})"
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    return render_template('restaurants.html', foodlist = foodlist)

@app.route('/viewcart', methods=['POST', 'GET'])
def viewcart():
    global db

    orderid = session['orderid']
    username = 'justning'
    #for cart 
    orderquery = f"select C.description, F.price, C.quantity, F.foodid from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid}"
    orderresult = db.session.execute(orderquery)
    orderlist = [dict(food = row[0], price = row[1], quantity = row[2], foodid = row[3]) for row in orderresult.fetchall()]

    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid}"
    totalresult = db.session.execute(totalquery)
    totalprice = [dict(total = row[0]) for row in totalresult.fetchall()]

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

    return render_template('cart.html', orderlist = orderlist, totalprice = totalprice, custdetails = custdetails, locationlist = locationlist, paymentlist = paymentlist)

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

@app.route('/backto', methods=['POST'])
def backto():

    orderid = session['orderid']
    #ensures the page stays on the specific restaurant menu
    randomfoodid = f"(select foodid from Contains where username = 'justning' and orderid = {orderid} limit 1)"
    restid = f"(select restid from Food where foodid = {randomfoodid})"
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
        
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    return render_template('restaurants.html', foodlist = foodlist)

@app.route('/placeorder', methods=['POST'])
def placeorder():

    orderid = session['orderid']
    username = 'justning'
    location = request.form['location']
    ordercreatedtime = datetime.now().strftime("%d/%m/%Y %H%M") 
    # for totalCost
    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = 1"
    totalresult = db.session.execute(totalquery).fetchall()
    totalprice = totalresult[0][0]
    
    fdspromoid = 'null'
    paymentmethodid = 1
    preparedbyrest = False
    collectedbyrider = False

    randomfoodid = f"(select foodid from Contains where username = '{username}' and orderid = {orderid} limit 1)"
    restidquery = f"(select restid from Food where foodid = {randomfoodid})"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]

    todo = f"insert into Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, collectedByRider, restid) values ('{orderid}'; '{username}'; '{location}'; '{ordercreatedtime}'; {totalprice}, {fdspromoid}, {paymentmethodid}, {preparedbyrest}, {collectedbyrider}, {restid})"
    
    db.session.execute(todo)
    db.session.commit()

    return render_template('ordered.html')

@app.route('/neworder', methods=['POST'])
def neworder():
    return redirect('gotorest')

# Riders: to see and select undelivered orders 
@app.route('/getUndeliveredOrders', methods=['GET'])
def getUndeliveredOrders():
    global db

    query = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation, from Orders where preparedByRest = False and collectedByRider = False"
    result = db.session.execute(query)

    ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in result.fetchall()]

    # select a certain order to form the next page 
    return render_template('riders_getUndeliveredOrders.html', ordersToPickUp=ordersToPickUp)

@app.route('/getFullTimeSchedule', methods=['GET'])
def getFullTimeSchedule():
    username = 'Bakkwa'
    today = datetime.today()
    datem = datetime(today.year, today.month, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)
    print(datem)

    schedulequery = f"create table dayShift (day integer, shift integer, primary key(day, shift)); insert into dayShift (day, shift) select M.wkStartDay, F.day1 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 1) % 7, F.day2 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 2) % 7, F.day3 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 3) % 7, F.day4 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 4) % 7, F.day5 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, case when shift = 0 then '1000 to 1400\n1500 to 1900' when shift = 1 then '1100 to 1500\n1600 to 2000' when shift = 2 then '1200 to 1600\n1700 to 2100' when shift = 3 then '1300 to 1700\n1800 to 2200' end as shift from dayShift;"
    scheduleresult = db.session.execute(schedulequery)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleresult.fetchall()]
    
    return render_template('fulltimeschedule.html', schedule = schedule, monthYear = monthYear)

@app.route('/getPartTimeSchedule', methods=['GET'])
def getPartTimeSchedule():
    username = "Bakkwa"
    today = datetime.today()
    monday = today - timedelta(days = today.weekday())
    datem = monday.date()
    print(datem)

    schedulequery = f"create table dayShift (day integer, shift integer, duration integer, primary key(day, shift, duration)); insert into dayShift (day, shift, duration) select D.day, D.starthour, D.duration from DailyWorkShift D, WeeklyWorkSchedule W where W.wwsid = D.wwsid and W.username = '{username}' and W.startDate = '{datem}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, concat(cast((shift * 100) as varchar), ' to ', cast(((shift + duration) * 100) as varchar)) as shift from dayShift"
    scheduleresult = db.session.execute(schedulequery)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleresult.fetchall()]
    
    return render_template('parttimeschedule.html', schedule = schedule)

@app.route('/setFullTimeSchedule', methods=['GET'])
def setFullTimeSchedule():
    username = "Bakkwa"
    today = datetime.today()
    datem = datetime(today.year, today.month + 1 % 12, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)

    return render_template('setfulltimeschedule.html', monthYear = monthYear)

@app.route('/setFullTimeScheduleResult', methods=['GET', 'POST'])
def setFullTimeScheduleResult():
    username = "Bakkwa"
    today = datetime.today()
    datem = datetime(today.year, today.month + 1 % 12, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)

    if request.method == 'POST':
        form = request.form
        startDay = form.get('startDay')
        day1 = form.get('day1')
        day2 = form.get('day2')
        day3 = form.get('day3')
        day4 = form.get('day4')
        day5 = form.get('day5')
        newMwsidQuery = f"select max(mwsid) from MonthlyWorkSchedule"
        newFwsidQuery = f"select max(fwsid) from FixedWeeklySchedule"
        newMwsid = db.session.execute(newMwsidQuery).fetchall()[0][0] + 1
        newFwsid = db.session.execute(newFwsidQuery).fetchall()[0][0] + 1
        print(newMwsid)
        print(newFwsid)

    return render_template('setfulltimescheduleresult.html', monthYear = monthYear)

    return render_template('setfulltimescheduleresult.html', monthYear = monthYear)


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
    data = f"insert into TestingSetup (memberName, ricePurityScore) values ('{name}'; {score})"
    db.session.execute(data)
    db.session.commit()
    return render_template('testsuccess.html')