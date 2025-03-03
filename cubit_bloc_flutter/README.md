# Products Cubit

This repository demonstrates a Flutter application using Cubit (from flutter_bloc) for state management to fetch and display products from the [FakeStore API](https://fakestoreapi.com/products).

## Features
- Fetches product data from the API using Cubit.
- Displays data in a GridView format.
- Implements a refresh indicator to reload products.
- Shows loading, error, and initial states.
- Uses `CachedNetworkImage` for efficient image loading.

## Project Structure
```
/lib
  ├── features
  │   ├── products
  │   │   ├── products.dart (UI Layer)
  │   │   ├── products_cubit.dart (Cubit Logic)
  │   │   ├── models
  │   │   │   ├── products_response_model.dart (Model)
  ├── core
  │   ├── api_provider.dart (API Handler)
```

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/yourrepository.git
   ```
2. Navigate to the project directory:
   ```sh
   cd yourrepository
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```

## Code Overview

### Products UI (`products.dart`)
The `Products` widget fetches product data and displays it in a `GridView`. It uses `BlocBuilder` to manage different states.

```dart
BlocBuilder<ProductsCubit, ProductsState>(
  builder: (context, state) {
    if (state is ProductsLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is ProductsError) {
      return Center(child: Text(state.message));
    }
    if (state is ProductsLoaded) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(MediaQuery.of(context).size.width),
          childAspectRatio: 0.75,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: state.products[index].image!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Text(state.products[index].title!),
              ],
            ),
          );
        },
      );
    }
    return Container();
  },
)
```

### Products Cubit (`products_cubit.dart`)
Handles fetching data from the API and managing different states.

```dart
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  var apiProvider = ApiProvider(parseUrl: 'https://fakestoreapi.com/products');

  void fetchApi() async {
    emit(ProductsLoading());
    try {
      http.Response response = await apiProvider.get();
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ProductsResponse> responseListData = data.map((e) => ProductsResponse.fromJson(e)).toList();
        emit(ProductsLoaded(responseListData));
      } else {
        emit(ProductsError("Failed to load products"));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
```

### API Provider (`api_provider.dart`)
Handles API requests using `http` package.

```dart
class ApiProvider {
  final String parseUrl;
  ApiProvider({required this.parseUrl});

  Future<http.Response> get({Map<String, String>? headers}) async {
    return await http.get(Uri.parse(parseUrl), headers: headers);
  }
}
```

## Dependencies
Ensure the following dependencies are added to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  cached_network_image: ^3.2.3
  http: ^0.13.5
```

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contribution
Feel free to contribute to this project by submitting issues or pull requests!

