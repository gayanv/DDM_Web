<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*,java.util.*,java.io.*" errorPage="../error.jsp"%>
<%
    session.invalidate();
    String msg = null;
    msg = (String) request.getParameter("msg");
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Login (Version 1.0.0)</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../css/ddm.css" rel="stylesheet" type="text/css" /> 
        <script>


            function hideMessage_onFocus()
            {
                if (document.getElementById('displayMsg_error') != null)
                {
                    document.getElementById('displayMsg_error').style.display = 'none';

                }
            }

            function validate()
            {

                if (isempty(document.getElementById('txtUserName').value))
                {
                    alert('Please enter the Username.');
                    return false;
                }
                else if (isempty(document.getElementById('txtPassword').value))
                {
                    alert('Please enter the password.');
                    return false;
                }
                else
                {
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
    <!-- body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" -->
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
    



        <form method="post" action="../index.jsp" name="frmLogin" onSubmit="return validate()">   


            <div class="ddm_loginbox"> 
                <img src="../images/login_avatar.png" class="ddm_login_avatar">        

                <h1>LankaPay DDM - Login</h1>


          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="15" align="center" class="ddm_loginbox_error"><input type="hidden" name="hdnActionType" id="hdnActionType" >
                            <%
                                if (msg != null)
                                {
                                    if (msg.equals("up"))
                                    {
                            %>
                            <div id="displayMsg_error" class="ddm_loginbox_error" >Invalid Username Or Password!</div>
                            <%                                                
                                    }
                                    else if (msg.equals("up"))
                                    {
                            %>
                            <div id="displayMsg_error" class="ddm_loginbox_error" >Invalid Username Or Password!</div>
                            <%
                                    }
                                    else if (msg.equals("op"))
                                    {
                            %>
                            <div id="displayMsg_error" class="ddm_loginbox_error" >OTP Validation Failed!</div>
                            <%                                                        
                                    }
                                }
                            %>


                        </td>
                    </tr>
                    <tr>
                        <td height="15" align="center" class="ddm_loginbox_error">&nbsp;</td>
                    </tr>
                </table>




                <p>Username</p>
                <input type="text" name="txtUserName" id="txtUserName" class="ddm_loginbox_input" maxlength="32" onFocus="hideMessage_onFocus()" placeholder="Enter Username">
                <p>Password</p>
                <input type="password" name="txtPassword" id="txtPassword" class="ddm_loginbox_input" maxlength="32" onFocus="hideMessage_onFocus()" placeholder="Enter Password">
                <br/>
                <br/>
                <input type="submit" id="btnLogin" name="btnLogin" value="Login" class="ddm_loginbox_submit" onClick="document.frmLogin.submit()">



            </div>

    </form>



    </body>
</html>