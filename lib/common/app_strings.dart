import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';

class AppStrings {
  static const welcome = 'Welcome';
  static const signIn = "Signin";
  static const retry = "Retry";
  static const notNow = "notNow";
  static const dictationJson = "assets/json/appointment.json";
  static const documentNotFound = "File doesn't exist";

  /// team 1
  // Splash Screen
  static const yourDrs = "YOURDRS";
  static const title = 'Your Doctors';
  // Login
  static const your = "Your";
  static const doctors = "Doctors";
  static const welcome_text = 'Welcome!';
  static const email_text_field_hint = 'enter your email address ';
  static const password_text_field_hint = 'password';
  static const sign_in = 'Sign In';
  static const valid_credentials = 'enter valid credentials';
  static const no_internet = 'no internet connection';
  static const checkConnection = "Please check your connection and try again";
  static const enter_email = 'Please enter your email ';
  static const enter_password = 'Please enter your password';
  static const incorrectCredentials = 'Invalid Credentials';
  static const timeOutError = "The connection has timed out, Please try again!";
  static const wrongCredentialsMsg =
      'Verify your username and password and try again';
  static const serverError =
      "Unable to connect to server please try after some time";
  static const your_doctor_text =
      'your practice, your patients,\nyour peace of mind.';

  //pin screen
  static const loginWithDiffAcc = "login with different account";
  static const userTouchAndFaceId = 'use touch or face ID';
  static const enterPin = "enter pin";
  static const confirmPin = "Confirm PIN";
  static const createPin = "Create PIN";
  static const pinNotMatched = "Pin Not Matched";
  static const enterValidPin = "Enter Valid Pin";
  static const cannot_be_empty = "Cannot be empty";
  static const pinAvailable = "isPINAvailable";
  static const transaction_overview =
      "Please authenticate to Unlock YourDoctors";

  //changePin
  static const resetPassword = "Reset Password";
  static const enterNewPassword = "Enter new password";
  static const reEnterNewPassword = "Re-enter new password";
  static const passwordDoNotMatch = "Password doesn't Match";
  static const updatePassword = "Update Password";

  static const PasswordUpdated = "Password Updated";
  static const passwordUpdateSuccess =
      "Your password has been updated successfully";
  static const done = "Done";
  static const enterNewPIN = "Enter new PIN";
  static const pinUpdated = 'PIN Updated';
  static const pinUpdateSuccessful = 'PIN has been updated successfully';
  static const reEnterPN = "Re-enter new PIN";
  static const pinDoNotMatch = "Enter valid pin";
  static const samePin = 'New PIN should not be same as previous PIN';
  static const updatePin = "Update PIN";

  //Home screen strings or team2
  static const daterange = "Date";
  static const errormsg = "No appointments found";
  static const noData = 'All data is loaded!there is no further data to scroll';
  static const actiontxt = "Quick Actions";
  static const errortext = "Error";
  static const canceltxt = "cancelled";
  static const nopatients = 'No patients found';
  static const noresultsfoundrelatedsearch = 'No results found';
  static const selectfilter = 'Filter Appointments';
  static const daterangetxt1 = "Selected date range ";
  static const daterangetxt2 = 'Selected Dates:';
  static const calendar = "Calendar";
  //drawer.dart file text
  static const myProfile = "My Profile";
  static const logout = 'Logout';
  static const selectedPatient = 'PatientName';
  //searchable dropdowns
  static const dictationstxt = 'Dictations';
  static const dictationtxt = 'Dictation';
  static const locationtxt = 'Location';
  static const datafiltertitle = 'Appointment Date';
  static const searchpatienttitle = 'Search Patients';
  static const patientName = "Patient Name";
  static const cancel = 'Cancel';
  static const ok = 'Ok';
  static const clearfiltertxt = 'Clear';
  static const dr_txt = "Dr.";
  static const statuscompleted = "Dictation Completed";
  static const pendding = "Pending";
  static const notapplicable = "Not Applicable";
  static const tab = "Tabs:";
  static const select = 'Select ';

