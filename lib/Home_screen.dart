import 'package:crud/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _allData = [];

  bool _isloading = true;

  void _refreshdata() async{
    final data = await SQLHELPER.getAllData();
    setState(() {
      _allData = data;
      _isloading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshdata();
    

  }

  

//add data
  Future<void> _addData() async{
    await SQLHELPER.createdData(_titleController.text, _descController.text);
    _refreshdata();
  }

//Update Data
  Future<void> _updateData(int id) async{
    await SQLHELPER.updateData(id, _titleController.text, _descController.text);
    _refreshdata();
  }

//Delete data
  void _deleteData(int id) async{
    await SQLHELPER.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data terpilih"),
      ));
      _refreshdata();
    
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


void showBottomSheet(int? id) async{
  if(id != null){
    final exisdata = _allData.firstWhere((element) => element['id']==id);
    _titleController.text = exisdata['title'];
    _descController.text = exisdata['desc'];
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      ),
      //input data fitur
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Description",
            ),
          ),
          SizedBox(height: 20),

          Center(
            child: ElevatedButton(
            onPressed: () async{
              if (id == null){
                await _addData();
              }

              if (id != null){
                await _updateData(id);
              }

              _titleController.text = "";
              _descController.text = "";

              Navigator.of(context).pop();
              print("data tertambahkan");
            },
            //padding child
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                id == null ? "Tambahkan data" : "Update",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
                ),
               ),
            ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "CRUD SIALAN",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isloading 
      ? Center(
          child: CircularProgressIndicator(),
          )
          : ListView.builder(
            itemCount: _allData.length,
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.all(15),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    _allData[index]['title'],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                subtitle: Text(_allData[index]['desc']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: (){
                        showBottomSheet(_allData[index]['id']);
                      }, 
                      icon: Icon(
                        Icons.edit, 
                        color: Colors.indigo,
                      ),
                      ),
                      IconButton(
                      onPressed: (){
                        _deleteData(_allData[index]['id']);
                      }, 
                      icon: Icon(
                        Icons.delete, 
                        color: Colors.redAccent,
                      ),
                      ),

                      
                  ],
                ),
              )
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showBottomSheet(null),
            child: Icon(Icons.add),
          ),
    );
  }
}