import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/widget.dart';
import '../../logic/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String appBarTitle = 'Home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      drawer: DrawerWidget(
        onItemSelected: (String title) {
          // Update the AppBar title when a drawer item is selected
          setState(() {
            appBarTitle = title;
          });
          // Close the drawer after item selection
          Navigator.of(context).pop();
        },
      ),
      body: 

      BlocBuilder<DrawerBloc, DrawerState>(
      builder: (context, state) {
        if (state.value == 1) {
          return Container(
            height: 100,
            width: 100,
            color: Colors.green,
            child: Center(child: Text("Value is 1")),
          );
        } else {
          return HomePageUI();
        }
      },
    )

    );
  }
}

class HomePageUI extends StatelessWidget{
  const HomePageUI({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Welcome to the Gym App"),
        Image(image: AssetImage('assets/images/therock.jpeg')),
      ]
    );
  }
}