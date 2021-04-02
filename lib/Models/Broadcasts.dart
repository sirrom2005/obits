/*
* @Author Rohan Morris
* @Date 07/04/2020
* */


class BroadCastsList {
  final List<Broadcasts> results;

  BroadCastsList({
    this.results,
  });

  factory BroadCastsList.fromJson(List<dynamic> parsedJson) {

    List<Broadcasts> items = new List<Broadcasts>();
    items = parsedJson.map((i)=>Broadcasts.fromJson(i)).toList();

    return new BroadCastsList(
        results: items
    );
  }
}

class Broadcasts{
  final String id;
  final String clientVersion;
  final String resourceUri;
  final String created;


  Broadcasts({this.id,this.clientVersion, this.resourceUri, this.created});

  toSting(){ return "\n$id\n$clientVersion\n$resourceUri\n$created\n";}

  factory Broadcasts.fromJson(Map<String, dynamic> json){
    return new Broadcasts(
        id: json['id'],
        clientVersion: json['clientVersion'],
        resourceUri: json['resourceUri'],
        created: json['created'].toString()
    );
  }
}