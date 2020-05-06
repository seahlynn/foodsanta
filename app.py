import settings
import os
from flask import Flask, render_template, request, session, flash, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.schema import MetaData
#from flask_login import LoginManager
from datetime import datetime, date, timedelta
from decimal import *

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

        #return redirect('login')
        return redirect('login')

        
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
            return redirect_accordingly(username)
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
    insert_users = f"insert into Users(username, name, password, phoneNumber, dateCreated) values ('{username}','{name}','{password}', '{98782507}', '{date}');"
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

def redirect_accordingly(username):
    global db
    check_user_customer = f"select 1 from Customers where username = '{username}'"
    if db.session.execute(check_user_customer).fetchone():
        return redirect('gotocusprofile')
    check_user_manager = f"select 1 from FDSManagers where username = '{username}'"
    if db.session.execute(check_user_manager).fetchone():
        return redirect('gotomanagerprofile')
    check_user_rider = f"select 1 from DeliveryRiders where username = '{username}'"
    if db.session.execute(check_user_rider).fetchone():
        return redirect('gotoriderprofile')
    return redirect('login')
        

'''
Manager related: Profile
'''
@app.route('/gotomanagerprofile', methods=['GET'])
def gotomanagerprofile():
    username = session['username']

    profilequery = f"select name, phoneNumber from Users where username = '{username}'"
    profileresult = db.session.execute(profilequery)
    profile = [dict(name = row[0], number = row[1]) for row in profileresult.fetchall()]
    
    
    return render_template('managerprofile.html', profile = profile)

@app.route('/editmanagerprofile', methods=['POST'])
def editmanagerprofile():
    username = session['username']

    contact = request.form['contact']
    
    if contact != '':
        update_contact = f"update Users set phoneNumber = {contact} where username = '{username}'"
        db.session.execute(update_contact)

    db.session.commit()

    return redirect('gotomanagerprofile')

'''
Manager related: manage restaurants
'''
@app.route('/gotomanagerests', methods=['GET'])
def gotomanagerests():
    username = session['username']

    restquery = f"select * from Restaurants"
    restresult = db.session.execute(restquery)
    restlist = [dict(restid = row[0], restname = row[1], location = row[3], minamnt = row[2]) for row in restresult.fetchall()]
    
    restnamequery = f"select restid, restname from Restaurants"
    restnameresult = db.session.execute(restnamequery)
    namelist = [dict(restid = row[0], restname = row[1]) for row in restnameresult.fetchall()]

    staffquery = f"select U.name, U.username from Users U, RestaurantStaff R where U.username = R.username and R.restid is null"
    staffresult = db.session.execute(staffquery)
    stafflist = [dict(staffname = row[0], username = row[1]) for row in staffresult.fetchall()]

    return render_template('managerestaurants.html', restlist = restlist, namelist = namelist, stafflist = stafflist)

@app.route('/addrestaurant', methods=['POST'])
def addrestaurant():
    username = session['username']

    restname = request.form['restname']
    location = request.form['location']
    minamnt = request.form['minamnt']
    restidquery = f"select max(restid) from Restaurants"
    restid = int(db.session.execute(restidquery).fetchall()[0][0] or 0) + 1

    if restname == '' or location =='' or minamnt == '':
        flash("Please make sure all the fields have been filled!")
        return redirect('gotomanagerests')

    minamnt = int(minamnt)
    todo = f"insert into Restaurants values ({restid}, '{restname}', {minamnt}, '{location}')"
    db.session.execute(todo)
    db.session.commit()
    
    return redirect('gotomanagerests')

@app.route('/editrestaurant', methods=['POST'])
def editrestaurant():
    username = session['username']

    restid = request.form['restid']
    restname = request.form['restname']
    location = request.form['location']
    minamnt = request.form['minamnt']
    
    if restid == '':
        flash("Choose the restaurant you want to edit!")
        return redirect('gotomanagerests')

    restidcheckquery = f"select count(*) from Restaurants where restid = {restid}"
    restidcheck = db.session.execute(restidcheckquery).fetchall()[0][0]

    if restidcheck == 0:
        flash("Restaurant ID doesn't exist!")
        return redirect('gotomanagerests')

    if restname == '' and location =='' and minamnt == '':
        flash("Please fill in at least one field")
        return redirect('gotomanagerests')


    if minamnt != '':
        minamnt = int(minamnt)
        updateamount = f"update Restaurants set minAmt = {minamnt} where restid = {restid}"
        db.session.execute(updateamount)
    if location != '':
        updatelocation = f"update Restaurants set location = '{location}' where restid = {restid}"
        db.session.execute(updatelocation)
    if restname != '':
        updatename = f"update Restaurants set restname = '{restname}' where restid = {restid}"
        db.session.execute(updatename)

    db.session.commit()
    
    return redirect('gotomanagerests')

@app.route('/linkstaff', methods=['POST'])
def linkstaff():
    restid = request.form.get('restid')
    username = request.form.get('username')
    
    if restid is None or username is None:
        flash("Please make sure all the fields have been filled!")
        return redirect('gotomanagerests')
    
    todo = f"update RestaurantStaff set restid={restid} where username = '{username}'"
    db.session.execute(todo)
    db.session.commit()
    
    return redirect('gotomanagerests')

'''
Manager related: View, Add, Delete Promos
'''
@app.route('/gotopromos', methods=['GET'])
def gotopromos():
    promoquery = f"select * from FDSPromo where endTime > (select current_date)"
    promoresult = db.session.execute(promoquery).fetchall()

    promolist = [dict(id = row[0], description = row[1], start = row[3], end = row[4]) for row in promoresult]
    return render_template('managerpromopage.html', promolist = promolist)

