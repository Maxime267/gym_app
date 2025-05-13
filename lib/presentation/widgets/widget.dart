import 'package:flutter/material.dart';
import '../../logic/bloc/event.dart';
import '../../logic/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerWidget extends StatelessWidget {
  final Function(String) onItemSelected;

  const DrawerWidget({Key? key, required this.onItemSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            onTap:
                () => {
                  onItemSelected('Home'),
                  context.read<DrawerBloc>().updateValue(0),
                }, // Pass 'Home' when selected
          ),
          ListTile(
            title: const Text('Settings'),
            onTap:
                () => {
                  onItemSelected('Settings'),
                  context.read<DrawerBloc>().updateValue(1),
                }, // Pass 'Settings' when selected
          ),
          ListTile(
            title: const Text('Profile'),
            onTap:
                () => {
                  onItemSelected('Profile'),
                  context.read<DrawerBloc>().updateValue(2),
                }, // Pass 'Profile' when selected
          ),
        ],
      ),
    );
  }
}
