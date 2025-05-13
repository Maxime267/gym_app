import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/home_page.dart';
import 'logic/bloc/bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => DrawerBloc(),
      child: MaterialApp(
        title: 'Gym App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
    ),
    )
  );
}
