import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/exercise_details.dart';
import '../../logic/bloc/drawer.dart';
import '../widgets/widget_drawer.dart';


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
          appBar: AppBar(
            title: Text(
              state.action == "Select" && DrawerState.items.containsKey(state.selectedItemId)
                  ? DrawerState.items[state.selectedItemId]!.name
                  : 'Home',
            ),
          ),
          drawer: DrawerWidget(),
          body: () {
            if (state.action == "Select") {
              final pageBuilder = DrawerState.items[state.selectedItemId];
              if (pageBuilder != null) {
                return pageBuilder.builder(context);
              } else {
                return Center(child: Text("Page not found"));
              }
            } else {
              return HomePageUI();
            }
          }(),
        );
      },
    );
  }
}

class Tile {
  final String name;
  final String imageLink;

  Tile({required this.name, required this.imageLink});
}

final List<Tile> tiles = [
  Tile(name: 'abs', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/abs_0.jpg'),
  Tile(name: 'biceps', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/biceps_0.jpg'),
  Tile(name: 'chest', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/chest_0.jpg'),
  Tile(name: 'forearms', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/forearms_0.jpg'),
  Tile(name: 'lats', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/lats_0.jpg'),
  Tile(name: 'shoulders', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/shoulders_0.jpg'),
  Tile(name: 'traps', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/traps_0.jpg'),
  Tile(name: 'triceps', imageLink: 'https://cdn.muscleandstrength.com/sites/default/files/taxonomy/image/videos/triceps_0.jpg'),
];



class HomePageUI extends StatelessWidget {
  const HomePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              width: 385,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.fitness_center, size: 50),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Welcome to Gym App !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.fitness_center, size: 50),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('You can browse through the different exercise '
                      'categories underneath or use the tab to create '
                      'your own workout program !',
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 14,
                children: tiles.map((Tile) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                          ExerciseDetails(category: Tile.name))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          Tile.imageLink,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text(
                          Tile.name,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
