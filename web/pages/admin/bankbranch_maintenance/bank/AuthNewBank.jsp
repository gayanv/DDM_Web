
<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.emaillist.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.services.email.SendHTMLEmail2" errorPage="../../../../error.jsp"%>

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
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Authorize New Bank' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Authorize_New_Bank");
            }
        }
        else
        {

%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    Collection<Bank> colBank = null;
    Bank bankDetails = null;
    String reqType = null;
    String cmbBankCode = null;
    String bankCode = null;
    String shortName = null;
    String fullName = null;
    String status = null;
    String password = null;
    String rePassword = null;
    String defaultPwd = null;
    String msg = null;

    boolean result = false;

    colBank = DAOFactory.getBankDAO().getAuthPendingBank(session_userName);
    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);

    reqType = (String) request.getParameter("hdnRequestType");

    if (reqType == null)
    {
        cmbBankCode = "-1";
    }
    else if (reqType.equals("0"))
    {
        cmbBankCode = (String) request.getParameter("cmbBank");
        bankDetails = DAOFactory.getBankDAO().getBankDetails(cmbBankCode);

        if (bankDetails != null)
        {
            bankCode = bankDetails.getBankCode();
            shortName = bankDetails.getShortName();
            fullName = bankDetails.getBankFullName();
            status = bankDetails.getStatus();
        }
    }
    else if (reqType.equals("1"))
    {
        cmbBankCode = (String) request.getParameter("cmbBank");
        bankDetails = DAOFactory.getBankDAO().getBankDetails(cmbBankCode);

        bankCode = (String) request.getParameter("txtBankCode");

        BankDAO bankDAO = DAOFactory.getBankDAO();

        result = bankDAO.doAuthorizedBank(new Bank(bankCode, session_userName));

        if (!result)
        {
            msg = bankDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_authorized_new_bank, "| Bank Code - " + bankCode + " | Process Status - Unsuccess (" + msg + ") | Authorized By - " + session_userName + " (" + session_userType + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_authorized_new_bank, "| Bank Code - " + bankCode + " | Process Status - Success | Authorized By - " + session_userName + " (" + session_userType + ") |"));
