import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_bloc_flutter/features/products/products.dart';
import 'package:cubit_bloc_flutter/features/products/products_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Cubit With Fake Store API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProductsCubit>(
            create: (BuildContext context) => ProductsCubit(),
          ),
        ],
        child: Products(),
      ),
    );
  }
}
