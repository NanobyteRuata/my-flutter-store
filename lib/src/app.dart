import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_store/src/blocs/cart_bloc.dart';
import 'package:my_store/src/blocs/orderlist_bloc.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/services/connectivity_service.dart';
import 'package:my_store/src/ui/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StreamProvider<ConnectivityStatus>(
        create: (_) => ConnectivityService().connectionStatusController.stream,
        child: MultiBlocProvider(
            providers: [
              BlocProvider<CartBloc>(create: (context) => CartBloc()),
              BlocProvider<WishListBloc>(create: (context) => WishListBloc()),
              BlocProvider<OrderListBloc>(create: (context) => OrderListBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyStore',
              theme: ThemeData(
                // Define the default brightness and colors.
                brightness: Brightness.light,
                primaryColor: Colors.black,
                accentColor: Colors.teal,

                // Define the default font family.
                fontFamily: 'Roboto',

                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: TextTheme(
                  headline1:
                      TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  headline6:
                      TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                  bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
                ),
              ),
              home: HomeWidget(),
            )));
  }
}