@app.route('/deletepromo', methods=['POST'])
def deletepromo():
    global db

    fdspromoid = int(request.form['fdspromoid'])
    todo = f"delete from FDSPromo where fdspromoid = {fdspromoid}"

    db.session.execute(todo)
    db.session.commit()
    return redirect('gotopromos')

@app.route('/showpromohistory', methods=['POST'])
def showpromohistory():
    global db

    promoquery = f"select * from FDSPromo where endTime > (select current_date)"
    promoresult = db.session.execute(promoquery).fetchall()
    pastpromoquery = f"select * from FDSPromo where endTime < (select current_date)"
    pastpromoresult = db.session.execute(pastpromoquery).fetchall()

    promolist = [dict(id = row[0], description = row[1], start = row[3], end = row[4]) for row in promoresult]
    pastpromolist = [dict(id = row[0], description = row[1], start = row[3], end = row[4]) for row in pastpromoresult]

    return render_template('managerpromopage.html', promolist = promolist, pastpromolist = pastpromolist)


@app.route('/addpromo', methods=['POST'])
def addpromo():
    global db

    promotype = request.form.get('promotype')
    description = request.form['description']
    discount = request.form['discount']
    minamnt = request.form['minamnt']
    appliedto = request.form.get('appliedto')
    validfrom = request.form['validfrom']
    validtill = request.form['validtill']
    cost = request.form['cost']
    
    fdspromoidquery = f"select fdspromoid from FDSPromo order by fdspromoid desc limit 1"
    fdspromoidresult = db.session.execute(fdspromoidquery).fetchall()
    fdspromoid = fdspromoidresult[0][0] + 1

    if promotype is None or appliedto is None or description == '' or discount == '' or minamnt == '' or cost == '':
        flash("Please make sure all fields are filled in!")
        return redirect('gotopromos')

    if validtill < validfrom:
        flash("Invalid Promotion dates! Please make sure the start date is before the end date!")
        return redirect('gotopromos')

    discount = int(discount)
    minamnt = int(minamnt)
    cost = int(cost)

    if promotype == 'PercentOff':
        addtofdspromo = f"insert into FDSPromo values ({fdspromoid}, '{description}', 'percentoff', '{validfrom}', '{validtill}', {cost})"
        addtospecificpromo = f"insert into PercentOff values ({fdspromoid}, {discount}, {minamnt}, '{appliedto}')"
    else:
        addtofdspromo = f"insert into FDSPromo values ({fdspromoid}, '{description}', 'amountoff', '{validfrom}', '{validtill}', {cost})"
        addtospecificpromo = f"insert into AmountOff values ({fdspromoid}, {discount}, {minamnt}, '{appliedto}')"

    db.session.execute(addtofdspromo)
    db.session.execute(addtospecificpromo)
    db.session.commit()
    return redirect('gotopromos')


'''
Manager related: View statistics
'''
@app.route('/gotostats', methods=['GET'])
def gotostats():
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
        
    return render_template('stats.html', monthlist = monthlist)


@app.route('/viewallstats', methods=['GET', 'POST'])
def viewallstats():
    '''to have the month dropdown'''
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    statsquery = f"select * from AllStats order by monthid"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[0], customers = row[1], orders = row[2], cost = row[3]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, overallstatslist = statslist)

@app.route('/viewspecificstats', methods=['GET', 'POST'])
def viewspecificstats():
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    monthid = int(request.form['month'])
    statsquery = f"select * from AllStats where monthid = {monthid}"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[0], customers = row[1], orders = row[2], cost = row[3]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, overallstatslist = statslist)

@app.route('/viewallcusstats', methods=['GET', 'POST'])
def viewallcusstats():
    '''to have the month dropdown'''
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    statsquery = f"select * from CustomerStats order by monthid"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[1], username = row[0], orders = row[2], cost = row[3]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, cusstatslist = statslist)

@app.route('/viewspecificcusstats', methods=['GET', 'POST'])
def viewspecificcusstats():
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    monthid = int(request.form['month'])
    statsquery = f"select * from CustomerStats where monthid = {monthid}"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[1], username = row[0], orders = row[2], cost = row[3]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, cusstatslist = statslist)

@app.route('/viewallriderstats', methods=['GET', 'POST'])
def viewallriderstats():
    '''to have the month dropdown'''
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    statsquery = f"select * from RiderStats order by month"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[0], username = row[2], orders = row[3], hours = row[4], salary = row[5]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, riderstatslist = statslist)

@app.route('/viewspecificriderstats', methods=['GET', 'POST'])
def viewspecificriderstats():
    '''to have the month dropdown'''
    monthlistresult = db.session.execute(f"select distinct monthid from Allstats order by monthid")
    monthlist = [dict(month = row[0]) for row in monthlistresult.fetchall()]
    
    monthid = int(request.form['month'])
    statsquery = f"select * from RiderStats where month = {monthid}"
    statsresult = db.session.execute(statsquery)
    statslist = [dict(month = row[0], username = row[2], orders = row[3], hours = row[4], salary = row[5]) for row in statsresult.fetchall()]

    return render_template('stats.html', monthlist = monthlist, riderstatslist = statslist)