  //External Attachment screen data
  static const externalAttachment = "External Attachment";
  static const submitNew = "Submit New";
  static const allattachment = "All Attachment";
  static const firstName = "First Name";
  static const lastName = "Last Name";
  static const enterName = "Enter Name";
  static const dateOfBirth = "Date of Birth";
  static const dateFormatr = 'yyyyMMdd';
  static const documenttype = "Document Type";
  static const emergency_descrption = "Is emergency add on description";
  static const description = "Description";
  static const selectpractice_text = "select";
  static const currentdate_text = "yyyyMMddHHmmss";
  static const feildsCannotBeEmpty = "Fill the Mandatory Fields";
  static const noImageselected_text = "no image selected";
  static const showtoast_text = "Submitted Successfully";
  static const showtoastdb_text = "Inserted Successfully to localdb";
  static const camera = "Camera";
  static const gallery_text = "Gallery";
  static const casedetails_text = "Case Detail";
  static const practice_text = "Practice";
  static const doc_text = "Doc Type";
  static const provider = "Provider";
  static const name_text = "Name";
  static const dob_text = "DOB";
  static const doctypealertmsg = "Please select document type";
  static const nofutherrecords_text = "No further records!!!";

  static const isemergency_text = "Is Emergency\nadd on";
  static const uploadedattachments_text = "Uploaded Attachments";
  static const noimagefound_text = "No image found!!!";
  static const errorloadingphotos_text =
      "Error while loading photos, tap to try again after sometime";
  static const uploadedsuccessfully_text = "Uploaded successfully";
  static const noofflinerecordsfound_text = "no offline records found";
  static const somethingwentwrong_text = "Something went wrong";
  static const alreadyuploaded_text = "already uploaded";
  static const noexternaldocumentsfound_text = "No external documents found!!!";
  static const nofurtherdocumentsfound_text = "No further documents found!!!";
  static const connection_text = "Please check internet connection!!!";
  //team 3
  static const saveToDB = "Saving to Local DB";
  static const manualDictation = 'Manual Dictations';
  static const practice = 'Practice';
  static const treatingProvider = 'Treating Provider';
  static const documentType = 'Document Type';
  static const appointmentType = 'Appointment Type';
  static const submitwithDictButtonText = 'Submit with Dictation';
  static const clearAll = 'Clear All';
  static const emergencyText = 'Is Emergency add on ?';
  static const dosDropDownText = 'Date of Service';
  static const submit = 'Submit';
  static const toggleYES = 'YES';
  static const toggleNO = 'NO';
  static const allDictations = "All Dictations";
  static const images = " Images";
  static const PhotoGallery = "Photo Gallery";
  static const noAudioRecordings = "No Audio Recordings found";
  static const closeDialog = "Close";
  static const uploadedImages = "Uploaded Images";
  static const uploadingDialog = "Uploading...";
  static const uploadedSuccessfully = 'Successfully Uploaded';
  static const selectImgOrAudio = 'Select Images or Dictate Audio';
  static const selectImg = 'Select images';

  static const caseNo = "Case No";
  static const submitImages = "Submit Images";
  static const dateFormat = "MMddyyyyHHmmss";
  static const folderName = "YourDrsImages";
  static const profilePicsfolderName = "ProfilePictures";
  static const noImageSelected = "No image Selected";
  static const filePathNotFound = "File path not found";
  static const imageFormat = ".jpeg";
  static const yearOld = "years old";
  static const dos = "DOS";
  static const dateFormatForDatePicker = 'MM-dd-yyyy';
  static const dateFormatLableHintText = 'mm-dd-yyyy';
  static const saveForLater = "Save for Later";
  static const saveRecording = "Save Recording";
  static const dict = "Upload this dictation for transcription?";
  static const upload = "Upload";
  static const addImgandtakePic = "Add Image/Take Picture";
  static const uploadedDataSuccessfully = "Uploaded Data Successfully";
  static const uploadedDataToSqliteSuccessfully =
      "Uploaded Data to Sqlite Successfully";
  static const mandatoryAsterisk = "*";
  static const close = 'Close';
  static const doctype = 'Document Type';
  static const Appointment_Type = 'Appointment Type';

