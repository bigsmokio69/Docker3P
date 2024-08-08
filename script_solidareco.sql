use db;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(300) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `contrasena` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla tipo usuario
CREATE TABLE `tipo_usuario` (
  `id_tipo_usuario` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabla patrocinador
CREATE TABLE `patrocinador` (
  `id_patrocinador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id_patrocinador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla fundacion
CREATE TABLE `fundacion` (
  `id_funcion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_funcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabla bitacora
CREATE TABLE `bitacora` (
  `id_bitacora` int NOT NULL AUTO_INCREMENT,
  `operacion` varchar(100) DEFAULT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id_bitacora`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla administradores
CREATE TABLE `administradores` (
  `id_administrador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  `contrasena` varchar(40) DEFAULT NULL,
  `id_usuario_adm` int NOT NULL,
  PRIMARY KEY (`id_administrador`),
  KEY `id_usuario_idx` (`id_usuario_adm`),
  CONSTRAINT `id_usuario_adm` FOREIGN KEY (`id_usuario_adm`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla comentario
CREATE TABLE `comentario` (
  `id_comentario` int NOT NULL,
  `id_usuario` int DEFAULT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_comentario`),
  KEY `id_usuario_idx` (`id_usuario`),
  CONSTRAINT `id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla evento
CREATE TABLE `evento` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  `id_fundacion` int NOT NULL,
  `estado` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `id_fundacion_idx` (`id_fundacion`),
  CONSTRAINT `id_fundacion` FOREIGN KEY (`id_fundacion`) REFERENCES `fundacion` (`id_funcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla persona
CREATE TABLE `persona` (
  `id_persona` int NOT NULL AUTO_INCREMENT,
  `id_usuarios` int DEFAULT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_persona`),
  KEY `id_usuario_idx` (`id_usuarios`),
  CONSTRAINT `id_usuarios` FOREIGN KEY (`id_usuarios`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla publicacion
CREATE TABLE `publicacion` (
  `id_publicacion` int NOT NULL AUTO_INCREMENT,
  `id_fundacion` int NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `id_comentario` int DEFAULT NULL,
  PRIMARY KEY (`id_publicacion`),
  KEY `id_funcion_idx` (`id_fundacion`),
  KEY `id_comentario_idx` (`id_comentario`),
  CONSTRAINT `id_comentario` FOREIGN KEY (`id_comentario`) REFERENCES `comentario` (`id_comentario`),
  CONSTRAINT `id_funcion` FOREIGN KEY (`id_fundacion`) REFERENCES `fundacion` (`id_funcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INSERTS EN TIPO DE USUARIO
INSERT INTO `tipo_usuario` VALUES (1,'administrador'),(2,'fundacion'),(3,'persona'),(4,'sponsor');
-- INSERT EN USUARIOS
INSERT INTO `usuario` VALUES (1,'alonso','chavez@gmail.com','pbkdf2:sha256:600000$ZVRfRvROf2Wse875$0ff3029d3546aad8ee0cbff3e74e9a8fba4fbd5a68bfc2db67dce3d323fc3f68'),(2,'AlonsoDC','correo@gmail.com','12345'),(3,'Fernanda','fer@gmail.com','pbkdf2:sha256:600000$0ScIWzyd4bN0G3PE$56d4c566980af0ad65795ff1d45c2aa30a64238563f8ae6f69479c883839f6da'),(4,'Mariano','mariano@gmail.com','pbkdf2:sha256:600000$5YTls4LPuDAyMIqF$b6e7cbd338158f77f855d8545220e78aa59dec37eec8c7a5bd9c9e302680629b');
