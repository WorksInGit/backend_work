import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            150.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50).r,
              child: TextFormField(
                decoration: InputDecoration(
                    label: Text('Enter your name'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r).r)),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50).r,
              child: TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                    label: Text('Enter your phone no'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r).r)),
              ),
            ),
          Container(
            width: 200.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30).r
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: (){}, child: Text('Login',style: TextStyle(color: Colors.white),)))
          ],
        ),
      ),
    );
  }
}