  //Database table
  static const databaseName = 'ydrslocaldb';
  static const dbTableDictation = "dictationlocal";
  static const dbTableExternalAttachment = 'externalattachmentlocal';
  static const dbTablePhotoList = 'photolistlocal';
  static const dbTablePhotoListExternal = 'photolistlocaltable';
  static const dbexternalDocumentType = 'externalDocument';

  static const someThingWentWrong = 'Something went wrong';
  static const recordingSaved = 'Recording Saved';
  static const recordingSavedLocally = 'Recording Saved locally';
  static const recordingStarted = 'Recording Started';
  static const recordingPaused = 'Recording Paused';
  static const recordingResumed = 'Recording Resumed';
  static const uploading = 'Uploading';
  static const loading = 'Loading...';
  static const recordingDeleted = 'Current Recording Deleted';
  static const networkNotConnected = 'Network Not Connected';
  static const audioFolderName = "YourDrsAudios";
  static const audioFormat = '.mp4';
  static const attachmentType = 'mp4';
  static const appointmentTypeSurgery = 'Surgery';
  static const dictationRouteName = '/DictationType';
  static const allDictationList = 'allDictation';
  static const preDictationList = 'allPreDictation';
  static const myPreDictationList = 'myPreDictation';
  static const dictationItem = 'item';

  //Patient dictation and Manual dictation columns
  static const colId = 'id';

  // static const col_AudioFile = 'col_audioFile';
  static const col_dictationId = 'dictationid';
  static const col_AudioFileName = 'fileName';
  static const col_PatientFname = 'patientfirstname';
  static const col_PatientLname = 'patientlastname';
  static const col_CreatedDate = 'createddate';
  static const col_Patient_DOB = 'patientdob';
  static const col_DictationTypeId = 'dictationtypeid';
  static const col_EpisodeId = 'episodeid';
  static const col_AppointmentId = 'appointmentid';
  static const col_AttachmentName = 'attachmentname';
  static const col_attachmentSizeBytes = 'attachmentsizebytes';
  static const col_attachmentType = 'attachmenttype';
  static const col_MemberId = 'memberid';
  static const col_StatusId = 'statusid';
  static const col_UploadedToServer = 'uploadedtoserver';
  static const col_DisplayFileName = 'displayfilename';
  static const col_PhysicalFileName = 'physicalfilename';
  static const col_DOS = 'dos';
  static const col_PracticeId = 'practiceid';
  static const col_PracticeName = 'practicename';
  static const col_LocationId = 'locationid';
  static const col_LocationName = 'locationname';
  static const col_ProviderId = 'providerid';
  static const col_ProviderName = 'providername';
  static const col_AppointmentTypeId = 'appointmenttypeid';
  static const col_PhotoNameList = 'photoNameList';
  static const col_isEmergencyAddOn = 'isemergencyaddon';
  static const col_ExternalDocumentTypeId = 'externaldocumenttypeid';
  static const col_Description = 'description';
  static const col_AppointmentProvider = 'appointmentprovider';
  static const col_isSelected = 'isselected';

  //External attachment columns
  static const col_External_Id = 'id';
  static const col_ExternalAttachmentId = 'externalattachmentid';
  static const col_ExternalPatientFname = 'patientfirstname';
  static const col_ExternalPatientLname = 'patientlastname';
  static const col_ExternalCreatedDate = 'createddate';
  static const col_ExternalPatient_DOB = 'patientdob';
  static const col_ExternalAppointmentType = 'appointmenttype';
  static const col_ExternalMemberId = 'memberid';
  static const col_ExternalStatusId = 'statusid';
  static const col_ExternalUploadedToServer = 'uploadedtoserver';
  static const col_ExternalDisplayFileName = 'displayfilename';
  static const col_ExternalDOS = 'dos';
  static const col_ExternalFileName = 'filename';
  static const col_ExternalPracticeId = 'practiceid';
  static const col_ExternalPracticeName = 'practicename';
  static const col_ExternalLocationId = 'locationid';
  static const col_ExternalLocationName = 'locationname';
  static const col_ExternalProviderId = 'providerid';
  static const col_ExternalProviderName = 'providername ';
  static const col_ExternalAppointmentTypeId = 'appointmenttypeid';
  static const col_ExternalDocumentType = 'externaldocumenttype';
  static const col_ExternalisEmergencyAddOn = 'isemergencyaddon';
  static const col_Ex_ExternalDocumentTypeId = 'externaldocumenttypeid';
  static const col_ExternalDes = 'description';

