from pydantic import BaseModel, EmailStr

class UsuarioCreate(BaseModel):
    id_usuario: str
    nombre: str
    correo: EmailStr
    contrasena: str

class UsuarioResponse(BaseModel):
    id_usuario: str
    nombre: str
    correo: EmailStr

    class Config:
        from_attributes = True

class LoginRequest(BaseModel):
    correo: EmailStr
    contrasena: str