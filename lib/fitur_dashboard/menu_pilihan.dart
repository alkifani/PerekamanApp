// import 'dart:html';

import 'package:blackboxalat/configure/constants.dart';
import 'package:blackboxalat/fitur_dashboard/transfer_data/transfer_data.dart';
import 'package:blackboxalat/fitur_dashboard/widget_clock.dart';
import 'package:flutter/material.dart';


class MenuIconApp extends StatefulWidget {
  const MenuIconApp({super.key});

  @override
  State<MenuIconApp> createState() => _MenuIconAppState();
}

class _MenuIconAppState extends State<MenuIconApp> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            SizedBox(height: 15,),
            SizedBox(
              height: 90,
              width: 170,
              child: Card(
                color: wutama,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClockWidget(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.orange,
                color: button,
                border: Border.all(
                  color: Colors.black87, // Warna garis lingkaran
                  width: 1.0, // Lebar garis lingkaran
                ),
              ),
              padding: EdgeInsets.all(5.0), // Jarak antara lingkaran dan ikon
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTransfer(),
                    ),
                  );
                },
                icon: Icon(Icons.swap_horiz, color: Colors.black, size: 30,),
              ),

            ),
            SizedBox(height: 5,),
            Text('Transfer Data',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8,),
            // Column(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: button,
            //         // color: Colors.orange,
            //         border: Border.all(
            //           color: Colors.black87, // Warna garis lingkaran
            //           width: 1.0, // Lebar garis lingkaran
            //         ),
            //       ),
            //       padding: EdgeInsets.all(5.0), // Jarak antara lingkaran dan ikon
            //       child: IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => RunModelObjectDetection(),
            //             ),
            //           );
            //         },
            //         icon: Icon(Icons.camera, color: Colors.black, size: 30,),
            //       ),
            //     ),
            //     SizedBox(height: 5,),
            //     Text('Object Detection',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 8,),
            // Column(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: button,
            //         // color: Colors.orange,
            //         border: Border.all(
            //           color: Colors.black87, // Warna garis lingkaran
            //           width: 1.0, // Lebar garis lingkaran
            //         ),
            //       ),
            //       padding: EdgeInsets.all(5.0), // Jarak antara lingkaran dan ikon
            //       child: IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => AboutUs(),
            //                 ),
            //               );
            //         },
            //         icon: Icon(Icons.info_sharp, color: Colors.black, size: 30,),
            //       ),
            //     ),
            //     SizedBox(height: 5,),
            //     Text('About Us',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Menu Icon App'),
//       ),
//       body: Center(
//         child: MenuIconApp(),
//       ),
//     ),
//   ));
// }