'''
Customer related: View, Edit profile
'''
@app.route('/gotocusprofile', methods=['GET'])
def gotocusprofile():
    username = session['username']

    profilequery = f"select U.name, U.phoneNumber, C.points from Users U, Customers C where C.username = '{username}' and U.username = '{username}'"
    profileresult = db.session.execute(profilequery)
    profile = [dict(name = row[0], number = row[1], points = row[2]) for row in profileresult.fetchall()]
    
    cardquery = f"select cardInfo from PaymentMethods where username='{username}' and cardInfo <> 'cash on delivery'"
    cardresult = db.session.execute(cardquery)
    cardlist = [dict(card = row[0]) for row in cardresult.fetchall()]
    
    return render_template('profile.html', cardlist = cardlist, profile = profile)

@app.route('/editprofile', methods=['POST'])
def editprofile():
    username = session['username']

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

    return redirect('gotocusprofile')


'''
Customer related: View ordering page, order from Menu, add to cart
'''
@app.route('/gotorest', methods=['GET'])
def gotorest():
    orderidquery = f"select orderid from Orders order by orderid desc limit 1"
    orderidresult = db.session.execute(orderidquery).fetchall()
    orderid = int(orderidresult[0][0] or 0) + 1
    session['orderid'] = orderid
    session['deliveryfee'] = 4

    query = f"select * from Restaurants"
    result = db.session.execute(query)
        
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
    return render_template('restaurants.html', restlist = restlist)


@app.route('/restresults', methods=['GET', 'POST'])
def restresults():
    global db

    orderid = session['orderid']
    query = f"select * from Restaurants"
    result = db.session.execute(query)
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]
    

    restid = int(request.args['chosen'])
    query = f"SELECT * FROM Food WHERE restid = {restid} and availability > 0"
    result = db.session.execute(query)
    foodlist = [dict(food= row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    
    checklatest = db.session.execute(f"select count(*) from Latest where orderid = {orderid}").fetchall()[0][0]

    if checklatest != 0:
        latestRestID = db.session.execute(f"select restid from Latest where orderid = {orderid}").fetchall()[0][0]
        restaurantName = db.session.execute(f"select restName from Restaurants where restid = {latestRestID}").fetchall()[0][0]

        if restid != latestRestID:
            flash("You have items in your cart under " + restaurantName + "! Each order can only be from one restaurant!")

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

    username = session['username']
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

    restidquery = f"(select restid from Food where foodid = {foodid})"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]

    checklatestquery = f"select count(*) from Latest where orderid = {orderid}"
    checklatestresult = db.session.execute(checklatestquery).fetchall()
    checklatest = checklatestresult[0][0]

    if checklatest != 0:
        updateLatest = f"update Latest set restid = {restid} where orderid = {orderid}"
    else:
        updateLatest = f"insert into Latest (orderid, restid) values ({orderid}, {restid})"

    '''updateLatest = f"insert into Latest (orderid, restid) values({orderid}, {restid}) on conflict (orderid) do update set restid = excluded.restid"'''
    db.session.execute(updateLatest)
    db.session.commit()

    #ensures the page stays on the specific restaurant menu
    query = f"select * from Food where restid = {restid}"
    result = db.session.execute(query)
    foodlist = [dict(food = row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    query = f"select * from Restaurants"
    result = db.session.execute(query)
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]

    #display min amt for restaurant
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]

    return render_template('restaurants.html', restlist = restlist, minAmt = minAmt, foodlist = foodlist)


'''
Customer related: View, Delete from cart
'''
@app.route('/viewcart', methods=['POST', 'GET'])
def viewcart():
    global db

    orderid = session['orderid']
    username = session['username']

    checkLatest = db.session.execute(f"select count(*) from Latest where orderid = {orderid}").fetchall()[0][0]

    if checkLatest == 0:
        flash("Your cart is empty!")
        return redirect('gotorest')

    restidquery = f"select restid from Latest where orderid = {orderid}"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]
    
    #for cart 
    orderquery = f"select C.description, F.price, C.quantity, F.foodid from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid} and restid = {restid}"
    orderresult = db.session.execute(orderquery)
    orderlist = [dict(food = row[0], price = row[1], quantity = row[2], foodid = row[3]) for row in orderresult.fetchall()]

    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid} and restid = {restid}"
    totalresult = db.session.execute(totalquery).fetchall()
    totalprice = totalresult[0][0]

    if totalprice is None:
        totalprice = 0

    #to find amount away from minimum order
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]
    difference = '{0:.2f}'.format(float(minAmt) -float(totalprice))

    if float(difference) <= 0:
        difference = 0

    return render_template('cart.html', orderlist = orderlist, totalprice = totalprice, difference = difference)

@app.route('/deletefromcart', methods=['POST'])
def deletefromcart():
    global db

    orderid = session['orderid']
    username = session['username']
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

    #ensures the page displays the specific restaurant menu
    restid = f"(select restid from Latest where orderid = {orderid})"
    query = f"SELECT * FROM Food WHERE restid = {restid}"
    result = db.session.execute(query)
    foodlist = [dict(food = row[1], price = row[2], foodid = row[0]) for row in result.fetchall()]
    
    #for the restaurants dropdown
    query = f"select * from Restaurants"
    result = db.session.execute(query)
    restlist = [dict(restid = row[0], restname = row[1]) for row in result.fetchall()]

    #display min amt for restaurant
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]

    return render_template('restaurants.html', foodlist = foodlist, restlist = restlist, minAmt = minAmt)


