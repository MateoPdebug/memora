from sqlalchemy import Column, String
from database import Base

class Usuario(Base):
    __tablename__ = "usuarios"

    id_usuario = Column(String(30), primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    correo = Column(String(200), unique=True, nullable=False)
    contrasena = Column(String(200), nullable=False)