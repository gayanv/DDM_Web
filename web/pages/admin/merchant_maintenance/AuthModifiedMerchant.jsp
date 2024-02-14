

<%@page import="lk.com.ttsl.pb.slips.dao.merchant.MerchantDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.emaillist.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.services.email.SendHTMLEmail2" errorPage="../../../error.jsp"%>

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
            //session.invalidate();
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Authorize Modified Bank' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Authorize_Modified_Bank");
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
    Collection<Merchant> colAuthPendingMerchant = null;
    Collection<MerchantAccNoMap> colAccNoMap = null;
    Merchant merchantDetails = null;
    String reqType = null;
    String cmbMerchantId = null;
    String msg = null;

    boolean result = false;

    colAuthPendingMerchant = DAOFactory.getMerchantDAO().getAuthPendingModifiedMerchant(session_userName);

    reqType = (String) request.getParameter("hdnRequestType");

    if (reqType == null)
    {
        cmbMerchantId = "-1";
    }
    else if (reqType.equals("0"))
    {
        cmbMerchantId = (String) request.getParameter("cmbMerchant");
        merchantDetails = DAOFactory.getMerchantDAO().getMerchantDetails(cmbMerchantId);

    }
    else if (reqType.equals("1"))
    {
        cmbMerchantId = (String) request.getParameter("cmbMerchant");
        merchantDetails = DAOFactory.getMerchantDAO().getMerchantDetails(cmbMerchantId);

        MerchantDAO merchantDAO = DAOFactory.getMerchantDAO();

        result = merchantDAO.doAuthorizeModifiedMerchant(new Merchant(cmbMerchantId, session_userName));

        if (!result)
        {
            msg = merchantDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_authorize_modified_merchant_details, "| Merchant ID - " + cmbMerchantId + " | Process Status - Unsuccess (" + msg + ") | Authorized By - " + session_userName + " (" + session_userType + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_authorize_modified_merchant_details, "| Merchant ID - " + cmbMerchantId + " | Process Status - Success | Authorized By - " + session_userName + " (" + session_userType + ") |"));
//            Collection<EmailList> colEL = DAOFactory.getEmailListDAO().getEmailMappings(DDM_Constants.status_all, DDM_Constants.email_notification_type_bank_branch_update);
//
//            for (EmailList el : colEL)
//            {
//                if (el != null && el.getEmailAddress() != null)
//                {
//                    new SendHTMLEmail2().sendEmailForBankBranchUpdate(el.getEmailAddress(), "SLIPS BCM Alert - New Bank : " +  merchantDetails.getBankFullName() +"(" + merchantDetails.getBankCode() + "), has been added to the system!", "<br/><br/><br/> Bank Code - <b>" + merchantDetails.getBankCode() + "</b><br/>Bank Full Name - <b>" + merchantDetails.getBankFullName() + "</b><br/>Bank Short Name - <b>" + merchantDetails.getShortName() + "</b>", "<br/><br/><br/>Please confirm with your system. ");
//                }
//            }
        }
    }