'''
Customer related: Check out cart, buy delivery promo, place order
'''
@app.route('/checkout', methods=['POST', 'GET'])
def checkout():

    orderid = session['orderid']
    username = session['username']
    deliveryfee = session['deliveryfee']

    #for customer details
    custquery = f"select U.name, U.phoneNumber from Users U where U.username = '{username}' limit 1"
    custresult = db.session.execute(custquery)
    custdetails = [dict(name = row[0], number = row[1]) for row in custresult.fetchall()]
    
    #locationlist
    locationquery = f"select location from Locations where username = '{username}'"
    locationresult = db.session.execute(locationquery)
    locationlist = [dict(location = row[0]) for row in locationresult.fetchall()]

    #paymentlist
    paymentquery = f"select cardInfo from PaymentMethods where username = '{username}'"
    paymentresult = db.session.execute(paymentquery)
    paymentlist = [dict(method = row[0]) for row in paymentresult.fetchall()]

    #totalprice
    restidquery = f"select restid from Latest where orderid = {orderid}"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]

    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid} and restid = {restid}"
    totalresult = db.session.execute(totalquery).fetchall()
    subtotal = totalresult[0][0]
    
    if subtotal is None:
        subtotal = 0

    total = subtotal + session['deliveryfee']

    # check cart
    checkCartquery = f"select count(*) from Contains where orderid = {orderid}"
    checkCartresult = db.session.execute(checkCartquery).fetchall()
    checkCart = checkCartresult[0][0]

    if (checkCart == 0):
        flash("Your cart is empty, there is nothing to order!")
        return redirect('confirmcheckout')

    #to check if it hits restaurant's minimum order amount
    query = f"select minAmt from Restaurants where restid = {restid}"
    result = db.session.execute(query).fetchall()
    minAmt = result[0][0]
    difference = '{0:.2f}'.format(float(minAmt) - float(subtotal))
    
    if (subtotal < minAmt):
        flash("You are $" + difference + " away from the minimum order amount!")
        return redirect('viewcart')
        
    #delivery promotions
    deliverypromoquery = f"select deliverypromoid, description, points from DeliveryPromo where deliverypromoid not in (select deliverypromoid from UsersDeliveryPromo)"
    deliverypromoresult = db.session.execute(deliverypromoquery)
    deliverypromolist = [dict(description = row[1], deliverypromoid = row[0], points = row[2]) for row in deliverypromoresult.fetchall()]

    #delivery promotions bought
    boughtdeliverypromoquery = f"select D.deliverypromoid, D.description from DeliveryPromo D, UsersDeliveryPromo U where D.deliverypromoid = U.deliverypromoid and U.username = '{username}'"
    boughtdeliverypromoresult = db.session.execute(boughtdeliverypromoquery)
    boughtdeliverypromolist = [dict(deliverypromoid = row[0], description = row[1]) for row in boughtdeliverypromoresult.fetchall()]

    #existing promos available for user (including the ones for this restaurant)
    promoquery = f"select fdspromoid, description from FDSPromo where fdspromoid in (select fdspromoid from Userspromo where username = '{username}') and fdspromoid not in (select fdspromoid from RestaurantPromo where restid <> {restid})"
    promoresult = db.session.execute(promoquery)
    promolist = [dict(fdspromoid = row[0], description = row[1]) for row in promoresult.fetchall()]

    #get points
    pointsquery = f"select points from Customers where username = '{username}'"
    points = db.session.execute(pointsquery).fetchall()[0][0]

    return render_template('checkout.html', custdetails = custdetails, locationlist = locationlist, paymentlist = paymentlist, deliveryfee = deliveryfee, subtotal = subtotal, total = total, deliverypromolist = deliverypromolist, boughtdeliverypromolist = boughtdeliverypromolist, points = points, boughtpromolist = promolist)

@app.route('/buydeliverypromo', methods=['POST', 'GET'])
def buydeliverypromo():
    username = session['username']
    promoid = int(request.form['deliverypromoid'])
    
    #promo points
    promopointsquery = f"select points from DeliveryPromo where deliverypromoid = {promoid}"
    promopoints = db.session.execute(promopointsquery).fetchall()[0][0]
    
    #customer's points
    cuspointsquery = f"select points from Customers where username = '{username}'"
    cuspoints = db.session.execute(cuspointsquery).fetchall()[0][0]

    if (promopoints < cuspoints):
       todo = f"insert into UsersDeliveryPromo values({promoid}, '{username}')"
       db.session.execute(todo)
       db.session.commit()

       return redirect('checkout')
    else:
        flash("You don't have enough points to purchase this promo! \n You get 1 point for every $1 spent!")
     
