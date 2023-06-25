/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.common.utils;

/**
 *
 * @author Dinesh
 */
public class DDM_Constants
{

    private DDM_Constants()
    {
    }

    //Property file paths
    //local 
    public static final String path_common_properties = "E:\\TTS\\LCPL\\conf\\web.properties";
    public static final String path_dbProperty = "E:\\TTS\\LCPL\\conf\\db_properties_ddm.properties";
    public static final String path_email_properties = "E:\\TTS\\LCPL\\conf\\email.properties";

    //server
//    public static final String path_dbProperty = "/DDA/properties/db_properties.properties";
//    public static final String path_common_properties = "/DDA/properties/common.properties";
//    public static final String path_email_properties = "/DDA/properties/email_properties.properties";
    
    
    public static final String param_id_user_system = "System";
    public static final String param_id_businessdate = "BatchBusinessDate";
    public static final String param_id_batch_businessdate = "BatchBusinessDate";
    public static final String param_id_cits_cutoff_time = "CITS";
    public static final String param_id_default_pwd = "DefaultPwd";
    public static final String param_id_db_enc_pw_1 = "DBEncPW_1";
    public static final String param_id_db_enc_pw_2 = "DBEncPW_2";
    public static final String param_id_no_of_sessions = "NoOfSessions";

    public static final String param_id_session = "Session";

    public static final String param_id_minimum_pwd_change_days = "MinPwdChangeDays";
    public static final String param_id_minimum_pwd_history = "MinPwdHistory";
    public static final String param_id_minimum_pwd_length = "MinPwdLength";
    public static final String param_id_minimum_lowercase_characters = "MinLowCaseChar";
    public static final String param_id_minimum_uppercase_characters = "MinUpCaseChar";

    public static final String param_id_otp_exp_minutes = "OTPExpireMinutes";

    public static final String param_id_SystemUserPwdExpireDuration = "SystemUserPwdExpireDuration";
    public static final String param_id_UserPwdExpireDuration = "UserPwdExpireDuration";
    public static final String param_id_InvalidPwdMaxWaitTime = "InvalidPwdMaxWaitTime";
    public static final String param_id_UnsuccesfulLoginCount = "UnsuccesfulLoginCount";
    public static final String param_id_userAccountAutoUnlockTime = "UserAccountAutoUnlockTime";
    public static final String param_id_InactiveUsersDeactivationDuration = "InactiveUsersDeactivationDuration";

    public static final String param_id_ShowSnow = "ShowSnow";
    public static final String param_id_PwdExpireWarningDays = "PwdExpireWarningDays";
    public static final String param_id_CertExpireWarningDays = "CertExpireWarningDays";

    public static final String param_id_setlement_bank = "SettlementBank";

    public static final String param_id_msg_reply_before = "MsgReplyBefore";
    public static final String param_id_msg_max_length = "MsgMaxLength";
    public static final String param_id_msg_max_attachment_size = "MsgAttachmentMaxSize";

    public static final String param_id_justpay_code = "JustPayCode";
    public static final String param_id_justpay_url = "JUSTPAY_HOSTIP";

    public static final String param_id_email_p1 = "EmailP1";
    public static final String param_id_email_p2 = "EmailP2";
    public static final String param_id_email_p3 = "EmailP3";
    public static final String param_id_email_p4 = "EmailP4";
    public static final String param_id_email_p5 = "EmailP5";
    public static final String param_id_email_p6 = "EmailP6";

    public static final String param_id_eMailAdd_Admin = "eMailAdd_Admin";
    public static final String param_id_eMailAdd_Alt = "eMailAdd_Alt";
    public static final String param_id_eMailAdd_Helpdesk = "eMailAdd_Helpdesk";

    public static final String param_id_send_email_pwd_expiry = "SendEmailForPwdExpiry";
    public static final String param_id_last_date_email_pwd_expiry_sent = "LastDateEmailForPwdExpirySent";

    public static final String param_id_default_credit_account = "DefaultCreditAccount";

    public static final String param_id_ddm_report_common_file_path = "SlipsReportCommonFilePath";
    public static final String param_id_ddm_jasper_file_base_path = "SlipsJasperFileBasePath";
    public static final String param_id_ddm_report_logo_path = "SlipsReportLogoPath";

    public static final String param_id_ddm_data_tmp_file_path = "SlipsDataTempFilePath";
    public static final String param_id_ddm_common_file_path_core_ow_file = "CoreOWSLIPSFileCommonPath";
    public static final String param_id_ddm_common_file_path_lcpl_ow_file = "LcplOWSLIPSFileCommonPath";

    public static final String param_id_email_mail_smtp_auth = "mail_smtp_auth";
    public static final String param_id_email_mail_smtp_host = "mail_smtp_host";
    public static final String param_id_email_mail_smtp_port = "mail_smtp_port";
    public static final String param_id_email_mail_smtp_user = "mail_smtp_un";
    public static final String param_id_email_mail_smtp_pwd = "mail_smtp_pwd";
    public static final String param_id_email_mail_smtp_tls_enabled = "mail_smtp_tls";
    public static final String param_id_email_mail_smtp_socketFactory_class = "mail_smtp_socketFactory_class";
    public static final String param_id_email_mail_smtp_socketFactory_port = "mail_smtp_socketFactory_port";

     
    public static final String param_id_ddm_sla_breach_for_acquiring_bank = "DDMSLABreachCountAquiringBank";
    public static final String param_id_ddm_sla_breach_for_issuing_bank = "DDMSLABreachCountIssuingBank";
    

    public static final String email_notification_type_bank_branch_update = "01";
    public static final String email_notification_type_inward_readiness = "02";
    public static final String email_notification_type_outward_file_validation_summary = "03";
    public static final String email_notification_type_session_summary = "04";
    public static final String email_notification_type_cbsl_mlns = "05";

