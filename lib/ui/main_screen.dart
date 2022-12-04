import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<User> users = [];

  @override
  void initState() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BlocConsumer
    return BlocListener<UsersBloc, UsersState>(
      listener: (BuildContext context, state) {
        if (state is UsersLoadedState) {
          users = state.users;
          setState(() {});
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration.collapsed(hintText: 'Enter name'),
                controller: nameController,
              ),
            ),
          ),
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration.collapsed(hintText: 'Enter age'),
                controller: ageController,
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addUser,
            child: const Text('Add user'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(users[index].name),
                          Text(" age: ${users[index].age.toString()}"),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void _addUser() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(
      AddUserEvent(
        User(
          name: nameController.text,
          age: int.parse(ageController.text),
        ),
      ),
    );
    nameController.clear();
    ageController.clear();
  }
}
