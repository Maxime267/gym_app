import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/home_page.dart';
import '../../logic/bloc/drawer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final myMap = DrawerState.items;
    final drawerbloc = BlocProvider.of<DrawerBloc>(context);

    return Drawer(
      child: ListView(
        children: [
          // Button to add a new session/item to the drawer
          ElevatedButton(
            onPressed: () {
              // Dispatch AddDrawerItemEvent to add a new item to the drawer
              context.read<DrawerBloc>().add(
                AddDrawerItemEvent(
                  itemName: 'Profile', // Name of the item
                  itemPage:
                      (context) =>
                          TestPageUI(), // Widget to display for the item
                ),
              );
            },
            child: Text("Add Session"),
          ),

          // Display the drawer items using ListView.builder
          ListView.builder(
            shrinkWrap:
                true, // Ensures the list view takes only as much space as needed
            itemCount: myMap.length,
            itemBuilder: (context, index) {
              final entry = myMap.entries.elementAt(index);
              final key = entry.key;
              final value = entry.value;

              return ListTile(
                title: Text(key), // Display item name
                onTap: () {
                  // When an item is tapped, navigate to the corresponding page
                  print("key : " + key);
                  drawerbloc.add(DrawerEventSelectedPage(pagename: key));
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class TestPageUI extends StatelessWidget {
  const TestPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}
