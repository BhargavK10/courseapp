// import 'package:courseapp/drawermenu.dart';
// import 'package:courseapp/topbar.dart';
// import 'package:flutter/material.dart';

// class CreateCourse extends StatelessWidget {
//   const CreateCourse({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: topBar(context, 'Create'),
//       drawer: DrawerMenu(),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsetsGeometry.all(10),
//           child: Column(
//             children: [
//               SizedBox(height: 30,),
//               TextField(
//                 // controller: cont ,
//                 // style: const TextStyle(color: Colors.white),
//                 // cursorColor: const Color(0xFFDB3939),
//                 decoration: InputDecoration(
//                   hintText: 'Enter your course title',
//                   // hintStyle: const TextStyle(color: Colors.white70),
//                   // prefixIcon: Icon(icon, color: const Color(0xFFDB3939)),
//                   filled: true,
//                   // fillColor: const Color(0xFF2C3137),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Color(0xFFDB3939)),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30,),
//               TextField(
//                 // controller: cont ,
//                 // style: const TextStyle(color: Colors.white),
//                 // cursorColor: const Color(0xFFDB3939),
//                 decoration: InputDecoration(
//                   hintText: 'Enter your course description',
//                   // hintStyle: const TextStyle(color: Colors.white70),
//                   // prefixIcon: Icon(icon, color: const Color(0xFFDB3939)),
//                   filled: true,
//                   // fillColor: const Color(0xFF2C3137),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Color(0xFFDB3939)),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30,),
//               Container(
//                 width: MediaQuery.of(context).size.width*0.95,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsGeometry.only(left: 10, top: 10),
//                       child: Text(
//                         'Videos',
//                         style: TextStyle(
//                           fontSize: 20
//                         ),
//                       )
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 10, left: 5),
//                       child: GestureDetector(
//                         onTap: () {

//                         },
//                         child: Container(
//                           height: 70,
//                           width: MediaQuery.of(context).size.width*0.92,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withAlpha(127),
//                                 spreadRadius: 2,
//                                 blurRadius: 2,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                             color: Colors.blue.shade50
//                           ),
//                           child: Center(
//                             child: Text(
//                               '+',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 50,
//                                 color: const Color.fromARGB(255, 161, 161, 161)
//                               ),
//                             )
//                           )
//                           // Icon(CupertinoIcons.plus),
//                         ),
//                       )
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         )
//       ),
//     );
//   }
// }

import 'package:courseapp/drawermenu.dart';
import 'package:courseapp/topbar.dart';
import 'package:flutter/material.dart';

class CreateCourse extends StatelessWidget {
  const CreateCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: topBar(context, 'Create'),
      drawer: const DrawerMenu(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your course title',
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your course description',
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.dividerColor.withOpacity(0.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        'Videos',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width * 0.92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: theme.colorScheme.surfaceVariant,
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
