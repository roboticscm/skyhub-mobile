import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'dart:async';
import 'package:mobile/l10n/messages_all.dart';
import 'package:mobile/locale/r2.dart';


class L10n {
  String get username => Intl.message('Username', name: 'username');
  String get password => Intl.message('Password', name: 'password');
  String get title => Intl.message('Title', name: 'title');
  String get login => Intl.message('Login', name: 'login');
  String get forgotPassword => Intl.message('Forgot password?', name: 'forgotPassword');
  String get home => Intl.message('Home', name: 'home');
  String get logout => Intl.message('Logout', name: 'logout');
  String get connectingToApiServer => Intl.message('Connecting to API Server...', name: 'connectingToApiServer');
  String get usernameDoesNotExisted => Intl.message('Username does not existed', name: 'usernameDoesNotExisted');
  String get wrongPassword => Intl.message('Wrong password', name: 'wrongPassword');
  String get connectToServerFailed => Intl.message('Connect to Server failed', name: 'connectToServerFailed');
  String get serverConnectionStringDesc => Intl.message('http(s)://ip[domain]:port', name: 'serverConnectionStringDesc');
  String get serverConfig => Intl.message('Server config', name: 'serverConfig');
  String get save => Intl.message('Save', name: 'save');
  String get close => Intl.message('Close', name: 'close');
  String get appName => Intl.message('SkyHub', name: 'appName');
  String get autoLoginNextTimes => Intl.message('Auto login next times', name: 'autoLoginNextTimes');
  String get resetPasswordCheckMail => Intl.message('Please check your email to complete reset password', name: 'resetPasswordCheckMail');
  String get connectionTimeout => Intl.message('Connection timeout (second)', name: 'connectionTimeout');
  String get maybeYourUsernameIsIncorrect_PleaseTryAnotherOne => Intl.message('Maybe your Username is incorrect. Please try another one.', name: 'maybeYourUsernameIsIncorrect_PleaseTryAnotherOne');
  String get pleaseContactToTheAdminToGetAnEmailAddress => Intl.message('Please contact to the Admin to get an Email address.', name: 'pleaseContactToTheAdminToGetAnEmailAddress');
  String get chatServerConnectionStringDesc => Intl.message('ws(s)://ip[domain]:port/path', name: 'chatServerConnectionStringDesc');
  String get more => Intl.message('More', name: 'more');
  String get voiceCall => Intl.message('Voice call', name: 'voiceCall');
  String get videoCall => Intl.message('Video call', name: 'videoCall');
  String get imageServerConnectionStringDesc => Intl.message('http(s)://ip[domain]:port/path', name: 'imageServerConnectionStringDesc');

