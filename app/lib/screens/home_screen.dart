import 'dart:convert';
import 'dart:io';

import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/product_provider.dart';
import 'package:app/providers/search_provider.dart';
import 'package:app/screens/add_product_screen.dart';
import 'package:app/screens/auth_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/see_product_screen.dart';
import 'package:app/widgets/custom_drawer.dart';
import 'package:app/widgets/custom_fab.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

import 'package:app/utils/utils.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      drawer: CustomDrawer(),
      floatingActionButton: CustomFab(),
      appBar: AppBar(
        title: Text('QR Inventory'),
        backgroundColor: Utils.secondaryBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  authProvider.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AuthScreen(),
                  ));
                },
                child: Text('enter')),
            TypeAheadField(
              loadingBuilder: (context) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Utils.secondaryBackground,
                );
              },
              itemBuilder: (context, suggestion) {
                print(suggestion);
                return ListTile(
                  tileColor: Utils.primaryColor,
                  title: Text(
                    '${suggestion}',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      color: Utils.primaryFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) async {
                print(suggestion);
                final getData = await SearchProvider.getSearchFullData(name: suggestion.toString());
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SeeProductScreen(getData),
                ));
              },
              suggestionsCallback: (pattern) {
                return SearchProvider.getSearchData(name: pattern);
              },
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                style: GoogleFonts.titilliumWeb(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  fillColor: Utils.secondaryBackground,
                  filled: true,
                  border: InputBorder.none,
                  labelText: 'Search Product using Name or Id:',
                  labelStyle: GoogleFonts.rubik(
                    fontSize: 16,
                    color: Utils.primaryFontColor,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [Sign out code]
///
///  ElevatedButton(
//   onPressed: () {
//     authProvider.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (context) => AuthScreen(),
//     ));
//   },
//   child: Text(
//     'Onnum eh illaaaa, aprom vanga',
//     style: GoogleFonts.rubik(
//       fontSize: 30,
//     ),
//   ),
// ),

//    Center(
//   child: ElevatedButton(
//     onPressed: () async {
//       final response =
//           await get(Uri.parse('http://192.168.0.101:3000/api/pdf/${FirebaseAuth.instance.currentUser!.uid}'));

//       // print(response.bodyBytes);

//       final output = await getExternalStorageDirectory();
//       final file = File("/storage/emulated/0/Downloads/example.pdf");
//       print(output!.path);
//       await file.writeAsBytes(response.bodyBytes.buffer.asUint8List());
//       print('done');
//       // print(response.body);
//       // Navigator.of(context).push(MaterialPageRoute(
//       //   builder: (context) => ProfileScreen(),
//       // ));
//     },
//     child: Text(
//       'Onnum eh illaaaa, aprom vanga',
//       style: GoogleFonts.rubik(
//         fontSize: 30,
//       ),
//     ),
//   ),
// ),