    public static final String default_bank_code = "9991";
    public static final String default_branch_code = "001";
    public static final String bank_default_branch_code = "001";
    public static final String default_branch_code_card_centre = "600";
    public static final String default_branch_code_head_office_990 = "990";
    public static final String default_branch_code_head_office_999 = "999";

    public static final String default_coporate_customer_id = "9999";
    public static final String default_ddm_acc_no = "624999999999999";
    public static final String default_ddm_acc_name = "PB SLIPS Default Account";
    public static final String default_merchant_id = "9999";
    public static final String default_return_code = "00";
    
    ///////////////////
    public static final String default_merchant_pwd_hash = "$2a$10$SNt/ROoHwh0EjjTWWAusxeBLM.XrczvZ6ga1frGp38LmRpJdw6EoO";
    ///////////////////
    
    
    public static final String ddm_cust1_file_Type = "CUST1";
    public static final String ddm_cust1_file_suffix = "cust1.txt";
    public static final String ddm_dddm_file_Type = "DSLIPS";
    public static final String ddm_dddm_file_suffix = "dslips.txt";
    public static final String ddm_fddm_file_Type = "FSLIPS";
    public static final String ddm_fddm_file_suffix = "fslips.txt";

    public static final String ddm_dddm_fddm_file_Type = "D_F_SLIPS";

    public static final String ddm_custout_file_Type = "CUSTOUT";
    public static final String ddm_custout_file_suffix1 = "custout.txt";
    public static final String ddm_custout_file_suffix2 = "custout";
    public static final String ddm_custout_1_file_Type = "CUSTOUT1";
    public static final String ddm_custout_2_file_Type = "CUSTOUT2";

    public static final String ddm_iwd_file_Type = "IWD";
    public static final String ddm_iwd_file_perfix = "IWD";

    public static final String ddm_core_return_file_Type = "CORERETURN";
    public static final String ddm_core_return_file_prefix = "SLIPSREJ";
    public static final String ddm_core_return_file_header_prefix = "SIBS";
    public static final String ddm_core_return_file_extension = ".TXT";

    /* Non core-return files */
    public static final String ddm_non_core_return_file_Type = "NON-CORERETURN";

    public static final String ddm_aft_file_Type = "AFT";
    public static final String ddm_aft_file_Type_header_prefix = "AFTS";
    public static final String ddm_aft_file_extension = ".TXT";

    public static final String ddm_digital_banking_file = "DBANK";
    public static final String ddm_digital_banking_file_Type = "DDSLIPSF";
    public static final String ddm_digital_banking_file_Type_header_prefix = "DBIB";
    public static final String ddm_digital_banking_file_extension = ".TXT";

    public static final String ddm_e_net_file = "INET";
    public static final String ddm_e_net_file_Type = "slipsnet.";
    public static final String ddm_e_net_file_Type_header_prefix = "INET";
    public static final String ddm_e_net_file_extension = ".TXT";

    public static final String ddm_sms_file = "SMS";
    public static final String ddm_sms_file_Type = "slipssms.";
    public static final String ddm_sms_file_Type_header_prefix = "USSD";
    public static final String ddm_sms_file_extension = ".TXT";

    public static final String ddm_lcpl_owd_file_prefix = "OWD";
    public static final String ddm_lcpl_owd_file_type = "LCPL";
    public static final String ddm_pb_core_owd_file_suffix = "SLIPS.TXT";
    public static final String ddm_pb_core_owd_file_type = "CORE";

    public static final String ddm_hogl_report_prefix = "HOGL";
    public static final String ddm_hogl_report_suffix = ".txt";

    public static final String ddm_ibt_file_suffix = "_SLIPS.TXT";

    public static final String ddm_file_process_status_processing = "1";
    public static final String ddm_file_process_status_completed = "2";
    public static final String ddm_file_process_status_uploaded = "3";
    public static final String ddm_file_process_status_error = "5";
    public static final String ddm_file_process_status_rejected = "8";
    public static final String ddm_file_process_status_timedout = "9";

    // DDM Main Functions related page paths
    public static final String ddm_main_finction_path_auth_new_bank = "/pages/admin/bankbranch_maintenance/bank/AuthNewBank.jsp";
    public static final String ddm_main_finction_path_auth_modified_bank = "/pages/admin/bankbranch_maintenance/bank/AuthModifiedBank.jsp";

    public static final String ddm_main_finction_path_auth_new_branch = "/pages/admin/bankbranch_maintenance/branch/AuthNewBranch.jsp";
    public static final String ddm_main_finction_path_auth_modified_branch = "/pages/admin/bankbranch_maintenance/branch/AuthModifiedBranch.jsp";

    public static final String ddm_main_finction_path_auth_new_merchant = "/pages/admin/merchant_maintenance/AuthNewMerchant.jsp";
    public static final String ddm_main_finction_path_auth_modified_merchant = "/pages/admin/merchant_maintenance/AuthModifiedMerchant.jsp";

    public static final String ddm_main_finction_path_auth_modified_params = "/pages/admin/parameter_maintenance/AuthModifiedParams.jsp";
    
    public static final String ddm_main_finction_path_auth_modified_userlevel_functionmap = "/pages/admin/usrlvlfunction_maintenance/AuthModifiedUsrLvlFunctions.jsp";

    public static final String ddm_main_finction_path_auth_new_user = "/pages/admin/user_maintenance/AuthNewUser.jsp";
    public static final String ddm_main_finction_path_auth_modified_user = "/pages/admin/user_maintenance/AuthModifiedUser.jsp";    

