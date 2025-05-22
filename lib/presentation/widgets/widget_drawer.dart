import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/session.dart';
import '../../logic/bloc/drawer.dart';
import '../../logic/session_logic/session_storage.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final myMapload = DrawerState.items;
    final myMap = myMapload.entries.where((e) => e.key != 0).toList();  //we take out setting not to put it in the list (we do not want it on the drawer list)
    
    return Drawer(
      child: 
      Column(
        children: [
          SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                    onPressed: () {
                      final int newId = DrawerState.getNextId();
                      final String sessionName = nameSession();
                      context.read<DrawerBloc>().add(
                        AddDrawerItemEvent(
                          itemName: sessionName,
                          itemPage: (context) => SessionDetails(
                            session_id: newId,
                            session_name: sessionName,
                          ),
                        ),
                      );
                      SessionStorage.saveSessionName('session$newId', sessionName);
                      SessionStorage.saveSession('session$newId', []);
                    },
                    child: Text("Add Session"),
                  ),
              IconButton(
                onPressed: () {
                  context.read<DrawerBloc>().add(
                                DrawerEventSelectedPage(pageid: 0),
                              );
                              Navigator.pop(context); //Close drawer
                },
                icon: Icon(Icons.settings),
                tooltip: 'Settings',
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ListView.separated(
                  separatorBuilder: (context,index) => Divider(
                    color: Colors.black,
                  ),
                  shrinkWrap:
                      true,
                  physics: BouncingScrollPhysics(),
                  itemCount: myMap.length,
                  itemBuilder: (context, index) {
                    final entry = myMap[index];
                    final key = entry.key;
                    return Column(
                      children: [
                        BlocBuilder<DrawerBloc, DrawerState>(
                          builder: (context, state) {
                          if(state.action == "RenameButton" && state.selectedItemId == key){
                            return TextField(
                              onSubmitted: (newName){
                                context.read<DrawerBloc>().add(
                                  DrawerEventRenameText(pageid: state.selectedItemId, newName: newName),
                                );
                              },
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
            
                        if(key != 1) Row( //if not home
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          IconButton(
                            onPressed: () {
                              print("Trashed" + "$key");
                              context.read<DrawerBloc>().add(
                                DrawerEventDelete(pageid: key),
                              );
                            },
                            icon: Icon(Icons.delete),
                            tooltip: "Delete",
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              print("Rename " + "$key");
                              context.read<DrawerBloc>().add(
                                DrawerEventRenameButton(pageid: key),
                              );
                            },
                            icon: Icon(Icons.edit),
                            tooltip: "Rename",
                          ),
                        ]),
                      ],
                    );
                  },
                ),
              ],
            ),
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