  //photo list table columns
  static const col_PhotoList_Id = 'id';
  static const col_PhotoListDictationId = 'dictationlocalid';
  static const col_PhotoListExternalAttachmentId = 'externalattachmentlocalid';
  static const col_PhotoListAttachmentName = 'attachmentname';
  static const col_PhotoListAttachmentSizeBytes = 'attachmentsizebytes';
  static const col_PhotoListAttachmentAttachmentType = 'attachmenttype';
  static const col_PhotoListAttachmentFileName = 'fileName';
  static const col_PhotoListAttachmentPhysicalFileName = 'physicalfilename';
  static const col_PhotoListAttachmentCreatedDate = 'createddate';

  //Queries
  static const deleteOlderRecords =
      "DELETE FROM dictationlocal WHERE createdDate <= date('now','-90 day') AND uploadedtoserver = 1";
  static const deleteOlderImageRecords =
      "DELETE FROM photolistlocal WHERE createdDate <= date('now','-90 day') AND uploadedtoserver = 1";
  static const deleteAllExternalRecords =
      "DELETE FROM externalattachmentlocal WHERE createdDate <= date('now','-90 day')";
  static const selectAllDictationsQuery = "SELECT * FROM dictationlocal";

  static const syncRecordsToServer =
      'SELECT * FROM dictationlocal WHERE uploadedtoserver = 0';
  static const updateOfflineRecords = ''' UPDATE dictationlocal 
    SET uploadedtoserver = ?, dictationid = ? 
    WHERE id = ?
    ''';
  static const updateOfflinePhotoListRecords =
      ''' UPDATE photolistlocal  SET uploadedtoserver = ?
     WHERE dictationlocalid = ?
    ''';
  static const updateOfflineExternalRecords = '''UPDATE externalattachmentlocal 
    SET uploadedtoserver = ?, externalattachmentid = ? 
    WHERE id = ?
    ''';

  static const updateOfflineManualPhotoListRecords = ''' UPDATE dictationlocal 
    SET uploadedtoserver = ?, dictationid = ? 
    WHERE id = ?
    ''';

  static const selectexternalattachmnentQuery =
      'SELECT * FROM externalattachmentlocal WHERE uploadedtoserver = 0';
  static const selectPhotoQuery =
      'SELECT physicalfilename FROM photolistlocal WHEREid=id';

  static const selectManualDictationQuery =
      'SELECT * FROM dictationlocal WHERE dos NOT NULL AND uploadedtoserver = 0';

  // static const selectManualDictationQuery =
  //     'SELECT * FROM dictationlocal WHERE uploadedtoserver = 0';
  static const selectManualDictationPhotoListQuery =
      'SELECT physicalfilename FROM photolistlocal WHEREid=id';
  static const selectIdFromTable = 'SELECT id FROM dictationlocal';

  static const selectImagesForAutoSyncForManualDictation =
      "SELECT * FROM photolistlocal WHERE dictationlocalid=id";

  //Table for Patient Dictation and Manual Dictation
  static const tableDictation = 'CREATE TABLE IF NOT EXISTS dictationlocal('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'dictationid INT DEFAULT NULL,'
      // 'col_audioFile BLOB,'
      'fileName TEXT DEFAULT NULL,'
      'patientfirstname TEXT DEFAULT NULL,'
      'patientlastname TEXT DEFAULT NULL,'
      'patientdob TEXT DEFAULT NULL,'
      'dictationtypeid INT DEFAULT NULL,'
      'createddate DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'episodeid INT DEFAULT NULL,'
      'appointmentid INT DEFAULT NULL,'
      'attachmentname TEXT DEFAULT NULL,'
      'attachmentsizebytes INT DEFAULT NULL,'
      'attachmenttype TEXT DEFAULT NULL,'
      'memberid INT DEFAULT NULL,'
      'statusid INT DEFAULT NULL,'
      'uploadedtoserver NUMERIC DEFAULT 0,'
      'displayfilename TEXT DEFAULT NULL,'
      'physicalfilename TEXT DEFAULT NULL,'
      'dos DATETIME DEFAULT NULL,'
      'practiceid INT DEFAULT NULL,'
      'practicename TEXT DEFAULT NULL,'
      'locationid INT DEFAULT NULL,'
      'locationname TEXT DEFAULT NULL,'
      'providerid INT DEFAULT NULL,'
      'providername TEXT DEFAULT NULL,'
      'appointmenttypeid INT DEFAULT NULL,'
      //'photoNameList DEFAULT NULL,'
      'isemergencyaddon NUMERIC DEFAULT 0,'
      'externaldocumenttypeid INT DEFAULT NULL,'
      'description TEXT DEFAULT NULL,'
      'appointmentprovider TEXT DEFAULT NULL,'
      'isselected NUMERIC DEFAULT 0'
      ')';

