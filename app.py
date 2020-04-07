import settings
import os
from flask import Flask, render_template, request, session, flash, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.schema import MetaData
from flask_login import LoginManager
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
login_manager = LoginManager()

@app.route('/', methods=['GET'])
def index():
    print("Root page accessed")
    return render_template('login.html')

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
    insert_users = f"insert into Users(username, name, password, dateCreated) values ('{username}','{name}','{password}', '{date}');"
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
    
"""
Running application
"""
#Check if server can be run, must be placed at the back of this file
if __name__ == '__main__':
    app.run()



