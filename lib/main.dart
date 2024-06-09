import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:kopma/bloc/item_bloc/item_bloc.dart';
import 'package:kopma/bloc/user_bloc/user_bloc.dart';
import 'package:kopma/data/datasource/local/local_cart_datasource.dart';
import 'package:kopma/data/datasource/local/local_database.dart';
import 'package:kopma/data/datasource/network/firebase_user_datasource.dart';
import 'package:kopma/data/item_repository.dart';
import 'package:kopma/data/item_repository_impl.dart';
import 'package:kopma/data/model/user/user_model.dart';
import 'package:kopma/simple_bloc_observer.dart';
import 'package:kopma/ui/main_page.dart';
import 'data/datasource/network/firebase_item_datasource.dart';
import 'data/user_repository.dart';
import 'di/service_locator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  await serviceLocator<LocalDatabase>().initialize();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserDataSource(), ItemRepositoryImpl(FirebaseItemDataSource(), LocalCartDataSource(FirebaseItemDataSource()))));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final ItemRepository itemRepository;

  const MyApp(this.userRepository, this.itemRepository, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserBloc>(
          create: (_) => UserBloc(userRepository: userRepository),
        ),
        RepositoryProvider<ItemBloc>(
          create: (_) => ItemBloc(itemRepository: itemRepository),
        ),
        RepositoryProvider<DetailItemBloc>(
          create: (_) => DetailItemBloc(itemRepository: itemRepository),
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UserBloc(
                  userRepository: context.read<UserBloc>().userRepository,
                ),
              ),
              BlocProvider(
                create: (context) => ItemBloc(
                  itemRepository: context.read<ItemBloc>().itemRepository,
                ),
              ),
              BlocProvider(
                create: (context) => DetailItemBloc(
                  itemRepository: context.read<DetailItemBloc>().itemRepository,
                ),
              ),
            ],
            child: MainApp(userRepository: userRepository),
          );
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  final UserRepository userRepository;

  const MainApp({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kopma',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(8),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate, // This is required
      ],
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return BlocListener<UserBloc, UserState>(
            listener: (context, state) {},
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(clientId: googleClientId, scopes: ['email']),
              ],
              actions: [
                AuthStateChangeAction<UserCreated>((context, state) {
                  User user = state.credential.user!;
                  setState(() {
                    context.read<UserBloc>().add(SetUserData(
                      user: UserModel(
                        id: user.uid,
                        name: user.displayName ?? '',
                        email: user.email!,
                        image: user.photoURL,
                        balance: 0,
                      ),
                    ));
                  });
                  Navigator.popAndPushNamed(context, '/sign-in');
                }),
                AuthStateChangeAction<SignedIn>((context, state) {
                  User user = state.user!;
                  setState(() {
                    context.read<UserBloc>().add(GetMyUser(myUserId: user.uid));
                  });
                  Navigator.pushReplacementNamed(context, '/home');
                }),
              ],
            ),
          );
        },
        '/home': (context) {
          return MainPage(userRepository: widget.userRepository);
        },
      },
    );
  }
}
