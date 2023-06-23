
<%@page import="java.util.*,java.sql.*,java.io.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.CommonUtils" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.NumberFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.report.Report" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.reporttype.ReportType" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../error.jsp"%>


<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
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
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - New DDM Request(s) Acquiring Bank Approval' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Annual_Reports");
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
    String selectedBankCode = null;
    String selectedMerchant = null;
    String reportType = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;

    boolean isSubBankAvailable = false;
    Collection<Report> colResult = null;
    Collection<Bank> colBank = null;
    Collection<Merchant> colMerchant = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        if (!(session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user) || session_userType.equals(DDM_Constants.user_type_ddm_operator)))
        {
            selectedBankCode = session_bankCode;
            reportType = DDM_Constants.report_type_bank_annual;

            if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
            {
                selectedMerchant = session_cocuId;
            }
            else
            {
                selectedMerchant = DDM_Constants.status_all;
            }
        }
        else
        {
            selectedBankCode = DDM_Constants.status_all;
            selectedMerchant = DDM_Constants.status_all;
            reportType = DDM_Constants.status_all;
        }
        
        //colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, selectedBankCode, DDM_Constants.status_all);
        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

        fromBusinessDate = webBusinessDate;
        toBusinessDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        if (!(session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user) || session_userType.equals(DDM_Constants.user_type_ddm_operator)))
        {
            selectedBankCode = session_bankCode;
            reportType = DDM_Constants.report_type_bank_annual;

            if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
            {
                selectedMerchant = session_cocuId;
            }
            else
            {
                selectedMerchant = (String) request.getParameter("search_cmbMerchant");
            }
        }
        else
        {
            selectedBankCode = (String) request.getParameter("cmbBank");
            selectedMerchant = (String) request.getParameter("search_cmbMerchant");
            reportType = DDM_Constants.status_all;
        }
        
        //colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, selectedBankCode, DDM_Constants.status_all);
        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
    }
    else if (isSearchReq.equals("1"))
    {
        if (!(session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user) || session_userType.equals(DDM_Constants.user_type_ddm_operator)))
        {
            selectedBankCode = session_bankCode;
            reportType = DDM_Constants.report_type_bank_annual;

            if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
            {
                selectedMerchant = session_cocuId;
            }
            else
            {
                selectedMerchant = (String) request.getParameter("search_cmbMerchant");
            }
        }
        else
        {
            selectedBankCode = (String) request.getParameter("cmbBank");
            selectedMerchant = (String) request.getParameter("search_cmbMerchant");
            reportType = DDM_Constants.status_all;
        }
        
        //colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, selectedBankCode, DDM_Constants.status_all);
        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");

        colResult = DAOFactory.getReportDAO().getReportDetails(selectedBankCode, DDM_Constants.status_all, selectedMerchant, reportType, DDM_Constants.report_type_annual, DDM_Constants.status_yes, fromBusinessDate, toBusinessDate);

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_reports_view_annual_reports, "| Search Criteria - (Bank : " + selectedBankCode + ", Merchant : " + selectedMerchant + ", Report Type : Annual, From BusinessDate : " + fromBusinessDate + ", To BusinessDate : " + toBusinessDate + ") | Result Count - " + (colResult != null ? colResult.size() : "0") + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Annual Reports</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/autocomplete.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>


        <script language="javascript" type="text/JavaScript">


            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2                 )
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

            function resetDates()
            {
            var from_elementId = 'txtFromBusinessDate';
            var to_elementId = 'txtToBusinessDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";
            }

            function isInitReq(status) {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";
            }

            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else
            {
            document.getElementById('hdnSearchReq').value = "0";
            }
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

            if(document.getElementById('clickSearch')!= null)
            {
            document.getElementById('clickSearch').style.display='block';
            }

            }

            function downloadReport(index)
            {

            var objReportName = "hdnFileName_" + index;
            var objReportPath = "hdnFilePath_" + index;
            var objBusinessDate = "hdnBusinessDate_" + index;
            var objBank = "hdnBank_" + index;

            document.getElementById('hdnFileName').value = document.getElementById(objReportName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(objReportPath).value;
            document.getElementById('hdnBusinessDate').value = document.getElementById(objBusinessDate).value;                
            document.getElementById('hdnBank').value = document.getElementById(objBank).value;	

            document.frmDownload.action="DownloadReport.jsp";
            document.frmDownload.submit();			
            }

            function downloadSignature(index)
            {
            var objSigName = "hdnFileName_" + index;
            var objSigPath = "hdnFilePath_" + index;

            document.getElementById('hdnFileName').value = document.getElementById(objSigName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(objSigPath).value;

            document.frmDownload.action="DownloadSignature.jsp";
            document.frmDownload.submit();			
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3)">

        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>


        <table width="100%" height="100%" style="min-width:900;min-height:600" align="center" border="0" cellpadding="0" cellspacing="0" >
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Annual Reports</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="ddm_header_text"><form id="frmSearchAnnualReports" name="frmSearchAnnualReports" method="post" action="AnnualReport.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="1" cellpadding="4">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#A9D1B9" class="ddm_tbl_header_text" >Bank :</td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_common_text"><%
                                                                                                                        try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="cmbBank" id="cmbBank" onChange="isSearchRequest(false);frmSearchAnnualReports.submit()" class="ddm_field_border" <%=(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                            <%
                                                                                                                                if (selectedBankCode == null || (selectedBankCode != null && selectedBankCode.equals(DDM_Constants.status_all)))
                                                                                                                                {
                                                                                                                            %>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" selected>-- All --</option>
                                                                                                                            <% }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                            <%
                                                                                                                                if (colBank != null && colBank.size() > 0)
                                                                                                                                {
                                                                                                                                    for (Bank bank : colBank)
                                                                                                                                    {

                                                                                                                            %>
                                                                                                                            <option value="<%=bank.getBankCode()%>" <%=(selectedBankCode != null && bank.getBankCode().equals(selectedBankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                            <%

                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="ddm_error">No bank details available.</span>
                                                                                                                        <%  }

                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }

                                                                                                                        %>                                                                                                        </td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_header_text">Business Date :</td>
                                                                                                                    <td align="left" valign="top" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="9" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(DDM_Constants.status_all)) ? "" : fromBusinessDate%>" >                                                                                                                    </td>
                                                                                                                                <td width="5" valign="middle"></td>
                                                                                                                                <td width="10" valign="middle"></td>
                                                                                                                                <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="9" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(DDM_Constants.status_all)) ? "" : toBusinessDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                <td width="5" valign="middle"></td>
                                                                                                                                <td width="10px" valign="middle"></td>
                                                                                                                                <td valign="middle"><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Reset Dates &nbsp;&nbsp;" type="button" onClick="resetDates()" class="ddm_custom_button_small" /></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>

                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" class="ddm_tbl_header_text" >Merchant :</td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                                    try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="search_cmbMerchant" id="search_cmbMerchant" class="ddm_field_border" onChange="clearResultData();" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                            <%
                                                                                                                                if (selectedMerchant == null || (selectedMerchant != null && selectedMerchant.equals(DDM_Constants.status_all)))
                                                                                                                                {
                                                                                                                            %>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" selected>-- All --</option>
                                                                                                                            <%                                                                                                                        }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                            <%                                                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <%
                                                                                                                                if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                {
                                                                                                                                    for (Merchant objMerch : colMerchant)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=objMerch.getMerchantID()%>" <%=(selectedMerchant != null && objMerch.getMerchantID().equals(selectedMerchant)) ? "selected" : ""%>><%=objMerch.getMerchantID() %> - <%=objMerch.getMerchantName()%></option>
                                                                                                                            <%

                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="ddm_error">No merchant details available!</span>
                                                                                                                        <%}
                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }
                                                                                                                        %></td>
                                                                                                                    <td colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                <td align="center">                                                                                                                     
                                                                                                                                    <div id="clickSearch" class="ddm_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td align="right"><input name="btnSearch" id="btnSearch" value="&nbsp;&nbsp; Search &nbsp;&nbsp;" type="button" onClick="isSearchRequest(true);frmSearchAnnualReports.submit()"  class="ddm_custom_button"/></td>
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
                                                                                        <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td><table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%
                                                                                                                if (isSearchReq.equals("1") && colResult.size() == 0)
                                                                                                                {%>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%   }
                                                                                                            else if (isSearchReq.equals("1") && colResult.size() > 0)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table class="ddm_table_boder_result" cellspacing="1" cellpadding="4" >
                                                                                                                      <thead>
                                                                                                                                <tr>
                                                                                                                                    <th rowspan="2" align="right"></th>
                                                                                                                                    <th rowspan="2" align="center" valign="top" >Business<br/>Date</th>
                                                                                                                                    <th rowspan="2" align="center" valign="top" >Bank</th>
                                                                                                                                    <th rowspan="2" align="center" valign="top" >Merchant</th>
                                                                                                                                    <th rowspan="2" align="center" valign="top">Report<br/>Name</th>
                                                                                                                                    <th rowspan="2" align="center" valign="top">Created<br/>Time</th>
                                                                                                                                    <th colspan="5" align="center" >Download Status</th>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <th align="center" >Report</th>
                                                                                                                                    <th align="center" >Size<br/>(Bytes)</th>
                                                                                                                                    <th align="center" >Already<br/>D.load</th>
                                                                                                                                    <th align="center" >D.load<br/>By</th>
                                                                                                                                    <th align="center" >D.load<br/>Time</th>
                                                                                                                                </tr>
                                                                                                                            </thead>
                                                                                                                            <tbody>
                                                                                                                                <%
                                                                                                                                    boolean isReportFileAvailable = false;

                                                                                                                                    File reportFile = null;

                                                                                                                                    int rowNum = 0;
                                                                                                                                    int itemCountCredit = 0;
                                                                                                                                    int itemCountDebit = 0;

                                                                                                                                    long reportSize = 0;
                                                                                                                                    long totalAmountCredit = 0;
                                                                                                                                    long totalAmountDebit = 0;

                                                                                                                                    for (Report rpt : colResult)
                                                                                                                                    {
                                                                                                                                        rowNum++;

                                                                                                                                        isReportFileAvailable = new CommonUtils().isFileAvailable(rpt.getReportPath());

                                                                                                                                        if (isReportFileAvailable)
                                                                                                                                        {
                                                                                                                                            reportFile = new File(rpt.getReportPath());
                                                                                                                                            reportSize = new CommonUtils().getFileSize(rpt.getReportPath());
                                                                                                                                        }


                                                                                                                                %>

                                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                    <td align="right" class="ddm_common_text" ><%=rowNum%>.</td>
                                                                                                                                    <td align="center"  class="ddm_common_text"><%=rpt.getBusinessDate()%></td>
                                                                                                                                    <td  class="ddm_common_text"><span class="ddm_common_text" title="<%=rpt.getBankFullName()%>"><%=rpt.getBank() + " - " + rpt.getBankShortName()%></span></td>
                                                                                                                                    <td  class="ddm_common_text"><% if(rpt.getMerchantId()!= null) {%>  <%=rpt.getMerchantId() + " - " + rpt.getMerchantName()%> <% } %></td>
                                                                                                                                    <td  class="ddm_common_text"><%=rpt.getReportName()%></td>
                                                                                                                                    <td align="center"  class="ddm_common_text"><%=rpt.getCreatedTime()%></td>
                                                                                                                                    <td align="center"  class="ddm_common_text">
                                                                                                                                        <input type="hidden" id="hdnFileName_<%=rowNum%>" name="hdnFileName_<%=rowNum%>" value="<%=rpt.getReportName()%>" />                                                                                                                
                                                                                                                                        <input type="hidden" id="hdnFilePath_<%=rowNum%>" name="hdnFilePath_<%=rowNum%>" value="<%=rpt.getReportPath()%>" /> 
                                                                                                                                        <input type="hidden" id="hdnBusinessDate_<%=rowNum%>" name="hdnBusinessDate_<%=rowNum%>" value="<%=rpt.getBusinessDate()%>" />                                                                                                                                    
                                                                                                                                        <input type="hidden" id="hdnBank_<%=rowNum%>" name="hdnBank_<%=rowNum%>" value="<%=rpt.getBank()%>" />

                                                                                                                                        <%
                                                                                                                                            if (isReportFileAvailable)
                                                                                                                                            {

                                                                                                                                                //File reportFile = ne  
%>                                                                                                               
                                                                                                                                        <input type="button" name="btnDwnReport" id="btnDwnReport" value="&nbsp;&nbsp; <%=rpt.getReportPath().endsWith(DDM_Constants.file_ext_type_pdf) ? "PDF" : "File"%> &nbsp;&nbsp;" class="ddm_custom_button_small" onClick="downloadReport(<%=rowNum%>)">
                                                                                                                                      <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <span class="ddm_error" title="Report Not Available">RNA</span>
                                                                                                                                        <%                                                                                                                }
                                                                                                                                        %></td>
                                                                                                                                    <td align="right"  class="ddm_common_text"><%=isReportFileAvailable == true ? reportSize : "<center>-</center>"%></td>
                                                                                                                                    <td align="center"  class="ddm_common_text"><%=rpt.getIsAlreadyDownloaded().equals(DDM_Constants.status_yes) ? "Yes" : "No"%></td>
                                                                                                                                    <td align="center"  class="ddm_common_text"><%=rpt.getDownloadedBy() != null ? rpt.getDownloadedBy() : "-"%></td>
                                                                                                                                    <td align="center"  class="ddm_common_text"><%=rpt.getDownloadedTime() != null ? rpt.getDownloadedTime() : "-"%></td>
                                                                                                                                </tr>

                                                                                                                                <%
                                                                                                                                    }

                                                                                                                                %>
                                                                                                                            </tbody>

                                                                                                                            <form id="frmDownload" name="frmDownload" method="post" target="_blank">
                                                                                                                                <tfoot>
                                                                                                                                    <tr  class="ddm_common_text">
                                                                                                                                        <td align="right" bgcolor="#CCCCCC" ></td>
                                                                                                                                      <td align="center" bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                      <td align="center" bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>

                                                                                                                                      <td align="center" bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                      <td align="center" bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>




                                                                                                                                      <td align="center" bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                  <td bgcolor="#CCCCCC" class="ddm_common_text"><input type="hidden" id="hdnFileName" name="hdnFileName"  />                                                                                                                
                                                                                                                                            <input type="hidden" id="hdnFilePath" name="hdnFilePath"  /><input type="hidden" id="hdnBusinessDate" name="hdnBusinessDate"  /><input type="hidden" id="hdnBank" name="hdnBank"  /></td>
                                                                                                                                      <td bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                      <td bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                      <td bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                      <td bgcolor="#CCCCCC" class="ddm_common_text">&nbsp;</td>
                                                                                                                                  </tr>
                                                                                                                                </tfoot>
                                                                                                                            </form>
                                                                                                                        </table>
                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%                                                                                                                }
                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table></td>
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
    
    <script language="javascript" type="text/JavaScript">
        if (!document.layers)
        {		
            document.write('<div id="GotoDown" style="position:absolute">');
            document.write('<layer id="GotoDown">');
            document.write('<a href="javascript:void(0)" onClick="gotoDown()"><img src="<%=request.getContextPath()%>/images/down.png" border="0" width="40" height="40" title="Go To Bottom" class="gradualshine" onMouseOver="slowhigh(this)" onMouseOut="slowlow(this)" /></a>');
            document.write('</layer>');
            document.write('</div>');
		
            document.write('<div id="GotoTop" style="position:absolute">');
            document.write('<layer id="GotoTop">');
            document.write('<a href="javascript:void(0)" onClick="gotoTop()"><img src="<%=request.getContextPath()%>/images/up.png" border="0" width="40" height="40" title="Go To Top" class="gradualshine" onMouseOver="slowhigh(this)" onMouseOut="slowlow(this)" /></a>');
            document.write('</layer>');
            document.write('</div>');
        }

    </script>
    
    <script language="javascript">floatItem("GotoDown",40,40,"right",2,"top",125);</script>
    <script language="javascript">floatItem("GotoTop",40,40,"right",2,"bottom",25);</script>
    
    
</html>
<%
        }
    }
%>
