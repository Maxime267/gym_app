abstract class DrawerEvent {}

class DrawerChange extends DrawerEvent {
  final int selectedIndex;
  DrawerChange(this.selectedIndex);
}