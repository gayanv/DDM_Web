<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>



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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Deactivate User' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Deactivate_User");
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
    Collection<Bank> colBank = null;
    Collection<Merchant> colMerchant = null;    
    Collection<UserLevel> colUserLevel = null;    
    Collection<User> col_user = null;

    String isReq = null;
    
    String selectedUserLevel = null;
    String selectedUserStatus = null;
    String selectedUserBank = null;
    String selectedUserMerchant = null;
    
    String selectedUserId = null;
    String msg = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatusBasicDetails(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

    isReq = (String) request.getParameter("hdnReq");

    //System.out.println("isReq - " + isReq);
    if (isReq == null)
    {
        isReq = "0";

        selectedUserLevel = DDM_Constants.status_all;
        selectedUserStatus = DDM_Constants.status_all;
        selectedUserBank = DDM_Constants.status_all;
        selectedUserMerchant = DDM_Constants.status_all;

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_deactive + "','" + DDM_Constants.status_pending + "'");
    }
    else if (isReq.equals("0"))
    {
        selectedUserLevel = request.getParameter("cmbUserLevel");
        selectedUserBank = request.getParameter("cmbBank");
        selectedUserMerchant = request.getParameter("cmbMerchant");
        selectedUserStatus = request.getParameter("cmbStatus");
        
        selectedUserId = request.getParameter("cmbUserId");

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_deactive + "','" + DDM_Constants.status_pending + "'");
    }
    else if (isReq.equals("1"))
    {
        selectedUserLevel = request.getParameter("cmbUserLevel");
        selectedUserBank = request.getParameter("cmbBank");
        selectedUserMerchant = request.getParameter("cmbMerchant");
        selectedUserStatus = request.getParameter("cmbStatus");        
        
        selectedUserId = request.getParameter("cmbUserId");

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_deactive + "','" + DDM_Constants.status_pending + "'");

        String currentUserStat = null;

        if (selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_all))
        {
            User objUser = DAOFactory.getUserDAO().getUserDetails(selectedUserId, DDM_Constants.status_all);            

            currentUserStat = objUser.getStatus();  

        }
        else if (selectedUserStatus != null && (selectedUserStatus.equals(DDM_Constants.status_expired) || selectedUserStatus.equals(DDM_Constants.status_locked)))
        {
            currentUserStat = selectedUserStatus;
        }

        UserDAO userDAO = DAOFactory.getUserDAO();

        result = userDAO.setUserStatusManual(selectedUserId, DDM_Constants.status_deactive, false, session_userName);

        currentUserStat = currentUserStat != null ? currentUserStat.equals(DDM_Constants.status_active) ? "Active" : currentUserStat.equals(DDM_Constants.status_deactive) ? "Deactive" : currentUserStat.equals(DDM_Constants.status_locked) ? "Locked" : currentUserStat.equals(DDM_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_deactivate_user, "| Username - " + selectedUserId + ", Status - (New : Deactive, Old : " + currentUserStat + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_deactivate_user, "| Username - " + selectedUserId + ", Status - (New : Deactive, Old : " + currentUserStat + ") | Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>


<head>
    	<title>LankaPay Direct Debit Mandate Exchange System - Deactivate User</title>
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

        function validate()
        {            

        var selUser = document.getElementById('cmbUserId').value;
        //var password = document.getElementById('txtUserPassword').value;
        //var reType_password = document.getElementById('txtReTypePassword').value;

        if(selUser == "-1")
        {
        alert("Select User ID For Deactivation!");
        document.getElementById('cmbUserId').focus();
        return false;
        }
        else
        {
        document.frmDeActivateUser.submit();
        }
        }
		
		function clearRecords()
        {
        document.getElementById('cmbUserLevel').selectedIndex = 0;
        document.getElementById('cmbStatus').selectedIndex = 0;
        document.getElementById('cmbBranch').selectedIndex = 0;
        document.getElementById('cmbUserId').selectedIndex = 0;
        hideMessage_onFocus();
		isRequest(false);
        frmDeActivateUser.submit();
		
		
        }

        function showClock(type)
        {
        if(type==1)
        {
        clock(document.getElementById('showText'),type,null);
        }
        else if(type==2 )
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

        function isSearchRequest(status)
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
                                                                                    <td align="left" valign="top" class="ddm_header_text">Deactivate User</td>
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


                                                                                        <form id="frmDeActivateUser" name="frmDeActivateUser" action="UserDeactivation.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">

                                                                                                <%
                                                                                                    if (isReq.equals("1") && result == true)
                                                                                                    {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="ddm_Display_Success_msg" >User Deactivated  Succesfully. <span class="ddm_error">(Manager Level Authorization Is Mandatory!)</span></div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="ddm_Display_Error_msg"><div id="displayMsg_error" class="ddm_Display_Error_msg" >User Deactivation Failed - <span class="ddm_error"><%=msg%></span></div></td>
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
                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">User Type :</td>
                                                                                                                            <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"><select name="cmbUserLevel" id="cmbUserLevel" class="ddm_field_border" onChange="isSearchRequest(false);frmDeActivateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserLevel != null && selectedUserLevel.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <%
                                                                                                                                        for (UserLevel usrlvl : colUserLevel)
                                                                                                                                        {

                                                                                                                                    %>
                                                                                                                                    <option value=<%=usrlvl.getUserLevelId()%> <%=(selectedUserLevel != null && usrlvl.getUserLevelId().equals(selectedUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    %></select>
                                                                                                                                    
                                                                                                                                    <input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" />                                                                                                                                    </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Bank : </td>
                                                                                                                                <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                    <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()" <%=(selectedUserLevel.equals(DDM_Constants.user_type_bank_manager) || selectedUserLevel.equals(DDM_Constants.user_type_bank_user)) ? "" : "disabled"%>>

                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserBank != null && selectedUserBank.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>


                                                                                                                                        <%

                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bk : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bk.getBankCode()%>" <%=(selectedUserBank != null && bk.getBankCode().equals(selectedUserBank)) ? "selected" : ""%> >
                                                                                                                                            <%=bk.getBankCode() + " - " + bk.getBankFullName()%>                                                                                                                                        </option>
                                                                                                                                        <%

                                                                                                                                                }
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                                            </tr>
                                                                                                                        <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                    <select name="cmbMerchant" id="cmbMerchant" class="ddm_field_border"  onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()" <%=(selectedUserLevel.equals(DDM_Constants.user_type_merchant_su) || selectedUserLevel.equals(DDM_Constants.user_type_merchant_op)) ? "" : "disabled"%> >
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserMerchant != null && selectedUserMerchant.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <%
                                                                                                                                            if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Merchant merchant : colMerchant)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchant.getMerchantID()%>" <%=(selectedUserMerchant != null && merchant.getMerchantID().equals(selectedUserMerchant)) ? "selected" : ""%> ><%=merchant.getMerchantID()%> - <%=merchant.getMerchantName()%></option>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Status :</td>
                                                                                                                            <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"><select name="cmbStatus" id="cmbStatus" class="ddm_field_border" onChange="isRequest(false);frmDeActivateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_active%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_expired%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                    <option value="<%=DDM_Constants.status_locked%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                </select></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Username :</td>
                                                                                                                            <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"> <select name="cmbUserId" class="ddm_field_border" id="cmbUserId" onFocus="hideMessage_onFocus()" >
                                                                                                                                    <option value="-1" selected="selected">-- Select User --</option>
                                                                                                                                    <% if (col_user != null && col_user.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (User u : col_user)
                                                                                                                                            {
                                                                                                                                                if (u != null && !(u.getUserId().equals(session_userName)))
                                                                                                                                                {
                                                                                                                                                    if (!session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        if (u.getUserLevelId().equals(DDM_Constants.user_type_bank_user) || u.getUserLevelId().equals(DDM_Constants.user_type_bank_manager))
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <%
                                                                                                                                                        }

                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                </select>  </td></tr>
                                                                                                                        <tr>
                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="ddm_tbl_footer_text">                                                                                                                              <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Deactivate &nbsp;&nbsp;" name="btnChange" id="btnChange" class="ddm_custom_button" onClick="isRequest(true);
                                                                                                                                                validate();" <%=((isReq != null && isReq.equals("1")) && result) ? "disabled" : ""%>/></td>
                                                                                                                                      <td width="5"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((isReq != null && isReq.equals("1")) && result) ? "Done" : "Cancel"%> &nbsp;&nbsp;" type="button" onClick="clearRecords()"  class="ddm_custom_button" />                                                </td></tr>
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
