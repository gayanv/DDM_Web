
<%@page import="java.util.*,java.sql.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../error.jsp"%>

<%
    response.setHeader("Cache-Control", "no-cache"); //Forces caches to obtain a new copy of the page from the origin server
    response.setHeader("Cache-Control", "no-store"); //Directs caches not to store the page under any circumstance
    response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
    response.setHeader("Pragma", "no-cache");
%>
<%
    String userName = null;
    String isAuthenticated = null;
    String userTypeDesc = null;
    String otpPrefix = null;
    String isChangeReq = null;    
    
    String strOTP1 = null;
    String strOTP2 = null;
    String strOTP3 = null;
    String strOTP4 = null;
    String strOTP5 = null;
    String strOTP6 = null;
    
    String msg = null;

    boolean result = false;

    userName = (String) session.getAttribute("session_userName");
    isAuthenticated = (String) session.getAttribute("session_isAuthenticated");
    userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
    otpPrefix = (String) session.getAttribute("session_OTP_Prefix");
    
    isChangeReq = (String) request.getParameter("isChangeReq");
    

    if (userName == null || userName.equals("null"))
    {
        //session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        if (isAuthenticated == null || isAuthenticated.equals("null"))
        {
            //response.sendRedirect("../login.jsp");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        }
        else if (isAuthenticated.equals(DDM_Constants.status_no))
        {
            //response.sendRedirect("../../index.jsp");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        }
        else if (isAuthenticated.equals(DDM_Constants.is_authorized_yes))
        {
            if (isChangeReq == null || isChangeReq.equalsIgnoreCase("null"))
            {
                isChangeReq = "0";
            }
            else if (isChangeReq.equals("1"))
            {
                strOTP1 = (String) request.getParameter("txtOTP1");
                strOTP2 = (String) request.getParameter("txtOTP2");
                strOTP3 = (String) request.getParameter("txtOTP3");
                strOTP4 = (String) request.getParameter("txtOTP4");
                strOTP5 = (String) request.getParameter("txtOTP5");
                strOTP6 = (String) request.getParameter("txtOTP6");
                
                String strOTP = null;
                
                if(otpPrefix != null)
                {
                    strOTP = otpPrefix + strOTP1 + strOTP2 + strOTP3 + strOTP4 + strOTP5 + strOTP6;
                }

                UserDAO userDAO = DAOFactory.getUserDAO();

                if (userName != null && strOTP != null)
                {
                    result = userDAO.isValidOTP(userName, strOTP);
                }

                if (result)
                {
                        session.setAttribute("session_OTP", strOTP);
                        session.setAttribute("session_userName", null);
                        session.setAttribute("session_isOTPCorrect", DDM_Constants.is_authorized_yes);
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_otp_validation, "| OTP Validation | Username - " + userName + ") | Process Status - Success | Done By - " + userName + " (" + userTypeDesc + ") |"));
                        response.sendRedirect("../index.jsp?uName=" + userName);               
                }
                else
                {
                    msg = userDAO.getMsg();
                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_otp_validation, "| OTP Validation | Username - " + userName + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + userName + " (" + userTypeDesc + ") |"));
                    response.sendRedirect("login.jsp?msg=op");
                }
            }