  //Table for External Dictation
  static const tableExternalAttachment =
      'CREATE TABLE IF NOT EXISTS externalattachmentlocal ('
      '${AppStrings.col_External_Id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'externalattachmentid INT DEFAULT NULL,'
      'filename TEXT DEFAULT NULL,'
      'patientfirstname TEXT DEFAULT NULL,'
      'patientlastname TEXT DEFAULT NULL,'
      'patientdob TEXT DEFAULT NULL,' //changing
      'memberid INT DEFAULT NULL,'
      'statusid INT DEFAULT NULL,'
      'uploadedtoserver NUMERIC DEFAULT 0,'
      'createddate DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'displayfilename TEXT DEFAULT NULL,'
      'dos DATETIME DEFAULT NULL,'
      'practiceid INT DEFAULT NULL,'
      'practicename TEXT DEFAULT NULL,'
      'locationid INT DEFAULT NULL,'
      'locationname TEXT DEFAULT NULL,'
      'providerid INT DEFAULT NULL,'
      'providername TEXT DEFAULT NULL,'
      'appointmenttypeid INT DEFAULT NULL,'
      'appointmenttype TEXT DEFAULT NULL,'
      'col_photoNameList,'
      'externaldocumenttype TEXT DEFAULT NULL,'
      'isemergencyaddon NUMERIC DEFAULT 0,'
      'externaldocumenttypeid INTEGER DEFAULT NULL,'
      'description TEXT DEFAULT NULL'
      ')';

  static const tblPhotoListExt =
      'CREATE TABLE IF NOT EXISTS photolistlocaltable ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'
      'dictationlocalid INTEGER DEFAULT NULL,'
      'externalattachmentlocalid INTEGER DEFAULT NULL,'
      'attachmentname TEXT DEFAULT NULL,'
      'attachmentsizebytes INTEGER DEFAULT NULL,'
      'attachmenttype TEXT DEFAULT NULL,'
      'fileName TEXT DEFAULT NULL,'
      'physicalfilename TEXT DEFAULT NULL,'
      'createddate DATETIME DEFAULT NULL'
      ')';

  static const tblPhotoList = 'CREATE TABLE IF NOT EXISTS photolistlocal ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'
      'dictationlocalid INTEGER DEFAULT NULL,'
      'externalattachmentlocalid INTEGER DEFAULT NULL,'
      'attachmentname TEXT DEFAULT NULL,'
      'attachmentsizebytes INTEGER DEFAULT NULL,'
      'attachmenttype TEXT DEFAULT NULL,'
      'fileName TEXT DEFAULT NULL,'
      'physicalfilename TEXT DEFAULT NULL,'
      'createddate DATETIME DEFAULT NULL,'
      'uploadedtoserver NUMERIC DEFAULT 0'
      ')';
  //External documentType table
  static const externalDocumentType =
      'CREATE TABLE IF NOT EXISTS externalDocument ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'externalDocumentTypeName TEXT DEFAULT NULL'
      ')';

  //Dictation type list
  static const dictationTypeList = [
    "MR",
    "NBR",
    "OPR",
  ];

  // Team 4 strings

