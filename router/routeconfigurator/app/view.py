from flask import render_template, request, redirect
from app import app
from app import viewmodel
from app import routingmodel
import sys

# this is not ideal at least for testing as it will run with package __init__ and become a singleton
view_model = viewmodel.ViewModel()

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html', title='Home', devices=view_model.devices)

@app.route('/route', methods=['POST'])
def route():
    ip = request.form['ip']
    route_to = request.form['route_to']
    view_model.set_route(ip, route_to)
    return redirect('/')

    
