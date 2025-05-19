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
                  itemName: nameSession(), // Name of the item
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
                  BlocBuilder<DrawerBloc, DrawerState>(
                    builder: (context, state) {
                    if(state.action == "RenameButton" && state.selectedItemId == key){
                      return TextField(
                        //onSubmitted: ,

                      );
                    }
                    else{
                     return ListTile(
                      title: Text(DrawerState.items[key]?.name ?? 'Unknown'), 
                      onTap: () {
                        context.read<DrawerBloc>().add(
                          DrawerEventSelectedPage(pageid: key),
                        );
                        Navigator.pop(context); //Close drawer
                      },
                      );
                      }
                    }
                  ),

                  if(key != 1) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print("Trashed" + "$key");
                        context.read<DrawerBloc>().add(
                          DrawerEventDelete(pageid: key),
                        );
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        print("Rename " + "$key");
                        context.read<DrawerBloc>().add(
                          DrawerEventRenameButton(pageid: key),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Rename"),
                    ),
                  ])
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


String nameSession() {
  int index = 1;
  while (DrawerState.items.values.any((item) => item.name == 'Session $index')) {
    index++;
  }
  return 'Session $index';
}
