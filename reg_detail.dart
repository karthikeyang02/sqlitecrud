import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_sqflite/Reg.dart';
import 'package:flutter_sqflite/database_helper.dart';
import 'package:intl/intl.dart';


class RegDetail extends StatefulWidget {

  final String appBarTitle;
  final Reg reg;

  RegDetail(this.reg, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return RegDetailState(this.reg, this.appBarTitle);
  }
}

class RegDetailState extends State<RegDetail> {

  static var _priorities = ['Male', 'Female'];

  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Reg reg;

  bool _isChecked = 0;

  int _selected = 0;


  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Pattern _emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegDetailState(this.reg, this.appBarTitle);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _onChanged(int value) {
    setState(() {
      _selected = value;
    });
  }

  Widget _buildRadio() {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Text('Radio', style: TextStyle(fontSize: 20, color: Colors.black)),
              FormBuilderRadio(
                decoration: InputDecoration(labelText: 'Are you Married'),
                validators: [FormBuilderValidators.required()],
                attribute: 'radio',
                // onChanged: (int value){_onChanged(value);},
                options: [
                  FormBuilderFieldOption(value: 'Yes'),
                  FormBuilderFieldOption(value: 'No'),
                  // FormBuilderFieldOption(value: 'Bad'),
                ]
                // onChanged: _onChanged,
                // onChanged: (valueSelectedByUser){
                //   setState(() {
                //     debugPrint('User Selected $valueSelectedByUser');
                //     updateRadioAsInt(valueSelectedByUser);
                //   });
                // },

              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheck() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Text('Radio', style: TextStyle(fontSize: 20, color: Colors.black)),
              FormBuilderCheckboxList(
                decoration: InputDecoration(labelText: 'Your Hobbies'),
                validators: [FormBuilderValidators.required()],
                attribute: 'checkbox',
                options: [
                  FormBuilderFieldOption(value: 'Cricket'),
                  FormBuilderFieldOption(value: 'Vollyball'),
                  FormBuilderFieldOption(value: 'Carrom'),
                ],
                initialValue: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildName() {
    return FormBuilderTextField(
      controller: titleController,

      onChanged: (value) {
        debugPrint('Name field changed');
        updateTitle();
      },

      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,

      validators: [FormBuilderValidators.required()], attribute: null,

    );
  }

  Widget _buildEmail() {
    return FormBuilderTextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,

      onChanged: (value) {
        debugPrint('Email field changed');
        updateEmail();
      },
      decoration: InputDecoration(labelText: 'Email'),
      validators: [
       FormBuilderValidators.required(),
        FormBuilderValidators.pattern(_emailPattern),
      ], attribute: null,
    );
  }

  Widget _buildPhonenumber() {
    return FormBuilderTextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        debugPrint('Phone field changed');
        updatePhone();
      },

      decoration: InputDecoration(labelText: 'Phone'),
      maxLength: 10,
      validators: [FormBuilderValidators.required()], attribute: null,

    );
  }


  Widget _buildSwitch () {
    return FormBuilderSwitch(
      attribute: 'switch', label: Text('On or Off'),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;

    titleController.text = reg.title;
    emailController.text = reg.description;
    phoneController.text = reg.phone;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),

        body: Container(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: FormBuilder(
              key: _formKey,
             child: ListView(
                children: <Widget>[
                  // First Element
                  ListTile(
                    title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      value: getPriorityAsString(reg.priority),

                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User Selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      },
                    ),
                  ),

                  _buildName(),
                  _buildEmail(),
                  _buildRadio(),
                  _buildCheck(),
                  _buildSwitch(),
                  _buildPhonenumber(),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Save',
                                textScaleFactor: 1.2,
                              ),

                              onPressed: (){
                                // if (!_formKey.currentState.validate()) {
                                //   // setState(() {
                                //   // });
                                //   return;
                                // } else {
                                //   debugPrint("Save button Clicked");
                                //   _save();
                                // }
                                if (_formKey.currentState.saveAndValidate()) {
                                  print(_formKey.currentState.value);
                                  _save();
                                } else {
                                  print(_formKey.currentState.value);
                                  print("validation failed");
                                }
                              },
                            ),
                        ),

                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.2,
                            ),

                            onPressed: (){
                              setState(() {
                                debugPrint("Delete button Clicked");
                                _delete();
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                  )

                ]
            ),
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Male':
        reg.priority = 1;
        break;
      case 'Female':
        reg.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    reg.title = titleController.text;
  }

  void updateEmail() {
    reg.description = emailController.text;
  }

  void updatePhone() {
    reg.phone = phoneController.text;
  }

  void _save() async {
    moveToLastScreen();

    reg.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (reg.id != null) {
      result = await helper.updateReg(reg);
    } else {
      result = await helper.insertReg(reg);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'details Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured While Saving the details');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (reg.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    int result = await helper.deleteReg(reg.id);
    if (result != 0) {
      _showAlertDialog('Status', 'details Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured While deleting the details');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  // void updateRadioAsInt(valueSelectedByUser) {
  //   switch (value) {
  //     case 'Yes':
  //       reg.radio = 1;
  //       break;
  //     case 'No':
  //       reg.radio = 0;
  //       break;
  //   }
  // }

}