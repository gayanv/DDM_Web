
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../error.jsp"%>

<%
    response.setHeader("Cache-Control", "no-cache"); //Forces caches to obtain a new copy of the page from the origin server
    response.setHeader("Cache-Control", "no-store"); //Directs caches not to store the page under any circumstance
    response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
    response.setHeader("Pragma", "no-cache");
%>

<%
    String userName = null;
    String userTypeDesc = null;
    String isInitLogin = null;
    String isChangeReq = null;
    String strCurPassword = null;
    String strNewPassword = null;
    String msg = null;

    boolean result = false;

    int iMinPwdHistory = 1;
    int iMinPwdLength = 8;
    int iMinLowChars = 1;
    int iMinUpChars = 1;

    userName = (String) session.getAttribute("session_userName");
    isInitLogin = (String) session.getAttribute("session_isInitLogin");
    userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
    isChangeReq = (String) request.getParameter("isChangeReq");
    strCurPassword = (String) session.getAttribute("session_curPwd");

    if (userName == null || userName.equals("null"))
    {
        //session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        if (isInitLogin == null || isInitLogin.equals("null"))
        {
            //response.sendRedirect("../login.jsp");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        }
        else if (isInitLogin.equals(DDM_Constants.status_no))
        {
            //response.sendRedirect("../../index.jsp");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

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


    if (isChangeReq == null || isChangeReq.equalsIgnoreCase("null"))
    {
        isChangeReq = "0";
    }
    else if (isChangeReq.equals("1"))
    {
        strNewPassword = request.getParameter("txtNewPwd");

        UserDAO userDAO = DAOFactory.getUserDAO();

        if (userName != null && strNewPassword != null)
        {
            result = userDAO.changeUserPassword(new User(userName, strNewPassword.trim()), strCurPassword.trim(), false);
        }
        
        System.out.println(" Expired Password reset success ---> " + result);

        if (result)
        {   
            PWD_HistoryDAO pwdHisDAO = DAOFactory.getPWD_HistoryDAO();

            boolean pwdHisUpdateStat = pwdHisDAO.addPWD_History(new PWD_History(userName, strNewPassword.trim()));

            if (pwdHisUpdateStat)
            {
                session.setAttribute("session_isInitLogin", DDM_Constants.status_no);
                session.setAttribute("session_isAuthenticated", DDM_Constants.is_authorized_yes);
                session.setAttribute("session_userName", null);                
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_expired_password_change, "| Expired Password Change | Username - " + userName + ") | Process Status - Success | Done By - " + userName + " (" + userTypeDesc + ") |"));                
                
                response.sendRedirect("../../index.jsp?uName=" + userName);
            }
            else
            {
                msg = pwdHisDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_expired_password_change, "| Expired Password Change | Username - " + userName + ") | Process Status - Unsuccess update password history (" + msg + ") | Done By - " + userName + " (" + userTypeDesc + ") |"));                
                
                response.sendRedirect("../login.jsp");
            }
        }
        else
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_expired_password_change, "| Expired Password Change | Username - " + userName + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + userName + " (" + userTypeDesc + ") |"));
            
            response.sendRedirect("../login.jsp");
        }
    }


