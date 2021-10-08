import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token; // Expires after sometime
  DateTime? _expiryDate;
  String? _userId;
  Timer? authtime;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
  }

  String? get userID {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyDd2HEQotiyGOb21M_Nl8GK3Ous6kXVT1g");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      
      final userData = json.encode(
        {
          "token": _token,
          'userId': _userId,
          "expiryDate": _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }
  // Future<bool> tryAutoLogin() async{

  // }
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (authtime != null) {
      authtime!.cancel();
      authtime = null;
    }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (authtime != null) {
      // print("Auto logout first if");
      authtime!.cancel();
    }
    var timetoexpiry = 0;
    if (_expiryDate != null) {
      // print("Auto logout second if");
      timetoexpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    }

    authtime = Timer(Duration(seconds: timetoexpiry), () {
      // print("Iwas here");
      logout();
    });
  }
  
  Future<bool> tryAutoLogin() async {
    print("TryAuto");
  
    final prefs=await SharedPreferences.getInstance();

    if(!prefs.containsKey("userData")){
      // print("first if");
      return false;
    }
    print("before extrateduserdata");
    
    final extractedUserData=json.decode(prefs.getString("userData").toString()) ;
    
    
  
    

    final expiryDates=DateTime.parse(extractedUserData["expiryDate"].toString());
    print(extractedUserData);

    if(expiryDates.isBefore(DateTime.now())){
      print("Is Before");
      return false;
    }
    _token=extractedUserData['token'].toString();
    _userId=extractedUserData['userId'].toString();
    print(_userId);
    print(token);
    _expiryDate=expiryDates;
    notifyListeners();
    _autoLogout();
    return true;
    

  }
}
