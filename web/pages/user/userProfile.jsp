
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../error.jsp"%>

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
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

%>

<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    User usr = null;
    String isReq = null;
    String msg = null;
    boolean result = false;

    int iMinPwdHistory = 1;
    int iMinPwdResetDays = 1;
    int iMinPwdLength = 8;
    int iMinLowChars = 1;
    int iMinUpChars = 1;

    try
    {
        String strMinPwdHistory = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_pwd_history);

        if (strMinPwdHistory != null)
        {
            iMinPwdHistory = Integer.parseInt(strMinPwdHistory);
        }
        else
        {
            iMinPwdHistory = 1;
        }
    }
    catch (Exception e)
    {
        iMinPwdHistory = 1;
    }

    try
    {
        String strMinPwdLength = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_pwd_length);

        if (strMinPwdLength != null)
        {
            iMinPwdLength = Integer.parseInt(strMinPwdLength);
        }
        else
        {
            iMinPwdLength = 8;
        }
    }
    catch (Exception e)
    {
        iMinPwdLength = 8;
    }

    try
    {
        String strMinLowChars = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_lowercase_characters);

        if (strMinLowChars != null)
        {
            iMinLowChars = Integer.parseInt(strMinLowChars);
        }
        else
        {
            iMinLowChars = 1;
        }
    }
    catch (Exception e)
    {
        iMinLowChars = 1;
    }

    try
    {
        String strMinUpChars = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_uppercase_characters);

        if (strMinUpChars != null)
        {
            iMinUpChars = Integer.parseInt(strMinUpChars);
        }
        else
        {
            iMinUpChars = 1;
        }
    }
    catch (Exception e)
    {
        iMinUpChars = 1;
    }

    try
    {
        String strPwdResetDays = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_pwd_change_days);

        if (strPwdResetDays != null)
        {
            iMinPwdResetDays = Integer.parseInt(strPwdResetDays);
        }
        else
        {
            iMinPwdResetDays = 1;
        }
    }
    catch (Exception e)
    {
        iMinPwdResetDays = 1;
    }

    boolean isOkToChangePassword = DAOFactory.getUserDAO().isOkToChangePassword(session_userName, iMinPwdResetDays);

    isReq = (String) request.getParameter("hdnReq");

    usr = DAOFactory.getUserDAO().getUserDetails(session_userName, DDM_Constants.status_active);

    if (isReq == null)
    {
        isReq = "0";
    }
    else if (isReq.equals("0"))
    {

    }
    else if (isReq.equals("1"))
    {
        String user = request.getParameter("txt_User");
        String currentPwd = request.getParameter("txt_CurrentPassword");
        String new_pw = request.getParameter("txtNewPwd");

        UserDAO userDAO = DAOFactory.getUserDAO();
        //result = userDAO.changeUserPassword(new User(user, new_pw.trim()), currentPwd.trim(), false);

        if (user != null && new_pw != null)
        {
            result = userDAO.changeUserPassword(new User(user, new_pw.trim()), currentPwd.trim(), false);
        }

        if (result)
        {
            PWD_HistoryDAO pwdHisDAO = DAOFactory.getPWD_HistoryDAO();

            boolean pwdHisUpdateStat = pwdHisDAO.addPWD_History(new PWD_History(user, new_pw.trim()));

            if (pwdHisUpdateStat)
            {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_password_change, "| Username - " + user + ") | Process Status - Success | Done By - " + user + " (" + session_userTypeDesc + ") |"));

            }
            else
            {
                msg = pwdHisDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_password_change, "| Username - " + user + ") | Process Status - Unsuccess update password history (" + msg + ") | Done By - " + user + " (" + session_userTypeDesc + ") |"));

            }
        }
        else
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_password_change, "| Username - " + user + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + user + " (" + session_userTypeDesc + ") |"));
        }

    }

%>