  String get notification => Intl.message('Notification', name: 'notification');
  String get event => Intl.message('Event', name: 'event');
  String get message => Intl.message('Chat', name: 'message');
  String get task => Intl.message('Task', name: 'task');
  String get calendar => Intl.message('Calendar', name: 'calendar');
  String get callingTo => Intl.message('Calling to', name: 'callingTo');
  String get callingFrom => Intl.message('Calling from', name: 'callingFrom');
  String get typing => Intl.message('Typing...', name: 'typing');
  String get lastAccess => Intl.message('Last access', name: 'lastAccess');
  String get justAccess => Intl.message('Just access', name: 'justAccess');
  String get longTime => Intl.message('Long time', name: 'longTime');
  String get employee => Intl.message('Employee', name: 'employee');
  String get traveling => Intl.message('Travel Request', name: 'traveling');
  String get quotation => Intl.message('Quotation', name: 'quotation');
  String get holiday => Intl.message('Leaves Request', name: 'holiday');
  String get reqInventoryOut => Intl.message('Inventory Out Request', name: 'reqInventoryOut');
  String get reqInventoryOutAddNew => Intl.message('New Inv Out Req', name: 'reqInventoryOutAddNew');
  String get reqInventoryIn => Intl.message('Inventory In Request', name: 'reqInventoryIn');
  String get reqPo => Intl.message('Order Request', name: 'reqPo');
  String get reqPoAddNew => Intl.message('New Order Req', name: 'reqPoAddNew');
  String get po => Intl.message('Order', name: 'po');
  String get youHave => Intl.message('You have', name: 'youHave');
  String get newMessage => Intl.message('new message', name: 'newMessage');
  String get selectEmoji => Intl.message('Select emoji', name: 'selectEmoji');
  String get select => Intl.message('Select', name: 'select');
  String get connectionStatus => Intl.message('Connection status', name: 'connectionStatus');
  String get noConnectionAvailable => Intl.message('No connection is available', name: 'noConnectionAvailable');
  String get unregisterDevice => Intl.message('Your device has not been registered. Please contact Admin', name: 'unregisterDevice');
  String get newDeviceToRegister => Intl.message('There is a new device to register', name: 'newDeviceToRegister');
  String get uuid => Intl.message('Device identity', name: 'uuid');
  String get device => Intl.message('Device', name: 'device');
  String get os => Intl.message('OS', name: 'os');
  String get waitingAdminAccept => Intl.message('Please waiting for Admin to check your Device', name: 'waitingAdminAccept');
  String get pleaseAccept => Intl.message('Please consider new Device', name: 'pleaseAccept');
  String get deviceID => Intl.message('Device ID', name: 'deviceID');
  String get connectToMessageServer => Intl.message('Connect to Message Server', name: 'connectToMessageServer');
  String get connectApiError => Intl.message('Can not connect to API Server', name: 'connectApiError');
  String get advance => Intl.message('Cash Advance', name: 'advance');
  String get reqPayment => Intl.message('Payment request', name: 'reqPayment');
  String get payment => Intl.message('Payment Note', name: 'payment');
  String get receiveNote => Intl.message('Receive Note', name: 'payment');
  String get contract => Intl.message('Contract', name: 'contract');
  String get acceptance => Intl.message('Acceptance', name: 'acceptance');
  String get inspection => Intl.message('Technical Report', name: 'inspection');
  String get repairReport => Intl.message('Repair report', name: 'repairReport');
  String get inventoryIn => Intl.message('Inv-In Receipt', name: 'inventoryIn');
  String get inventoryOut => Intl.message('Inv-Out Receipt', name: 'inventoryOut');
  String get approve => Intl.message('Approve', name: 'approve');
  String get cancelApprove => Intl.message('Cancel Approve', name: 'cancelApprove');
  String get submit => Intl.message('Submit', name: 'submit');
  String get cancelSubmit => Intl.message('Cancel Submit', name: 'cancelSubmit');
  String get deny => Intl.message('Deny', name: 'deny');
  String get finish => Intl.message('Finish', name: 'finish');
  String get noRecordFound => Intl.message('No record found', name: 'noRecordFound');
  String get record => Intl.message('Record(s)', name: 'record');
  String get moreThan => Intl.message('More than', name: 'moreThan');
  String get search => Intl.message('Add # to search exactly', name: 'search');

  String get status => Intl.message('Status', name: 'status');
  String get newStatus => Intl.message('New', name: 'newStatus');
  String get rejectStatus => Intl.message('Denied', name: 'rejectStatus');
  String get waitingStatus => Intl.message('Approve pending', name: 'waitingStatus');
  String get submitStatus => Intl.message('Approved', name: 'submitStatus');
  String get managerStatus => Intl.message('Approved L2', name: 'managerStatus');
  String get approvedStatus => Intl.message('Approved L3', name: 'approvedStatus');
  String get followUpStatus => Intl.message('Monitoring', name: 'followUpStatus');
  String get soldStatus => Intl.message('Sold', name: 'soldStatus');
  String get cancelStatus => Intl.message('Cancelled', name: 'cancelStatus');
  String get timeoutStatus => Intl.message('Timeout', name: 'timeoutStatus');
  String get failedStatus => Intl.message('Failed', name: 'failedStatus');
  String get joinDate => Intl.message('Join date', name: 'joinDate');
  String get trailWorkStatus => Intl.message('Trail work', name: 'trailWorkStatus');
  String get officialStatus => Intl.message('Official', name: 'officialStatus');
  String get leaveJobStatus => Intl.message('Leave job', name: 'leaveJobStatus');
  String get email => Intl.message('Email', name: 'email');
  String get quantity => Intl.message('Quantity', name: 'quantity');
  String get unit => Intl.message('Unit', name: 'unit');
  String get inventory => Intl.message('Inventory', name: 'inventory');
  String get model => Intl.message('Model', name: 'model');
  String get serial => Intl.message('Serial', name: 'serial');
  String get lot => Intl.message('LOT', name: 'lot');
  String get expireDate => Intl.message('Exp', name: 'expireDate');
  String get orderBy => Intl.message('Ordered by', name: 'orderBy');
  String get requesterForDelivery => Intl.message('Requester for delivery', name: 'requesterForDelivery');
  String get item => Intl.message('Item', name: 'item');
  String get totalQuantity => Intl.message('Total Qty', name: 'totalQuantity');

