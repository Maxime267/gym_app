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
  final int pageid;
  DrawerEventSelectedPage({required this.pageid});
}

class DrawerEventDelete extends DrawerEvent {
  final int pageid;
  DrawerEventDelete({required this.pageid});
}

class DrawerEventRenameButton extends DrawerEvent {
  final int pageid;
  DrawerEventRenameButton({required this.pageid});
}

class DrawerEventRenameText extends DrawerEvent {
  final int pageid;
  DrawerEventRenameText({required this.pageid});
}

//State

class DrawerItemData {
  String name;
  final WidgetBuilder builder;

  DrawerItemData({
    required this.name,
    required this.builder,
  });
}


class DrawerState {
  final int selectedItemId;
  final String action;
  static final Map<int, DrawerItemData> items = {
    1: DrawerItemData(
      name: 'Home',
      builder: (context) => HomePageUI(),
    ),
  };
  DrawerState(this.action, this.selectedItemId);

  static int _nextId = 2;
  // Method to add a new item to the items map
  static void addItem(String name, WidgetBuilder page) {
    items[_nextId] = DrawerItemData(
      name: name,
      builder: page,
    );
    _nextId++;
  }

  static void deleteItem(int itemID) {
    items.remove(itemID);
  }

  static void renameItem(int id, String newName) {
    if (items.containsKey(id)) {
      items[id]!.name = newName;
    }
  }

}

//Bloc

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerState('Select', 1)) { // Default state is 'Home' (id : 1 = home)
    on<AddDrawerItemEvent>((event, emit) {
      DrawerState.addItem(event.itemName, event.itemPage);
      emit(
        DrawerState("Add", 0), // 0 is random value just not to cause error
      );
    });
    on<DrawerEventDelete>((event, emit) {
      DrawerState.deleteItem(event.pageid);
      emit(DrawerState("Delete", event.pageid));
    });

    on<DrawerEventSelectedPage>((event, emit) {
      emit(DrawerState("Select", event.pageid));
    });

    //When rename button is pressed
    on<DrawerEventRenameButton>((event, emit) {
      emit(DrawerState("RenameButton", event.pageid));
    });
  }
}
