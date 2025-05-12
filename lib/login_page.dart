import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Libera o login com qualquer valor digitado
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _register() {
    // Ação para registro (por enquanto apenas exibe um diálogo)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registro'),
        content: const Text('Funcionalidade de registro será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _googleLogin() {
    // Ação para login com Google (por enquanto apenas exibe um diálogo)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Google'),
        content: const Text('Funcionalidade de login com o Google será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _forgotPassword() {
    // Ação para esqueci minha senha (por enquanto apenas exibe um diálogo)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperação de Senha'),
        content: const Text('Funcionalidade de recuperação de senha será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem escura
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/worship_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Bem-vindo de volta!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Faça login para continuar',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'E-mail',
                      icon: Icons.email_outlined,
                      obscure: false,
                    ),
                    const SizedBox(height: 18),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Senha',
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 12),
                    
                    // Esqueci minha senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botão de login
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.15),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Separador
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 1,
                            color: Colors.white30,
                          ),
                        ),
                        const Text(
                          'ou',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 1,
                            color: Colors.white30,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Botão de login com Google
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: _googleLogin,
                          borderRadius: BorderRadius.circular(14),
                          hoverColor: Colors.grey.shade100,
                          splashColor: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 16, 12),
                            child: Stack(
                              children: [
                                // Posiciona o ícone à esquerda
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.string(
                                        _googleIconSvg,
                                        placeholderBuilder: (context) => const Icon(
                                          Icons.g_mobiledata,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Texto centralizado (ignorando o espaço do ícone)
                                Center(
                                  child: Text(
                                    'Continuar com Google',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Link para registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ainda não tem uma conta?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: _register,
                          child: const Text(
                            'Registre-se',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white54,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static const String _googleIconSvg = '''
<svg width="18" height="18" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><path d="M17.6 9.2l-.1-1.8H9v3.4h4.8C13.6 12 13 13 12 13.6v2.2h3a8.8 8.8 0 0 0 2.6-6.6z" fill="#4285F4" fill-rule="nonzero"/><path d="M9 18c2.4 0 4.5-.8 6-2.2l-3-2.2a5.4 5.4 0 0 1-8-2.9H1V13a9 9 0 0 0 8 5z" fill="#34A853" fill-rule="nonzero"/><path d="M4 10.7a5.4 5.4 0 0 1 0-3.4V5H1a9 9 0 0 0 0 8l3-2.3z" fill="#FBBC05" fill-rule="nonzero"/><path d="M9 3.6c1.3 0 2.5.4 3.4 1.3L15 2.3A9 9 0 0 0 1 5l3 2.4a5.4 5.4 0 0 1 5-3.7z" fill="#EA4335" fill-rule="nonzero"/><path d="M0 0h18v18H0z"/></g></svg>
''';
} 