  String get salesItem => Intl.message('Sales item', name: 'salesItem');
  String get samplesItem => Intl.message('Samples item', name: 'samplesItem');
  String get consignmentItem => Intl.message('Consignment item', name: 'consignmentItem');
  String get forLoanItem => Intl.message('For loan item', name: 'forLoanItem');
  String get forRentItem => Intl.message('For rent item', name: 'forRentItem');
  String get internalLoanItem => Intl.message('Internal loan item', name: 'internalLoanItem');
  String get loanedItem => Intl.message('Loaned Item', name: 'loanedItem');
  String get warrantyItem => Intl.message('Warranty item', name: 'warrantyItem');
  String get damagedItem => Intl.message('Damaged item', name: 'damagedItem');
  String get promotionItem => Intl.message('Promotion item', name: 'promotionItem');
  String get othersItem => Intl.message('Others item', name: 'othersItem');
  String get cancel => Intl.message('Cancel', name: 'cancel');
  String get barcode => Intl.message('Barcode', name: 'barcode');
  String get office => Intl.message('Office', name: 'office');
  String get services => Intl.message('Services', name: 'services');
  String get accounting => Intl.message('Accounting', name: 'accounting');
  String get administrative => Intl.message('Administrative', name: 'administrative');
  String get general => Intl.message('General', name: 'general');
  String get purchase => Intl.message('Purchase', name: 'purchase');
  String get today => Intl.message('Today', name: 'today');
  String get view => Intl.message('View', name: 'view');

  String get year => Intl.message('Year', name: 'year');
  String get month => Intl.message('Month', name: 'month');
  String get week => Intl.message('Week', name: 'week');
  String get day => Intl.message('Day', name: 'day');
  String get dayInLowerCase => Intl.message('day', name: 'day');

  String get shortMonday => Intl.message('M', name: 'shortMonday');
  String get shortTuesday => Intl.message('T', name: 'shortTuesday');
  String get shortWednesday => Intl.message('W', name: 'shortWednesday');
  String get shortThursday => Intl.message('T', name: 'shortThursday');
  String get shortFriday => Intl.message('F', name: 'shortFriday');
  String get shortSaturday => Intl.message('S', name: 'shortSaturday');
  String get shortSunday => Intl.message('S', name: 'shortSunday');

  String get monday => Intl.message('Mon', name: 'monday');
  String get tuesday => Intl.message('Tue', name: 'tuesday');
  String get wednesday => Intl.message('Wed', name: 'wednesday');
  String get thursday => Intl.message('Thu', name: 'thursday');
  String get friday => Intl.message('Fri', name: 'friday');
  String get saturday => Intl.message('Sat', name: 'saturday');
  String get sunday => Intl.message('Sun', name: 'sunday');

  String get january => Intl.message('Jan', name: 'january');
  String get february => Intl.message('Feb', name: 'february');
  String get march => Intl.message('Mar', name: 'march');
  String get april => Intl.message('Apr', name: 'april');
  String get may => Intl.message('May', name: 'may');
  String get june => Intl.message('Jun', name: 'june');
  String get july => Intl.message('Jul', name: 'july');
  String get august => Intl.message('Aug', name: 'august');
  String get september => Intl.message('Sep', name: 'september');
  String get october => Intl.message('Oct', name: 'october');
  String get november => Intl.message('Nov', name: 'november');
  String get december => Intl.message('Dec', name: 'december');
  String get filter => Intl.message('Filter', name: 'filter');

