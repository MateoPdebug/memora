from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from schemas import UsuarioCreate, UsuarioResponse, LoginRequest
import crud 

app = FastAPI()

# Abrir y cerrar conexión a la BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def root():
    return {"message": "API Memora funcionando"}

@app.post("/usuarios", response_model=UsuarioResponse)
def registrar_usuario(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    usuario_existente = crud.get_usuario_by_correo(db, usuario.correo)

    if usuario_existente:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")

    nuevo_usuario = crud.create_usuario(
        db=db,
        id_usuario=usuario.id_usuario,
        nombre=usuario.nombre,
        correo=usuario.correo,
        contrasena=usuario.contrasena
    )

    return nuevo_usuario

@app.post("/login")
def login(usuario: LoginRequest, db: Session = Depends(get_db)):
    print("LOGIN INTENTO:")
    print("Correo recibido:", usuario.correo)
    print("Password recibido:", usuario.contrasena)

    usuario_db = crud.login_usuario(db, usuario.correo, usuario.contrasena)

    if not usuario_db:
        print("❌ LOGIN FALLIDO")
        raise HTTPException(status_code=401, detail="Correo o contraseña incorrectos")

    print("✅ LOGIN OK")

    return {
        "message": "Login exitoso",
        "id_usuario": usuario_db.id_usuario,
        "nombre": usuario_db.nombre,
        "correo": usuario_db.correo
    }