    public static final String ddm_main_finction_path_auth_ddm_req_acquiring_bank = "/pages/manage/apddmacb.jsp";
    public static final String ddm_main_finction_path_auth_ddm_req_issuing_bank = "/pages/manage/apddmisb.jsp";
    public static final String ddm_main_finction_path_auth_ddm_req_terminated = "/pages/manage/apddmter.jsp";    
    
    public static final String ddm_main_finction_path_inquiry_sla_breach_ddm_req_inquiry = "/pages/inquiry/inqddm.jsp";
    public static final String ddm_main_finction_path_inquiry_sla_breach_ddm_req_issuing_bank = "/pages/inquiry/slbddmisb.jsp";
    public static final String ddm_main_finction_path_inquiry_sla_breach_ddm_req_acquiring_bank = "/pages/inquiry/slbddmacb.jsp";

    //public static final String des_key = "bcm2012slips"; // please shuffle 
    public static final String cert_type = "X.509";
    public static final int noPageRecords = 5000;
    public static final int maxWebRecords = 400000;
    public static final String data_mode_enc = "E";
    public static final String data_mode_plain = "P";

    public static final String account_type_cheque = "C";
    public static final String account_type_normal = "N";

    public static final String slisp_account_status_active = "A";
    public static final String slisp_account_status_inactive = "I";

    public static final String core_bank_account_status_invalid = "000";
    public static final String core_bank_account_status_active = "001";
    public static final String core_bank_account_status_closed = "007";
    public static final String core_bank_account_status_dormant = "008";
    public static final String core_bank_account_status_isa = "009";
    public static final String core_bank_account_status_frozen = "010";
    public static final String core_bank_account_status_deceased = "033";
    public static final String core_bank_account_status_staff = "542";

    public static final String cbo_bulk_acc_web_service_sys_propery_no_proxy_key = "http.nonProxyHosts";
    //public static final String cbo_bulk_acc_web_service_sys_propery_no_proxy_value = "localhost|127.0.0.1|15.65.0.111"; // collection.peoplesbank.lk
    public static final String cbo_bulk_acc_web_service_sys_propery_no_proxy_value = "localhost|127.0.0.1|172.18.232.250|collection.peoplesbank.lk"; // collection.peoplesbank.lk
    public static final String cbo_bulk_acc_web_service_user_id = "cbo2pb";
    public static final String cbo_bulk_acc_web_service_password = "bp2obc";

    /**
     * JS - menu related constants
     */
    public static final String js_menu_start_source_txt_for_bank_admin = "menu_bank_admin.txt";
    public static final String js_menu_start_source_txt_for_bank_operator = "menu_bank_operator.txt";
    public static final String js_menu_start_source_txt_for_corporate_customer_su = "menu_corporate_customer_su.txt";
    public static final String js_menu_start_source_txt_for_corporate_customer_op = "menu_corporate_customer_op.txt";
    public static final String js_menu_start_source_txt_for_ddm_admin = "menu_ddm_admin.txt";
    public static final String js_menu_start_source_txt_for_ddm_helpdesk = "menu_ddm_helpdesk.txt";
    public static final String js_menu_start_source_txt_for_ddm_manager = "menu_ddm_manager.txt";
    public static final String js_menu_start_source_txt_for_ddm_operator = "menu_ddm_operator.txt";
    public static final String js_menu_start_source_txt_for_ddm_supervisor = "menu_ddm_supervisor.txt";

    public static final String js_menu_id_for_ddm_admin = "399000";
    public static final String js_menu_name_for_ddm_admin = "menu_SLIPS_Admin.js";

    public static final String js_menu_id_for_ddm_operator = "399010";
    public static final String js_menu_name_for_ddm_operator = "menu_SLIPS_Operator.js";

    public static final String js_menu_id_for_ddm_helpdesk = "399020";
    public static final String js_menu_name_for_ddm_helpdesk = "menu_SLIPS_HelpDesk.js";

    public static final String js_menu_id_for_ddm_supervisor = "399030";
    public static final String js_menu_name_for_ddm_supervisor = "menu_SLIPS_Supervisor.js";

    public static final String js_menu_id_for_ddm_manager = "399040";
    public static final String js_menu_name_for_ddm_manager = "menu_SLIPS_Manager.js";

    public static final String js_menu_id_for_bank_operator = "399050";
    public static final String js_menu_name_for_bank_operator = "menu_BankOperator.js";

    public static final String js_menu_id_for_bank_admin = "399060";
    public static final String js_menu_name_for_bank_admin = "menu_BankAdmin.js";

    public static final String js_menu_id_for_corporate_customer_op = "399070";
    public static final String js_menu_name_for_corporate_customer_op = "menu_CorporateCustomer_OP.js";

    public static final String js_menu_id_for_corporate_customer_su = "399080";
    public static final String js_menu_name_for_corporate_customer_su = "menu_CorporateCustomer_SU.js";

    public static final String js_menu_end_source_txt = "menu_end.txt";

    public static final String js_menu_new_line = "\n";
    public static final String js_menu_equal = " = ";
    public static final String js_menu_double_qoute = "\"";
    public static final String js_menu_double_qoute_and_semicolon = "\";";
    public static final String js_menu_4_spaces = "    ";
    public static final String js_menu_underscore = "_";

    public static final String js_menu_level_1_item_val_user_profile = " = \"My Profile\";";
    public static final String js_menu_level_1_item_width_val_user_profile = " = \"70\";";
    public static final String js_menu_level_1_url_val_user_profile = " = \"../pages/user/userProfile.jsp\";";

    public static final String js_menu_level_1_item_tag = "this.item";
    public static final String js_menu_level_1_item_width_tag = "this.item_width";

    public static final String js_menu_level_1_text_color_roll_tag = "this.item_text_color_roll";
    public static final String js_menu_level_1_text_color_roll_val = " = \"#FF9105\";";

