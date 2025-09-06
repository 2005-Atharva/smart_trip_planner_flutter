import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<LoginWithMailButtonPressed>((event, emit) async {
      emit(AuthLoading());

      try {
        if (event.email.isEmpty || event.password.isEmpty) {
          emit(AuthErrorState(err: "Email and password cannot be empty"));
          return;
        }

        final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
        if (!emailRegex.hasMatch(event.email)) {
          emit(AuthErrorState(err: "Please enter a valid email address"));
          return;
        }

        if (event.password.length < 6) {
          emit(AuthErrorState(err: "Password must be at least 6 characters"));
          return;
        }

        final userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccessState(user: userCredential.user!));
      } on FirebaseException catch (e) {
        String errorMsg;
        switch (e.code) {
          case "user-not-found":
            errorMsg = "No account found with this email.";
            break;
          case "wrong-password":
            errorMsg = "Incorrect password.";
            break;
          case "invalid-email":
            errorMsg = "Invalid email format.";
            break;
          case "user-disabled":
            errorMsg = "This account has been disabled.";
            break;
          default:
            errorMsg = e.message ?? "Login failed. Please try again.";
        }
        emit(AuthErrorState(err: errorMsg));
      } catch (e) {
        emit(AuthErrorState(err: "Something went wrong: ${e.toString()}"));
      }
    });

    on<CreateWithMailButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        if (event.email.isEmpty ||
            event.password.isEmpty ||
            event.password2.isEmpty) {
          emit(AuthErrorState(err: "All fields are required"));
          return;
        }

        if (event.password != event.password2) {
          emit(AuthErrorState(err: "Passwords do not match"));
          return;
        }

        if (event.password.length < 6) {
          emit(AuthErrorState(err: "Password must be at least 6 characters"));
          return;
        }

        final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
        if (!emailRegex.hasMatch(event.email)) {
          emit(AuthErrorState(err: "Please enter a valid email address"));
          return;
        }

        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccessState(user: userCredential.user!));
      } on FirebaseAuthException catch (e) {
        emit(AuthErrorState(err: _mapFirebaseError(e)));
      } catch (e) {
        emit(AuthErrorState(err: "Something went wrong: ${e.toString()}"));
      }
    });
  }
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        return "This email is already registered.";
      case "invalid-email":
        return "Invalid email format.";
      case "weak-password":
        return "Password is too weak.";
      default:
        return e.message ?? "Authentication failed.";
    }
  }
}