  static const startFile = "Start file";
  static const dictType = "Select dictation type";
  static const photoLib = "Photo Library";
  static const dictationType = "Dictation type";
  static const patientNameAppBar = "Kevin Peterson";
  static const uploadToServer = "Dictation has been submitted successfully!";
  static const uploadFailed = "Failed to upload Dictation";
  static const dictationJsonFile = 'assets/json/dictation_type_surgery.json';
  static const googleDocViewer = 'https://docs.google.com/viewer?url=';
  //Dictations
  static const textMyDictation = "My Previous Dictations";
  static const textAllDictation = "All Previous Dictations";
  static const noDictations = "No Dictations are available";

  /// Quick Appointment
  static const appointmentCreated = "Appointment created successfully";
  static const appointmentNotCreated = "Appointment not created";
  static const alert = "Alert!";
  static const patientExist =
      "Patient is already exist, Click on Continue to create new Patient Or Click on Select Existing patient";
  static const reasonRequired = "Reason for Creating new patient (Required)";
  static const reasonForPatient = "Reason for creating patient";
  static const reasonForPatientToast = "Reason for new patient is required";
  static const createPatient = "Create new Patient";
  static const continueTxt = "Continue";
  static const selectPatient = "Select from existing Patient";
  static const patientNotFound = "Patients not found";
  static const quickAppointment = "Quick Appointment";
  static const male = "Male";
  static const female = "Female";
  static const unknown = "Unknown";
  static const shortMale = "M";
  static const shortFemale = "F";
  static const shortUnknown = "U";
  static const maleValue = "1";
  static const femaleValue = "2";
  static const unknownValue = "3";
  static const patientDetails = "Patient Details";
  static const gender = "Gender";
  static const search = "Search";
  static const fillAllFields = "Fill all the fields";
  static const caseType = "Case Type";
  static const caseTxt =
      "If Case Type is changed new case for same patient will be created.";
  static const doa = "Date of Accident";
  static const time = "Time";
  static const requestAppointment = "Request Appointment";
  static const errorLoadingPatient =
      "Error while loading patients, tap to try again after sometime";
  static const errorLoadingData = "Error while loading data, tap to try again";
  static const caseNumber = "Case Number";
  static const accountNumber = "Account Number";
  static const yyyymmdd = "yyyy-mm-dd";
  static const caseTypeState = "Case Type State";
  static const selectDate = "Select correct date";
  static const selectTime = "Select further time";
  static const MMddyyyyhhmma = "MM-dd-yyyy hh:mm a";

  static var syncingOffline = "Syncing Offline Data...";
}

class ApiUrlConstants {
// for getting Locations//
  static const getLocation =
      AppConstants.dioBaseUrl + "api/Schedule/GetMemberLocations";

// for getting Provider
  static const getProviders =
      AppConstants.dioBaseUrl + "api/Schedule/GetAssociatedProvider";

//for getting Schedules
  static const getSchedules = AppConstants.dioBaseUrl +
      "api/Schedule/GetSchedulesGroupByPracticeLocation";

//for getting schedules for Practice Locations
  static const getSchedulesForPracticeLocations =
      AppConstants.dioBaseUrl + "api/Schedule/GetSchedulesForPracticeLocation";
  // for Authenticating the user Credentials
  static const getUser =
      AppConstants.dioBaseUrl + "api/Account/AuthenticateUser";

  // for Changing the User Profile
  static const UserProfile =
      AppConstants.dioBaseUrl + "api/Account/UpdateUserProfilePhoto";

  // for changing the User Password
  static const UserPassword =
      AppConstants.dioBaseUrl + "api/Account/ResetUserPassword";

  // for LogException POST API
  static const logException =
      AppConstants.dioBaseUrl + "api/MasterData/LogException";

  // for validating the pin
  static const getUserValidate =
      AppConstants.dioBaseUrl + "api/Account/ValidatePin";

  // for generating the pin
  static const generatePin =
      AppConstants.dioBaseUrl + "api/Account/GenerateMemberPin";
  static const getDocumenttype =
      AppConstants.dioBaseUrl + "api/MasterData/GetExternalDocumentTypes";

  //for appointment type
  static const getAppointmenttype =
      AppConstants.dioBaseUrl + "api/MasterData/GetAppointmentTypes";

