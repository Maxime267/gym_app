import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/presentation/screen/home_page.dart';
import 'package:gym_app/presentation/screen/settings.dart';
import 'package:gym_app/logic/session_logic/session_storage.dart';
import 'package:gym_app/presentation/screen/session.dart';

abstract class DrawerEvent {}

class AddDrawerItemEvent extends DrawerEvent {
  final String itemName;
  final WidgetBuilder itemPage;

  AddDrawerItemEvent({required this.itemName, required this.itemPage});
}

class LoadSavedSessionsEvent extends DrawerEvent {}

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
  final String newName;
  DrawerEventRenameText({required this.pageid, required this.newName});
}


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
    0: DrawerItemData(
      name: 'Settings',
      builder: (context) =>Settings(),
    ),
  };
  DrawerState(this.action, this.selectedItemId);

  static int _nextId = 2;
  static int getNextId() => _nextId;
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

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerState('Select', 1)) {
    on<AddDrawerItemEvent>((event, emit) {
      DrawerState.addItem(event.itemName, event.itemPage);
      emit(
        DrawerState("Add", 0),
      );
    });
    on<DrawerEventDelete>((event, emit)async {
      DrawerState.deleteItem(event.pageid);
      emit(DrawerState("Delete", event.pageid));
      final sessionId = 'session${event.pageid}';
      await SessionStorage.deleteSession(sessionId);
    });

    on<DrawerEventSelectedPage>((event, emit) {
      emit(DrawerState("Select", event.pageid));
    });

    on<DrawerEventRenameButton>((event, emit) {
      emit(DrawerState("RenameButton", event.pageid));
    });

    on<DrawerEventRenameText>((event, emit)async {
      DrawerState.renameItem(event.pageid,event.newName);
      emit(DrawerState("RenameText", event.pageid));
      final sessionId = 'session${event.pageid}';
      await SessionStorage.saveSessionName(sessionId, event.newName);
    });

    on<LoadSavedSessionsEvent>((event, emit) async {

      final index = await SessionStorage.loadSessionIndex();

      for (final entry in index.entries) {
        final sessionId = entry.key;
        final name = entry.value;
        final id = int.tryParse(sessionId.replaceAll('session', ''));
        if (id == null) continue;

        DrawerState.items[id] = DrawerItemData(
          name: name,
          builder: (context) => SessionDetails(
            session_id: id,
            session_name: name,
          ),
        );

        if (id >= DrawerState._nextId) {
          DrawerState._nextId = id + 1;
        }
      }

      emit(DrawerState("Loaded", DrawerState.items.keys.first));
    });

  }
}