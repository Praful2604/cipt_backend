import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRegister = false;
  final _loginUsername = TextEditingController();
  final _loginPassword = TextEditingController();
  final _regUsername = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  bool _loginLoading = false;
  bool _regLoading = false;

  @override
  void dispose() {
    _loginUsername.dispose();
    _loginPassword.dispose();
    _regUsername.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    super.dispose();
  }

  String? _validateUsername(String? v) {
    if (v == null || v.length < 3) return 'Username must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) return 'Only letters, numbers, underscores';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Please enter email';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) return 'Invalid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 6) return 'At least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'One uppercase';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'One lowercase';
    if (!RegExp(r'\d').hasMatch(v)) return 'One number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) return 'One special char';
    return null;
  }

  Future<void> _login() async {
    if (_loginUsername.text.isEmpty || _loginPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter username and password')));
      return;
    }
    setState(() => _loginLoading = true);
    final ok = await context.read<AuthProvider>().login(_loginUsername.text, _loginPassword.text);
    setState(() => _loginLoading = false);
    if (ok && mounted) context.go('/skills');
    else if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
  }

  Future<void> _register() async {
    _usernameError = _validateUsername(_regUsername.text);
    _emailError = _validateEmail(_regEmail.text);
    _passwordError = _validatePassword(_regPassword.text);
    if (_usernameError != null || _emailError != null || _passwordError != null) {
      setState(() {});
      return;
    }
    setState(() => _regLoading = true);
    final ok = await context.read<AuthProvider>().register(_regUsername.text, _regEmail.text, _regPassword.text);
    setState(() => _regLoading = false);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful')));
      setState(() {
        _isRegister = false;
        _regUsername.clear();
        _regEmail.clear();
        _regPassword.clear();
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }

  void _testLogin() {
    _loginUsername.text = 'testuser';
    _loginPassword.text = 'testpass';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6a11cb), Color(0xFF2575fc)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isRegister ? _buildRegisterPanel() : _buildLoginPanel(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPanel() {
    return Card(
      key: const ValueKey('login'),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome Back', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF5807af))),
            const SizedBox(height: 8),
            Text('Sign in to your account', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 24),
            TextField(
              controller: _loginUsername,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              enabled: !_loginLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _loginPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              enabled: !_loginLoading,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loginLoading ? null : _login,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6a11cb),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_loginLoading ? 'Logging in...' : 'Login'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loginLoading ? null : _testLogin,
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFff7e5f)),
              child: const Text('Use Test Account (testuser/testpass)'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => _isRegister = true),
              child: Text('New here? Create account', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterPanel() {
    return Card(
      key: const ValueKey('register'),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF5807af))),
            const SizedBox(height: 8),
            Text('Join us — it\'s quick!', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 24),
            TextField(
              controller: _regUsername,
              decoration: InputDecoration(
                labelText: 'Username',
                border: const OutlineInputBorder(),
                errorText: _usernameError,
              ),
              onChanged: (_) => setState(() => _usernameError = _validateUsername(_regUsername.text)),
              enabled: !_regLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _regEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: _emailError,
              ),
              onChanged: (_) => setState(() => _emailError = _validateEmail(_regEmail.text)),
              enabled: !_regLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _regPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                errorText: _passwordError,
              ),
              onChanged: (_) => setState(() => _passwordError = _validatePassword(_regPassword.text)),
              enabled: !_regLoading,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _regLoading ? null : _register,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6a11cb), padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(_regLoading ? 'Registering...' : 'Register'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() {
                _isRegister = false;
                _usernameError = _emailError = _passwordError = null;
              }),
              child: Text('Already have an account? Sign in', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
