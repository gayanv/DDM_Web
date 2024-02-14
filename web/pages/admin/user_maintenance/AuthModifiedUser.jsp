<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>


<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>

<%
    String session_userName = null;
    String session_userType = null;
    String session_userTypeDesc = null;
    String session_bankCode = null;
    String session_bankName = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_cocuId = null;
    String session_cocuName = null;
    String session_menuId = null;
    String session_menuName = null;

    session_userName = (String) session.getAttribute("session_userName");

    if (session_userName == null || session_userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        session_userType = (String) session.getAttribute("session_userType");
        session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            //session.invalidate();
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Authorize Modified User' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Authorize_Modified_User");
            }
        }
        else
        {

%>

<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>


<%
    //Collection<UserLevel> colUserLevel = null;
    //Collection<Bank> colBank = null;
    //Collection<Branch> colBranch = null;
    Collection<User> col_user = null;
    User userDetails = null;

    String reqType = null;
    String selectedUsername = null;
    //String selectedUserLevel = null;
    //String selectedUserStatus = null;
    //String selectedUserBank = null;
    //String selectedUserBranch = null;

    String userID = null;
    String newUserStatus = null;
//    String newUserStatusDesc = null;
//    String oldUserStatusDesc = null;
    String newName = null;
    String newDesignation = null;
    String newEmail = null;
    String newContactNo = null;
    //String newUserRemarks = null;
    //String defaultPwd = null;
    String msg = null;

    boolean result = false;

    col_user = DAOFactory.getUserDAO().getAuthPendingModifiedUser(session_userName, DDM_Constants.status_user_modify_details, session_userType);

    //defaultPwd = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);
    reqType = (String) request.getParameter("hdnRequestType");

    if (reqType == null)
    {
        selectedUsername = "-1";
    }
    else if (reqType.equals("0"))
    {
        selectedUsername = request.getParameter("search_cmbUserId");

        if (selectedUsername != null && !selectedUsername.equals("-1"))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, DDM_Constants.status_all);
        }
    }
    else if (reqType.equals("1"))
    {
        selectedUsername = request.getParameter("search_cmbUserId");

        col_user = DAOFactory.getUserDAO().getAuthPendingModifiedUser(session_userName, DDM_Constants.status_user_modify_details, session_userType);

        if (selectedUsername != null && !selectedUsername.equals("-1"))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, DDM_Constants.status_all);
        }

        userID = request.getParameter("hdnUsername");

        UserDAO userDAO = DAOFactory.getUserDAO();
        User authUser = new User();
        authUser.setUserId(userID);
        authUser.setModificationAuthBy(session_userName);

        result = userDAO.doAuthorizeModifiedUser(authUser);

