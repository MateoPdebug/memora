import 'package:flutter/material.dart';
import 'package:memora/pantallas/crearcuenta.dart';
import 'package:memora/services/api_services.dart';
import 'home_screen.dart';
// Pantalla Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 0),

                  // Logo memora
                  Center(
                    child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Image.asset(
                      'assets/images/logo_memora.png',
                      width: 230,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Bienvenido a Memora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),
                Form(
                  key: _formKey, 
                  child: Column(
                    children: [

                  // Correo
                  TextFormField(
                    controller: correoController,
                    keyboardType: TextInputType.emailAddress,
                    //validacion
                      validator:(valor){
                        if(valor==null|| valor.isEmpty){
                          return 'El correo es obligatorio';
                        }
                        if(!valor.contains('@')){
                          return 'Ingresa un correo valido';
                        }
                        return null;
                      },
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.deepPurpleAccent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Contraseña
                  TextFormField(
                    controller: contrasenaController,
                    obscureText: true,
                    validator: (valor){
                      if(valor==null||valor.isEmpty){
                        return 'la contraseña es obligatoria';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white

                    ),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.deepPurpleAccent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: (){},
                      child: const Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize:17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botón principal
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        
                      }
                      bool ok = await ApiService.loginUsuario(
                          correo: correoController.text.trim(),
                          contrasena: contrasenaController.text.trim(),
                      );
                      if (ok){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context)=> const HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Correo o contraseña incorrecto"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),

                    ),
                  ),

                  //Boton Crear Cuenta
                  const SizedBox(height: 14),

                  Center(
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const CrearCuentaScreen(),
                        ),
                        );
                      },
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
           ]),
        ),
      ),
    ) )  );
    
  }
}
