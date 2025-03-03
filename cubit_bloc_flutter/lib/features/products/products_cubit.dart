import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_bloc_flutter/core/api_provider.dart';
import 'package:cubit_bloc_flutter/features/products/models/products_response_model.dart';

// Define states
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductsResponse> products;
  ProductsLoaded(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  var apiProvider = ApiProvider(parseUrl: 'https://fakestoreapi.com/products');

  void fetchApi() async {
    emit(ProductsLoading()); // Emit loading state

    try {
      http.Response response = await apiProvider.get();
      print(response.statusCode);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ProductsResponse> responseListData = data.map((e) => ProductsResponse.fromJson(e)).toList();

        emit(ProductsLoaded(responseListData)); // Emit success state
      } else {
        emit(ProductsError("Failed to load products")); // Emit error state
      }
    } catch (e) {
      emit(ProductsError(e.toString())); // Emit error state
    }
  }
}
