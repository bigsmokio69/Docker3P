#Encender el SO con python
FROM python:3.12.3-slim
#Crear una carpeta
WORKDIR /app
#crear el codigo, copiar
COPY . /app
#instalar el venv (dependencias)
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
#correr el codigo python2 app.py
CMD [ "python", "formulario.py" ]