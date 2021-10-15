// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:squel_1/customer_model.dart';
import 'package:squel_1/squel_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController fNameEditingController;
  late TextEditingController lNameEditingController;
  late TextEditingController emailEditingController;

  Random random = Random();

  int customerId = 0;

  @override
  void initState() {
    fNameEditingController = TextEditingController();
    lNameEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqlite"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: fNameEditingController,
                decoration: InputDecoration(hintText: "First Name"),
              ),
              TextField(
                controller: lNameEditingController,
                decoration: InputDecoration(hintText: "Last Name"),
              ),
              TextField(
                controller: emailEditingController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final customer = CustomerModel(
                            id: random.nextInt(100),
                            firstName: fNameEditingController.text,
                            lastName: lNameEditingController.text,
                            email: emailEditingController.text);

                        DatabaseHelper.instance.addCustomer(customer);
                      });
                      fNameEditingController.clear();
                      lNameEditingController.clear();
                      emailEditingController.clear();
                    },
                    child: Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final customer = CustomerModel(
                            id: customerId,
                            firstName: fNameEditingController.text,
                            lastName: lNameEditingController.text,
                            email: emailEditingController.text);
                        DatabaseHelper.instance.updateCustomer(customer);
                      });
                      fNameEditingController.clear();
                      lNameEditingController.clear();
                      emailEditingController.clear();
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
              Container(
                  height: 400,
                  child: FutureBuilder(
                      future: DatabaseHelper.instance.getCustomer(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CustomerModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading......");
                        }
                        return ListView(
                          children: snapshot.data!.map((customer) {
                            return ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          DatabaseHelper.instance
                                              .deleteCustomer(customer.id);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          fNameEditingController.text =
                                              customer.firstName!;
                                          lNameEditingController.text =
                                              customer.lastName!;
                                          emailEditingController.text =
                                              customer.email!;
                                          customerId = customer.id!;
                                        });
                                      },
                                      icon: Icon(Icons.edit))
                                ],
                              ),
                              title: Text("${customer.firstName}" +
                                  "${customer.lastName}"),
                              subtitle: Text("${customer.email}"),
                            );
                          }).toList(),
                        );
                      }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
