import 'package:flutter/material.dart';

class WidgetLabelAndContent {
  Widget widget(
      {required String label,
      required String content,
      String? icon,
      double? width,
      Widget? contentWidget,
      bool? isNotTextOverflowEllipsis}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
            Padding(
                padding: const EdgeInsets.only(top: 5),
                child: icon != null
                    ? Row(children: [
                        SizedBox(
                            width: width,
                            child: Text(content,
                                style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                        const Padding(
                            padding: EdgeInsets.only(left: 5), child: null) //GEDocsIcons.icon(icon, width: 18))
                      ])
                    : contentWidget ??
                        SizedBox(
                          width: width,
                          child: Text(content,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              overflow: isNotTextOverflowEllipsis != null && isNotTextOverflowEllipsis
                                  ? null
                                  : TextOverflow.ellipsis),
                        )),
          ],
        ),
      ),
    );
  }
}
