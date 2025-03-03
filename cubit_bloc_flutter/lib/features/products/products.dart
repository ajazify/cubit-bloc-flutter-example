import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubit_bloc_flutter/features/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductsCubit>().fetchApi();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Products',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductsCubit>().fetchApi();
          },
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProductsError) {
                return Center(
                  child: Text(state.message),
                );
              }

              if (state is ProductsInitial) {
                return Center(
                  child: Text('Initial'),
                );
              }

              if (state is ProductsLoaded) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CachedNetworkImage(
                                      imageUrl: state.products[index].image!,
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      placeholder: (context, url) =>
                                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tooltip(
                                    message: state.products[index].title!,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      state.products[index].title!,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tooltip(
                                    message: state.products[index].description!,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      state.products[index].description!,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                );
              }

              // if (state is ProductsLoaded) {
              //   return ListView.builder(
              //     itemCount: state.products.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       var doc = state.products[index];
              //       return Card(
              //         child: ListTile(
              //           title: Text('Item ${doc.title}'),
              //           subtitle: Text('Description ${doc.description}'),
              //           leading: CachedNetworkImage(
              //             imageUrl: doc.image!,
              //             errorWidget: (context, url, error) => Icon(Icons.error),
              //             placeholder: (context, url) => CircularProgressIndicator(),
              //           ),
              //           trailing: Icon(Icons.arrow_forward_ios),
              //         ),
              //       );
              //     },
              //   );
              // }

              return Container();
            },
          ),
        ));
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 300) return 3;
    return 2;
  }
}
