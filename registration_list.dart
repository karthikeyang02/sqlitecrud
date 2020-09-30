import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/Reg.dart';
import 'package:flutter_sqflite/database_helper.dart';
import 'package:flutter_sqflite/reg_detail.dart';
import 'package:sqflite/sqflite.dart';

class RegList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegListState();
  }
}

class RegListState extends State<RegList> {

  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Reg> regList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (regList == null) {
      regList = List<Reg>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: getRegListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Fab clicked');
          navigateToDetails(Reg('', '', 2, '',''), 'Add Detail');
        },
        tooltip: 'Add Detail',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getRegListView() {
    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriortyColor(
                    this.regList[position].priority),
                child: getPriortyAssets(this.regList[position].priority),
              ),
              title: Text(this.regList[position].title, style: titleStyle),
              subtitle: Text(this.regList[position].date),


              trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  _delete(context, regList[position]);
                },
              ),

              onTap: () {
                debugPrint('ListTile Tapped');
                navigateToDetails(this.regList[position], 'Edit Details');
              },

            // padding: const EdgeInsets.all(8),
            // children: <Widget>[
            //   Container(
            //     child: CircleAvatar(
            //     backgroundColor: getPriortyColor(
            //         this.regList[position].priority),
            //      child: getPriortyAssets(this.regList[position].priority),
            //     ),
            //   ),
            //   Container(
            //     child: Text(this.regList[position].title, style: titleStyle),
            //   ),
            //   Container(
            //     child: Text(this.regList[position].date),
            //   ),
            //   Container(
            //     child: Text(this.regList[position].title, style: titleStyle),
            //   ),
            //   GestureDetector(
            //     child: Icon(Icons.delete, color: Colors.grey),
            //     onTap: () {
            //       _delete(context, regList[position]);
            //     },
            //   ),
            // ],
            ),
          );
        }
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Reg>> regListFuture = _databaseHelper.getRegList();
      regListFuture.then((regList) {
        setState(() {
          this.regList = regList;
          this.count =regList.length;
        });
      });
    });
  }

  Future<void> navigateToDetails(Reg reg, String s) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return RegDetail(reg, s);
    }));
    if (result == true){
      updateListView();
    }
  }

  void _delete(BuildContext context, Reg reg) async {
    int result = await _databaseHelper.deleteReg(reg.id);
    if (result != 0) {
      _showSnackBar(context, 'Details Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String s) {

      final snackBar = SnackBar(content: Text(s));
      Scaffold.of(context).showSnackBar(snackBar);
  }



  Image getPriortyAssets(int priority) {
    switch (priority) {
      case 1:
        return Image(image: AssetImage('assets/male.png'));
        break;
      case 2:
        return Image(image: AssetImage('assets/female.png'));
        break;
      default:
        return Image(image: AssetImage('assets/male.png'));
        break;
    }
  }

  Color getPriortyColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.red;
        break;
    }
  }
}
