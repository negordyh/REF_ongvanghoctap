import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/gradereport/gradereport_user_get_grade_items.dart';
import 'package:moodle_flutter/ui/components/appbar_custom.dart';
import 'package:moodle_flutter/utils/language.dart';
import 'package:moodle_flutter/utils/static_type.dart';
import 'components/chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCourse extends StatelessWidget {
  List<GraderReportUserGetGradeItems> gradeReportItems;
  String courseContenName;
  DashboardCourse(this.gradeReportItems, this.courseContenName);
  @override
  Widget build(BuildContext context) {
    logger.d(gradeReportItems.toString());
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarCustom(
        size: size,
        title: AppLocalizations.of(context).translate('statistics'),
        image: "assets/images/sinh-hoc.jpg",
      ),
      backgroundColor: Color(0xFF232133),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        courseContenName,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Quando",
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                getCourseStats(context),
                                SizedBox(height: 16.0),
                                getChartStat(),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getChartStat() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chart",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.0),
          Chart(),
        ],
      ),
    );
  }

  Widget getCourseStats(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 16.0),
        gradeReportItems.length == 0
            ? Container()
            : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: gradeReportItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) =>
                    statsCard(context, gradeReportItems[index]),
              )
      ],
    );
  }

  Widget statsCard(BuildContext context, GraderReportUserGetGradeItems info) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x81138981),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.network(info.itemmodule == ModType.QUIZ
                    ? "http://ongvanghoctap.edu.vn/theme/image.php?theme=klass&component=quiz&image=icon"
                    : "http://ongvanghoctap.edu.vn/theme/image.php?theme=klass&component=h5pactivity&image=icon"),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: _size.width * 0.55,
                  child: Text(
                    info.itemname,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            "${info.graderaw.toStringAsFixed(2)}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "điểm",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.cyan, fontSize: 15),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          progressLine(
            Color(0xFF007EE5),
            info.graderaw / info.grademax,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.grademin}",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white70),
              ),
              Text(
                "${info.grademax} điểm",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget progressLine(Color color, double percentage) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * percentage,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
