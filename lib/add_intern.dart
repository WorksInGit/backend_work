import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIntern extends StatefulWidget {
  const AddIntern({super.key});

  @override
  State<AddIntern> createState() => _AddInternState();
}

class _AddInternState extends State<AddIntern> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addIntern() {
    if (nameController.text.isEmpty || phoneNoController.text.isEmpty || selectedValue == 'Select Course Duration') {
      Fluttertoast.showToast(msg: 'Please fill are fields to continue');
      return Future.value();
    }
    return firestore.collection('interns')
    .add({
      'name': nameController.text,
      'phone': phoneNoController.text,
      'duration': selectedValue
    }).then((value) {
     Fluttertoast.showToast(msg: 'Intern details added successfully');
     nameController.clear();
     phoneNoController.clear();
     setState(() {
       selectedValue = 'Select Course Duration';
     });
    })
     .catchError((error) {
      Fluttertoast.showToast(msg: 'Failed to add intern details: $error');
     });
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  final List<String> lists = ['6 Months', '8 Months', '1 Year'];
  String selectedValue = 'Select Course Duration';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 20.h, right: 50.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp),
                ),
                Text('Intern',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp)),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 45.w),
                child: Row(
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.poppins(
                          fontSize: 25.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      label: Text(
                        'Enter name of the intern',
                        style: GoogleFonts.poppins(),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 45.w),
                child: Row(
                  children: [
                    Text(
                      'Phone No',
                      style: GoogleFonts.poppins(
                          fontSize: 25.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: TextField(
                  controller: phoneNoController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      label: Text(
                        'Enter contact no',
                        style: GoogleFonts.poppins(),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 45.w),
                child: Row(
                  children: [
                    Text(
                      'Duration',
                      style: GoogleFonts.poppins(
                          fontSize: 25.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    width: 330.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.6.w),
                        borderRadius: BorderRadius.circular(30.r)),
                    child: Padding(
                      padding: EdgeInsets.all(15.0.r),
                      child: DropdownButton<String>(
                          underline: SizedBox.shrink(),
                          hint: Text(selectedValue.toString()),
                          items: lists.map((String list) {
                            return DropdownMenuItem(
                                value: list, child: Text(list));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          }),
                    ),
                  )),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: () {
                addIntern();
                },
                child: Container(
                  width: 200.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.black],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(40.r)),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

