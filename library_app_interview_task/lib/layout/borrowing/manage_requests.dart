import 'package:flutter/material.dart';
import 'package:library_app_interview_task/models/borrow_request.dart';
import 'package:library_app_interview_task/models/enums/borrow_status.dart';
import 'package:library_app_interview_task/shared/local/components/do_action_with_loading.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class ManageBorrowingRequestsScreen extends StatefulWidget {
  const ManageBorrowingRequestsScreen({Key? key, required this.status}) : super(key: key);
  final BorrowStatus status;

  @override
  State<ManageBorrowingRequestsScreen> createState() => _ManageBorrowingRequestsScreenState();
}

class _ManageBorrowingRequestsScreenState extends State<ManageBorrowingRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Requests'),
      ),
      body: FutureBuilder(
        future: FirebaseProvider.instance.getBindingBorrowingRequests(widget.status.index),
        builder: (BuildContext context, AsyncSnapshot<List<BorrowRequest>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                child: Text(
                  'No Requests',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }
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
                                    if (widget.status == BorrowStatus.returnRequested)
                                      buildText('Lender\'s Name      ', context),
                                    if (widget.status == BorrowStatus.returnRequested)
                                      const SizedBox(height: 10.0),
                                    buildText('Borrow Request Time ', context),
                                    if (widget.status == BorrowStatus.returnRequested)
                                      const SizedBox(height: 10.0),
                                    if (widget.status == BorrowStatus.returnRequested)
                                      buildText('Borrow Response Time', context),
                                    if (widget.status == BorrowStatus.returnRequested)
                                      const SizedBox(height: 10.0),
                                    if (widget.status == BorrowStatus.returnRequested)
                                      buildText('Return Request Time ', context),
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
                                      if (widget.status == BorrowStatus.returnRequested)
                                        buildText(':  ${req.lenderStaffName ?? ''}', context),
                                      if (widget.status == BorrowStatus.returnRequested)
                                        const SizedBox(height: 10.0),
                                      buildText(':  ${req.borrowRequestTime?.toString().substring(0, 16) ?? ''}', context),
                                        const SizedBox(height: 10.0),
                                      if (widget.status == BorrowStatus.returnRequested)
                                        buildText(':  ${req.borrowResponseTime?.toString().substring(0, 16) ?? ''}', context),
                                      if (widget.status == BorrowStatus.returnRequested)
                                        const SizedBox(height: 10.0),
                                      if (widget.status == BorrowStatus.returnRequested)
                                        buildText(':  ${req.returnRequestTime?.toString().substring(0, 16) ?? ''}', context),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                              ),
                              onPressed: () async {
                                await doActionWithLoading(context, () async {
                                  BorrowRequest newReq = snapshot.data![index];
                                  if (widget.status == BorrowStatus.borrowRequested) {
                                    newReq.status = BorrowStatus.borrowApproved;
                                    newReq.borrowResponseTime = DateTime.now();
                                    newReq.borrowerStaffUid =
                                        UserProvider.instance.currentUser!.uid;
                                    await FirebaseProvider.instance.acceptBorrowBookRequest(newReq);
                                  }
                                  else if (widget.status == BorrowStatus.returnRequested) {
                                    newReq.status = BorrowStatus.returned;
                                    newReq.returnResponseTime = DateTime.now();
                                    newReq.returnerStaffUid =
                                        UserProvider.instance.currentUser!.uid;
                                    await FirebaseProvider.instance.acceptReturnBookRequest(newReq);
                                  }
                                });
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                            ),
                          ),
                          if (widget.status == BorrowStatus.borrowRequested)
                          const SizedBox(width: 20.0),
                          if (widget.status == BorrowStatus.borrowRequested)
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).errorColor),
                              ),
                              onPressed: () async {
                                await doActionWithLoading(context, () async {
                                  BorrowRequest newReq = snapshot.data![index];
                                  newReq.status = BorrowStatus.borrowRejected;
                                  newReq.borrowResponseTime = DateTime.now();
                                  newReq.borrowerStaffUid = UserProvider.instance.currentUser!.uid;
                                  await FirebaseProvider.instance.rejectBorrowBookRequest(newReq);
                                });
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.remove),
                              label: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildText(String text, BuildContext context) {
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
