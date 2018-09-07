from flask import render_template, request, redirect
from app import app
from app import viewmodel
import sys

model = viewmodel.ViewModel()

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html', title='Home', devices=model.devices)

@app.route('/route', methods=['POST'])
def route():
    print(str(request.form), file=sys.stdout)
    return redirect('/')

    