%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Change Expired Password</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>

        <script language="javascript" type="text/javascript">

            var frmChangeInitPwdActionVal = -1;

            function actionChange()
            {
                frmChangeInitPwdActionVal = 1;
            }

            function actionCancel()
            {
                frmChangeInitPwdActionVal = 0;
            }

            function validate()
            {
                if (frmChangeInitPwdActionVal == 1)
                {
                    var newPassword = document.getElementById('txtNewPwd').value;
                    var confirmPassword = document.getElementById('txtConfirmPwd').value;
                    if (isempty(newPassword))
                    {
                        alert('Please enter the New Password.');
                        return false;
                    }
                    else if (isempty(confirmPassword))
                    {
                        alert('Please enter the Confirm Password.');
                        return false;
                    }
                    else
                    {
                        if (newPassword == confirmPassword)
                        {
                            document.getElementById('isChangeReq').value = "1";
                            document.frmChangeInitPwd.action = "initPwdChange.jsp";
                            return true;
                        }
                        else
                        {
                            alert("New Password does not match with Confirm Password!");
                            document.getElementById('txtNewPwd').value = "";
                            document.getElementById('txtConfirmPwd').value = "";
                            document.getElementById('txtNewPwd').focus();
                            this.setAnimLights();
                            return false;
                        }
                    }
                }
                else if (frmChangeInitPwdActionVal == 0)
                {
                    document.frmChangeInitPwd.action = "../login.jsp";
                    return true;
                }
                else
                {
                    return false;
                }

            }

            function setAnimLights()
            {
                if (document.getElementById('validPwd') != null)
                {
                    document.getElementById('validPwd').style.display = 'none';
                }

                if (document.getElementById('invalidPwd') != null)
                {
                    document.getElementById('invalidPwd').style.display = 'none';
                }

                if (document.getElementById('btnChange') != null)
                {
                    document.getElementById('btnChange').disabled = true;
                }
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
                        document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                        document.getElementById('txtNewPwd').title = 'Empty Password!';
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
                            document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                            document.getElementById('txtNewPwd').title = 'Spaces not allowed!';
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
                                document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
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
                            var userID = '<%=userName%>';
                            if ((newPassword.toUpperCase()).indexOf(userID.toUpperCase()) >= 0)
                            {
                                if (document.getElementById('validPwd') != null)
                                {
                                    document.getElementById('validPwd').style.display = 'none';
                                }

                                if (document.getElementById('txtNewPwd') != null)
                                {
                                    document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                                    document.getElementById('txtNewPwd').title = 'Password can not contain UserId!';
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

                                    for (var i = 0;
                                            i < nPwd.length;
                                            i++)
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
                                                document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
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
                                            document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
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
                                        document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                                        document.getElementById('txtNewPwd').title = 'Password must be a combination of alpha-numeric characters and at least one special character!';
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
                                document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_ok';
                                document.getElementById('txtNewPwd').title = 'Correct password which match with password policy.';
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
                                document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                                document.getElementById('txtNewPwd').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
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
                                document.getElementById('txtNewPwd').className = 'ddm_loginbox_input_error';
                                document.getElementById('txtNewPwd').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
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




            function isempty(Value)
            {
                if (Value.length < 1)
                {
                    return true;
                }
                else
                {
                    var str = Value;
                    while (str.indexOf(" ") != -1)
                    {
                        str = str.replace(" ", "");
                    }

                    if (str.length < 1)
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
                for (var i = 0;
                        i < strTrimed.length;
                        i++)
                {
                    if (strTrimed[i] == " ")
                    {
                        status = true;
                        break;
                    }
                }

                return status;
            }

            function trim(str)
            {
                return str.replace(/^\s+|\s+$/g, "");
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="setAnimLights()">


    
    <!--div>
            <div class="wave"></div>
            <div class="wave"></div>
            <div class="wave"></div>
        </div -->

<div class="bg"></div>
<div class="bg bg2"></div>
<div class="bg bg3"></div>
        
            <div class="signup_welcome_div">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="550" align="left" valign="bottom" class="signup_welcome"></td>
                                <td width="100">&nbsp;</td>
                                <td align="right"><img src="../../images/LankaPay_logo_Small.png" width="150" height="58"></td>
                            </tr>
                        </table>
    </div>

        <form method="post" name="frmChangeInitPwd" onSubmit="return validate()">

            <div class="ddm_loginbox"> 
                <img src="../../images/change_pwd.png" class="ddm_login_avatar">        

                <h1>LankaPay DDM - Change Password</h1>
                <span class="ddm_error_ipwd_change_large"><u>Please change your expired password.</u></span>


                <table width="100%" border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td height="5" class="ddm_error_ipwd_change"></td>
                    </tr>
                    <tr>
                        <td height="15" valign="top" class="ddm_error_ipwd_change">
                            Note : The new password should not be equal to last  <%=iMinPwdHistory%> password(s) you used, must be a combination of alpha numeric and at least one special character and minimum of 8 characters in length!

                            <input type="hidden" name="isChangeReq" id="isChangeReq"><input type="hidden" name="hdnIsPWDAvailableHis" id="hdnIsPWDAvailableHis">    											 </td>
                    </tr>
                    <tr>
                        <td height="10" align="center" class="ddm_loginbox_error"></td>
                    </tr>
                </table>


                <p>New Password</p>
                <input type="password" name="txtNewPwd" id="txtNewPwd" class="ddm_loginbox_input" maxlength="32" onKeyUp="validatePassword()" placeholder="Enter New Password">

                <p>Confirm Password</p>
                <input type="password" name="txtConfirmPwd" id="txtConfirmPwd" class="ddm_loginbox_input" maxlength="32" placeholder="Enter New Password">

                <br/>

                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="48%"><input type="submit" id="btnChange" name="btnChange" value="Change" class="ddm_loginbox_submit" onClick="actionChange()" disabled>    
                        </td>
                        <td width="4%"></td>
                        <td width="48%"><input type="submit" id="btnCancel" name="btnCancel" value="Cancel" class="ddm_loginbox_submit"  onClick="actionCancel()"></td>
                    </tr>
                </table>





            </div>









        </form>

    </body>
</html>