    public static final String js_menu_level_1_url_tag = "this.url";

    public static final String js_menu_level_2_3_4_border_color_tag = "this.menu_border_color";
    public static final String js_menu_level_2_3_4_border_color_val = " = \"#8287AA\";";

    public static final String js_menu_level_2_3_4_items_padding_tag = "this.menu_items_padding";
    public static final String js_menu_level_2_3_4_items_padding_val = " = \"5,0,5,0\";";

    public static final String js_menu_level_2_3_4_xy_tag = "this.menu_xy";
    public static final String js_menu_level_2_3_4_width_tag = "this.menu_width";

    public static final String js_menu_level_2_3_4_animation_tag = "this.menu_animation";
    public static final String js_menu_level_2_3_4_animation_val = " = \"progid:DXImageTransform.Microsoft.Fade(duration=0.5)\";";

    public static final String js_menu_level_2_3_4_transparency_tag = "this.menu_transparency";
    public static final String js_menu_level_2_3_4_transparency_val = " = \"progid:DXImageTransform.Microsoft.Alpha(Opacity=95)\";";

    public static final String js_menu_level_2_3_4_is_horizontal_tag = "this.menu_is_horizontal";
    public static final String js_menu_level_2_3_4_is_horizontal_val = " = false;";

    public static final String js_menu_level_2_3_4_is_divider_caps_tag = "this.divider_caps";
    public static final String js_menu_level_2_3_4_is_divider_caps_val = " = false;";

    public static final String js_menu_level_2_3_4_icon_roll_tag = "this.icon_rel";
    public static final String js_menu_level_2_3_4_icon_roll_val = " = 3;";

    public static final String js_menu_level_2_3_4_item_tag = "this.item";
    public static final String js_menu_level_2_3_4_url_tag = "this.url";

    /**
     * messenger service related parameters
     */
    public static final String msg_isred_no = "0";
    public static final String msg_isred_yes = "1";
    public static final String msg_prioritylevel_high = "1";
    public static final String msg_prioritylevel_normal = "2";
    public static final String msg_prioritylevel_low = "3";
    public static final String msg_recipient_lcpl = "LCPL";
    public static final String msg_recipient_bank = "Bank";
    public static final String msg_recipient_extensioncounter = "ec";
    public static final String msg_branch_counter_seperator = "-";

    /**
     * User Password expire duration (days)
     */
    public static final int user_pwd_expire_duration = 60;
    public static final int system_pwd_expire_duration = 365;

    public static final int default_pwd_expire_warning_days = 7;
    public static final int default_cert_expire_warning_days = 14;

    /**
     * confirmation status types
     */
    public static final String confirmation_status_one = "1";
    public static final String confirmation_status_two = "2";
    public static final String confirmation_status_three = "3";
    /**
     * calendar day types
     */
    public static final String calendar_day_type_fbd = "FBD";
    public static final String calendar_day_type_pbd = "PBD";
    public static final String calendar_day_type_nbd = "NBD";
    /**
     * Slips BCM Tables
     */

    public static final String tbl_accountinfo = "accountinfo";
    public static final String tbl_account_status = "account_status";
    public static final String tbl_account_type = "account_type";
    public static final String tbl_account_sub_type = "account_sub_type";
    public static final String tbl_activitylog = "activitylog";
    public static final String tbl_bank = "bank";
    public static final String tbl_batch = "batch";
    public static final String tbl_branch = "branch";
    public static final String tbl_calender = "calender";
    public static final String tbl_certificateinfo = "certificateinfo";
    public static final String tbl_confirmstatus = "confirmstatus";
    public static final String tbl_ddmrequest = "ddarequest";
    public static final String tbl_ddmrequeststatus = "ddarequeststatus";
    public static final String tbl_executionbatch = "executionbatch";
    public static final String tbl_executionbatchhistory = "executionbatchhistory";
    public static final String tbl_executionbatchstatus = "executionbatchstatus";
    public static final String tbl_logtype = "logtype";
    public static final String tbl_merchant = "merchant";
    public static final String tbl_merchant_accno_map = "merchantaccount";

    public static final String tbl_parameter = "parameter";
    public static final String tbl_parameterhistory = "parameterhistory";
    public static final String tbl_report = "reports";
    public static final String tbl_reportype = "reporttype";
    public static final String tbl_reportmap = "reportmap";
    public static final String tbl_slipowconfirmation = "slipowconfirmation";
    public static final String tbl_inwardfiles = "inwardfiles";
    public static final String tbl_status = "filestatus";
    public static final String tbl_transactiontype = "transaction";
    public static final String tbl_user = "user";
    public static final String tbl_user_pw_history = "user_pw_history";
    //public static final String tbl_user_history = "userhistory";
    public static final String tbl_userlevel = "userlevel";
    public static final String tbl_userlevelfunctionmap = "userlevelfunctionmap";
    public static final String tbl_emailnotificationtype = "emailnotificationtype";
    public static final String tbl_emaillist = "emaillist";

    public static final String tbl_messageheader = "messageheader";
    public static final String tbl_messagebody = "messagebody";
    public static final String tbl_messagepriority = "messagepriority";

    public static final String nextval_sequence_id_msgId = "msgId";

    public static final String aesk_0 = "0";
    public static final String aesk_1 = "1";
    public static final String aesk_2 = "2";
    public static final String aesk_3 = "3";
    public static final String aesk_a = "a";
    public static final String aesk_b = "b";
    public static final String aesk_c = "c";
    public static final String aesk_d = "d";
    public static final String aesk_i = "i";
    public static final String aesk_l = "l";
    public static final String aesk_m = "m";
    public static final String aesk_p = "p";
    public static final String aesk_r = "r";
    public static final String aesk_s = "s";
    public static final String aesk_hash = "#";

