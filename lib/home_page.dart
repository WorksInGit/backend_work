import 'package:backend_work/add_intern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> deleteIntern(String docId) {
    return FirebaseFirestore.instance
        .collection('interns')
        .doc(docId)
        .delete()
        .then((value) {
      Fluttertoast.showToast(msg: 'Intern deleted successfully');
    }).catchError((error) {
      Fluttertoast.showToast(msg: 'Failed to delete intern data: $error');
    });
  }

  void confirmDilog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Confirm Deletion',
            style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.white),
          ),
          content: Text(
            'Are you sure to delete the selected intern data?',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteIntern(docId);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flutter',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp),
                ),
                Text('Interns',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddIntern(),
                ));
          },
          child: Icon(
            CupertinoIcons.add_circled_solid,
            size: 40.sp,
            color: Colors.red,
          ),
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('interns').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No interns found'),
              );
            }
            final internDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: internDocs.length,
              itemBuilder: (context, index) {
                var internData =
                    internDocs[index].data() as Map<String, dynamic>;
                String docId = internDocs[index].id;
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Container(
                        width: 400.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.red, Colors.black],
                                begin: Alignment.topRight,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30.r)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Name : ${internData['name']}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Contact no : ${internData['phone']}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Course Duration : ${internData['duration']}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 360.w, top: 65.h),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext) {
                              return EditDetails(
                                docId: docId,
                                internData: internData,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30.r)),
                          child: Icon(
                            Icons.edit_document,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 65.h, left: 10.w),
                      child: InkWell(
                        onTap: () {
                          confirmDilog(context, docId);
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30.r)),
                          child: Icon(
                            CupertinoIcons.delete_solid,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}

class EditDetails extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> internData;
  const EditDetails({Key? key, required this.docId, required this.internData})
      : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.internData['name'];
    phoneNoController.text = widget.internData['phone'];
    selectedValue = widget.internData['duration'];
  }

  Future<void> EditInternDetails() {
    if (nameController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        selectedValue == 'Select Course Duration') {
      Fluttertoast.showToast(msg: 'Please fill all fields to continue');
      return Future.value();
    }
    return FirebaseFirestore.instance
        .collection('interns')
        .doc(widget.docId)
        .update({
      'name': nameController.text,
      'phone': phoneNoController.text,
      'duration': selectedValue
    }).then((value) {
      Fluttertoast.showToast(msg: 'Intern details updted successfuly');
      Navigator.pop(context);
    }).catchError((error) {
      Fluttertoast.showToast(msg: 'Failed to update intern details : $error');
    });
  }

  final List<String> lists = ['6 Months', '8 Months', '1 Year'];
  String selectedValue = 'Select Course Duration';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 45.w),
            child: Row(
              children: [
                Text(
                  'Phone No',
                  style: GoogleFonts.poppins(
                      fontSize: 20.sp, fontWeight: FontWeight.w600),
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
            padding: EdgeInsets.only(left: 45.w),
            child: Row(
              children: [
                Text(
                  'Duration',
                  style: GoogleFonts.poppins(
                      fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
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
                    return DropdownMenuItem(value: list, child: Text(list));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          InkWell(
            onTap: () {
              EditInternDetails();
            },
            child: Container(
              width: 170.w,
              height: 60.h,
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
    );
  }
}