<head>    
    <title>LankaPay Direct Debit Mandate Exchange System - User Profile</title>
    <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
    <link href="<%=request.getContextPath()%>/css/animbg3.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
    <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/datetimepicker.js"></script>

    <script language="javascript" type="text/JavaScript">

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

        function passwordValidation()
        {
        var curPassword = document.getElementById('txt_CurrentPassword').value;
        var password = document.getElementById('txtNewPwd').value;
        var reType_password = document.getElementById('txtConfirmPwd').value;

        if(isempty(curPassword))
        {
        alert("Current Password field can't be empty!");
        document.getElementById('txt_CurrentPassword').focus();
        return false;
        }
        else if(isempty(password))
        {
        alert("Password field can not be empty!");
        document.getElementById('txtNewPwd').focus();
        return false;
        }
        else
        {

        if(isempty(reType_password))
        {
        alert("Confirm Password field can not be empty!");
        return false;
        }
        else
        {
        if(password != reType_password)
        {
        alert("Password does not match with the Confirm Password!");
        document.getElementById('txtNewPwd').value="";
        document.getElementById('txtConfirmPwd').value="";
        document.getElementById('txtNewPwd').focus();
        this.setAnimLights();
        return false;	
        }
        else
        {
        document.frmprofilechange.submit();
        }
        }
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

        function setAnimLights()
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';					
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='none';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }

        function clearRecords()
        {
        document.getElementById('txt_CurrentPassword').value = "";
        document.getElementById('txtNewPwd').value = "";
        document.getElementById('txtConfirmPwd').value = "";
        }		

        function validatePassword()
        {

            var newPassword = document.getElementById('txtNewPwd').value;
            var minPwdLength = <%=iMinPwdLength%>;
            var minLowChars = <%=iMinLowChars%>;
            var minUpChars = <%=iMinUpChars%>;

        if (isempty(newPassword))
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Empty Password!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {                
        if (findSpaces(newPassword))
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Spaces not allowed!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        if (trim(newPassword).length < minPwdLength)
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
            document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
            document.getElementById('txtNewPwd').title = 'Password length less than ' + minPwdLength + ' characters!';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password length less than ' + minPwdLength + ' characters!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        var userID = '<%=session_userName%>';

        if ((newPassword.toUpperCase()).indexOf(userID.toUpperCase()) >= 0)
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password can not contain UserId!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        if (trim(newPassword).match(/[0-9]/) && trim(newPassword).match(/[a-zA-Z]/) && trim(newPassword).match(/[^\w\s]/))
        {

        var nPwd = trim(newPassword);
        var ucCharCount = 0;
        var lcCharCount = 0;            
        var charVal = '';
        var charValUC = '';
        var charValLC = '';

        for (var i = 0; i < nPwd.length; i++)
        {
        charVal = nPwd.charAt(i);

        if (charVal.match(/[a-zA-Z]/))
        {
        charValUC = charVal.toUpperCase();
        charValLC = charVal.toLowerCase();

        //alert('charVal --> |' + charVal + '|  charValUC --> |' + charValUC + '|  charValLC --> |' + charValLC + '|');

        if (charVal === charValUC)
        {
        ucCharCount++;
        }

        if (charVal === charValLC)
        {
        lcCharCount++;
        }
        }
        }

        //alert('ucCharCount --> ' + ucCharCount + '  lcCharCount --> ' + lcCharCount);

        if (ucCharCount >= minUpChars)
        {
        if (lcCharCount >= minLowChars)
        {
        isPWDNotAvailableInHistory();
        //validatePassword();                                            
        }
        else
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        document.getElementById('txtNewPwd').title = 'Password must contain minimum of ' + minLowChars + ' lower case characters!';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password must contain minimum of ' + minLowChars + ' lower case characters!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        }
        else
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        document.getElementById('txtNewPwd').title = 'Password must contain minimum of ' + minUpChars + ' upper case characters!';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password must contain minimum of ' + minUpChars + ' upper case characters!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }                                
        }
        else
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password must be a combination of alpha-numeric characters and at least one special character!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        }

        }

        }

        }
        }

        function isPWDNotAvailableInHistory()
        {
        var xmlhttp;
        var k = document.getElementById("txtNewPwd").value;
        //alert('txtNewPwd - ' + k)
        var urls = "getPWDHis.jsp?p=" + encodeURIComponent(k);
        var status = false;

        var res;

        if (window.XMLHttpRequest)
        {
        xmlhttp = new XMLHttpRequest();
        }
        else
        {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xmlhttp.onreadystatechange = function ()
        {
        if (xmlhttp.readyState == 4)
        {
        res = xmlhttp.responseText;
        //alert("res 1 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

        if (trim(res) == "1")
        {
        status = true;
        document.getElementById("hdnIsPWDAvailableHis").value = "1";

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_ok';
        }

        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'block';
        document.getElementById('imgOK').title = 'Correct password which match with password policy.';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'none';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = false;
        }
        }
        else if (trim(res) == "0")
        {
        status = false;
        document.getElementById("hdnIsPWDAvailableHis").value = "0";

        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        status = false;
        document.getElementById("hdnIsPWDAvailableHis").value = "0";

        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }

        if (document.getElementById('txtNewPwd') != null)
        {
        document.getElementById('txtNewPwd').className = 'ddm_login_input_text_error';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        }
        }

        xmlhttp.open("POST", urls, true);
        //xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send();

        //alert("res 2 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

        //return status;
        }    

        function hideMessage_onFocus()
        {

        if(document.getElementById('displayMsg_error') != null)
        {
        document.getElementById('displayMsg_error').style.display='none';

        if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
        {
        clearRecords();
        document.getElementById('hdnCheckPOSForClearREcords').value = '0';
        }
        }

        if(document.getElementById('displayMsg_success') != null)
        {
        document.getElementById('displayMsg_success').style.display = 'none';

        if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
        {
        clearRecords();
        document.getElementById('hdnCheckPOSForClearREcords').value = '0';
        }
        }
        }

        function doRefresh()
        {
        isRequest(false);
        document.frmprofilechange.submit();            
        }
        
        function cancel()
        {
        document.frmprofilechange.action="<%=request.getContextPath()%>/pages/homepage.jsp";
        document.frmprofilechange.submit();
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3);setAnimLights()">

    <div>
        <div class="wave"></div>
        <div class="wave"></div>
        <div class="wave"></div>
    </div>

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
                                                                                    <td align="left" valign="top" class="ddm_header_text">User Profile</td>
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


                                                                                        <form id="frmprofilechange" name="frmprofilechange" method="post"  action="userProfile.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">

                                                                                                <%
                                                                                                    if (isReq.equals("1") && result == true)
                                                                                                    {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="ddm_Display_Success_msg" >Password Changed Succesfully.</div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" align="center" ><input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" /></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="ddm_Display_Error_msg"><div id="displayMsg_error" class="ddm_Display_Error_msg" >Password change Failed - <span class="ddm_error"><%=msg%></span></div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" align="center" ><input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" /></td>
                                                                                                </tr>

                                                                                                <% }%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="top" class="ddm_Display_Error_msg"><table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" >

                                                                                                            <tr>
                                                                                                                <td><table border="0" cellspacing="1" cellpadding="4" >
                                                                                                          <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Username :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"> <%=session_userName%> <input name="txt_User" type="hidden" id="txt_User" value="<%=session_userName%>" />  </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">User Level :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getUserLevelDesc()%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Bank :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getBankCode()%> - <%=usr.getBankFullName()%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Name : </td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getName() != null ? usr.getName() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Designation :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getDesignation() != null ? usr.getDesignation() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">E-Mail :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getEmail() != null ? usr.getEmail() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Contact No. :</td>
                                                                                                                            <td valign="middle"class="ddm_tbl_common_text"><%=usr.getContactNo() != null ? usr.getContactNo() : "N/A"%></td>
                                                                                                                        </tr>

                                                                                                                        <%
                                                                                                                            if (!isOkToChangePassword)
                                                                                                                            {

                                                                                                                        %>

                                                                                                                        <tr>
                                                                                                                            <td colspan="2" align="center" valign="middle" class="ddm_tbl_special_area"><span class="ddm_error">Reset your current password is disabled due to minimum password reset days are not completed! <br>
                                                                                                                                    [ You have to wait minimum of <%=iMinPwdResetDays%> day(s) from last password reset date. - <%=usr.getLastPasswordResetDate()%>]</span></td>
                                                                                                                        </tr>

                                                                                                                        <%
                                                                                                                            }

                                                                                                                        %>

                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Current Password <span class="ddm_required_field">*</span> :</td>
                                                                                                                            <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"><input name="txt_CurrentPassword" type="password" class="ddm_login_input_text" id="txt_CurrentPassword" size="34" maxlength="32" onFocus="<%=result != true ? "hideMessage_onFocus()" : "doRefresh()"%>" <%=isOkToChangePassword == false ? "disabled" : ""%>  /></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">New Password <span class="ddm_required_field">*</span> :</td>

                                                                                                                            <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text">

                                                                                                                                <table  border="0" cellspacing="0" cellpadding="0">
                                                                                                                                    <tr>
                                                                                                                                        <td>

                                                                                                                                            <input name="txtNewPwd" type="password"  class="ddm_login_input_text" id="txtNewPwd" size="34" maxlength="32" height="16" onKeyUp="validatePassword()" onFocus="<%=result != true ? "hideMessage_onFocus()" : "doRefresh()"%>" <%=isOkToChangePassword == false ? "disabled" : ""%>>                                                                                                                                        </td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td align="center" valign="middle" width="12">                                    <div id="validPwd" align="center" ><img src="../../images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" style="cursor:help"></div>
                                                                                                                                            <div id="invalidPwd" align="center" ><img src="../../images/animRed.gif" name="imgError" id="imgError" width="12" height="12" style="cursor:help"></div></td>
                                                                                                                                    </tr>
                                                                                                                                </table></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text">Confirm Password <span class="ddm_required_field">*</span> :</td>

                                                                                                                            <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                <input name="txtConfirmPwd" type="password" class="ddm_login_input_text" id="txtConfirmPwd" size="34" maxlength="32" onFocus="<%=result != true ? "hideMessage_onFocus()" : "doRefresh()"%>" <%=isOkToChangePassword == false ? "disabled" : ""%>/></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="40" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Change &nbsp;&nbsp;" name="btnChange" id="btnChange" class="ddm_custom_button" onClick="isRequest(true);
                                                                                                                passwordValidation();" <%=isOkToChangePassword == false ? "disabled" : ""%>/>                             </td>
                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /><input type="hidden" name="hdnIsPWDAvailableHis" id="hdnIsPWDAvailableHis"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((isReq != null && isReq.equals("1")) && result) ? "Done" : "Cancel"%> &nbsp;&nbsp;" type="button" onClick="cancel()"  class="ddm_custom_button" />                                                </td></tr>
                                                                                                                                </table></td>
                                                                                                                  </tr>




                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                  </table></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </form>                                                          </td>
                                                                                    <td width="10"></td>
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
%>
