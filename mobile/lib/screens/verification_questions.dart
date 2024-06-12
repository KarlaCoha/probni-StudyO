import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studyo/main.dart';
import '../styles/themes.dart';
import 'package:studyo/services/user_service.dart';
import '../providers/user_provider.dart';
import '../entities/user.dart';
import 'privacy_policy_page.dart';
import '../main.dart';
import '../services/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// A StatefulWidget representing the game statistics screen.
///
/// This screen allows users to input their gender, grade, and date of birth to complete their profile setup.
class GameStats extends StatefulWidget {
  const GameStats({Key? key}) : super(key: key);

  @override
  _GameStatsState createState() => _GameStatsState();
}

/// The State class for the GameStats widget.
///
/// This class manages the state of the GameStats widget, including user data retrieval and updating.
class _GameStatsState extends State<GameStats> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  int? _selectedGrade;
  DateTime? _selectedDate; // Promijenjeno u nullable
  final TextEditingController _dateController = TextEditingController();

  late UserProvider _userProvider;
  MyUser? _user;
  final AuthService _authService =
      AuthService(); // Dodajte instancu AuthService

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _getUserData();
  }

  /// Fetches user data from the server.

  Future<void> _getUserData() async {
    final userService = UserService();
    final userId = _userProvider.userId;

    if (userId != null) {
      final userData = await userService.getUserData(userId);
      setState(() {
        _user = MyUser.fromJson(userData);
        _selectedGender = _user?.gender;
        _selectedGrade = _user?.grade;
        if (_user?.birthDate != null) {
          // Provjera postoji li datum rođenja
          _selectedDate = DateFormat('yyyy-MM-dd').parse(_user!.birthDate!);
          _dateController.text =
              DateFormat('dd.MM.yyyy').format(_selectedDate!);
        }
      });
    } else {
      print('User ID is null');
    }
  }

  /// Updates user data on the server.

  Future<void> _updateUser(BuildContext context) async {
    if (_user == null) {
      print('Korisnik nije inicijaliziran.');
      return;
    }

    print('Pokušaj ažuriranja korisnika. ID korisnika: ${_user!.id}');
    print('Odabrani spol za ažuriranje: $_selectedGender');
    print('Odabrani razred za ažuriranje: $_selectedGrade');
    if (_selectedDate != null) {
      print(
          'Odabrani datum rođenja za ažuriranje: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}');
    } else {
      _selectedDate = DateTime(2020, 1, 1);
    }

    final userService = UserService();

    try {
      await userService.updateUser(
        _user!.id!,
        _selectedGender ?? _user!.gender ?? '',
        _selectedGrade ?? _user!.grade ?? 0,
        DateFormat('dd.MM.yyyy').format(_selectedDate!),
      );

      print('Ažuriranje korisnika uspješno.');

      await _getUserData();

      if (_user != null) {
        print('Ažurirani korisnik:');
        print('ID: ${_user!.id}');
        print('Spol: ${_user!.gender}');
        print('Razred: ${_user!.grade}');
        print('Datum rođenja: ${_user!.birthDate}');
      }

      setState(() {});
    } catch (e) {
      print(
          'Došlo je do pogreške prilikom ažuriranja korisnika. ID korisnika: ${_user!.id}. Pogreška: $e');
    }

    print('Ažuriranje korisnika uspješno.');
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print('Dobiveni FCM token: $token');
      await userService.updateUserToken(_user!.id!, token);
      print('Dobiveni FCM token: $token');
    } else {
      print('Nije moguće dobiti FCM token');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).brightness == Brightness.dark
        ? darkTheme
        : lightTheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BackgroundPainter(theme: theme),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 61, 34, 2).withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Image.asset(
                            'images/logo.png',
                            height: 100,
                            width: 150,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Završi registraciju dodavanjem spola, razreda i datuma rođenja kako bi tvoj profil bio spreman za korištenje.',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.hintColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Spol',
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.hintColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.hintColor, width: 2.0),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        iconEnabledColor: theme.hintColor,
                        items: <String>['Muško', 'Žensko'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style:
                                    TextStyle(color: theme.primaryColorLight)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGender = newValue;
                            print('Odabrani spol: $_selectedGender');
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: _selectedGrade,
                        decoration: InputDecoration(
                          labelText: 'Razred',
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: theme.hintColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.hintColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.hintColor, width: 2.0),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        iconEnabledColor: theme.hintColor,
                        items: List.generate(8, (index) => index + 1)
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString(),
                                style:
                                    TextStyle(color: theme.primaryColorLight)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGrade = newValue;
                            print('Odabrani razred: $_selectedGrade');
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        cursorColor: Colors.orange,
                        decoration: InputDecoration(
                          labelText: 'Datum rođenja',
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: theme.hintColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.hintColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.hintColor, width: 2.0),
                          ),
                          suffixIcon: Icon(Icons.calendar_today,
                              color: theme.hintColor),
                        ),
                        style: TextStyle(color: theme.primaryColorLight),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.orange,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: theme.hintColor,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                              _dateController.text =
                                  DateFormat('dd.MM.yyyy').format(picked);
                              print('Odabrani datum: ${_dateController.text}');
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyPage()),
                          );
                        },
                        child: Text(
                          'Kako koristimo tvoje podatke?',
                          style: TextStyle(
                            color: theme.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              theme.primaryColor),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Ažuriramo podatke korisnika s onim što je unio na stranici GameStats
                            await _updateUser(context);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()));
                            // Isprintajmo ažurirane podatke korisnika radi provjere
                            if (_user != null) {
                              print('Ažurirani korisnik:');
                              print('Spol: ${_user!.id}');
                              print('Spol: ${_user!.gender}');
                              print('Razred: ${_user!.grade}');
                              print('Datum rođenja: ${_user!.birthDate}');
                            }
                          }
                        },
                        child: const Text(
                          'Spremi podatke',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
