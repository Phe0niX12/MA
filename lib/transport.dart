import 'package:flutter/material.dart';

class Transport{
  int? id;
  String product;
  String driver_name;
  String end_point;
  String start_point;
  int? estimated_time;
  Transport({
    this.id, 
    required this.product, 
    required this.driver_name,
    required this.end_point,
    required this.start_point,
    this.estimated_time,
  });
  String getProduct(){
    return this.product;
  }
  String getDriverName(){
    return this.driver_name;
  }
  String getEndPoint(){
    return this.end_point;
  }
  String getStartPoint(){
    return this.start_point;
  }
  String getEstimatedTime(){
    return this.estimated_time.toString();
  }
  void setProduct(String product){
    this.product = product;
  }
  void setDriverName(String driver_name){
    this.driver_name = driver_name;
  }
  void setEndPoint(String end_point){
    this.end_point= end_point;
  }
  void setStartPoint(String start_point){
    this.start_point = start_point;
  }
  void setEstimatedTime(int? estimated_time){
    this.estimated_time= estimated_time;
  }
}
class TransportRepository{
  List<Transport> _transports = [];
  int identity = 1;
  TransportRepository();
  int get length => _transports.length;

  Transport operator [](int index){
    if(index >= 0 && index < _transports.length){
      return _transports[index];
    }
    throw RangeError("index $index out of bound");
  }

  void addTransport(Transport transport){
    transport.id = identity++;
    _transports.add(transport);
  }


  void updateTransport(int id, Transport transport){
    Transport updateTransport = _transports.firstWhere((updateTransport) => updateTransport.id == id);
    if(updateTransport.driver_name != transport.driver_name)  transport.setDriverName(updateTransport.driver_name);
    if(updateTransport.product != transport.product)  transport.setProduct(updateTransport.product);
    if(updateTransport.end_point != transport.end_point)  transport.setEndPoint(updateTransport.end_point);
    if(updateTransport.start_point != transport.start_point)  transport.setStartPoint(updateTransport.start_point);
    if(updateTransport.estimated_time != transport.estimated_time)  transport.setEstimatedTime(updateTransport.estimated_time);
  }

  void deleteTransport(int id){
    _transports.removeWhere((transport) => transport.id == id);
  }
  List<Transport> getAllTransports(){
    return List.from(_transports);
  }

}
