import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lojaonlinegerencia/blocs/login_bloc.dart';
import 'package:lojaonlinegerencia/pages/home_screen.dart';
import 'package:lojaonlinegerencia/widgets/custom_input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Erro'),
                    content: Text("Você não possui os privelegios necessarios"),
                  ));
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: StreamBuilder<LoginState>(
              stream: _loginBloc.outState,
              initialData: LoginState.LOADING,
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case LoginState.LOADING:
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                    ));
                  case LoginState.FAIL:
                  case LoginState.SUCCESS:
                  case LoginState.IDLE:
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(),
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Icon(
                                  Icons.store_mall_directory,
                                  color: Colors.pinkAccent,
                                  size: 160,
                                ),
                                CustomInputField(
                                  icon: Icons.person_outline,
                                  hint: 'Usuario',
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                SizedBox(height: 10),
                                CustomInputField(
                                  icon: Icons.lock_outline,
                                  hint: 'Senha',
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                SizedBox(height: 20),
                                StreamBuilder<bool>(
                                    stream: _loginBloc.outSubmitedValid,
                                    builder: (context, snapshot) {
                                      return RaisedButton(
                                        color: Colors.pinkAccent,
                                        child: Text(
                                          'Entrar',
                                          style: GoogleFonts.orbitron(),
                                        ),
                                        textColor: Colors.white,
                                        onPressed: snapshot.hasData
                                            ? _loginBloc.submit
                                            : null,
                                        disabledColor:
                                            Colors.pinkAccent.withAlpha(140),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                }
              }),
        ));
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
