import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/home_page.dart';
import '../../logic/bloc/drawer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final myMap = DrawerState.items;

    return Drawer(
      child: ListView(
        children: [
          // Button to add a new session/item to the drawer
          ElevatedButton(
            onPressed: () {
              // Dispatch AddDrawerItemEvent to add a new item to the drawer
              context.read<DrawerBloc>().add(
                AddDrawerItemEvent(
                  itemName: nameSeesion(), // Name of the item
                  itemPage:
                      (context) =>
                          TestPageUI(), // Widget to display for the item
                ),
              );
            },
            child: Text("Add Session"),
          ),
          


          // Display the drawer items using ListView.builder
          ListView.separated(
            separatorBuilder: (context,index) => Divider(
              color: Colors.black,
            ),
            shrinkWrap:
                true, // Ensures the list view takes only as much space as needed
            itemCount: myMap.length,
            itemBuilder: (context, index) {
              final entry = myMap.entries.elementAt(index);
              final key = entry.key;
              final value = entry.value;

              return Column(
                children: [
                  ListTile(
                    title: Text(key), // Display item name
                    onTap: () {
                      // When an item is tapped, navigate to the corresponding page
                      print("key : " + key);
                      context.read<DrawerBloc>().add(
                        DrawerEventSelectedPage(pagename: key),
                      );
                      Navigator.pop(context); // Close the drawer
                      /*
                      /// not useful i keep it just in case
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      */
                    },
                  ),
                  if(key != 'Home') ElevatedButton.icon(
                    onPressed: () {
                      print("Trashed" + key);
                      context.read<DrawerBloc>().add(
                        DrawerEventDelete(pagename: key),
                      );
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                  ),
                  
                ],
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


String nameSeesion(){
 int index = 1;
  while (DrawerState.items.containsKey('Session $index')) {
    index++;
  }
  return 'Session $index';
}
