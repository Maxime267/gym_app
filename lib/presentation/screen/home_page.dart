import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/drawer.dart';
import '../widgets/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerBloc, DrawerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Home")), // Can use appBarTitle if needed
          drawer: DrawerWidget(),
          body: BlocBuilder<DrawerBloc, DrawerState>(
            builder: (context, state) {
              print(state.selectedItem);

              if (state.selectedItem.startsWith('Session')) {
                final pageBuilder = DrawerState.items[state.selectedItem];
                if (pageBuilder != null) {
                  return pageBuilder(context);
                }
              } 
              else {
                return HomePageUI();
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}

class HomePageUI extends StatelessWidget {
  const HomePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Welcome to the Gym App", style: TextStyle(fontSize: 25)),
        SizedBox(height: 50),
        Image(image: AssetImage('assets/images/therock.jpeg')),
      ],
    );
  }
}
