import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_database_project/constants.dart';
import 'package:local_database_project/database_helper.dart';
import 'package:local_database_project/info_model.dart';
import 'package:local_database_project/preferences_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InfoModel> data = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameEditController = TextEditingController();
  final TextEditingController phoneEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();

  Future<List<InfoModel>> getData() async {
    data = await DatabaseHelper.instance.readAllInfo();
    print('Data: ${data.length}');
    return data;
  }

  Future<void> updateData(InfoModel info) async {
    return await DatabaseHelper.instance.editInfo(info);
  }

  deleteData(id) async {
    return await DatabaseHelper.instance.deleteInfo(id);
  }

  // Git version control
  // Branch used saved code
  // GitHub
  // Bitbucket
  // main / master
  // Git Cli
  // Dev, Stage, Production
  // marge
  // Rebase
  // Push
  // Pull
  // Checkout change your branch
  // init
  // Login
  // Authentication
  // HTTP / SSH
  // jwt
  // git => Tool

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (PreferencesHelper.instance.getIsOpened() == false) {
        welcomeAlert();
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000c1f),
      body: Column(
        children: [
          topBar(),
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) => snapshot.hasData
                ? dataList(data)
                : snapshot.hasError
                    ? const Text('Sorry Something went wrong')
                    : const CircularProgressIndicator(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlert();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff031e48),
      ),
    );
  }

  Widget topBar() => Container(
        decoration: BoxDecoration(
            color: Color(0xff031e48),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        height: 150,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome in Note App',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'You can store any note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

  Widget dataList(List<InfoModel> noteList) => noteList.isEmpty
      ? Center(
          child: const Text(
            'No Data Found',
            style: TextStyle(color: Colors.white),
          ),
        )
      : Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: noteList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff031e48),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(
                            '${noteList[index].name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            '${noteList[index].email}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Text((noteList[index].name ?? '') != ''
                                ? noteList[index]
                                    .name!
                                    .substring(0, 2)
                                    .toUpperCase()
                                : ''),
                          ),
                          trailing: Container(
                            width: 70,
                            child: Row(
                              children: [
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          nameEditController.text =
                                              noteList[index].name ?? '';
                                          phoneEditController.text =
                                              noteList[index].phone ?? '';
                                          emailEditController.text =
                                              noteList[index].email ?? '';
                                          editDialog(noteList[index].id ?? 0);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ))),
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteData(data.removeAt(index).id);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
          ),
        );

  void showAlert() {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Add User',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: Wrap(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: fieldDecoration('Name'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: fieldDecoration('Phone'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: fieldDecoration('Email'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    DatabaseHelper.instance
                        .insertInfo(InfoModel(
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text))
                        .then((value) {
                      getData();
                      setState(() {});
                    }).whenComplete(() {
                      Navigator.pop(context);
                      nameController.clear();
                      phoneController.clear();
                      emailController.clear();
                    });
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff031e48)),
                )
              ],
            ));
  }

  welcomeAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Welcome in Note App',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    PreferencesHelper.instance.setIsOpened(true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff031e48)),
                )
              ],
            ));
  }

  void editDialog(int id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: Wrap(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: nameEditController,
                        decoration: fieldDecoration('Name'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: phoneEditController,
                        decoration: fieldDecoration('Phone'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailEditController,
                        decoration: fieldDecoration('Email'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    DatabaseHelper.instance
                        .editInfo(InfoModel(
                            id: id,
                            name: nameEditController.text,
                            phone: phoneEditController.text,
                            email: emailEditController.text))
                        .then((value) {
                      getData();
                      setState(() {});
                    }).whenComplete(() {
                      Navigator.pop(context);
                      nameEditController.clear();
                      phoneEditController.clear();
                      emailEditController.clear();
                    });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff031e48)),
                )
              ],
            ));
  }

  InputDecoration fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        border: UnderlineInputBorder(),
      );
}

// api flutter.builder Dialog alert
// bottom sheet
// callback
// then (val) Success
// whenComplete () Both
// catch error Failure
// on error Failure
// catch on
// try / catch (e) error dynamic
// try {Body in Success} catch (e) dynamic {Body in Error}
// Error 1_ value, 2_ Stacktrace
// ListTile leading, title, subtitle, description,
