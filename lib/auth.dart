import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoading();

      try {
        final response = await http.post(
          Uri.parse('https://dummyjson.com/auth/login'),
          body: {
            'username': event.username,
            'password': event.password,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];

          yield AuthSuccess(token: token);
        } else {
          throw Exception('Failed to login');
        }
      } catch (e) {
        yield AuthFailure(error: e.toString());
      }
    }
  }
}

class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess({required this.token});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}