    /**
     * CITS_FT status
     */
    public static final String status_all = "ALL";
    public static final String status_active = "A";
    public static final String status_approve = "A";
    public static final String status_deactive = "D";
    public static final String status_locked = "L";
    public static final String status_expired = "E";
    public static final String status_pending = "P";
    public static final String status_reject = "R";
    public static final String status_yes = "Y";
    public static final String status_no = "N";
    public static final String status_waiting = "0";
    public static final String status_processing = "1";
    public static final String status_success = "2";
    public static final String status_fail = "9";

    public static final String status_user_modify_details = "UMD";
    public static final String status_user_modify_deactivate = "UMI";
    public static final String status_user_modify_activate = "UMA";

    public static final String transaction_type_credit = "C";
    public static final String transaction_type_debit = "D";

    public static final String ddm_request_status_01 = "1";
    public static final String ddm_request_status_02 = "2";
    public static final String ddm_request_status_03 = "3";
    public static final String ddm_request_status_04 = "4";
    public static final String ddm_request_status_05 = "5";
    public static final String ddm_request_status_06 = "6";
    public static final String ddm_request_status_07 = "7";
    public static final String ddm_request_status_08 = "8";
    public static final String ddm_request_status_09 = "9";
    public static final String ddm_request_status_11 = "11";
    public static final String ddm_request_status_12 = "12";
    public static final String ddm_request_status_13 = "13";
    public static final String ddm_request_status_14 = "14";
    public static final String ddm_request_status_15 = "15";
    public static final String ddm_request_status_19 = "19";

    public static final String ddm_request_frequency_daily = "D";
    public static final String ddm_request_frequency_weekly = "W";
    public static final String ddm_request_frequency_monthly = "M";
    public static final String ddm_request_frequency_yearly = "Y";

    public static final String ddm_transaction_status_00 = "00";
    public static final String ddm_transaction_status_01 = "01";
    public static final String ddm_transaction_status_02 = "02";
    public static final String ddm_transaction_status_03 = "03";
    public static final String ddm_transaction_status_04 = "04";
    public static final String ddm_transaction_status_05 = "05";
    public static final String ddm_transaction_status_06 = "06";
    public static final String ddm_transaction_status_07 = "07";
    public static final String ddm_transaction_status_08 = "08";
    public static final String ddm_transaction_status_09 = "09";
    public static final String ddm_transaction_status_10 = "10";
    public static final String ddm_transaction_status_11 = "11";
    public static final String ddm_transaction_status_12 = "12";

    public static final String ddm_reject_code_valid_transaction = "00";
    public static final String ddm_reject_code_invalid_value_date = "22";
    public static final String ddm_reject_code_invalid_pb_account = "60";
    public static final String ddm_reject_code_invalid_pb_account_and_value_date = "60,22";
    public static final String ddm_reject_code_invalid_pb_account_and_value_date_2 = "22,60";

    public static final String ddm_transaction_inhouse = "I";
    public static final String ddm_transaction_out = "O";
    public static final String ddm_transaction_lcpl = "L";

    /*
     * User Types
     */
    public static final String user_type_ddm_administrator = "0";
    public static final String user_type_ddm_operator = "1";
    public static final String user_type_ddm_helpdesk_user = "2";
    public static final String user_type_ddm_supervisor = "3";
    public static final String user_type_ddm_manager = "4";
    public static final String user_type_bank_user = "5";
    public static final String user_type_bank_manager = "6";
    public static final String user_type_merchant_op = "7";
    public static final String user_type_merchant_su = "8";
    /**
     * Message details
     */
    public static final String msg_null_or_invalid_parameter = "Null or Invalid Parameter.";
    public static final String msg_no_records = "No records were found.";
    public static final String msg_no_records_updated = "No records were updated.";
    public static final String msg_error_while_processing = "An error occured while performing the task.";
    public static final String msg_duplicate_records = "Duplicate records were found.";
    public static final String msg_not_available = "N/A";
    public static final String msg_invalid_or_expired_otp = "Invalid or Expired OTP.";

    /**
     * Directory details
     */
    public static final String directory_separator = "/";
    public static final String directory_separator_windows = "\\";
    public static final String directory_separator_web = "/";
    public static final String directory_uploadedFiles = "uploadedFiles";
    public static final String directory_inward = "inward";
    public static final String directory_previous = "..";

    /**
     * simple date formats
     */
    public static final String simple_date_format_yyyy = "yyyy";
    public static final String simple_date_format_MM = "MM";
    public static final String simple_date_format_dd = "dd";
    public static final String simple_date_format_HH = "HH";
    public static final String simple_date_format_mm = "mm";
    public static final String simple_date_format_ss = "ss";
    public static final String simple_date_format_SSS = "SSS";
    public static final String simple_date_format_ddMMyy = "ddMMyy";
    public static final String simple_date_format_yyMMdd = "yyMMdd";
    public static final String simple_date_format_ddMMyyyy = "ddMMyyyy";
    public static final String simple_date_format_yyDDD = "yyDDD";
    public static final String simple_date_format_yyyyMMdd = "yyyyMMdd";
    public static final String simple_date_format_yyyy_MM_dd = "yyyy-MM-dd";
    public static final String simple_date_format_yyyy_MM_dd_hh_mm = "yyyy-MM-dd hh:mm a";
    public static final String simple_date_format_yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm";
    public static final String simple_date_format_yyyy_MM_dd_hh_mm_ss_a = "yyyy-MM-dd hh:mm:ss a";
    public static final String simple_date_format_yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss";
    public static final String simple_date_format_yyyy_MM_dd_HH_mm_ss_2 = "yyyy/MM/dd HH:mm:ss";