  //for selecting practices
  static const getPractices =
      AppConstants.dioBaseUrl + "api/MasterData/GetLoggedInMemberPractices";

  //location for selected practices
  static const getExternalLocation = AppConstants.dioBaseUrl +
      "api/MasterData/GetLocationsForSelectedPractices";

  //providers for selected location practices type
  static const getProvidersforSelectedPracticeLocation =
      AppConstants.dioBaseUrl +
          "api/MasterData/GetProvidersForSelectedPracticeLocation";

  //all dictations api
  static const dictations =
      AppConstants.dioBaseUrl + "api/Dictation/GetAllDictations";

  // to get all previous dictations
  static const allPreviousDictations =
      AppConstants.dioBaseUrl + "api/Dictation/GetPreviousDictations";

  // to get my previous dictations
  static const myPreviousDictations =
      AppConstants.dioBaseUrl + "api/Dictation/GetMyPreviousDictations";

  //Upload Dictations
  static const saveDictations =
      AppConstants.dioBaseUrl + "api/Dictation/SaveDictation";

  //play audios
  static const playAudios =
      AppConstants.dioBaseUrl + "api/Dictation/GetExternalOrManualRecording";

  //all dictations and attachment post api
  static const allDictationsAttachment = AppConstants.dioBaseUrl +
      "api/Dictation/SaveExternalDictationOrAttachment";

  //all get external document get api
  static const allMyExternalAttachmentUrl =
      AppConstants.dioBaseUrl + "api/Dictation/GetExternalDocuments";

  //all dictations and attachment post api
  // static const allDictationsAttachment = AppConstants.dioBaseUrl +
  //     "api/Dictation/SaveExternalDictationOrAttachment";
  //all my manual dictations get api
  static const allMyManualDictationUrl =
      AppConstants.dioBaseUrl + "api/Dictation/GetAllMyManualDictations";

  static const getExternalDocumentDetails =
      AppConstants.dioBaseUrl + "api/Dictation/GetExternalDocumentDetails";

  static const getExternalPhotos =
      AppConstants.dioBaseUrl + "api/Dictation/GetExternalOrManualAttachment";

  static const getAllImages =
      AppConstants.dioBaseUrl + "api/Dictation/GetDictationAttachmentNames";

  static const getImageFile =
      AppConstants.dioBaseUrl + "api/Dictation/GetDictationAttachment";
//all my manual dictations get api
// static const allMyExternalAttachmentUrl =
//     AppConstants.dioBaseUrl + "api/Dictation/GetExternalDocuments";
  static const getProfilePhotos =
      AppConstants.dioBaseUrl + "api/Schedule/GetPatientProfilePhoto";

  static const getTranscriptionFile =
      AppConstants.dioBaseUrl + "api/Dictation/GetTranscriptionFIle";

  ///quick appointment api urls
  ///for selecting practice locations
  static const getPracticeLocations =
      AppConstants.dioBaseUrl + "api/Appointment/GetPracticeLocations";

  ///for selecting case types
  static const getQuickAppointmentCaseType =
      AppConstants.dioBaseUrl + "api/Appointment/GetCaseTypes";

  ///for selecting appointment types
  static const getQuickAppointmentTypeList = AppConstants.dioBaseUrl +
      "api/Appointment/GetAppointmentTypesForQuickAppoitnment";

  ///for selecting appointment time slots
  static const getQuickAppointmentTimeSlots = AppConstants.dioBaseUrl +
      "api/Appointment/GetLimitedAppointmentTimeSlots";

  ///for searching matching patients
  static const getMatchingPatients = AppConstants.dioBaseUrl +
      "api/Appointment/GetQuickAppointmentMatcingPatients";

  ///to book the appointment
  static const bookAppointment =
      AppConstants.dioBaseUrl + "api/Appointment/BookQuickAppointment";

  ///for selecting providers
  static const getProvidersForPracticeLocations = AppConstants.dioBaseUrl +
      "api/Appointment/GetProvidersForPracticeLocations";

  ///for selecting case types state
  static const getCaseTypeState =
      AppConstants.dioBaseUrl + "api/Appointment/GetStates";
}