  String get branch => Intl.message('Branch', name: 'branch');
  String get department => Intl.message('Department', name: 'department');
  String get group => Intl.message('Group', name: 'group');
  String get meetings => Intl.message('Meetings', name: 'meetings');
  String get works => Intl.message('Works', name: 'works');
  String get reminder => Intl.message('Reminder', name: 'reminder');
  String get promotion => Intl.message('Promotion', name: 'promotion');
  String get potential => Intl.message('Potential', name: 'potential');
  String get opportunity => Intl.message('Opportunity', name: 'opportunity');

  String get all => Intl.message('All', name: 'all');
  String get addEvent => Intl.message('Add event', name: 'addEvent');
  String get editEvent => Intl.message('Edit event', name: 'editEvent');
  String get periodOfTime => Intl.message('Period of time', name: 'periodOfTime');
  String get location => Intl.message('Location', name: 'location');
  String get allDay => Intl.message('All day', name: 'allDay');
  String get participants => Intl.message('Participants', name: 'participants');
  String get range => Intl.message('Range', name: 'range');
  String get busy => Intl.message('Busy', name: 'busy');
  String get idle => Intl.message('Idle', name: 'idle');
  String get fromDateTime => Intl.message('From date/time', name: 'fromDateTime');
  String get toDateTime => Intl.message('To date/time', name: 'toDateTime');
  String get notes => Intl.message('Notes', name: 'notes');
  String get notice => Intl.message('Notice', name: 'notice');
  String get dayAt => Intl.message('day(s), at', name: 'dayAt');
  String get sales => Intl.message('Sales', name: 'sales');
  String get tapToSeeMore => Intl.message('Tap to see more', name: 'tapToSeeMore');
  String get totalItem => Intl.message('Total item', name: 'totalItem');
  String get toggleBetweenGraphAndAgendaMode => Intl.message('Toggle between graph and agenda mode', name: 'toggleBetweenGraphAndAgendaMode');
  String get noDataFound => Intl.message('No data found', name: 'noDataFound');
  String get invisibleEvent => Intl.message('Invisible event', name: 'invisibleItem');
  String get resourceError => Intl.message('Resource error', name: 'resourceError');
  String get moreEventList => Intl.message('More events', name: 'moreEventList');
  String get delete => Intl.message('Delete', name: 'delete');
  String get yes => Intl.message('Yes', name: 'yes');
  String get no => Intl.message('No', name: 'no');
  String get doYouWantToDelete => Intl.message('Do you want to delete', name: 'doYouWantToDelete');
  String get youMustEnterTheTitle => Intl.message('You must enter the [Title]', name: 'youMustEnterTheTitle');
  String get youMustEnterTheFromDateTime => Intl.message('You must enter the [From date time]', name: 'youMustEnterTheFromDateTime');
  String get youMustEnterTheToDateTime => Intl.message('You must enter the [To date time]', name: 'youMustEnterTheToDateTime');
  String get fromDateTimeMustBeLessThanToDateTime => Intl.message('[Start date] must be less than [End date]', name: 'fromDateTimeMustBeLessThanToDateTime');
  String get allUsers => Intl.message('All Users', name: 'allUsers');
  String get minute => Intl.message('Minute', name: 'minute');
  String get hour => Intl.message('Hour', name: 'hour');
  String get at => Intl.message('at', name: 'at');
  String get valueOfTimeMustGreaterThanZero => Intl.message('Value of time must be greater than Zero', name: 'valueOfTimeMustGreaterThanZero');
  String get youMustEnterNoticeTime => Intl.message('You must enter Notice time (at)', name: 'youMustEnterNoticeTime');
  String get addNew => Intl.message('New', name: 'addNew');
  String get mode => Intl.message('Mode', name: 'mode');
  String get numOfDay => Intl.message('Num day', name: 'numOfDay');
  String get leavesRequestType => Intl.message('LQ. type', name: 'leavesRequestType');
  String get content => Intl.message('Content', name: 'content');
  String get annualLeave => Intl.message('Annual leave', name: 'annualLeave');
  String get publicLeave => Intl.message('Public leave', name: 'publicLeave');
  String get marriedLeave => Intl.message('Married leave', name: 'marriedLeave');
  String get sickLeave => Intl.message('Sick leave', name: 'sickLeave');
  String get funeralLeave => Intl.message('Funeral leave', name: 'funeralLeave');
  String get maternityLeave => Intl.message('Maternity leave', name: 'maternityLeave');
  String get personalLeave => Intl.message('Personal leave (Unpaid)', name: 'personalLeave');
  String get injuryLeave => Intl.message('Injury leave', name: 'injuryLeave');
  String get specialLeave => Intl.message('Special leave (Others)', name: 'specialLeave');
  String get totalLeave => Intl.message('Total leave', name: 'totalLeave');
  String get compensatedLeave => Intl.message('Compensated leave', name: 'compensatedLeave');
  String get used => Intl.message('Used', name: 'used');
  String get remained => Intl.message('Remained', name: 'remained');
  String get createdDate => Intl.message('Created date', name: 'createdDate');
  String get refNo => Intl.message('REF. No.', name: 'refNo');
  String get youMustEnterTheContent => Intl.message('You must enter the [Content]', name: 'youMustEnterTheContent');
  String get youMustSelectLeavesRequestType => Intl.message('You must select [Leaves request Type]', name: 'youMustSelectLeavesRequestType');
  String get youHaveUsedUpTheLeavesDay => Intl.message('You have used up the Leaves day. Please select [Personal leave (Unpaid)]', name: 'youHaveUsedUpTheLeavesDay');
  String get leavesDay => Intl.message('Leaves day #', name: 'leavesDay');
  String get leavesDayMustBeGreaterThanZero => Intl.message('Leaves day must be greater than Zero', name: 'leavesDayMustBeGreaterThanZero');
  String get doYouWantToSelectThis => Intl.message('Do you want to select this', name: 'doYouWantToSelectLeavesRequestType');
  String get update => Intl.message('Update', name: 'update');
  String get createNew => Intl.message('Create', name: 'createNew');
  String get approvedBy => Intl.message('Approved by', name: 'approvedBy');
  String get underConstruction => Intl.message('Under Construction', name: 'underConstruction');
  String get quickSearchInventoryOnly => Intl.message('Quick search Inventory only', name: 'quickSearchInventoryOnly');
  String get humanResources => Intl.message('Human resources', name: 'humanResources');
  String get areYouSure => Intl.message('Are you sure', name: 'areYouSure');
  String get youHaveNotBeenGrantedTheLeavesDay => Intl.message('You have not been granted the leaves day', name: 'youHaveNotBeenGrantedTheLeavesDay');
  String get pleaseSelectAnEmployee => Intl.message('Please select an Employee', name: 'pleaseSelectAnEmployee');
  String get pleaseSelectStatus => Intl.message('Please select a Status', name: 'pleaseSelectStatus');
  String get newOrWaitingStatus => Intl.message('New or Approve pending', name: 'newOrWaitingStatus');
  String get pleaseSelectYear => Intl.message('Please select a Year', name: 'pleaseSelectYear');
  String get customer => Intl.message('Customer', name: 'customer');
  String get unitPrice => Intl.message('Unit price', name: 'unitPrice');