%>
<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - Authorize Modified Corporate Customer Details</title>

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
            clearResultData();
            document.getElementById('cmbMerchant').selectedIndex = 0;
            doSearch();
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
            document.frmApproveModifiedMerchant.action="AuthModifiedMerchant.jsp";
            document.frmApproveModifiedMerchant.submit();					
            }

            function doUpdate()
            {
            setRequestType(true);
            document.frmApproveModifiedMerchant.action="AuthModifiedMerchant.jsp";
            document.frmApproveModifiedMerchant.submit(); 				
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

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="clearRecords_onPageLoad()">
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Authorize Modified Merchant</td>
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
                                                                                            <form name="frmApproveModifiedMerchant" id="frmApproveModifiedMerchant" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table border="0" align="center" cellspacing="1" cellpadding="5" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#E1ECE4" class="ddm_tbl_common_text">
                                                                                                                        <select name="cmbMerchant" id="cmbMerchant" class="ddm_field_border" onChange="doSearch();">

                                                                                                                            <option value="-1" <%=(cmbMerchantId == null || cmbMerchantId.equals("-1")) ? "selected" : ""%>>-- Select Merchant --</option>

                                                                                                                            <%
                                                                                                                                if (colAuthPendingMerchant != null && !colAuthPendingMerchant.isEmpty())
                                                                                                                                {

                                                                                                                                    for (Merchant merchant : colAuthPendingMerchant)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=merchant.getMerchantID() %>" <%=(cmbMerchantId != null && merchant.getMerchantID().equals(cmbMerchantId)) ? "selected" : ""%>><%=merchant.getMerchantID() %> - <%=merchant.getMerchantName() %></option>

                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                        <span class="ddm_error">Merchant details not available.</span>
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
                                                                                                                    if (merchantDetails == null)
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

                                                                                                                                            Modified Corporate Customer Details Approved Successfully!                                                                                                </div>
                                                                                                                                            <% }
                                                                                                                                            else
                                                                                                                                            {%>


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >Modified Corporate Customer Details Approval Failed.- <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                                                    
                                                                                                                                    <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder"><tr><td>
                                                                                                                                    <table border="0" cellspacing="1" cellpadding="5"  bgcolor="#FFFFFF">
                                                                                                                              <tr>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text">&nbsp;</td>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text_horizontal"> New Value</td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Merchant ID :</td>
                                                                                                                                                <td colspan="2" class="ddm_tbl_common_text"><%=merchantDetails.getMerchantID() %></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Merchant Name :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getMerchantName() != null ? merchantDetails.getMerchantName() : ""%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getMerchantNameModify() != null ? merchantDetails.getMerchantNameModify() : ""%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Email :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getEmail() != null ? merchantDetails.getEmail() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getEmailModify() != null ? merchantDetails.getEmailModify() : "N/A"%></td>
                                                                                                                                            </tr>                                                                                                                                            
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Telephone No. :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getPrimaryTP() != null ? merchantDetails.getPrimaryTP() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getPrimaryTPModify() != null ? merchantDetails.getPrimaryTPModify() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Secondary Telephone :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getSecondaryTP() != null ? merchantDetails.getSecondaryTP() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=merchantDetails.getSecondaryTPModify() != null ? merchantDetails.getSecondaryTPModify() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Password :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text">
                                                                                                                                                  <% 
                                                                                                                                                  String  curPwd = merchantDetails.getPassword();
                                                                                                                                                  String  modiPwd = merchantDetails.getPasswordModify();
                                                                                                                                                          
                                                                                                                                                  if((curPwd != null && modiPwd != null) && !curPwd.equals(modiPwd)) 
                                                                                                                                                  { 
                                                                                                                                                  %> 
                                                                                                                                                  <span class="ddm_required_field">Password has been changed. Need Dual Authorization to affect the changes. </span> 
                                                                                                                                                  <% } else { %> 
                                                                                                                                                  <span class="ddm_tbl_common_text">Password unchanged.</span> 
                                                                                                                                                  <% } %>                                                                                                                                              </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Account Bank :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getBankCode() != null ? merchantDetails.getBankCode() : "N/A")%> - <%=(merchantDetails.getBankName() != null ? merchantDetails.getBankName() : "N/A")%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getBankCodeModify()!= null ? merchantDetails.getBankCodeModify() : "N/A")%> - <%=(merchantDetails.getBankNameModify()!= null ? merchantDetails.getBankNameModify() : "N/A")%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Account Branch :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getBranchCode()!= null ? merchantDetails.getBranchCode() : "N/A")%> - <%=(merchantDetails.getBranchName()!= null ? merchantDetails.getBranchName() : "N/A")%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getBranchCodeModify()!= null ? merchantDetails.getBranchCodeModify() : "N/A")%> - <%=(merchantDetails.getBranchNameModify()!= null ? merchantDetails.getBranchNameModify() : "N/A")%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Acc. No. :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=(merchantDetails.getPrimaryAccountNo() != null ? merchantDetails.getPrimaryAccountNo() : "")%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=(merchantDetails.getPrimaryAccountNoModify()!= null ? merchantDetails.getPrimaryAccountNoModify() : "")%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Account Name :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getPrimaryAccountName()!= null ? merchantDetails.getPrimaryAccountName() : "N/A")%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=(merchantDetails.getPrimaryAccountNameModify()!= null ? merchantDetails.getPrimaryAccountNameModify(): "N/A")%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Other Accounts :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%

                                                                                                                                                    colAccNoMap = merchantDetails.getColAccNoMap();

                                                                                                                                                    if (colAccNoMap != null && colAccNoMap.size() > 0)
                                                                                                                                                    {


                                                                                                                                                    %>
                                                                                                                                                    <table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                        <%                                                                                                                                                  for (MerchantAccNoMap merchantAccNoMap : colAccNoMap)
                                                                                                                                                            {
                                                                                                                                                        %>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_common_text"><%=merchantAccNoMap.getAcNo() %></td>
                                                                                                                                                            <td class="ddm_common_text"><%=merchantAccNoMap.getAcName() != null ? merchantAccNoMap.getAcName() : "N/A"%></td>
                                                                                                                                                            <td class="ddm_common_text">(<%=(merchantAccNoMap.getStatus() != null ? merchantAccNoMap.getStatus().equals(DDM_Constants.status_active) ? "Active" : merchantAccNoMap.getStatus().equals(DDM_Constants.status_deactive)? "Inactive" : "Pending" : "N/A")%>)</td>
                                                                                                                                                        </tr>
                                                                                                                                                        <%
                                                                                                                                                            }
                                                                                                                                                        %>
                                                                                                                                                    </table>
                                                                                                                                                    <%
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    N/A
                                                                                                                                                    <%
                                                                                                                                                        }
                                                                                                                                                    %>                                                                                                                                        </td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%
                                                                                                                                                    colAccNoMap = merchantDetails.getColAccNoMap();

                                                                                                                                                    if (colAccNoMap != null && colAccNoMap.size() > 0)
                                                                                                                                                    {


                                                                                                                                                    %>
                                                                                                                                                    <table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                        <%                                                                                                                                                  for (MerchantAccNoMap merchantAccNoMap : colAccNoMap)
                                                                                                                                                            {
                                                                                                                                                        %>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_common_text"><%=merchantAccNoMap.getAcNo() %></td>
                                                                                                                                                            <td class="ddm_common_text"><%=(merchantAccNoMap.getAcName() != null ? merchantAccNoMap.getAcName() : "N/A")%></td>
                                                                                                                                                            <td class="ddm_common_text">(<%=(merchantAccNoMap.getStatusModify() != null ? merchantAccNoMap.getStatusModify().equals(DDM_Constants.status_active) ? "Active" : merchantAccNoMap.getStatusModify().equals(DDM_Constants.status_deactive)? "Inactive" : "Pending" : "N/A")%>)</td>
                                                                                                                                                        </tr>
                                                                                                                                                        <%
                                                                                                                                                            }
                                                                                                                                                        %>
                                                                                                                                                    </table>
                                                                                                                                                    <%
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    N/A
                                                                                                                                                    <%
                                                                                                                                                        }
                                                                                                                                                    %>                                                                                                                                        </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                                <%
                                                                                                                                                    String stat = null;
                                                                                                                                                    String statModify = null;

                                                                                                                                                    if (merchantDetails.getStatus() == null)
                                                                                                                                                    {
                                                                                                                                                        stat = "N/A";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatus().equals(DDM_Constants.status_active))
                                                                                                                                                    {
                                                                                                                                                        stat = "Active";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatus().equals(DDM_Constants.status_deactive))
                                                                                                                                                    {
                                                                                                                                                        stat = "Inactive";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatus().equals(DDM_Constants.status_pending))
                                                                                                                                                    {
                                                                                                                                                        stat = "Pending for Authorization";
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        stat = "Other";
                                                                                                                                                    }

                                                                                                                                                    if (merchantDetails.getStatusModify() == null)
                                                                                                                                                    {
                                                                                                                                                        statModify = "N/A";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatusModify().equals(DDM_Constants.status_active))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Active";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatusModify().equals(DDM_Constants.status_deactive))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Inactive";
                                                                                                                                                    }
                                                                                                                                                    else if (merchantDetails.getStatusModify().equals(DDM_Constants.status_pending))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Pending for Authorization";
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        statModify = "Other";
                                                                                                                                                    }


                                                                                                                                                %>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=stat%> </td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=statModify%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td height="10" colspan="3" align="left" valign="middle" class="ddm_tbl_footer_text"></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Modified By :</td>
                                                                                                                                                <td colspan="2" class="ddm_tbl_common_text"><%=merchantDetails.getModifiedBy()%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Modified Date :</td>
                                                                                                                                                <td colspan="2" class="ddm_tbl_common_text"><%=merchantDetails.getModifiedDate()%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td height="35" colspan="3" align="right" class="ddm_tbl_footer_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" value="&nbsp;&nbsp; Authorize &nbsp;&nbsp;" onClick="doUpdate()" class="ddm_custom_button" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%> >                                                                                                                                              </td>
                                                                                                                                                            <td width="5"></td>
                                                                                                                                                            <td><input type="button" name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((reqType != null && reqType.equals("1")) && result) ? "OK" : "Cancel"%> &nbsp;&nbsp;" class="ddm_custom_button" onClick="cancel()"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table></td>
                                                                                                                                            </tr>
                                                                                                                                  </table></td></tr></table>
                                                                                                                                    
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