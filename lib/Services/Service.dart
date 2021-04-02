import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:obituaries/Models/Obituary.dart';
import '../Models/Account.dart';

class Services
{
  final ERR_RES = 'Invalid response';
  static const String API_ENDPOINT = "https://www.joinobit.com/";

  Future<Account> login(String username, String password) async
  {
    Map data = {
        'session': {
            'login': username,
            'password': password
        }
    };

    var _body = json.encode(data);
    var response;

    try {
      response = await http.post(API_ENDPOINT + 'api/v1/login', headers: {"Content-Type": "application/json"}, body: _body)
                           .timeout(const Duration(seconds: 5));
    }
    on TimeoutException catch(_){
      return new Account(message: "Opps!! Server Timeout");
    }
    on SocketException catch(_){
      return new Account(message: "Error connecting to server");
    }
    on HttpException catch(a){
      return new Account(message: a.message);
    }
    on Exception catch(b){
      return new Account(message: b.toString());
    }
    print(_body);
    print(response.body);
    if(response.statusCode==200){
      if(json.decode(response.body)["success"] == "ok"){
        return new Account.fromJson(json.decode(response.body)["data"]["record"]);
      }else{
        return new Account(message: json.decode(response.body)["message"]);
      }
    }else{
      throw Exception(ERR_RES);
    }
  }

  Future<List<Orituary>> getOrituary(String token) async
  {
    var response;
    try{
      response = await http.get(API_ENDPOINT + 'api/v1/obituaries',
                                headers: {
                                  "Content-Type": "application/json",
                                  "Authorization": "Bearer $token"
                                }).timeout(const Duration(seconds: 5));
    }
    on TimeoutException catch(_){
      throw Exception("Opps!! Server Timeout");
    }
    on SocketException catch(_){
      throw Exception("Error connecting to server");
    }
    on HttpException catch(a){
      throw Exception(a.message);
    }
    on Exception catch(b){
      throw Exception(b.toString());
    }

    if(response.statusCode==200){
      if(json.decode(response.body)["success"] == "ok"){
        Map<String, dynamic> data = json.decode(response.body);

        if(data["success"] == "ok"){
          List<Orituary> list = [];

          if(!data["data"]["records"].isEmpty){
            List<dynamic> person = data["data"]["records"];

            person.forEach((T) {
              List<dynamic> event = T["services"];

              List<Events> events = [];
              event.forEach((E) {
                String _date = E["date"]!=null ? E["date"] : "";
                String _time = E["time"]!=null ? E["time"] : "";
                String _memorialType = E["memorial_type"]!=null ? E["memorial_type"] : "";
                events.add(new Events(id: E["id"], eventType: _memorialType, date: _date , time: _time));
              });

              String fullname = !T["first_name"].toString().isEmpty ? T["first_name"] + " " : "" ;
              fullname += !T["last_name"].toString().isEmpty ? T["last_name"] : "" ;
              list.add(new Orituary(id: T["id"],
                                    fullName: fullname.trim(),
                                    avatarUrl: T["avatar_url"],
                                    bambuserResourceUrl: T["bambuser_resource_uri"],
                                    events: events));
            });
          }
          return list;
        }
        return [];
      }else{
        return [];
      }
    }else{
      throw Exception(ERR_RES);
    }
  }
}