import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_helper.dart';
import 'package:flutter_application_1/transport.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  List<Transport> _allTransport = [];
  TransportRepository _transportRepository = TransportRepository();
  void _refreshData() async{
    final data = await SQLHelper.getAllData();
    setState(() {
      _allTransport = _transportRepository.getAllTransports();
      _allData =  data;
      _isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
  }



  Future<void> _addData() async{
    _transportRepository.addTransport(
      Transport(product: _productController.text, 
      driver_name: _driverNameConctroller.text, 
      end_point: _endPointController.text, 
      start_point: _startPointController.text, 
      estimated_time: int.parse(_estimatedTimeController.text))
      );
    await SQLHelper.createData(
      _driverNameConctroller.text,
      _startPointController.text, 
      _endPointController.text, 
      int.parse(_estimatedTimeController.text), 
      _productController.text);
      _refreshData();
  }

  Future<void> _updateData(int id) async {
    _transportRepository.updateTransport(
      id,
      Transport(
        product: _productController.text, 
        driver_name: _driverNameConctroller.text, 
        end_point: _endPointController.text, 
        start_point: _startPointController.text, 
        estimated_time: int.parse(_estimatedTimeController.text))
    );
    await SQLHelper.updateData(
      id, 
      _driverNameConctroller.text,
      _startPointController.text, 
      _endPointController.text, 
      int.parse(_estimatedTimeController.text), 
      _productController.text);
      _refreshData();
  }

  void _deleteData(int id) async{
    _transportRepository.deleteTransport(id);
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Transport Deleted")));
    _refreshData();
  }
  
  final TextEditingController _driverNameConctroller = TextEditingController();
  final TextEditingController _startPointController = TextEditingController();
  final TextEditingController _endPointController = TextEditingController();
  final TextEditingController _estimatedTimeController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showBottomSheet( int? id) async{
    if(id != null){
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _driverNameConctroller.text = existingData['driver_name'];
      _startPointController.text = existingData['start_point'];
      _endPointController.text = existingData['end_point'];
      _estimatedTimeController.text = existingData['estimated_time'].toString();
      _productController.text = existingData['product'];

    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context, 
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50

        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Product",
                ),
                validator: (value){
                  if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)){
                      return "Enter correct product name";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _driverNameConctroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Driver Name",
                ),
                validator: (value){
                  if(value!.isEmpty || !RegExp(r'^[A-Z][a-z]*$').hasMatch(value)){
                      return "Enter correct driver name";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _startPointController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Start Point",
                ),
                validator: (value){
                  if(value!.isEmpty || !RegExp(r'^[a-z A-Z0-9]+$').hasMatch(value)){
                      return "Enter correct start point";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _endPointController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "End Point",
                ),
                validator: (value){
                  if(value!.isEmpty || !RegExp(r'^[a-z A-Z0-9]+$').hasMatch(value)){
                      return "Enter correct end point";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _estimatedTimeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Estimated Time",
                ),
                validator: (value){
                  if(value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)){
                      return "Enter correct estimated time in in minutes";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10,),

              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    if(formKey.currentState!.validate()){
                      if(id == null){
                        await _addData();
                      }else{
                        await _updateData(id);
                      }
                      
                      _productController.text = "";
                      _driverNameConctroller.text = "";
                      _startPointController.text = "";
                      _endPointController.text = "";
                      _estimatedTimeController.text = "0";
                      Navigator.of(context).pop();
                      print("Data Added");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(id == null ? "Add Transport" : "Update",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    
                  ),
                ),
              )
            ],
          ),
        )
      )
      );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title:const  Text("Transport Management"),
      ),
      body: _isLoading ? 
        const Center(
          child: CircularProgressIndicator(),
          ): 
        
        ListView.builder(
          itemCount: _allData.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  _allData[index]['product'],
                  style: const TextStyle(
                    fontSize: 20,
                  ) ,
                ),
              ),
              subtitle: Text(_allData[index]['driver_name'] +
               "\n" + _allData[index]['start_point'] +
               "\n" + _allData[index]['end_point'] +
               "\n" + _allData[index]['estimated_time'].toString() ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed:() {
                      showBottomSheet(_allData[index]['id']);
                    }, 
                    icon: Icon(
                      Icons.edit,
                      color: Colors.indigo,
                    )
                  ),
                  IconButton(
                    onPressed:() {
                      _deleteData(_allData[index]['id']);
                    }, 
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    )
                  )
                ]
              ),
            ),
          )
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: () => showBottomSheet(null),
          child: Icon(Icons.add),
        ),
    );
  }
}