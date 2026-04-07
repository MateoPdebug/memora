from sqlalchemy.orm import Session
import models

def get_usuario_by_correo(db: Session, correo: str):
    return db.query(models.Usuario).filter(models.Usuario.correo == correo).first()

def create_usuario(db: Session, id_usuario: str, nombre: str, correo: str, contrasena: str):
    nuevo_usuario = models.Usuario(
        id_usuario=id_usuario,
        nombre=nombre,
        correo=correo,
        contrasena=contrasena
    )

    db.add(nuevo_usuario)
    db.commit()
    db.refresh(nuevo_usuario)
    return nuevo_usuario

def login_usuario(db: Session, correo: str, contrasena: str):
    return db.query(models.Usuario).filter(
        models.Usuario.correo == correo,
        models.Usuario.contrasena == contrasena
    ).first()