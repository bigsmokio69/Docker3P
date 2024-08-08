from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'your_secret_key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/solidareco'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Modelos de la base de datos
class Administrador(db.Model):
    __tablename__ = 'administradores'
    id_administrador = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(150), nullable=False, unique=True)
    contrasena = db.Column(db.String(150), nullable=False)

class Usuario(db.Model):
    __tablename__ = 'usuario'
    id_usuario = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(300), nullable=False)
    correo = db.Column(db.String(150), nullable=False, unique=True)
    contrasena = db.Column(db.String(512), nullable=False)

class Patrocinador(db.Model):
    __tablename__ = 'patrocinador'
    id_patrocinador = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.String(200), nullable=True)


class Evento(db.Model):
    __tablename__ = 'evento'
    id_evento = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(200), nullable=False)
    id_fundacion = db.Column(db.Integer, db.ForeignKey('fundacion.id_fundacion'), nullable=False)
    estado = db.Column(db.String(100), nullable=False)

class Publicacion(db.Model):
    __tablename__ = 'publicacion'
    id_publicacion = db.Column(db.Integer, primary_key=True)
    id_fundacion = db.Column(db.Integer, db.ForeignKey('fundacion.id_fundacion'), nullable=False)
    descripcion = db.Column(db.String(500), nullable=False)
    id_comentario = db.Column(db.Integer, nullable=True)

# Crear las tablas dentro del contexto de la aplicación
with app.app_context():
    db.create_all()

@app.route('/')
def home():
    return render_template('loginadmin.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    admin = Administrador.query.filter_by(nombre=username).first()

    if admin and admin.contrasena == password:
        session['user_id'] = admin.id_administrador
        return redirect(url_for('tablas'))
    else:
        flash('Nombre de usuario o contraseña incorrectos')
        return redirect(url_for('home'))

@app.route('/tablas')
def tablas():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    patrocinadores = Patrocinador.query.all()
    usuarios = Usuario.query.all()
    eventos = Evento.query.all()
    publicaciones = Publicacion.query.all()

    return render_template('tablas.html', 
                           patrocinadores=patrocinadores,
                           usuarios=usuarios,
                           eventos=eventos,
                           publicaciones=publicaciones)

@app.route('/editar_usuario/<int:id_usuario>', methods=['POST'])
def editar_usuario(id_usuario):
    usuario = Usuario.query.get(id_usuario)
    if usuario:
        usuario.nombre = request.form['nombre']
        usuario.correo = request.form['correo']
        if request.form['contrasena']:
            usuario.contrasena = request.form['contrasena']
        db.session.commit()
        flash('Usuario actualizado correctamente')
    else:
        flash('Usuario no encontrado')
    return redirect(url_for('tablas'))

# Añade aquí rutas adicionales para editar otros modelos

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