  String get deliveredQty => Intl.message('Delivered', name: 'deliveredQty');
  String get remainedQty => Intl.message('Remained', name: 'remainedQty');
  String get stockQty => Intl.message('Stock', name: 'stockQty');
  String get totalPrice => Intl.message('Total Price', name: 'totalPrice');
  String get orderRequest => Intl.message('Order Request', name: 'orderRequest');
  String get grandTotal => Intl.message('Grand total', name: 'grandTotal');

  String get typeSales => Intl.message('Sales', name: 'typeSales');
  String get typeFreeSample => Intl.message('FreeSample', name: 'typeFreeSample');
  String get typeConsignment => Intl.message('Consignment', name: 'typeConsignment');
  String get typeLoan => Intl.message('Loan', name: 'typeLoan');
  String get typeLease => Intl.message('Lease', name: 'typeLease');
  String get typeLoanInternal => Intl.message('Internal Loan', name: 'typeLoanInternal');
  String get typeReturn => Intl.message('Return', name: 'typeReturn');
  String get typeChange => Intl.message('Change', name: 'typeChange');
  String get typeDamaged => Intl.message('Damaged', name: 'typeDamaged');
  String get typeLoss => Intl.message('Loss', name: 'typeLoss');
  String get typeWarranty => Intl.message('Warranty', name: 'typeWarranty');
  String get typeLiquidation => Intl.message('Liquidation', name: 'typeLiquidation');
  String get typeInventory => Intl.message('Inventory', name: 'typeInventory');
  String get typeOther => Intl.message('Other', name: 'typeOther');
  String get stockerStatus => Intl.message('Stocker', name: 'stockerStatus');
  String get doneStatus => Intl.message('Completed', name: 'doneStatus');
  String get inventoryType => Intl.message('Type', name: 'inventoryType');
  String get itemCode => Intl.message('Item code', name: 'itemCode');
  String get supplier => Intl.message('Supplier', name: 'supplier');
  String get itemName => Intl.message('Item name', name: 'itemName');
  String get usernameMustBeNotEmpty => Intl.message('Username must be not empty', name: 'usernameMustBeNotEmpty');
  String get passwordMustBeNotEmpty => Intl.message('Password must be not empty', name: 'passwordMustBeNotEmpty');
  String get outForPartner => Intl.message('For', name: 'outForPartner');
  String get waitingOut => Intl.message('Booking', name: 'waitingOut');
  String get defaultWarehouse => Intl.message('Mặc định', name: 'defaultWarehouse');
  String get saveOrUpdateSuccess => Intl.message('Save or Update sucessful', name: 'saveOrUpdateSuccess');
  String get noCode => Intl.message('NO CODE', name: 'nodeCode');
  String get inventoryInfo => Intl.message('Inventory Infomation', name: 'inventoryInfo');
  String get shortDeliveredQty => Intl.message('Q\'ty', name: 'shortDeliveredQty');
  String get shortStockQty => Intl.message('Stock', name: 'shortStockQty');
  String get fromQuotation => Intl.message('From Quotation', name: 'fromQuotation');
  String get youMustSelectAtLessOneItem => Intl.message('You must select at less one Item', name: 'youMustSelectAtLessOneItem');
  String get showLess => Intl.message('Less', name: 'showLess');
  String get showMore => Intl.message('More', name: 'showMore');

