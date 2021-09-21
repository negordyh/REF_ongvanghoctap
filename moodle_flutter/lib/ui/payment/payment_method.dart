import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/bee_service/payment/vnpay_service.dart';
import 'package:moodle_flutter/bee_service/payment/zalopay_service/create_order_response.dart';
import 'package:moodle_flutter/moodle/core/core_course_get_courses_by_field.dart';
import 'package:moodle_flutter/moodle/enroll/enrol_manual_enrol_users.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';
import 'package:moodle_flutter/ui/components/alert_error_dialog.dart';
import 'package:moodle_flutter/ui/components/index.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';

class PaymentMethod extends StatefulWidget {
  final CoursesByFieldResponse course;

  PaymentMethod({Key key, this.course}) : super(key: key);
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  int value = 0;
  final paymentIcons = [
    AssetImage("assets/icons/logo-zalopay2.png"),
    AssetImage("assets/icons/logo-vnpay.png"),
  ];
  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    final paymentLabels = [
      AppLocalizations.of(context).translate('zalopay'),
      AppLocalizations.of(context).translate('vnpay'),
    ]; //'Ví MoMo',
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(
        size: deviceSize,
        title: AppLocalizations.of(context).translate('payment_confirmation'),
        image: "assets/images/payment.jpeg",
      ),
      body: Column(
        children: [
          getItem('${AppLocalizations.of(context).translate('course_name')}: ',
              widget.course.fullName),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Divider(
              height: 1,
              color: Colors.blueAccent,
            ),
          ),
          getItem('${AppLocalizations.of(context).translate('price')}: ',
              '${widget.course.price} đồng'),
          getItem('${AppLocalizations.of(context).translate('discount')}: ',
              '-${widget.course.discount / 100 * widget.course.price} đồng'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Divider(
              height: 1,
              color: Colors.blueAccent,
            ),
          ),
          getItem('${AppLocalizations.of(context).translate('total')}: ',
              '${(100 - widget.course.discount) / 100 * widget.course.price} đồng'),
          getItem(
              '${AppLocalizations.of(context).translate('payment_method')}: '),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0, 40, 0),
                  child: Divider(
                    height: 1,
                  ),
                );
              },
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    activeColor: Colors.amber,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i),
                  ),
                  title: Text(
                    paymentLabels[index],
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Image(
                      image: paymentIcons[index],
                      alignment: Alignment.centerRight,
                      height: 50.0,
                      width: 80.0,
                    ),
                  ),
                );
              },
            ),
          ),
          _buttonChoose(AppLocalizations.of(context).translate('pay_now'),
          ),
          SizedBox(height: deviceSize.height * 0.05),
        ],
      ),
    );
  }

  Widget getItem(String title, [String data]) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 20.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
        data == null
            ? Container()
            : Flexible(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
                    child: Text(
                      data, //'Chọn phương thức thanh toán',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buttonChoose(String title) => RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 60.0),
        shape: StadiumBorder(),
        child: AutoSizeText(
          title,
          style: TextStyle(fontSize: 20,color: Colors.white),
          maxLines: 1,
        ),
        color: const Color(0xFF425DAE),
        onPressed: () {
          this.value == 1 ? paymentVNPay() : paymentZaloPay();
        },
      );

  void paymentZaloPay() async {
    int amount = widget.course.price;
    if (amount < 1000 || amount > 1000000) {
      logger.i("Invalid Amount");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      var result = await ZaloPayService.getUrlPayment(amount, widget.course.id);
      if (result != null) {
        Navigator.pop(context);
        logger.i("zpTransToken ${result.zptranstoken}");
        FlutterZaloPaySdk.payOrder(zpToken: result.zptranstoken)
            .listen((event) async {
          switch (event) {
            case FlutterZaloPayStatus.cancelled:
              showDialog(
                context: context,
                builder: (context) => CustomErrorDialog(
                  title: 'ZaloPay',
                  description: 'Bạn đã hủy thanh toán',
                ),
              );
              logger.i("User Huỷ Thanh Toán");
              break;
            case FlutterZaloPayStatus.success:
              await EnrolManualEnrolUsersRequest(widget.course.id)
                  .fetchUsingTokenAdmin();
              Navigator.pop(
                  context); //Until(context, ModalRoute.withName('/home'));
              Navigator.pushReplacementNamed(context, "/home");
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title: 'ZaloPay',
                  description: 'Thanh toán thành công',
                ),
              );
              logger.i("Thanh toán thành công");
              break;
            case FlutterZaloPayStatus.failed:
              showDialog(
                context: context,
                builder: (context) => CustomErrorDialog(
                  title: 'ZaloPay',
                  description: 'Thanh toán thất bại',
                ),
              );
              logger.i("Thanh toán thất bại");
              break;
            default:
              showDialog(
                context: context,
                builder: (context) => CustomErrorDialog(
                  title: 'ZaloPay',
                  description: 'Thanh toán thất bại',
                ),
              );
              logger.i("Thanh toán thất bại");
              break;
          }
        });
      }
    }
  }

  void paymentVNPay() async {
    String url =
        await VNPayService.getUrlPayment(widget.course.id, widget.course.price);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
