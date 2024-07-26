import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/utils/constants.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final FocusNode _passwordFocus = FocusNode();
  final _passwordController = TextEditingController();
  final FocusNode _passwordConfirmationFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogIn() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  @override
  Widget build(final BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        height: _isLogIn() ? 310 : 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocus),
                onSaved: (final String? email) =>
                    _authData['email'] = email ?? '',
                validator: (final String? emailToValidate) {
                  final String email = emailToValidate ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Please type a valid email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction:
                    _isSignup() ? TextInputAction.next : TextInputAction.go,
                obscureText: true,
                onFieldSubmitted: (_) {
                  if (_isSignup()) {
                    FocusScope.of(context)
                        .requestFocus(_passwordConfirmationFocus);
                  } else {
                    _submitForm();
                  }
                },
                onSaved: (final String? password) =>
                    _authData['password'] = password ?? '',
                validator: (final String? passwordToValidate) {
                  final String password = passwordToValidate ?? '';
                  if (password.isEmpty ||
                      password.length < Constants.minPasswordLength) {
                    return 'Please provide a valid password. It must have at' +
                        ' least ${Constants.minPasswordLength} characters.';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  focusNode: _passwordConfirmationFocus,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.go,
                  obscureText: true,
                  onFieldSubmitted: (_) {
                    _submitForm();
                  },
                  validator: _isLogIn()
                      ? null
                      : (final String? passwordToValidate) {
                          final password = passwordToValidate ?? '';
                          if (password != _passwordController.text) {
                            return 'The passwords provided do not match.';
                          }
                          return null;
                        },
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 30,
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'Sign in' : 'Create account',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogIn() ? 'Sign up' : 'Do you already have an account?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);
    _formKey.currentState?.save();
    final AuthProvider authProvider = Provider.of(
      context,
      listen: false,
    );
    try {
      if (_isLogIn()) {
        await authProvider.logIn(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await authProvider.signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (_) {
      _showErrorDialog('An unexpected error has occurred!');
    }
    setState(() => _isLoading = false);
  }

  void _showErrorDialog(final String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('An error has occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogIn()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordConfirmationFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
  }
}

enum AuthMode {
  signup,
  login,
}
