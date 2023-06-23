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
    String session_pw = null;
    String session_bankCode = null;
    String session_bankName = null;
    String session_sbCode = null;
    String session_sbType = null;
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
        session_pw = (String) session.getAttribute("session_password");
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Reset User Passwords' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Reset_User_Passwords");
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
    Collection<UserLevel> colUserLevel = null;
    //Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<User> col_user = null;

    String isReq = null;
    String selectedUserId = null;
    String newUserPassword = null;
    String newUserReTypePassword = null;
    String newUserLevel = null;
    String newUserStatus = null;
    String newUserBank = null;
    String newUserBranch = null;
    String msg = null;
    String defaultPwd = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    //colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(DDM_Constants.default_bank_code, DDM_Constants.status_pending);

    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);

    isReq = (String) request.getParameter("hdnReq");

    //System.out.println("isReq - " + isReq);
    if (isReq == null)
    {
        isReq = "0";

        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            newUserLevel = DDM_Constants.status_all;
            newUserStatus = DDM_Constants.status_all;
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
        {
            newUserLevel = DDM_Constants.status_all;
            newUserStatus = DDM_Constants.status_all;
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else
        {
            newUserLevel = DDM_Constants.status_all;
            newUserStatus = DDM_Constants.status_all;
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = DDM_Constants.status_all;
        }

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), "'" + DDM_Constants.status_pending + "'");
    }
    else if (isReq.equals("0"))
    {
        selectedUserId = (String) request.getParameter("cmbUserId");
        newUserPassword = (String) request.getParameter("txtUserPassword");
        newUserReTypePassword = (String) request.getParameter("txtReTypePassword");
        newUserLevel = (String) request.getParameter("cmbUserLevel");
        newUserStatus = (String) request.getParameter("cmbStatus");

        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {

            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
        {

            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else
        {
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = (String) request.getParameter("cmbBranch");
        }

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), "'" + DDM_Constants.status_pending + "'");

    }
    else if (isReq.equals("1"))
    {
        selectedUserId = (String) request.getParameter("cmbUserId");
        newUserPassword = (String) request.getParameter("txtUserPassword");
        newUserReTypePassword = (String) request.getParameter("txtReTypePassword");
        newUserLevel = (String) request.getParameter("cmbUserLevel");
        newUserStatus = (String) request.getParameter("cmbStatus");

        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {

            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
        {

            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = session_branchId;
        }
        else
        {
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = (String) request.getParameter("cmbBranch");
        }

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), "'" + DDM_Constants.status_pending + "'");

        String currentUserStat = null;
        String userStat = null;

        if (newUserStatus != null && newUserStatus.equals(DDM_Constants.status_all))
        {
            User objUser = DAOFactory.getUserDAO().getUserDetails(selectedUserId, DDM_Constants.status_all);

            currentUserStat = objUser.getStatus();

            if (objUser != null && (objUser.getStatus().equals(DDM_Constants.status_expired) || objUser.getStatus().equals(DDM_Constants.status_locked)))
            {
                userStat = DDM_Constants.status_active;
            }
        }
        else if (newUserStatus != null && (newUserStatus.equals(DDM_Constants.status_expired) || newUserStatus.equals(DDM_Constants.status_locked)))
        {
            currentUserStat = newUserStatus;
            userStat = DDM_Constants.status_active;
        }

        UserDAO userDAO = DAOFactory.getUserDAO();

        result = userDAO.resetUserPassword(new User(selectedUserId, newUserPassword, userStat), true);

        if (!result)
        {
            msg = userDAO.getMsg();

            currentUserStat = currentUserStat != null ? currentUserStat.equals(DDM_Constants.status_active) ? "Active" : currentUserStat.equals(DDM_Constants.status_deactive) ? "Deactive" : currentUserStat.equals(DDM_Constants.status_locked) ? "Locked" : currentUserStat.equals(DDM_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
            userStat = userStat != null ? userStat.equals(DDM_Constants.status_active) ? "Active" : userStat.equals(DDM_Constants.status_deactive) ? "Deactive" : userStat.equals(DDM_Constants.status_locked) ? "Locked" : userStat.equals(DDM_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_reset_user_password, "| User Name - " + selectedUserId + ", Status - (New : " + userStat + ", Old : " + currentUserStat + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            currentUserStat = currentUserStat != null ? currentUserStat.equals(DDM_Constants.status_active) ? "Active" : currentUserStat.equals(DDM_Constants.status_deactive) ? "Deactive" : currentUserStat.equals(DDM_Constants.status_locked) ? "Locked" : currentUserStat.equals(DDM_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
            userStat = userStat != null ? userStat.equals(DDM_Constants.status_active) ? "Active" : userStat.equals(DDM_Constants.status_deactive) ? "Deactive" : userStat.equals(DDM_Constants.status_locked) ? "Locked" : userStat.equals(DDM_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_reset_user_password, "| User Name - " + selectedUserId + ", Status - (New : " + userStat + ", Old : " + currentUserStat + ") | Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>


<head>

    <title>LankaPay Direct Debit Mandate Exchange System - Reset Password</title>
    <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
    <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />
    <link href="../../../css/tcal.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>



    <script language="javascript" type="text/JavaScript">

        function validate()
        {

        var selUser = document.getElementById('cmbUserId').value;
        var password = document.getElementById('txtUserPassword').value;
        var reType_password = document.getElementById('txtReTypePassword').value;
        //alert("password.length "+password.length);

        if(password.length < 8)
        {
        alert("Password must have more than 8 character");
        return false;
        }

        if(selUser == "-1")
        {
        alert("You must select valid user name for reset password!");
        document.getElementById('cmbUserId').focus();
        return false;
        }
        else
        {
        if(isempty(password))
        {
        alert("Password field can't be empty.");
        return false;
        }
        else
        {
        if(isempty(reType_password))
        {
        alert("Password and Re-type Password does not match.");
        return false;
        }
        else
        {
        if(password != reType_password)
        {
        alert("Password does not match with the Re-type Password!");
        document.getElementById('txtUserPassword').value="";
        document.getElementById('txtReTypePassword').value="";
        document.getElementById('txtUserPassword').focus();
        this.setAnimLights();
        return false;
        }
        else
        {
        document.frmResetPwd.submit();
        }
        }
        }	
        }

        }

        function showClock(type)
        {
        if (type == 1)
        {
        clock(document.getElementById('showText'), type, null);
        }
        else if (type == 2)
        {
        var val = new Array(<%=serverTime%>);
        clock(document.getElementById('showText'), type, val);
        }
        else if (type == 3)
        {
        var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=window != null ? window.getOW_cutontimeHour() : null%>, <%=window != null ? window.getOW_cutontimeMinutes() : null%>, <%=window != null ? window.getOW_cutofftimeHour() : null%>, <%=window != null ? window.getOW_cutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=window != null ? window.getIW_cutontimeHour() : null%>, <%=window != null ? window.getIW_cutontimeMinutes() : null%>, <%=window != null ? window.getIW_cutofftimeHour() : null%>, <%=window != null ? window.getIW_cutofftimeMinutes() : null%>);
        clock(document.getElementById('showText'), type, val);
        }
        }

        function isRequest(status)
        {
        if(status)
        {
        document.getElementById('hdnReq').value = "1";
        }
        else
        {                    
        document.getElementById('hdnReq').value = "0";
        }
        }


        function validatePassword()
        {
        var newPassword = document.getElementById('txtUserPassword').value;

        if(isempty(newPassword))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Empty Password!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if(findSpaces(newPassword))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Spaces not allowed!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if(trim(newPassword).length < 8)
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Password length less than 8 characters!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if (trim(newPassword).match(/[0-9]/) && trim(newPassword).match(/[a-zA-Z]/))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='block';
        document.getElementById('imgOK').title='Correct password which match with password policy.';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='none';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=false;
        }
        }
        else
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Password must be a combination of alpha-numeric characters!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        }

        }

        }
        }

        function hideMessage_onFocus()
        {
        if(document.getElementById('displayMsg_error') != null)
        {
        document.getElementById('displayMsg_error').style.display='none';
        }

        if(document.getElementById('displayMsg_success') != null)
        {
        document.getElementById('displayMsg_success').style.display = 'none';
        }
        }


        function resetRecords()
        {


        document.getElementById('cmbUserLevel').selectedIndex = 0;
        document.getElementById('cmbStatus').selectedIndex = 0;
        document.getElementById('cmbBranch').selectedIndex = 0; 


        if(document.getElementById('cmbBranch')!=null)
        {
        document.getElementById('cmbBranch').selectedIndex = 0; 
        }

        document.getElementById('cmbUserId').selectedIndex = 0; 				
        document.getElementById('txtUserPassword').value = "<%=defaultPwd%>";
        document.getElementById('txtReTypePassword').value = "<%=defaultPwd%>";
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

        function findSpaces(str)
        {

        var status = false;
        var strTrimed = this.trim(str);

        for (var i=0;i<strTrimed.length;i++)
        {
        if(strTrimed[i]== " ")
        {
        status = true;
        break;
        }
        }

        return status;                
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
                                                                                                        <div id="layer" style="position:absolute;visibility:hidden;">**** SLIPS ****</div>
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

                                                                                    <td width="10" valign="middle"></td>
                                                                                    <%
                                                                                        String owWindowStartTime = window.getOW_cutontime() != null ? window.getOW_cutontime().substring(0, 2) + ":" + window.getOW_cutontime().substring(2) : "00:00";
                                                                                        String owWindowEndTime = window.getOW_cutofftime() != null ? window.getOW_cutofftime().substring(0, 2) + ":" + window.getOW_cutofftime().substring(2) : "00:00";

                                                                                        String iwWindowStartTime = window.getIW_cutontime() != null ? window.getIW_cutontime().substring(0, 2) + ":" + window.getIW_cutontime().substring(2) : "00:00";
                                                                                        String iwWindowEndTime = window.getIW_cutofftime() != null ? window.getIW_cutofftime().substring(0, 2) + ":" + window.getIW_cutofftime().substring(2) : "00:00";
                                                                                    %>

                                                                                    <td valign="top" nowrap class="ddm_menubar_text_dark">| &nbsp; Session : <%=winSession%></td>
                                                                                    <td width="5" valign="middle"></td>

                                                                                    <td valign="top" nowrap class="ddm_menubar_text_dark"><table border="0" cellspacing="0">
                                                                                            <tr height="12">
                                                                                                <td valign="middle" nowrap class="ddm_menubar_text_dark">[</td>
                                                                                                <td valign="middle" nowrap class="ddm_menubar_text_dark"><span class="ddm_menubar_text_dark" title="Outward (OWNM) Window Start and End Time">OW (<%=owWindowStartTime%>-<%=owWindowEndTime%>)</span></td>
                                                                                                <td width="3" valign="middle"></td>
                                                                                                <td valign="middle"><div id="actWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward (OWNM) Window is active!" ></div>
                                                                                                    <div id="expWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward (OWNM) Window is expired!" ></div></td>
                                                                                                <td valign="middle" nowrap class="ddm_menubar_text_dark">| <span class="ddm_menubar_text_dark" title="Inward (IWNM) Window Start and End Time">IW (<%=iwWindowStartTime%>-<%=iwWindowEndTime%>)</span>                                                                                          </td>
                                                                                                <td width="3" valign="middle"></td>
                                                                                                <td valign="middle" class="ddm_menubar_text"><div id="actWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (IWNM) Window is active!" ></div>
                                                                                                    <div id="expWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward (IWNM) Window is expired!" ></div></td>
                                                                                                <td valign="middle" class="ddm_menubar_text_dark">]&nbsp;</td>
                                                                                            </tr>
                                                                                        </table></td>
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
                                                                                    <td align="left" valign="top" class="ddm_header_text">Reset User  Password</td>
                                                                                    <td width="10">&nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td height="20"></td>
                                                                                    <td></td>
                                                                                    <td></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="10"></td>
                                                                                    <td align="center" valign="top" class="ddm_header_text">


                                                                                        <form id="frmResetPwd" name="frmResetPwd" action="UserPwdReset.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">

                                                                                                <%
                                                                                                    if (isReq.equals("1") && result == true)
                                                                                                    {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="ddm_Display_Success_msg" >Password Changed Succesfully.</div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="ddm_Display_Error_msg"><div id="displayMsg_error" class="ddm_Display_Error_msg" >Password Reset Failed - <span class="ddm_error"><%=msg%></span></div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>

                                                                                                <% }%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="top" class="ddm_Display_Error_msg"><table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" >

                                                                                                            <tr>
                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">User Type :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><select name="cmbUserLevel" id="cmbUserLevel" class="ddm_field_border" onChange="isRequest(false);
                                                                                                                                            frmResetPwd.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(newUserLevel != null && newUserLevel.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <%
                                                                                                                                        for (UserLevel usrlvl : colUserLevel)
                                                                                                                                        {
                                                                                                                                            if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                            {
                                                                                                                                                if (usrlvl.getUserLevelId().equals(DDM_Constants.user_type_merchant_su) || usrlvl.getUserLevelId().equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                                {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=usrlvl.getUserLevelId()%>" <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
                                                                                                                                    {
                                                                                                                                        if (usrlvl.getUserLevelId().equals(DDM_Constants.user_type_bank_manager) || usrlvl.getUserLevelId().equals(DDM_Constants.user_type_bank_user) || usrlvl.getUserLevelId().equals(DDM_Constants.user_type_merchant_su) || usrlvl.getUserLevelId().equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=usrlvl.getUserLevelId()%>" <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=usrlvl.getUserLevelId()%>" <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                    <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                </select></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><select name="cmbStatus" id="cmbStatus" class="ddm_field_border" onChange="isRequest(false);
                                                                                                                                    frmResetPwd.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_active%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_deactive%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_expired%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_locked%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                </select></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Branch :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><select name="cmbBranch" id="cmbBranch" class="ddm_field_border" onChange="isRequest(false);
                                                                                                                                    frmResetPwd.submit()" onFocus="hideMessage_onFocus()" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op) || session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user)) ? "disabled" : ""%>>
                                                                                                                                    <%
                                                                                                                                        if (newUserBranch == null || newUserBranch.equals(DDM_Constants.status_all))
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                        if (colBranch != null && colBranch.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (Branch br : colBranch)
                                                                                                                                            {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=br.getBranchCode()%>" <%=(newUserBranch != null && br.getBranchCode().equals(newUserBranch)) ? "selected" : ""%> >
                                                                                                                                        <%=br.getBranchCode() + " - " + br.getBranchName()%></option>
                                                                                                                                        <%

                                                                                                                                                }
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                </select>                                                                                                                            </td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">User Name :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"> <select name="cmbUserId" class="ddm_field_border" id="cmbUserId" onFocus="hideMessage_onFocus()" >
                                                                                                                                    <option value="-1" selected="selected">-- Select User --</option>
                                                                                                                                    <% if (col_user != null && col_user.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (User u : col_user)
                                                                                                                                            {
                                                                                                                                                if (u != null && !(u.getUserId().equals(session_userName)))
                                                                                                                                                {
                                                                                                                                                    if (session_userType.equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                                    {
                                                                                                                                                        if (u.getUserLevelId().equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <% 
                                                                                                                                                        }                                                                                                                                    
                                                                                                                                                    }
                                                                                                                                                    else if (session_userType.equals(DDM_Constants.user_type_merchant_su))
                                                                                                                                                    {
                                                                                                                                                        if (u.getUserLevelId().equals(DDM_Constants.user_type_merchant_su) || u.getUserLevelId().equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <% 
                                                                                                                                                        }                                                                                                                                    
                                                                                                                                                    }
                                                                                                                                                    else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
                                                                                                                                                    {
                                                                                                                                                        if (u.getUserLevelId().equals(DDM_Constants.user_type_bank_manager) || u.getUserLevelId().equals(DDM_Constants.user_type_bank_user) || u.getUserLevelId().equals(DDM_Constants.user_type_merchant_su) || u.getUserLevelId().equals(DDM_Constants.user_type_merchant_op))
                                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <% 
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <%
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }%>
                                                                                                                                </select>  </td></tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">New Password <span class="ddm_required_field">*</span> :</td>

                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><input name="txtUserPassword" type="password" class="ddm_field_border" id="txtUserPassword" value="<%=(newUserPassword != null) ? newUserPassword : defaultPwd%>" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_header_text">Re-Type Password <span class="ddm_required_field">*</span> :</td>

                                                                                                                            <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                <input name="txtReTypePassword" type="password" class="ddm_field_border" id="txtReTypePassword" value="<%=(newUserPassword != null) ? newUserPassword : defaultPwd%>" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/>                    </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" />                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="Change" name="btnChange" id="btnChange" class="ddm_custom_button" onClick="isRequest(true);
                                                                                                                                                validate();"/>                             </td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetRecords()" class="ddm_custom_button" />                                                </td></tr>
                                                                                                                                </table></td>
                                                                                                                        </tr>

                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table>




                                                                                        </form>



                                                                                    </td>
                                                                                    <td width="10"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td></td>

                                                                                    <td align="center" valign="top">&nbsp;</td>


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