//        newUserStatusDesc = "Active";
//        oldUserStatusDesc = "Pending";
        String newUserStatusDesc = userDetails.getStatusModify() != null ? userDetails.getStatusModify().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatusModify().equals(DDM_Constants.status_deactive) ? "Deactive" : userDetails.getStatusModify().equals(DDM_Constants.status_locked) ? "Locked" : userDetails.getStatusModify().equals(DDM_Constants.status_expired) ? "Expired" : userDetails.getStatusModify().equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";
        String oldUserStatusDesc = userDetails.getStatus() != null ? userDetails.getStatus().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatus().equals(DDM_Constants.status_deactive) ? "Deactive" : userDetails.getStatus().equals(DDM_Constants.status_locked) ? "Locked" : userDetails.getStatus().equals(DDM_Constants.status_expired) ? "Expired" : newUserStatus.equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_authorized_modified_user, "| Username - " + userDetails.getUserId() + ", User Type - (New : " + (userDetails.getUserLevelDescModify() != null ? userDetails.getUserLevelDescModify() : "") + " , Old :" + (userDetails.getUserLevelDesc() != null ? userDetails.getUserLevelDesc() : "") + "), Branch - (New : " + (userDetails.getBranchCodeModify() != null ? userDetails.getBranchCodeModify() : "") + ", Old : " + userDetails.getBankCode() + "), Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + (userDetails.getNameModify() != null ? userDetails.getNameModify() : "") + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + (userDetails.getDesignationModify() != null ? userDetails.getDesignationModify() : "") + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + (userDetails.getEmailModify() != null ? userDetails.getEmailModify() : "") + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + (userDetails.getContactNoModify() != null ? userDetails.getContactNoModify() : "") + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), NIC - (New : " + (userDetails.getNICModify() != null ? userDetails.getNICModify().replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Old : " + (userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "") + "), Assign Token Serial - (New : " + (userDetails.getTokenSerialModify() != null ? userDetails.getTokenSerialModify() : "") + " , Old : " + (userDetails.getTokenSerial() != null ? userDetails.getTokenSerial() : "") + "), Remarks - (New : " + (userDetails.getRemarksModify() != null ? userDetails.getRemarksModify() : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_authorized_modified_user, "| Username - " + userDetails.getUserId() + ", User Type - (New : " + (userDetails.getUserLevelDescModify() != null ? userDetails.getUserLevelDescModify() : "") + " , Old :" + (userDetails.getUserLevelDesc() != null ? userDetails.getUserLevelDesc() : "") + "), Branch - (New : " + (userDetails.getBranchCodeModify() != null ? userDetails.getBranchCodeModify() : "") + ", Old : " + userDetails.getBankCode() + "), Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + (userDetails.getNameModify() != null ? userDetails.getNameModify() : "") + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + (userDetails.getDesignationModify() != null ? userDetails.getDesignationModify() : "") + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + (userDetails.getEmailModify() != null ? userDetails.getEmailModify() : "") + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + (userDetails.getContactNoModify() != null ? userDetails.getContactNoModify() : "") + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), NIC - (New : " + (userDetails.getNICModify() != null ? userDetails.getNICModify().replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Old : " + (userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "") + "), Assign Token Serial - (New : " + (userDetails.getTokenSerialModify() != null ? userDetails.getTokenSerialModify() : "") + " , Old : " + (userDetails.getTokenSerial() != null ? userDetails.getTokenSerial() : "") + "), Remarks - (New : " + (userDetails.getRemarksModify() != null ? userDetails.getRemarksModify() : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head>
    	<title>LankaPay Direct Debit Mandate Exchange System - Authorize New User</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />
        
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>

        <script language="javascript" type="text/JavaScript">



            function clearRecords_onPageLoad()
            {
            showClock(3);
            }

            function Cancel()
            {
            document.getElementById('search_cmbUserId').selectedIndex = 0;
            setRequestType(false);
            doSearchUser();
            }

            function password_Validation()
            {               
            var password = document.getElementById('txtUserPassword').value;
            var reType_password = document.getElementById('txtReTypePassword').value;

            if(password != reType_password)
            {

            return false;
            }
            else
            {
            return true;
            }
            }



            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2)
            {
            var val = new Array(<%=serverTime%>);
            clock(document.getElementById('showText'),type,val);
            }
            else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
                    clock(document.getElementById('showText'), type, val);
                }
            }

            function fieldValidation()
            {
            setRequestType(true);        
            document.frmAuthModifiedUser.action="AuthModifiedUser.jsp";
            document.frmAuthModifiedUser.submit();
            return true;

            }

            function showDivisionArea()
            {        
            if('<%=reqType%>' == '0')
            {
            // alert("reqType");
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'none';                    
            }
            else 
            {
            if('<%=result%>' == 'true')
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            else
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error') != null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            //Cancel();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser();
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            //Cancel();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser();
            }
            }
            }


            function doSearchUser()
            {
            setRequestType(false);
            document.frmAuthModifiedUser.action="AuthModifiedUser.jsp";
            document.frmAuthModifiedUser.submit();                    
            }


            function setRequestType(status)
            {
            if(status)
            {
            document.getElementById('hdnRequestType').value = "1";
            }
            else
            {
            document.getElementById('hdnRequestType').value = "0";
            }
            }


            function updateUserDetails()
            {                                   
            fieldValidation();			
            }

            function isempty(Value)
            {
            if(Value.length < 1)
            {
            return true;
            }
            else
            {
            var str = Value;

            while(str.indexOf(" ") != -1)
            {
            str = str.replace(" ","");
            }

            if(str.length < 1)
            {
            return true;
            }
            else
            {
            return false;
            }
            }
            }

            function trim(str) 
            {
            return str.replace(/^\s+|\s+$/g,"");
            }

        </script>
    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3)">

        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>
        
        <table width="100%" style="min-width:900;min-height:600" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" class="ddm_bgRepeat_center">
                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_bgRepeat_left">
                        <tr>
                            <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="ddm_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="102" valign="top" class="ddm_header_center">

                                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_header_left">
                                                            <tr>
                                                                <td valign="top"><table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0" class="ddm_header_right">
                                                                        <tr>
                                                                            <td><table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td height="75"><table width="900" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="22"><table width="100%" height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                    <td>

                                                                                                        <div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** LankaPay DDM ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=session_menuName%>" vqp_uid0=<%=session_menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                                                                cdd__codebase<%=session_menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=session_menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=session_menuId%>" language="JavaScript">create_menu(<%=session_menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="bottom"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="ddm_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="ddm_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuId : session_branchId%> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuName : session_branchName%></td>
                                                                                                                <td width="15">&nbsp;</td>
                                                                                                                <td valign="middle"><a href="<%=request.getContextPath()%>/pages/user/userProfile.jsp" title=" My Profile "><img src="<%=request.getContextPath()%>/images/user.png" width="18"
                                                                                                                                                                                                        height="22" border="0" align="middle" ></a></td>
                                                                                                                <td width="10"></td>
                                                                                                                <td class="ddm_menubar_text">[ <a href="<%=request.getContextPath()%>/pages/logout.jsp" class="ddm_menubar_link"><u>Logout</u></a> ]</td>
                                                                                                                <td width="5"></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5">                                        </td>
                                                                                    </tr>
                                                                                </table></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="min-height:400" align="center" valign="top" class="ddm_bgCommon">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">Business Date : <%=webBusinessDate%></td>
                                                                                        <td width="10" valign="middle"></td>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">|&nbsp; Now : [ <%=currentDate%></td>
                                                                                        <td width="5" valign="middle">&nbsp;</td>
                                                                                        <td valign="top" class="ddm_menubar_text_dark"><div id="showText" class="ddm_menubar_text_dark"></div></td>
                                                                                        <td width="5" valign="top" nowrap class="ddm_menubar_text_dark">&nbsp;]</td>                                                                                        
                                                                                    </tr>
                                                                          </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" valign="middle"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td height="5"></td>
                                                                            <td align="left" valign="top" ></td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="ddm_header_text">Authorize Modified User Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">
                                                                                            <form method="post" name="frmAuthModifiedUser" id="frmAuthModifiedUser">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center"><table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" >

                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                            <!--tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#A9D1B9" class="ddm_tbl_header_text">Branch :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1ECE4"class="ddm_tbl_header_text"></td>
                                                                                                                            </tr-->
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">User ID :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"> <select name="search_cmbUserId" class="ddm_field_border" id="search_cmbUserId" onChange="setRequestType(false);
                                                                                                                      doSearchUser();" onFocus="hideMessage_onFocus()" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>>
                                                                                                                                        <option value="-1" <%=(selectedUsername != null && selectedUsername.equals("-1")) ? "selected" : ""%>>-- Select User --</option>
                                                                                                                                        <% if (col_user != null && col_user.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (User u : col_user)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=u.getUserId()%>" <%=(selectedUsername != null && u.getUserId().equals(selectedUsername)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                        <% }
                                                                                                                                            }%>
                                                                                                                                    </select> <input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /> </td>
                                                                                                                            </tr>

                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center">





                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (userDetails == null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                                </tr>

                                                                                                                <%                                                                                    }
                                                                                                                else
                                                                                                                {
                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><div id="resultdata"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td align="center">
                                                                                                                                        <%
                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                                            User Modifications Approved Sucessfully.


                                                                                                                                        </div>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {%>


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >User Modifications Approval Failed.- <span class="ddm_error"><%=msg%></span></div>
                                                                                                                                            <%                                                                                            }
                                                                                                                                            %>
                                                                                                                                        <input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" />
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td height="10"></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td align="center" valign="middle">


                                                                                                                                        <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                                            <tr>
                                                                                                                                                <td>

                                                                                                                                                    <table border="0" cellspacing="1" cellpadding="5"  bgcolor="#FFFFFF">
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">
                                                                                                                                                                User ID :        </td>

                                                                                                                                                            <td colspan="2" valign="middle"class="ddm_tbl_common_text_bold"><%=userDetails.getUserId()%><input type="hidden" name="hdnUsername" id="hdnUsername" value="<%=userDetails.getUserId()%>" /></td>
                                                                                                                                                        </tr>
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                                                            <td align="center" valign="middle"class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                                                            <td align="center" valign="middle"class="ddm_tbl_header_text_horizontal">New Value</td>
                                                                                                                                                        </tr>
                                                                                                                                                        
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">User Type :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getUserLevelDesc()%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getUserLevelDescModify()%></td>
                                                                                                                                                        </tr>


                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Bank : </td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getBankCode()%> - <%=userDetails.getBankFullName()%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getBankCodeModify() %> - <%=userDetails.getBankFullNameModify() %></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Branch : </td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getBranchCode() %> - <%=userDetails.getBranchName() %></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getBranchCodeModify() %> - <%=userDetails.getBranchNameModify() %></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getStatus() != null ? userDetails.getStatus().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getStatusModify() != null ? userDetails.getStatusModify().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatusModify().equals(DDM_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Name :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getName() != null ? userDetails.getName() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getNameModify() != null ? userDetails.getNameModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Employee ID : </td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmpId() != null ? userDetails.getEmpId() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmpIdModify() != null ? userDetails.getEmpIdModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Designation :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getDesignation() != null ? userDetails.getDesignation() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getDesignationModify() != null ? userDetails.getDesignationModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">E-Mail : </td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmail() != null ? userDetails.getEmail() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmailModify() != null ? userDetails.getEmailModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Contact No. :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getContactNo() != null ? userDetails.getContactNo() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getContactNoModify() != null ? userDetails.getContactNoModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">NIC | Passport :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getNIC() != null ? userDetails.getNIC() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getNICModify() != null ? userDetails.getNICModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Assigned Token Serial :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getTokenSerial() != null ? userDetails.getTokenSerial() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getTokenSerialModify() != null ? userDetails.getTokenSerialModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Remarks :</td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getRemarks() != null ? userDetails.getRemarks() : "N/A"%></td>
                                                                                                                                                            <td valign="middle" class="ddm_tbl_common_text"><%=userDetails.getRemarksModify() != null ? userDetails.getRemarksModify() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td height="8" colspan="3" align="left" valign="middle" class="ddm_tbl_footer_text"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Modified By :</td>
                                                                                                                                                            <td colspan="2" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getModifiedBy() != null ? userDetails.getModifiedBy() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Modified Date :</td>
                                                                                                                                                            <td colspan="2" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getModifiedDate() != null ? userDetails.getModifiedDate() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td height="35" colspan="3" align="right" valign="middle" bgcolor="#CDCDCD" class="ddm_tbl_footer_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                      <td><input type="button" value="&nbsp;&nbsp; Authorize &nbsp;&nbsp;" name="btnUpdate" id="btnUpdate" class="ddm_custom_button" onClick="updateUserDetails()" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>/></td>
                                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=reqType%>" /></td>
                                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((reqType != null && reqType.equals("1")) && result) ? "Done" : "Cancel"%> &nbsp;&nbsp;" type="button" onClick="<%=((reqType != null && reqType.equals("1")) && result) ? "Cancel()" : "Cancel()"%>" class="ddm_custom_button" />                                                            </td></tr>
                                                                                                                                                                </table></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table>


                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>










                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%                                                                                                                }
                                                                                                            %>                                                                                





                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>



                                                                                            </form>
                                                                                        </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15">&nbsp;</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="50">&nbsp;</td>
                                                                            <td align="left" valign="top" >&nbsp;</td>
                                                                            <td>&nbsp;</td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                        </table>                          </td>
                                                </tr>


                                            </table></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                </td></tr>
            <tr>
                <td height="32" class="ddm_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_footter_left">
                        <tr>
                            <td height="32">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_footter_right">
                                    <tr>
                                        <td height="32" valign="bottom">
                                            <table width="100%" height="32" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="10"></td>
                                                    <td valign="middle" class="ddm_copyRight"></td>
                                                    <td align="right" valign="middle" class="ddm_copyRight"></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td width="25"></td>
                                                    <td valign="middle" class="ddm_copyRight">&copy; 2023 LankaPay (Pvt) Ltd. All rights reserved. | Tel: 011 2334455 | Mail: helpdesk.ddm@lankapay.net</td>
                                                    <td align="right" valign="middle" class="ddm_copyRight">Developed By - Transnational Technology Solutions Lanka (Pvt) Ltd.</td>
                                                    <td width="25"></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table>




                </td>
            </tr>
        </table>

    </body>
</html>
<%
        }
    }
%>