@app.route('/confirmcheckout', methods=['POST', 'GET'])
def confirmcheckout():

    orderid = session['orderid']
    username = session['username']
    #location
    location = request.form.get('location')
    #card info
    cardInfo = request.form.get('payment')

    if location == '':
        flash("Location cannot be blank!")
        return redirect('checkout')

    if cardInfo is None:
        flash("Please choose a payment method!")
        return redirect('checkout')

    #for customer details
    custquery = f"select U.name, U.phoneNumber from Users U where U.username = '{username}' limit 1"
    custresult = db.session.execute(custquery)
    custdetails = [dict(name = row[0], number = row[1]) for row in custresult.fetchall()]
    

    #amount off delivery fee
    deliverypromoid = request.form.get('deliverypromoid')

    if deliverypromoid == 'nonechosen':
        amountoff = 0
        deliverydescription = 'nonechosen'
    else:
        deliverydescription = db.session.execute(f"select description from DeliveryPromo where deliverypromoid = {deliverypromoid}").fetchall()[0][0]
        amountoffquery = f"select amount from DeliveryPromo where deliverypromoid = {deliverypromoid}"
        amountoff = db.session.execute(amountoffquery).fetchall()[0][0]
        session['removepromo'] = f"delete from UsersDeliveryPromo where deliverypromoid = {deliverypromoid}"

    deliveryfee = session['deliveryfee'] - amountoff

    #totalprice
    restidquery = f"select restid from Latest where orderid = {orderid}"
    restidresult = db.session.execute(restidquery).fetchall()
    restid = restidresult[0][0]

    totalquery = f"select sum(F.price * C.quantity) from Contains C, Food F where C.foodid = F.foodid and orderid = {orderid} and restid = {restid}"
    totalresult = db.session.execute(totalquery).fetchall()
    subtotal = totalresult[0][0]
    

    #process fds promotions
    fdspromoid = request.form.get('fdspromoid')

    if fdspromoid != 'nonechosen':
        typequery = f"select type from FDSPromo where fdspromoid = {fdspromoid}"
        typeresult = db.session.execute(typequery).fetchall()[0][0]

        if typeresult == 'percentoff':
            percent = db.session.execute(f"select percent from PercentOff where fdspromoid = {fdspromoid}").fetchall()[0][0]
            appliedto = db.session.execute(f"select appliedto from PercentOff where fdspromoid = {fdspromoid}").fetchall()[0][0]
            minamnt = db.session.execute(f"select minAmnt from PercentOff where fdspromoid = {fdspromoid}").fetchall()[0][0]

            if (minamnt > subtotal):
                flash("You cannot apply this promo! Minimum spending amount has to be $" + str(minamnt))
                return redirect ('checkout')
            else:
                if appliedto == 'delivery':
                    deliveryfee = round(Decimal((deliveryfee / 100) * (100 - percent)), 2)
                else:
                    subtotal = round(Decimal((subtotal / 100) * (100 - percent)), 2)
        #amount off
        else:
            amount = db.session.execute(f"select amount from AmountOff where fdspromoid = {fdspromoid}").fetchall()[0][0]
            appliedto = db.session.execute(f"select appliedto from AmountOff where fdspromoid = {fdspromoid}").fetchall()[0][0]
            minamnt = db.session.execute(f"select minAmnt from AmountOff where fdspromoid = {fdspromoid}").fetchall()[0][0]

            if (minamnt > subtotal):
                flash("You cannot apply this promo! Minimum spending amount has to be " + minamnt)
                return redirect ('checkout')
            else:
                if appliedto == 'delivery':
                    deliveryfee = deliveryfee - amount
                else:
                    subtotal = subtotal - amount

        session['removefdspromo'] = f"delete from UsersPromo where fdspromoid = {fdspromoid}"

    #eventual price 
    total = subtotal + deliveryfee

    #temp order 
    ordercreatedtime = datetime.now().strftime("%d/%m/%Y %H%M") 
    fdspromoid = 'null'
    paymentmethodquery = f"select paymentmethodid from PaymentMethods where username = '{username}' and cardInfo = '{cardInfo}'"
    paymentresult = db.session.execute(paymentmethodquery).fetchall()
    paymentmethodid = paymentresult[0][0]
    preparedbyrest = False
    selectedByRider = False

    session['insertorder'] = f"insert into Orders(orderid, username, custLocation, orderCreatedTime, totalCost, fdspromoid, paymentmethodid, preparedByRest, selectedByRider, restid, delivered) values ('{orderid}', '{username}', '{location}', '{ordercreatedtime}', {total}, {fdspromoid}, {paymentmethodid}, {preparedbyrest}, {selectedByRider}, {restid}, False)"
    session['insertdelivery'] = f"insert into Delivers(orderid, username, rating, location, deliveryFee, timeDepartToRestaurant, timeArrivedAtRestaurant, timeOrderDelivered, paymentmethodid) values ('{orderid}', null, null, '{location}', '{deliveryfee}', null, null, null, {paymentmethodid})"
    
    
    return render_template('confirmcheckout.html', custdetails = custdetails, location = location, cardInfo = cardInfo, subtotal = subtotal, total = total, deliverypromo = deliverydescription, deliveryfee = deliveryfee)

@app.route('/placeorder', methods=['POST'])
def placeorder():

    insertorder = session['insertorder']
    insertdelivery = session['insertdelivery']

    if session.get('removepromo') is not None:
        removepromo = session['removepromo']
        db.session.execute(removepromo)

    if session.get('removefdspromo') is not None:
        removefdspromo = session['removefdspromo']
        db.session.execute(removefdspromo)

    db.session.execute(insertorder)
    db.session.execute(insertdelivery)
    db.session.commit()

    return redirect('orderstatus')

'''
Customer related: View order status, order history, submit review
'''