    public static final String simple_date_format_yyyyMMddhhmm = "yyyyMMddhhmm";
    public static final String simple_date_format_hhmm = "hhmm";
    public static final String simple_date_format_hh_mm = "hh:mm";
    public static final String simple_date_format_HHmm = "HHmm";
    public static final String simple_date_format_HH_mm = "HH:mm";

    /**
     * Decimal Number Format Patterns
     */
    public static final String decimal_number_format_comma_sep_for_non_decimal_values = "###,###";

    public static final String path_ddm_data_file_temp_upload = "/DDA/DATA_FILES_TMP/";
    public static final String path_ddm_report_common_path = "/DDA/REPORTS/";
    public static final String path_ddm_jasper_file_base_path = "/DDA/JASPER/";
    public static final String path_ddm_mail_logo_path = "/DDA/LOGO/PB_Mail_Logo.jpg";
    public static final String path_ddm_report_logo_path = "/DDA/LOGO/PB_Report_Logo.png";

    public static final String is_authorized_yes = "yes";

    //Redownload Request
    public static final String redownload_type_data = "Data";
    public static final String redownload_type_report = "Report";

    //tbl_parameter
    public static final String param_type_time = "T";
    public static final String param_type_day = "D";
    public static final String param_type_other = "N";
    public static final String param_type_pwd = "P";

    public static final String tbl_status_value_0 = "0";
    public static final String tbl_status_value_7 = "7";
    //tbl_reply
    public static final String default_web_combo_select = "-1";
    public static final String default_original_return_date = "000000";

    public static final String sec_key = "SalPay@PB#SlipsWeb2022";

    public static final String file_ext_type_cert = ".cer";
    public static final String file_ext_type_jasper = ".jasper";
    public static final String file_ext_type_pdf = ".pdf";
    public static final String file_ext_type_sig = ".sig";
    public static final String file_ext_type_txt = ".txt";

    public static final String file_cert_prefix = "CRT";
    public static final String report_type_owd_bk1_report_name_suffix = "BNK1";
    public static final String report_type_owd_rj1_report_name_suffix = "REJ1";
    public static final String report_type_owd_vl1_report_name_suffix = "VLD1";
    public static final String report_type_owd_vld_summary_sufix = "_ValidationSummary.txt";
    
    
    public static final String report_type_daily = "D";
    public static final String report_type_monthly = "M";
    public static final String report_type_annual = "Y";
    
    public static final String report_type_bank_daily = "BNKD";
    public static final String report_type_bank_monthly = "BNKM";
    public static final String report_type_bank_annual = "BNKY";
    
    public static final String report_type_lppl_daily = "LCPLD";
    public static final String report_type_lppl_monthly = "LCPLM";
    public static final String report_type_lppl_annual = "LCPLY";
    
    

    public static final String report_type_owd_bk1_report = "OWDUPL_BNK1";
    public static final String report_type_owd_rj1_report = "OWDUPL_REJ1";
    public static final String report_type_owd_vl1_report = "OWDUPL_VLD1";
    public static final String report_type_hogl = "HOGL";

    public static final String report_type_owd_bk1_report_name_suffix_full = "BK1.PDF";
    public static final String report_type_owd_bk1_report_name_original_suffix = "SLIPS-S-BNK01.pdf";

    public static final String report_type_iwd_report = "IWDR";
    public static final String report_type_iwd_file_encrypted = "IWDD";

    public static final String report_type_ow_core_data_file = "OW_CORE_DF";
    public static final String report_type_ow_lcpl_data_file = "OW_LCPL_DF";
    public static final String report_type_ih_br_summary = "IH_BR_S";
    public static final String report_type_iwd_ft_session = "IWDFT_S";
    public static final String report_type_iwd_ft_session_all = "IWDFT_S_A";
    public static final String report_type_ow_br_summary = "OW_BR_S";
    public static final String report_type_owd_ft_session = "OWDFT_S";
    public static final String report_type_owd_ft_session_all = "OWDFT_S_A";
    public static final String report_type_rtn_advice = "RTN_ADV";
    public static final String report_type_rtn_advice_all = "RTN_ADV_ALL";
    public static final String report_type_cfws_summary = "CFWS_S";
    public static final String report_type_cfws_branch_summary = "CFWS_BR_S";
    public static final String report_type_cfws_merchant_summary = "CFWS_COCU_S";

    public static final String report_ih_branch_summary = "IH_Branch_Summary";
    public static final String report_iwd_session_ft = "IWD_Session_FT";
    public static final String report_iwd_all_session_ft = "IWD_All_Session_FT";
    public static final String report_ow_branch_summary = "OW_Branch_Summary";
    public static final String report_owd_session_ft = "OWD_Session_FT";
    public static final String report_owd_all_session_ft = "OWD_All_Session_FT";
    public static final String report_rtn_advice = "RTN_Advice";
    public static final String report_customer_file_wise_session_summary = "CFWS_Summary";
    public static final String report_customer_file_wise_session_wise_branch_summary = "CFWS_Branch_Summary";
    public static final String report_customer_file_wise_session_wise_merchant_summary = "CFWS_CoCu_Summary";

    public static final String slip_file_status_processing = "1";
    public static final String slip_file_status_uploader_confirmed = "2";
    public static final String slip_file_status_fund_confirmed = "3";
    public static final String slip_file_status_ddm_manager_confirmed = "4";
    public static final String slip_file_status_error = "5";
    public static final String slip_file_status_process_completed = "6";
    public static final String slip_file_status_rejected_insufficient_fund = "7";
    public static final String slip_file_status_ddm_manager_rejected = "8";
    public static final String slip_file_status_timeout = "9";
    public static final String slip_file_status_upload_confirmed_merchant_supervisor = "10";
    public static final String slip_file_status_upload_rejected_merchant_supervisor = "11";

