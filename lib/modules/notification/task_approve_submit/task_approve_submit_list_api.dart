import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/message_model.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_model.dart';


class TaskApproveSubmitListAPI {
  Future<Message> doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask({@required dynamic userId, @required dynamic groupId, @required int sourceId, @required int task}) async {
    const URL = 'task/do-approve-submit-with-userId-and-sourceId-and-groupId-and-task';
    try {
      var response = await Http.get('$URL?userId=$userId&groupId=$groupId&sourceId=$sourceId&task=$task');
      if (response.statusCode == 200) {
        return  Message.fromJson(json.decode(response.body));
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

}