//            Collection<EmailList> colEL = DAOFactory.getEmailListDAO().getEmailMappings(DDM_Constants.status_all, DDM_Constants.email_notification_type_bank_branch_update);
//
//            for (EmailList el : colEL)
//            {
//                if (el != null && el.getEmailAddress() != null)
//                {
//                    new SendHTMLEmail2().sendEmailForBankBranchUpdate(el.getEmailAddress(), "SLIPS BCM Alert - New Bank : " +  bankDetails.getBankFullName() +"(" + bankDetails.getBankCode() + "), has been added to the system!", "<br/><br/><br/> Bank Code - <b>" + bankDetails.getBankCode() + "</b><br/>Bank Full Name - <b>" + bankDetails.getBankFullName() + "</b><br/>Bank Short Name - <b>" + bankDetails.getShortName() + "</b>", "<br/><br/><br/>Please confirm with your system. ");
//                }
//            }
        }
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Authorize New Bank</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>

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


            function clearRecords_onPageLoad()
            {                

            if(document.getElementById('txtPassword')!=null)
            {
            document.getElementById('txtPassword').setAttribute("autocomplete","off");
            }

            if(document.getElementById('txtReTypePassword')!=null)
            {
            document.getElementById('txtReTypePassword').setAttribute("autocomplete","off");
            }

            showClock(3);
            }

            function cancel()
            {
            document.frmApproveBank.action="<%=request.getContextPath()%>/pages/homepage.jsp";
            document.frmApproveBank.submit();
            }


            function clearResultData()
            {
            if(document.getElementById('resultdata')!= null)
            {
            document.getElementById('resultdata').style.display='none';
            }

            if(document.getElementById('noresultbanner')!= null)
            {
            document.getElementById('noresultbanner').style.display='none';
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error')!= null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }

            }

            if(document.getElementById('displayMsg_success')!=null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }                
            }



            function doSearch()
            {	
            setRequestType(false);
            document.frmApproveBank.action="AuthNewBank.jsp";
            document.frmApproveBank.submit();					
            }

            function doUpdate()
            {
            setRequestType(true);
            document.frmApproveBank.action="AuthNewBank.jsp";
            document.frmApproveBank.submit(); 				
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Authorize New Bank(s)</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="center" valign="top" class="ddm_header_text">
                                                                                            <form name="frmApproveBank" id="frmApproveBank" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table border="0" align="center" cellspacing="1" cellpadding="5" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" class="ddm_tbl_header_text">Bank :</td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                        <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="doSearch();">

                                                                                                                            <option value="-1" <%=(cmbBankCode == null || cmbBankCode.equals("-1")) ? "selected" : ""%>>-- Select Bank --</option>

                                                                                                                            <%
                                                                                                                                if (colBank != null && !colBank.isEmpty())
                                                                                                                                {

                                                                                                                                    for (Bank bank : colBank)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=bank.getBankCode()%>" <%=(cmbBankCode != null && bank.getBankCode().equals(cmbBankCode)) ? "selected" : ""%>><%=bank.getBankCode()%> - <%=bank.getBankFullName()%></option>

                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                        <span class="ddm_error">No bank details available.</span>
                                                                                                                        <%}%><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">
                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (bankDetails == null)
                                                                                                                    {
                                                                                                                %>

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
                                                                                                                                        <%                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                                            Bank Approved Sucessfully.                                                                                                </div>
                                                                                                                                            <% }
                                                                                                                                            else
                                                                                                                                            {%>


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >Bank Approval Failed.- <span class="ddm_error"><%=msg%></span></div>
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

                                                                                                                                        <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder" bgcolor="#FFFFFF">

                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Bank Code :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%=bankDetails.getBankCode()%> <input type="hidden" name="txtBankCode" id="txtBankCode" class="ddm_success" value="<%=bankCode%>" maxlength="4" readonly/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Short Name :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%=bankDetails.getShortName()%>
                                                                                                                                                    <input type="hidden" name="hdnShortName" id="hdnShortName" class="ddm_common_text" value="<%=bankDetails.getShortName()%>"/>                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Full Name :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%=bankDetails.getBankFullName()%>
                                                                                                                                                    <input type="hidden" name="hdnFullName" id="hdnFullName" class="ddm_common_text" value="<%=bankDetails.getBankFullName()%>"/>                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Bank Status :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                    <%
                                                                                                                                                        String stat = null;

                                                                                                                                                        if (bankDetails.getStatus() == null)
                                                                                                                                                        {
                                                                                                                                                            stat = "N/A";
                                                                                                                                                        }
                                                                                                                                                        else if (bankDetails.getStatus().equals(DDM_Constants.status_active))
                                                                                                                                                        {
                                                                                                                                                            stat = "Active";
                                                                                                                                                        }
                                                                                                                                                        else if (bankDetails.getStatus().equals(DDM_Constants.status_deactive))
                                                                                                                                                        {
                                                                                                                                                            stat = "De-Active";
                                                                                                                                                        }
                                                                                                                                                        else if (bankDetails.getStatus().equals(DDM_Constants.status_pending))
                                                                                                                                                        {
                                                                                                                                                            stat = "Pending for Authorization";
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            stat = "Other";
                                                                                                                                                        }
                                                                                                                                                    %>

                                                                                                                                                    <%=stat%>                                                                                                                        </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td height="10" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text"></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Created By :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%=bankDetails.getCreatedBy()%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Created Date :</td>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%=bankDetails.getCreatedDate()%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>  <td height="35" colspan="2" align="right" class="ddm_tbl_footer_text">



                                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" value="&nbsp;&nbsp; Authorize &nbsp;&nbsp;" onClick="doUpdate()" class="ddm_custom_button" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>>                             </td>
                                                                                                                                                            <td width="5"></td>
                                                                                                                                                            <td><input type="button" name="btnClear" id="btnClear" value="&nbsp;&nbsp; Cancel &nbsp;&nbsp;" class="ddm_custom_button" onClick="cancel()"/></td></tr>
                                                                                                                                                    </table>

                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>                                                                                                            </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%                                                                                                                }
                                                                                                            %>                                                                                </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15">&nbsp;</td>
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