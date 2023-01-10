import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/amplifyconfiguration.dart';
import 'package:flutterapp/profilepicture.dart';

import 'models/ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          useMaterial3: true),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: Authenticator.builder(),
    ));
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.addPlugin(
          AmplifyAPI(modelProvider: ModelProvider.instance));
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _languageController = TextEditingController();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    final queryPredicate = UserProfile.USERID.eq(currentUser.userId);
    final request = ModelQueries.list<UserProfile>(UserProfile.classType,
    where: queryPredicate);
    final response = await Amplify.API.query(request: request).response;

    if (response.data!.items.isNotEmpty) {
      _userProfile = response.data?.items[0];

      setState(() {
        _nameController.text = _userProfile?.name ?? "";
        _locationController.text = _userProfile?.location ?? "";
        _languageController.text = _userProfile?.language ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const ProfilePicture(),
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: _nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Location"),
                controller: _locationController,
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: "Favourite Language"),
                controller: _languageController,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateUserDetails,
        tooltip: 'Save Details',
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _updateUserDetails() async {
    final currentUser = await Amplify.Auth.getCurrentUser();

    final updatedUserProfile = _userProfile?.copyWith(
            name: _nameController.text,
            location: _locationController.text,
            language: _languageController.text) ??
        UserProfile(
            userId: currentUser.userId,
            name: _nameController.text,
            location: _locationController.text,
            language: _languageController.text);

    final request = _userProfile == null
        ? ModelMutations.create(updatedUserProfile)
        : ModelMutations.update(updatedUserProfile);
    final response = await Amplify.API.mutate(request: request).response;

    final createdProfile = response.data;
    if (createdProfile == null) {
      safePrint('errors: ${response.errors}');
    }
  }
}