    public static final String file_download_status_ready_for_download = "0";
    public static final String file_download_status_processing = "1";
    public static final String file_download_status_complete = "2";
    public static final String file_download_status_error = "9";

    /**
     * Order Results By
     */
    public static final String results_order_by_file_uploaded_time = "uploadedtime";
    public static final String results_order_by_file_upload_confirmed_time = "uploadconfirmedtime";
    public static final String results_order_by_file_merchant_supervisor_confirmed_time = "cocusupervisorconfirmedtime";
    public static final String results_order_by_file_fund_verified_time = "fundverifiedtime";
    public static final String results_order_by_file_ddm_manager_approved_time = "slipsmanagerapprovedtime";

    /**
     * Log types
     */
    public static final String log_type_user_access_denied = "0000";
    public static final String log_type_user_login_info = "0001";
    public static final String log_type_user_init_password_reset = "0002";
    public static final String log_type_user_password_change = "0003";
    public static final String log_type_user_account_expired = "0004";
    public static final String log_type_user_account_locked = "0005";
    public static final String log_type_user_inquiry_transaction_ows_batch_status = "0006";
    public static final String log_type_user_inquiry_transaction_ows_file_transmission_status = "0007";
    public static final String log_type_user_inquiry_transaction_inward_download = "0008";
    public static final String log_type_user_inquiry_transaction_outward_details = "0009";
    public static final String log_type_user_inquiry_view_bank_details = "0010";
    public static final String log_type_user_inquiry_view_bank_window = "0011";
    public static final String log_type_user_inquiry_view_branch_details = "0012";
    public static final String log_type_user_inquiry_view_certificate_details = "0013";
    public static final String log_type_user_inquiry_view_cealring_calendar_details = "0014";
    public static final String log_type_user_inquiry_view_reject_reasons = "0015";
    public static final String log_type_user_inquiry_view_return_types = "0016";
    public static final String log_type_user_inquiry_view_transaction_types = "0017";
    public static final String log_type_user_inquiry_transaction_adhoc_reports = "0018";
    public static final String log_type_user_inquiry_transaction_ows_summary_ows_file_download = "0019";
    public static final String log_type_user_inquiry_transaction_ows_summary_transmission_confirmation = "0020";
    public static final String log_type_user_inquiry_transaction_ows_currently_transmitting_files = "0021";

    public static final String log_type_bank_admin_modify_ow_iw_data_paths = "0025";
    public static final String log_type_bank_admin_modify_inward_window_details = "0026";
    public static final String log_type_bank_admin_email_maintenance_modify_emailmapping = "0027";
    public static final String log_type_bank_admin_email_maintenance_view_emailmapping_details = "0028";

    public static final String log_type_user_inquiry_transaction_confirm_transmission_status = "0030";
    public static final String log_type_user_inquiry_transaction_modify_window_details_while_confirm_transmission_status = "0031";
    public static final String log_type_user_inquiry_transaction_delete_transmission_confirmation_status_while_extending_window = "0032";

    public static final String log_type_user_inquiry_transaction_inward_details = "0035";
    public static final String log_type_user_inquiry_transaction_inward_redownload_request_search = "0036";
    public static final String log_type_user_inquiry_transaction_inward_redownload_request = "0037";

    public static final String log_type_user_logout_info = "0040";
    public static final String log_type_user_expired_password_change = "0041";
    public static final String log_type_user_login_otp_validation = "0042";

    public static final String log_type_admin_user_maintenance_authorize_new_user = "0045";
    public static final String log_type_admin_user_maintenance_authorized_modified_user = "0046";
    public static final String log_type_admin_user_maintenance_authorize_deactivate_user = "0047";
    public static final String log_type_admin_user_maintenance_authorize_activate_user = "0048";
    public static final String log_type_admin_user_maintenance_deactivate_all_users_when_bank_deactivate = "0049";
    public static final String log_type_admin_user_maintenance_add_new_user = "0050";
    public static final String log_type_admin_user_maintenance_modify_user_details = "0051";
    public static final String log_type_admin_user_maintenance_view_user_details = "0052";
    public static final String log_type_admin_user_maintenance_deactivate_user = "0053";
    public static final String log_type_admin_user_maintenance_activate_user = "0054";
    public static final String log_type_admin_user_maintenance_reset_user_password = "0055";
    public static final String log_type_admin_user_maintenance_modify_user_level = "0056";

    public static final String log_type_admin_bank_branch_maintenance_add_new_bank = "0060";
    public static final String log_type_admin_bank_branch_maintenance_modify_bank_details = "0061";
    public static final String log_type_admin_bank_branch_maintenance_view_bank_details = "0062";
    public static final String log_type_admin_bank_branch_maintenance_add_new_branch = "0063";
    public static final String log_type_admin_bank_branch_maintenance_modify_branch_details = "0064";
    public static final String log_type_admin_bank_branch_maintenance_view_branch_details = "0065";

    public static final String log_type_admin_bank_branch_maintenance_authorized_new_bank = "0066";
    public static final String log_type_admin_bank_branch_maintenance_authorized_new_branch = "0067";
    public static final String log_type_admin_bank_branch_maintenance_authorized_modified_bank = "0068";
    public static final String log_type_admin_bank_branch_maintenance_authorized_modified_branch = "0069";

    public static final String log_type_admin_calendar_maintenance_add_calendar_year = "0070";
    public static final String log_type_admin_calendar_maintenance_add_calendar_details = "0071";
    public static final String log_type_admin_calendar_maintenance_modify_calendar_details = "0072";
    public static final String log_type_admin_calendar_maintenance_view_calendar_details = "0073";