  String get lotModel => Intl.message('Lot/Model', name: 'lotModel');
  String get dateSerial => Intl.message('Exp./Serial', name: 'dateSerial');
  String get advancedSearch => Intl.message('Advanced search', name: 'advancedSearch');

  String get youMustSelectItemAtLine => Intl.message('You must select an Item at line', name: 'youMustSelectItemAtLine');
  String get atLine => Intl.message('at line', name: 'atLine');
  String get isInvalid => Intl.message('is invalid', name: 'isInvalid');
  String get invalidateDate => Intl.message('Invalidate Date', name: 'invalidateDate');
  String get leap => Intl.message('leap', name: 'leap');
  String get shortLunar => Intl.message('Lunar', name: 'shortLunar');
  String get limitDate => Intl.message('Deadline', name: 'limitDate');
  String get quotationHasNotBeenApproved => Intl.message('Quotation has not been approved', name: 'quotationHasNotBeenApproved');
  String get reqInventoryOutHasNotBeenApproved => Intl.message('ReqInventoryOut has not been approved', name: 'reqInventoryOutHasNotBeenApproved');
  String get noEmployee => Intl.message('No Employee', name: 'noEmployee');
  String get edit => Intl.message('Edit', name: 'edit');
  String get maybeYourTokenIsExpired_doDouwantResigin => Intl.message('Maybe your token is expired. Dou you want resign?', name: 'maybeYourTokenIsExpired_doDouwantResigin');
  String get tokenExpire => Intl.message('Token expired', name: 'tokenExpire');
  String get settings => Intl.message('Settings', name: 'settings');
  String get language => Intl.message('Language', name: 'language');

  String get system => Intl.message('System', name: 'system');
  String get vietnamese => Intl.message('Tiếng việt', name: 'vietnamese');
  String get english => Intl.message('English', name: 'english');
  String get allValid => Intl.message('All-valid', name: 'allValid');

  String get contactName => Intl.message('Contact name', name: 'contactName');
  String get contactPhone => Intl.message('Contact phone', name: 'contactPhone');
  String get undoneStatus => Intl.message('Undone', name: 'undoneStatus');
  String get waitPoStatus=> Intl.message('Waiting Production', name: 'waitPoStatus');
  String get noEnoughStatus=> Intl.message('No Enough', name: 'noEnoughStatus');
  String get enoughStatus=> Intl.message('Enough', name: 'enoughStatus');
  String get processingStatus=> Intl.message("Processing", name: 'processingStatus');


