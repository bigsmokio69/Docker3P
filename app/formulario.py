from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Cambia esto por una clave secreta segura

# Conectar a la base de datos MySQL
def get_db_connection():
    conn = mysql.connector.connect(
        host='mysql',
        user='root', 
        password='root',
        database='db'
    )
    return conn

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    correo = request.form['correo']
    contrasena = request.form['contrasena']
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM usuario WHERE correo = %s', (correo,))
    usuario = cursor.fetchone()
    conn.close()
    
    if usuario is None or not check_password_hash(usuario['contrasena'], contrasena):
        flash('Correo electrónico o contraseña incorrectos')
        return redirect(url_for('home'))
    
    # Guardar solo el nombre en la sesión
    session['user_name'] = usuario['nombre']
    flash('Inicio de sesión exitoso')
    return redirect(url_for('Index'))

@app.route('/index')
def Index():
    return render_template("index.html")

@app.route('/register', methods=['POST'])
def register():
    nombre = request.form['nombre']
    correo = request.form['correo']
    contrasena = request.form['contrasena']
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM usuario WHERE correo = %s', (correo,))
    usuario = cursor.fetchone()
    
    if usuario:
        flash('El correo electrónico ya está registrado')
        return redirect(url_for('home'))
    
    contrasena_hash = generate_password_hash(contrasena, method='pbkdf2:sha256')
    cursor.execute('INSERT INTO usuario (nombre, correo, contrasena) VALUES (%s, %s, %s)',
                   (nombre, correo, contrasena_hash))
    conn.commit()
    conn.close()
    flash('Registrado con éxito! Inicia sesión')
    return redirect(url_for('home'))

@app.route('/dashboard')
def dashboard():
    if 'user_name' not in session:
        return redirect(url_for('home'))
    return render_template('dashboard.html', user_name=session['user_name'])

@app.route('/logout')
def logout():
    session.pop('user_name', None)
    flash('Sesión cerrada correctamente')
    return redirect(url_for('home'))

@app.route('/contactanos')
def Contactanos():
    return render_template('contactanos.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port='5000', debug=True)
