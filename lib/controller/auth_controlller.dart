import 'package:flutter/material.dart';

class AuthControlller {
  final _formKey = GlobalKey<FormState>(); // Key to identify the form
  // TextEditingControllers to manage the input of each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  // Getters to access the controllers
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get bankController => _bankController;
  TextEditingController get accountController => _accountController;

  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bankController.dispose();
    _accountController.dispose();
  }
}
