import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/presentation/screen/home_page.dart';

//event

abstract class DrawerEvent {}

class AddDrawerItemEvent extends DrawerEvent {
  final String itemName;
  final WidgetBuilder itemPage;

  AddDrawerItemEvent({required this.itemName, required this.itemPage});
}

class DrawerEventSelectedPage extends DrawerEvent {
  final String pagename;
  DrawerEventSelectedPage({required this.pagename});
}

class DrawerEventDelete extends DrawerEvent {
  final String pagename;
  DrawerEventDelete({required this.pagename});
}

//State

class DrawerState {
  final String selectedItem; // Change from int to String
  static final Map<String, WidgetBuilder> items = {
    'Home': (context) => HomePageUI(),
    // Other default items here
  };

  DrawerState(this.selectedItem);

  // Method to add a new item to the items map
  static void addItem(String itemName, WidgetBuilder page) {
    items[itemName] = page;
  }

  static void deleteItem(String itemName) {
    items.remove(itemName);
  }
}

//Bloc

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerState('Home')) {
    // Default state is 'Home'
    on<AddDrawerItemEvent>((event, emit) {
      // Logic to add a new item to the drawer
      // Since DrawerState.items is static, we handle adding items directly
      DrawerState.addItem(event.itemName, event.itemPage);

      // Emit new state with the updated selected item (you can decide the logic here)
      emit(
        DrawerState(event.itemName),
      ); // Updating selectedItem to the new item name
    });
    on<DrawerEventDelete>((event, emit) {
      DrawerState.deleteItem(event.pagename);
      emit(DrawerState("Delete"));
    });

    on<DrawerEventSelectedPage>((event, emit) {
      emit(DrawerState(event.pagename));
    });

    // You can add more event handlers here if needed
  }
}