    public static final String log_type_admin_merchant_maintenance_add_new_merchant = "0075";
    public static final String log_type_admin_merchant_maintenance_authorize_new_merchant = "0076";
    public static final String log_type_admin_merchant_maintenance_modify_merchant_details = "0077";
    public static final String log_type_admin_merchant_maintenance_authorize_modified_merchant_details = "0078";
    public static final String log_type_admin_merchant_maintenance_view_merchant_details = "0079";

    public static final String log_type_admin_parameter_maintenance_set_param_value = "0080";
    public static final String log_type_admin_parameter_maintenance_view_param_details = "0081";
    public static final String log_type_admin_parameter_maintenance_auth_modified_param_value = "0082";
    public static final String log_type_admin_parameter_maintenance_add_param_value = "0083";




    public static final String log_type_admin_functions_view_log_details = "0120";

    public static final String log_type_admin_reportmap_maintenance_add_new_reportmap_details = "0130";
    public static final String log_type_admin_reportmap_maintenance_view_reportmap_details = "0132";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_search = "0131";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_selection = "0133";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_confirmation = "0134";

    public static final String log_type_admin_email_maintenance_add_new_emailmapping = "0140";
    public static final String log_type_admin_email_maintenance_authorized_new_emailmapping = "0141";
    public static final String log_type_admin_email_maintenance_modify_emailmapping = "0142";
    public static final String log_type_admin_email_maintenance_authorized_modified_emailmapping = "0143";
    public static final String log_type_admin_email_maintenance_view_emailmapping_details = "0144";

    public static final String log_type_admin_session_maintenance_advance_session = "0146";

    public static final String log_type_admin_usr_lvl_func_map_maintenance_modify_userlevel_function_mapping = "0150";
    public static final String log_type_admin_usr_lvl_func_map_maintenance_authorized_modified_userlevel_function_mapping = "0151";
    public static final String log_type_admin_usr_lvl_func_map_maintenance_view_userlevel_function_mapping_details = "0152";

    public static final String log_type_user_message_download_attachment = "0180";
    public static final String log_type_user_message_compose_message_init = "0181";
    public static final String log_type_user_message_compose_message_send = "0182";
    public static final String log_type_user_message_search_inbox = "0183";
    public static final String log_type_user_message_search_outbox = "0184";
    public static final String log_type_user_message_view_new_msg_summary = "0185";
    public static final String log_type_user_message_view_recived_msg_details = "0186";
    public static final String log_type_user_message_view_sent_msg_details = "0187";
    public static final String log_type_user_message_reply_message_init = "0188";
    public static final String log_type_user_message_reply_message_send = "0189";

    public static final String log_type_user_upload_ddm_file_init = "0200";
    public static final String log_type_user_upload_ddm_file_confirmation = "0201";
    public static final String log_type_user_upload_ddm_file_confirmation_download_vs_file = "0202";

    public static final String log_type_user_confirm_on_uploaded_ddm_files_search = "0203";
    public static final String log_type_user_confirm_on_uploaded_ddm_transactions = "0204";

    public static final String log_type_user_confirm_ddm_transactions_fund_availability_search = "0205";
    public static final String log_type_user_confirm_ddm_transactions_fund_availability = "0206";

    public static final String log_type_user_confirm_ddm_transactions_manager_search = "0207";
    public static final String log_type_user_confirm_ddm_transactions_manager = "0208";

    public static final String log_type_user_generate_core_ow_file_initial = "0209";
    public static final String log_type_user_generate_core_ow_file = "0210";

    public static final String log_type_user_generate_lcpl_ow_file_initial = "0211";
    public static final String log_type_user_generate_lcpl_ow_file = "0212";

    public static final String log_type_user_download_generated_ddm_ow_file = "0213";

    public static final String log_type_user_confirm_on_uploaded_ddm_view_reject_transactions = "0214";

    public static final String log_type_user_generate_hogl_report_initial = "0215";
    public static final String log_type_user_generate_hogl_report = "0216";

    public static final String log_type_user_download_generated_hogl_report = "0217";

    public static final String log_type_user_confirm_on_uploaded_ddm_data_view_iw_des_br_999 = "0218";

    public static final String log_type_user_redownload_core_ow_file = "0220";
    public static final String log_type_user_redownload_lcpl_ow_file = "0221";
    public static final String log_type_user_redownload_hogl_report = "0221";

    public static final String log_type_user_reports_download_reports = "0300";
    public static final String log_type_user_reports_generate_ih_baranch_summary_report = "0301";
    public static final String log_type_user_reports_generate_ow_baranch_summary_report = "0302";
    
    public static final String log_type_user_reports_view_daily_reports = "0310";
    public static final String log_type_user_reports_view_monthly_reports = "0320";
    public static final String log_type_user_reports_view_annual_reports = "0330";

    public static final String log_type_user_ddm_request_issuing_bank_approval_search = "0400";
    public static final String log_type_user_ddm_request_issuing_bank_approval = "0401";

    public static final String log_type_user_ddm_request_acquiring_bank_approval_search = "0405";
    public static final String log_type_user_ddm_request_acquiring_bank_approval = "0406";

    public static final String log_type_lankapay_user_ddm_request_inquiry_search = "0410";
    public static final String log_type_bank_user_ddm_request_inquiry_search_as_issuing_bank = "0411";
    public static final String log_type_bank_user_ddm_request_inquiry_search_as_acquiring_bank = "0412";

//    public static final String log_type_user_upload_ddm_file_confirmation = "0201";    
//    public static final String log_type_user_upload_ddm_file_confirmation_download_vs_file = "0202";
    public static final String log_type_redirect_to_error_page = "0999";

}