%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Enter OTP</title>
                <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        
        <script language="javascript" type="text/javascript">

            var frmEnterOTPActionVal = -1;

            function actionChange()
            {
                frmEnterOTPActionVal = 1;
            }

            function actionCancel()
            {
                frmEnterOTPActionVal = 0;
            }

            function validate()
            {
                if (frmEnterOTPActionVal == 1)
                {   
                    if (validateOTP())
                    {
                        document.getElementById('isChangeReq').value = "1";
                        document.frmEnterOTP.action = "otp.jsp";
                        return true;
                    }                    
                    else
                    {
                        alert('Please enter valid OTP code.');
                        return false;                       
                    }
                }
                else if (frmEnterOTPActionVal == 0)
                {
                    document.frmEnterOTP.action = "login.jsp";
                    return true;
                }
                else
                {
                    return false;
                }
            }
            
            function validateOTP()
            {
                var numbers = /^[0-9]*$/;

                var valOTP1 = document.getElementById('txtOTP1').value;
                var valOTP2 = document.getElementById('txtOTP2').value;
                var valOTP3 = document.getElementById('txtOTP3').value;
                var valOTP4 = document.getElementById('txtOTP4').value;
                var valOTP5 = document.getElementById('txtOTP5').value;
                var valOTP6 = document.getElementById('txtOTP6').value;

                if (isempty(valOTP1))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP1))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('txtOTP2').focus();
                }

                if (isempty(valOTP2))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP2))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('txtOTP3').focus();
                }

                if (isempty(valOTP3))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP3))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }
                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('txtOTP4').focus();
                }

                if (isempty(valOTP4))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP4))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('txtOTP5').focus();
                }

                if (isempty(valOTP5))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP5))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('txtOTP6').focus();
                }

                if (isempty(valOTP6))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert('OTP values can not be empty!');
                    return false;
                }
                else if (!numbers.test(valOTP6))
                {
                    if (document.getElementById('btnSubmit') != null)
                    {
                        document.getElementById('btnSubmit').disabled = true;
                    }

                    //alert("OTP values must contain numbers only!");
                    return false;
                }
                else
                {                    
                    document.getElementById('btnSubmit').focus();
                }


                if (document.getElementById('btnSubmit') != null)
                {
                    document.getElementById('btnSubmit').disabled = false;
                    return true;
                }

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


        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
                                <td align="right"><img src="../images/LankaPay_logo_Small.png" width="150" height="58"></td>
                            </tr>
                        </table>
    </div>

        <form method="post" name="frmEnterOTP" onSubmit="return validate()">
            <div class="ddm_loginbox"> 
                <img src="../images/change_pwd.png" class="ddm_login_avatar">        

                <h1>LankaPay DDM - Enter OTP</h1>
                <br/>  
            <span class="ddm_error_ipwd_change_large"><u>Please enter the OTP that you received in your email to proceed.</u></span>

                <table width="100%" border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td height="35" class="ddm_error_ipwd_change"><input type="hidden" name="isChangeReq" id="isChangeReq"></td>
                    </tr>
                    <tr>
                        <td height="15" align="center" valign="top" class="ddm_login_otp_msg_text"><%=otpPrefix %></td>
                    </tr>
                    <tr>
                        <td height="15" align="center" class="ddm_loginbox_error"></td>
                    </tr>
                    <tr>
                        <td align="center" class="ddm_loginbox_error"><table border="0" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td><input type="text" name="txtOTP1" id="txtOTP1" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                    <td><input type="text" name="txtOTP2" id="txtOTP2" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                    <td><input type="text" name="txtOTP3" id="txtOTP3" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                    <td><input type="text" name="txtOTP4" id="txtOTP4" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                    <td><input type="text" name="txtOTP5" id="txtOTP5" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                    <td><input type="text" name="txtOTP6" id="txtOTP6" class="ddm_login_otp_input" maxlength="1" onKeyUp="validateOTP()"></td>
                                </tr>
                            </table></td>
                    </tr>
                    <tr>
                        <td align="center" class="ddm_loginbox_error">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center" class="ddm_loginbox_error">&nbsp;</td>
                    </tr>
                </table>           

                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="48%"><input type="submit" id="btnSubmit" name="btnSubmit" value="Submit" class="ddm_loginbox_submit" onClick="actionChange()" disabled>    
                        </td>
                        <td width="4%"></td>
                        <td width="48%"><input type="submit" id="btnCancel" name="btnCancel" value="Cancel" class="ddm_loginbox_submit"  onClick="actionCancel()"></td>
                    </tr>
                </table>
            </div>
        </form>
    </body>
</html>
<%
        }
    }
%>