@app.route('/orderstatus', methods=['POST', 'GET'])
def orderstatus():

    username = session['username']
    orderid = session['orderid']

    # allocate an available rider to deliver
    # rider is currently working (either part time or full time)
    # rider is not currently taking an order that has not been delivered
    checkavailableriderquery = f"select distinct username from DeliveryRiders F natural join MonthlyWorkSchedule M where not exists (select 1 from Delivers join Orders on (Delivers.orderid = Orders.orderid) where Delivers.username = F.username and Orders.delivered = False and Orders.selectedByRider = True) union select distinct username from DeliveryRiders F natural join WeeklyWorkSchedule W where not exists (select 1 from Delivers join Orders on (Delivers.orderid = Orders.orderid) where Delivers.username = F.username and Orders.delivered = False and Orders.selectedByRider = True) "
    availableriders = db.session.execute(checkavailableriderquery).fetchall()
    numavailableriders = availableriders.len()
    randridernum = randrange(0, numavailableriders, 0)
    randrider = availableriders[randridernum]
    riderusername = randrider[0]
    updateriderpicked = f"update Delivers set username = '{riderusername}' where orderid = '{orderid}'"
    updateorderselectedbyrider = f"update Orders set selectedByRider = True where orderid = '{orderid}'"
    db.session.execute(updateriderpicked)
    db.session.execute(updateorderselectedbyrider)
    db.session.commit()

    inprogressquery = f"select restName, orderCreatedTime, selectedByRider, timeArrivedAtRestaurant from Orders O, Delivers D, Restaurants R where D.orderid = O.orderid and O.username = '{username}' and O.delivered = False and R.restid = O.restid"
    progressresult = db.session.execute(inprogressquery)
    orderlist = [dict(rest = row[0], timeordered = row[1], orderpicked = row[2], pickedup = row[3]) for row in progressresult.fetchall()]

    finishedquery = f"select R.restName, O.totalCost, D.timeOrderDelivered, O.orderid from Orders O, Delivers D, Restaurants R where D.orderid = O.orderid and O.username = '{username}' and R.restid = O.restid and O.delivered = True"
    finishedresult = db.session.execute(finishedquery)
    finishedlist = [dict(rest = row[0], total = row[1], received = row[2], orderid = row[3]) for row in finishedresult.fetchall()]
    
    return render_template('orderstatus.html', orderlist = orderlist, finishedlist = finishedlist)

@app.route('/submitreview', methods=['POST'])
def submitreview():

    username = session['username']
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
Customer related: View and purchase promos
'''
   
@app.route('/viewpromos', methods=['POST', 'GET'])
def viewpromos():

    username = session['username']
    pointsquery = f"select points from Customers where username = '{username}'"
    points = db.session.execute(pointsquery).fetchall()[0][0]

    #fds promo
    promoquery = f"select fdspromoid, description, startTime, endTime, points from FDSPromo F where endTime > (select current_date) and fdspromoid not in (select fdspromoid from UsersPromo) and fdspromoid not in (select fdspromoid from RestaurantPromo)"
    promoresult = db.session.execute(promoquery)
    promolist = [dict(fdspromoid = row[0], description = row[1], validfrom = row[2], validtill = row[3], points = row[4]) for row in promoresult.fetchall()]
    
    #restaurant promos
    restpromoquery = f"select P.fdspromoid, P.description, P.startTime, P.endTime, P.points, R.restname from FDSPromo P, RestaurantPromo F, Restaurants R where P.endTime > (select current_date) and P.fdspromoid not in (select fdspromoid from UsersPromo) and P.fdspromoid in (select fdspromoid from RestaurantPromo) and F.restid = R.restid and F.fdspromoid = P.fdspromoid"
    restpromoresult = db.session.execute(restpromoquery)
    restpromolist = [dict(fdspromoid = row[0], description = row[1], validfrom = row[2], validtill = row[3], points = row[4], restname = row[5]) for row in restpromoresult.fetchall()]

    #promos user has
    boughtpromoquery = f"select fdspromoid, description, startTime, endTime from FDSPromo where endTime > (select current_date) and fdspromoid in (select fdspromoid from UsersPromo)"
    boughtpromoresult = db.session.execute(boughtpromoquery)
    boughtpromolist = [dict(fdspromoid = row[0], description = row[1], validfrom = row[2], validtill = row[3]) for row in boughtpromoresult.fetchall()]

    return render_template('cuspromopage.html', points = points, promolist = promolist, boughtpromolist = boughtpromolist, restpromolist = restpromolist)

@app.route('/buypromo', methods=['POST', 'GET'])
def buypromo():
    username = session['username']
    promoid = int(request.form['fdspromoid'])
    
    #promo points
    promopointsquery = f"select points from FDSPromo where fdspromoid = {promoid}"
    promopoints = db.session.execute(promopointsquery).fetchall()[0][0]
    
    #customer's points
    cuspointsquery = f"select points from Customers where username = '{username}'"
    cuspoints = db.session.execute(cuspointsquery).fetchall()[0][0]

    if (promopoints < cuspoints):
       todo = f"insert into UsersPromo values({promoid}, '{username}')"
       db.session.execute(todo)
       db.session.commit()

       return redirect('viewpromos')
    else:
        flash("You don't have enough points to purchase this promo! \n You get 1 point for every $1 spent!")
        return redirect('viewpromos')
    
'''
Riders accept allocated undelivered orders to pick up and deliver

