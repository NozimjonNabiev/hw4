import 'package:flutter/material.dart';
import 'package:hw4/models/users.dart';
import 'package:hw4/database/db_helper.dart';
import '../../login/login_screen.dart';
import '../validations/form_validator.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  late String _password = '';

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              hintText: "First Name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              ),
            ),
            validator: FormValidators.validateFirstName,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              hintText: "Last Name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              ),
            ),
            validator: FormValidators.validateLastName,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.done,
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
            controller: TextEditingController(
              text: selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : '',
            ),
            decoration: InputDecoration(
              hintText: "Date of Birth",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_today),
              ),
            ),
            validator: FormValidators.validateDateOfBirth,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              hintText: "Your Email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.email),
              ),
              errorMaxLines: 2,
            ),
            validator: FormValidators.validateEmail,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Your Password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.lock),
              ),
              errorMaxLines: 2,
            ),
            validator: FormValidators.validatePassword,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
              if (value != _password) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? firstName = _firstNameController.text;
                String? lastName = _lastNameController.text;
                String? dob = selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : '';
                String? email = _emailController.text;
                String? password = _passwordController.text;

                if (firstName != null &&
                    lastName != null &&
                    dob != null &&
                    email != null &&
                    password != null &&
                    firstName.isNotEmpty &&
                    lastName.isNotEmpty &&
                    dob.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty) {
                  User newUser = User(
                    firstName: firstName,
                    lastName: lastName,
                    dob: dob,
                    email: email,
                    password: password,
                  );

                  int result = await DBHelper.insertUser(newUser);

                  if (result == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to register user.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
        ],
      ),
    );
  }
}
