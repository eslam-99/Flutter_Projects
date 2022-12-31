import 'package:flutter/material.dart';
import 'package:library_app_interview_task/models/borrow_request.dart';
import 'package:library_app_interview_task/models/enums/borrow_status.dart';
import 'package:library_app_interview_task/shared/local/components/do_action_with_loading.dart';
import 'package:library_app_interview_task/shared/local/constants.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class BorrowingHistoryScreen extends StatefulWidget {
  const BorrowingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BorrowingHistoryScreen> createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder(
        future: FirebaseProvider.instance.getBorrowingRequestsForStudent(
            UserProvider.instance.currentUser!.uid!),
        builder: (BuildContext context,
            AsyncSnapshot<List<BorrowRequest>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                BorrowRequest req = snapshot.data![index];
                return Container(
                  width: double.infinity,
                  // height: 100.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          // expandedAlignment: Alignment.centerLeft,
                          leading: Icon(
                            req.status == BorrowStatus.borrowRequested ? Icons.timer_outlined :
                              req.status == BorrowStatus.borrowApproved ? Icons.check :
                                req.status == BorrowStatus.borrowRejected ? Icons.remove :
                                  req.status == BorrowStatus.returnRequested ? Icons.timer :
                                    req.status == BorrowStatus.returned ? Icons.check_circle : null
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildText(req.bookName ?? 'Unknown Book',context),
                            ],
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    buildText('Student Name        ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Request Status      ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Lender\'s Name      ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Retriever\'s Name   ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Borrow Request Time ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Borrow Response Time', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Return Request Time ', context),
                                    const SizedBox(height: 10.0),
                                    buildText('Return Response Time', context),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // const SizedBox(height: 10.0),
                                      // Text('Book Name : ${req.bookName ?? ''}', overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.studentName ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${AppConstants.borrowingStatus![req.status?.index ?? 99]}', context),
                                      // buildText(':  ${req.status?.name ?? 'Unknown Status'}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.lenderStaffName ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.retrieverStaffName ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.borrowRequestTime?.toString().substring(0, 16) ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.borrowResponseTime?.toString().substring(0, 16) ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.returnRequestTime?.toString().substring(0, 16) ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                      buildText(':  ${req.returnResponseTime?.toString().substring(0, 16) ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (req.status == BorrowStatus.borrowRequested)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => Theme.of(context).errorColor),
                                  // backgroundColor: Theme.of(context).errorColor,
                                ),
                                onPressed: () async {
                                  await doActionWithLoading(context, () async {
                                    await FirebaseProvider.instance
                                        .deleteBorrowRequest(req.uid!);
                                  });
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete_forever),
                                label: const Text(
                                  'Cancel Request',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (req.status == BorrowStatus.borrowApproved)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => Theme.of(context).primaryColor),
                                  // backgroundColor: Theme.of(context).errorColor,
                                ),
                                onPressed: () async {
                                  await doActionWithLoading(context, () async {
                                    await FirebaseProvider.instance
                                        .addReturnRequest(UserProvider.instance.currentUser!.uid!, req.uid!);
                                  });
                                  setState(() {});
                                },
                                icon: const Icon(Icons.keyboard_return),
                                label: const Text(
                                  'Return Book',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Text buildText(String text, BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