'''
@app.route('/gotoriderprofile', methods=['GET'])
def gotoriderprofile():
    username = session['username']

    profilequery = f"select name, phoneNumber from Users where username = '{username}'"
    profileresult = db.session.execute(profilequery)
    profile = [dict(name = row[0], number = row[1]) for row in profileresult.fetchall()]

    riderstatsquery = f"select * from RiderStats where username = '{username}'"    
    riderstatsresult = db.session.execute(riderstatsquery)
    riderstats = [dict(month = row[0], year = row[1], totalOrders = row[3], totalHours = row[4], totalSalary = row[5]) for row in riderstatsresult.fetchall()]
    
    return render_template('riderprofile.html', profile = profile, riderstats = riderstats)

@app.route('/gotodelivery', methods=['GET'])
def gotodelivery():
    username = session['username']  
    hasallocatedOrdersQuery = f"select count(*) from Delivers natural join Orders where Delivers.username = '{username}' and Orders.delivered = False and Orders.selectedByRider = True"
    hasallocatedOrdersResult = db.session.execute(hasallocatedOrdersQuery).fetchall()

    if hasallocatedOrdersResult[0][0] != 0:
        # there exists an allocated order (just pull one)
        allocatedorderquery = f"select Delivers.orderid, Orders.custLocation, Restaurants.location from Delivers natural join (Orders join Restaurants on (Orders.restid = Restaurants.restid)) where Delivers.username = '{username}' and Orders.delivered = False limit 1"
        allocatedOrderresult = db.session.execute(allocatedorderquery)
        allocatedOrder = [dict(orderid = row[0], custLocation = row[1], restLocation = row[2]) for row in allocatedOrderresult.fetchall()]
        session['deliveringOrderId'] = allocatedOrderresult[0][0]
        return render_template('riders_viewAllocatedOrder.html', allocatedOrder = allocatedOrder)

    else:
        # has no allocated order 
        # go to new html page that will lead back to profile
        return render_template('riders_nodeliveriesnow.html')

    #undeliveredOrdersQuery = f"select orderid, (select location from Restaurants where Restaurants.restid = Orders.restid), custLocation from Orders where preparedByRest = False and selectedByRider = False"
    #undeliveredOrdersResult = db.session.execute(undeliveredOrdersQuery)
    #ordersToPickUp = [dict(orderid = row[0], restLocation = row[1], custLocation = row[2]) for row in undeliveredOrdersResult.fetchall()]    

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
    
    return render_template('riders_selectUndeliveredOrders.html', chosenOrderInfo = chosenOrderInfo)

@app.route('/processOrderSelectedForDelivery', methods=['POST', 'GET'])
def processOrderSelectedForDelivery():
    global db

    deliveringOrderId = session['deliveringOrderId']

    # update order 
    updateOrderStatus = f'update Orders set selectedByRider = True where orderid = {deliveringOrderId}'
    db.session.execute(updateOrderStatus)
    db.session.commit()

    # add into delivery table
    '''username = session['username']'''
    username = 'justning'
    chosenOrderQuery = f"select custLocation from Orders where preparedByRest = False and selectedByRider = True and orderid = {deliveringOrderId}"
    chosenOrderResult = db.session.execute(chosenOrderQuery).fetchall()
    custLocation = str(chosenOrderResult[0][0])

    currentTime = datetime.now().strftime("%d/%m/%Y %H%M")
    deliveryFee = 3 # to be edited later
    # maybe can change to update Delivers instead of insert into
    updateDelivery = f"update Delivers set username = '{username}' where orderid = {deliveringOrderId}"
    db.session.execute(updateDelivery)
    db.session.commit()

    return redirect('collectFromRestaurant')

@app.route('/collectFromRestaurant', methods=['GET'])
def collectFromRestaurant():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = session['username']

    # timestamp for when he leaves for the restaurant
    currentTime = datetime.now().strftime("%d/%m/%Y %H%M")
    updateLeaveTime = f"update Delivers set timeDepartToRestaurant='{currentTime}' where orderid = '{deliveringOrderId}' and username = '{username}'"
    db.session.execute(updateLeaveTime)
    db.session.commit()

    # retrieve restaurant address to display
    restLocationQuery = f'select location from Restaurants where restid in (select distinct restid from Orders where Orders.orderid = {deliveringOrderId})'
    restLocationResult = db.session.execute(restLocationQuery).fetchall()
    restLocation = restLocationResult[0][0]

    return render_template('riders_orderToCollectAtRestaurant.html', restLocation = restLocation)

@app.route('/collectedFromRestaurant', methods=['POST'])
def collectedFromRestaurant():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = session['username']
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
    username = session['username']

    custLocationQuery = f'select custLocation from Orders where Orders.orderid = {deliveringOrderId}'
    custLocationResult = db.session.execute(custLocationQuery).fetchall()
    custLocation = custLocationResult[0][0]

    return render_template('riders_orderToDeliverToCustomer.html', custLocation = custLocation)

@app.route('/orderDelivered', methods=['POST', 'GET'])
def orderDelivered():
    global db

    deliveringOrderId = session['deliveringOrderId']
    username = session['username']
    '''username = 'justning' '''
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
    
@app.route('/returnToProfile', methods=['POST'])
def returnToProfile():
    return redirect('gotoriderprofile')

@app.route('/gotoschedule', methods=['GET'])
def gotoschedule():
    username = session['username']
    fullriderquery = f"select count(*) from FullTimeRiders where username = '{username}'"
    fullrider = db.session.execute(fullriderquery).fetchall()[0][0]

    if fullrider == 0:
        return redirect('getPartTimeSchedule')
    else:
        return redirect('getFullTimeSchedule')
    
@app.route('/getFullTimeSchedule', methods=['GET'])
def getFullTimeSchedule():
    username = 'bakwah'
    today = datetime.today()
    datem = datetime(today.year, today.month, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)
    schedulequery = f"create table dayShift (day integer, shift integer, primary key(day, shift)); insert into dayShift (day, shift) select M.wkStartDay, F.day1 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 1) % 7, F.day2 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 2) % 7, F.day3 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 3) % 7, F.day4 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 4) % 7, F.day5 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, case when shift = 0 then '1000 to 1400\n1500 to 1900' when shift = 1 then '1100 to 1500\n1600 to 2000' when shift = 2 then '1200 to 1600\n1700 to 2100' when shift = 3 then '1300 to 1700\n1800 to 2200' end as shift from dayShift;"
    scheduleresult = db.session.execute(schedulequery)
    nextMonth = datetime(today.year, today.month + 1 % 12, 1).date()
    nextScheduleQuery = f"select count(*) from MonthlyWorkSchedule where mnthStartDay = '{nextMonth}'"
    nextScheduleResult = db.session.execute(nextScheduleQuery).fetchall()[0][0]
    noNextSchedule = nextScheduleResult == 0
    print(noNextSchedule)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleresult.fetchall()]
    
    return render_template('fulltimeschedule.html', schedule = schedule, monthYear = monthYear, noNextSchedule = noNextSchedule)



@app.route('/getNextFullTimeSchedule', methods=['GET'])
def getNextFullTimeSchedule():
    username = 'bakwah'
    today = datetime.today()
    datem = datetime(today.year, today.month + 1 % 12, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)
    scheduleQuery = f"create table dayShift (day integer, shift integer, primary key(day, shift)); insert into dayShift (day, shift) select M.wkStartDay, F.day1 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 1) % 7, F.day2 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 2) % 7, F.day3 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 3) % 7, F.day4 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; insert into dayShift (day, shift) select (M.wkStartDay + 4) % 7, F.day5 from MonthlyWorkSchedule M, FixedWeeklySchedule F where M.mwsid = F.mwsid and M.mnthStartDay = '{datem}' and M.username = '{username}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, case when shift = 0 then '1000 to 1400\n1500 to 1900' when shift = 1 then '1100 to 1500\n1600 to 2000' when shift = 2 then '1200 to 1600\n1700 to 2100' when shift = 3 then '1300 to 1700\n1800 to 2200' end as shift from dayShift;"
    scheduleResult = db.session.execute(scheduleQuery)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleResult.fetchall()]
    
    return render_template('nextfulltimeschedule.html', schedule = schedule, monthYear = monthYear)

@app.route('/setFullTimeSchedule', methods=['GET'])
def setFullTimeSchedule():
    username = "bakwah"
    today = datetime.today()
    datem = datetime(today.year, today.month + 1 % 12, 1).date()
    monthYear = datem.strftime('%B') + ' ' + str(today.year)

    return render_template('setfulltimeschedule.html', monthYear = monthYear)

@app.route('/setFullTimeScheduleResult', methods=['GET', 'POST'])
def setFullTimeScheduleResult():
    username = "bakwah"
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
        newScheduleQuery = f"begin; insert into MonthlyWorkSchedule(mwsid, username, mnthStartDay, wkStartDay, completed) values ('{newMwsid}', '{username}', '{datem}', '{startDay}', false); insert into FixedWeeklySchedule(fwsid, mwsid, day1, day2, day3, day4, day5) values ('{newFwsid}', '{newMwsid}', '{day1}', '{day2}', '{day3}', '{day4}', '{day5}'); commit;"
        newScheduleResult = db.session.execute(newScheduleQuery)

    return render_template('setfulltimescheduleresult.html', monthYear = monthYear)

@app.route('/getPartTimeSchedule', methods=['GET'])
def getPartTimeSchedule():
    username = "bakwah"
    today = datetime.today()
    monday = today - timedelta(days = today.weekday())
    datem = monday.date()
    sunday = monday + timedelta(days = 6)
    datemEnd = sunday.date()
    print(datem)
    print(datemEnd)
    schedulequery = f"create table dayShift (day integer, shift integer, duration integer, primary key(day, shift, duration)); insert into dayShift (day, shift, duration) select D.day, D.starthour, D.duration from DailyWorkShift D, WeeklyWorkSchedule W where W.wwsid = D.wwsid and W.username = '{username}' and W.startDate = '{datem}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, concat(cast((shift * 100) as varchar), ' to ', cast(((shift + duration) * 100) as varchar)) as shift from dayShift"
    scheduleresult = db.session.execute(schedulequery)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleresult.fetchall()]
    
    return render_template('parttimeschedule.html', schedule = schedule, datem = datem, datemEnd = datemEnd)

@app.route('/getNextPartTimeSchedule', methods=['GET'])
def getNextPartTimeSchedule():
    username = 'bakwah'
    today = datetime.today()
    daysToNextMonday = 0 - today.weekday()
    if daysToNextMonday <= 0:
        daysToNextMonday += 7
    nextMonday = today + timedelta(days = daysToNextMonday)
    datem = nextMonday.date()
    nextSunday = nextMonday + timedelta(days = 6)
    datemEnd = nextSunday.date()

    schedulequery = f"create table dayShift (day integer, shift integer, duration integer, primary key(day, shift, duration)); insert into dayShift (day, shift, duration) select D.day, D.starthour, D.duration from DailyWorkShift D, WeeklyWorkSchedule W where W.wwsid = D.wwsid and W.username = '{username}' and W.startDate = '{datem}'; select case when day = 0 then 'Monday' when day = 1 then 'Tuesday' when day = 2 then 'Wednesday' when day = 3 then 'Thursday' when day = 4 then 'Friday' when day = 5 then 'Saturday' when day = 6 then 'Sunday' end as day, concat(cast((shift * 100) as varchar), ' to ', cast(((shift + duration) * 100) as varchar)) as shift from dayShift"
    scheduleresult = db.session.execute(schedulequery)
    schedule = [dict(day = row[0], shift = row[1]) for row in scheduleresult.fetchall()]
    
    return render_template('nextparttimeschedule.html', schedule = schedule, datem = datem, datemEnd = datemEnd)

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