  String  get pur11TableProduct=> Intl.message("Product", name: 'pur11TableProduct');
  String  get pur11TableNo=> Intl.message("No", name: 'pur11TableNo');
  String  get pur11TableCode=> Intl.message("Code", name: 'pur11TableCode');
  String  get pur11TableDate=> Intl.message("Date", name: 'pur11TableDate');
  String  get pur11TableRequester=> Intl.message("Requester", name: 'pur11TableRequester');
  String  get pur11TableCreator=> Intl.message("Creator", name: 'pur11TableCreator');
  String  get pur11TableSupplier=> Intl.message("Supplier", name: 'pur11TableSupplier');
  String  get pur11TableBrand=> Intl.message("Brand", name: 'pur11TableBrand');
  String  get pur11TableStock=> Intl.message("Stock", name: 'pur11TableStock');
  String  get pur11TableContent=> Intl.message("Content", name: 'pur11TableContent');
  String  get pur11TableStatus=> Intl.message("Status", name: 'pur11TableStatus');
  String  get pur11TableCustomer=> Intl.message("Customer", name: 'pur11TableCustomer');
  String  get pur11TableDelivereddate=> Intl.message("Delivered date", name: 'pur11TableDelivereddate');
  String  get pur11TableItemcode=> Intl.message("Item code", name: 'pur11TableItemcode');
  String  get pur11TableItemcodeorder=> Intl.message("Item code order", name: 'pur11TableItemcodeorder');
  String  get pur11TableItemname=> Intl.message("Item name", name: 'pur11TableItemname');
  String  get pur11TableItemnameorigin=> Intl.message("Itemname origin", name: 'pur11TableItemnameorigin');
  String  get pur11TablePublishCustomer=> Intl.message("Publish customer", name: 'pur11TablePublishCustomer');
  String  get pur11TableQuantity=> Intl.message("Quantity", name: 'pur11TableQuantity');
  String  get pur11TableUnit=> Intl.message("Unit", name: 'pur11TableUnit');
  String  get pur11TableQuotationcode=> Intl.message("Quotation code", name: 'pur11TableQuotationcode');
  String  get pur11TableContractcode=> Intl.message("Contract code", name: 'pur11TableContractcode');
  String  get pur11TableReqInventoryoutcode=> Intl.message("ReqInventoryout code", name: 'pur11TableReqInventoryoutcode');
  String  get pur11TableRequestdate=> Intl.message("Request date", name: 'processingStatus');
  String  get pur11TableNotes=> Intl.message("Notes", name: 'pur11TableNotes');
  String  get pur11TableInventory=> Intl.message("Inventory", name: 'pur11TableInventory');
  String  get pur11TableStockView=> Intl.message("Stock view", name: 'pur11TableStockView');
  String  get pur11TableInputqty=> Intl.message("Input qty", name: 'pur11TableInputqty');
  String  get pur11TableInventoryincode => Intl.message("Inventoryin code", name: 'pur11TableInventoryincode');
  String  get pur11TablePoCode => Intl.message("Po code", name: 'pur11TablePoCode');
  String  get pur11LabelRequester => Intl.message("Requester", name: 'pur11LabelRequester');
  String  get pur11LabelApprover => Intl.message("Approver", name: 'pur11LabelApprover');

  String  get pur11StatusSubmit => Intl.message("Leader approve", name: 'pur11StatusSubmit');
  String  get pur11StatusPur => Intl.message("Manager approve", name: 'pur11StatusPur');
  String  get pur11StatusApprove => Intl.message("Director approve", name: 'pur11StatusApprove');









  static Future<L10n> load(Locale locale) {
    var name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    var localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _){
        Intl.defaultLocale = localeName;
        return L10n();
    });
  }

  static L10n of (BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static L10n ofValue () {
    return Localizations.of<L10n>(GlobalParam.appContext, L10n);
  }
}

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<L10n> load(Locale locale) {
    R2.locale = locale.languageCode;
    return L10n.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<L10n> old) {
    return false;
  }

}