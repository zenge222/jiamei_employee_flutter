const serviceUrl = "https://cloud.jiameirl.com/jiamei-employee/";
//const serviceUrl = "http://192.168.1.59:8002/jiamei-employee/";
const servicePath = {
  // 获取短信验证码
  'getPhoneCode': serviceUrl + "employee/login/smsCode",
  // 登录
  'employeeLogin': serviceUrl + "employee/login",
  // 获取tabs红点标记数。面试任务数量、服务任务数量
  'indexCount': serviceUrl + "employee/orderTask/indexCount",
  // 分页获取面试任务列表
  'meetList': serviceUrl + "employee/orderTask/waitMeetList",
  // 分页获取服务任务列表
  'taskListByStatus': serviceUrl + "employee/orderTask/getEmployeeTaskListByStatus",
  // 获取员工自身的头像、姓名、手机号、门店信息
  'userInfo': serviceUrl + "employee/my/info",
  // 工时统计、获取员工某月的所有服务日期和服务状态
  'monthTaskSum': serviceUrl + "employee/orderTask/monthTaskSum",
  // 获取员工某天的所有服务任务
  'getTaskByDate': serviceUrl + "employee/orderTask/getTaskByDate",
  // 获取服务任务详情
  'orderTaskInfo': serviceUrl + "employee/orderTask/info",
  // 请假申请
  'vacationAdd': serviceUrl + "employee/vacation/add",
  // 分页获取自身请假列表
  'selfVacationList': serviceUrl + "employee/vacation/selfVacationList",
  // 分页获取自身门店可申领的物品列表
  'storeMaterialStockList': serviceUrl + "material/claim/storeMaterialStockList",
  // 物料申领
  'claimClaim': serviceUrl + "material/claim/claim",
  // 物料申领
  'selfMaterialClaimList': serviceUrl + "material/claim/selfMaterialClaimList",
  // 获取未读消息数量
  'unreadNotifyCount': serviceUrl + "employee/common/unreadNotifyCount",
  // 分页获取自身消息通知
  'selfNotifyList': serviceUrl + "employee/common/selfNotifyList",
  // 阅读所有消息
  'readAllNotify': serviceUrl + "employee/common/readAllNotify",
  // 获取某条消息详情
  'notifyInfo': serviceUrl + "employee/common/notifyInfo",
  // 阅读某条消息
  'readNotify': serviceUrl + "employee/common/readNotify",
  // 意见上报
  'addOpinion': serviceUrl + "employee/common/addOpinion",
  // 图片上传
  'uploadImage': serviceUrl + "employee/common/uploadImage",
  // 完成服务
  'finishTask': serviceUrl + "employee/orderTask/finishTask",
  // 开始服务
  'beginTask': serviceUrl + "employee/orderTask/beginTask",
};
