
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat,java.io.File" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.file.FileInfo" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.fileStatus.FileStatus" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.CommonUtils" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.batch.CustomBatch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.report.Report" errorPage="../../error.jsp"%>

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

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            //session.invalidate();
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Inward Fund Transfer Reports' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Inward_Fund_Transfer_Reports");
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
    String sessionID = null;
    String reportType = null;
    String cmbBusinessDate = null;
    Collection<String> colPrevBusinessDates = null;

    boolean isSubBankAvailable = false;
    int noOfActiveSessions = 0;
    Collection<Report> colResult = null;

    String noOfSessions = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_no_of_sessions);
    
    colPrevBusinessDates = DAOFactory.getBCMCalendarDAO().getPreviousBusinessDates(webBusinessDate, 7);

    if (noOfSessions != null)
    {
        try
        {
            noOfActiveSessions = Integer.parseInt(noOfSessions);
        }
        catch (Exception e)
        {
            System.out.println("invalid noOfSessions parameter ====> " + noOfSessions);
        }
    }

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        reportType = DDM_Constants.report_type_owd_ft_session_all;

        if (noOfActiveSessions > 0)
        {
            sessionID = DDM_Constants.window_session_1;
        }
        
        cmbBusinessDate = webBusinessDate;        
    }
    else if (isSearchReq.equals("0"))
    {
        reportType = DDM_Constants.report_type_owd_ft_session_all;
        sessionID = DDM_Constants.status_all;
        
        cmbBusinessDate = (String) request.getParameter("cmbBusinessDate");

    }
    else if (isSearchReq.equals("1"))
    {
        System.out.println("inside isSearchReq.equals('1') ------> ");

        reportType = DDM_Constants.report_type_owd_ft_session_all;
        sessionID = DDM_Constants.status_all;
        cmbBusinessDate = (String) request.getParameter("cmbBusinessDate");


        System.out.println("sessionID ------> " + sessionID);
        System.out.println("cmbBusinessDate ------> " + cmbBusinessDate);


        String reportName = cmbBusinessDate.replaceAll("-", "")  + "_" + DDM_Constants.report_owd_all_session_ft + DDM_Constants.file_ext_type_pdf;

        System.out.println("reportName ------> " + reportName);

        String url = DAOFactory.getReportDAO().generateFT_Reports(cmbBusinessDate, sessionID, reportType, reportName, session_userName);

        if (url != null && !url.isEmpty())
        { 
            DAOFactory.getReportDAO().addReportDetails(cmbBusinessDate, sessionID, DDM_Constants.default_bank_code, DDM_Constants.default_branch_code, DDM_Constants.default_coporate_customer_id, reportName, url, reportType, session_userName);

            colResult = DAOFactory.getReportDAO().getReportDetails(DDM_Constants.default_bank_code, DDM_Constants.default_branch_code, DDM_Constants.default_coporate_customer_id, sessionID, reportType, DDM_Constants.status_yes, cmbBusinessDate, cmbBusinessDate);
        }
        else
        {
            colResult = null;
        }

    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Outward Fund Transfer Reports - All Sessions</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>

        <script language="javascript" type="text/JavaScript">

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
            else if(type==3 )
            {
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
            clock(document.getElementById('showText'),type,val);
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
            //var objBusinessDate = "hdnBusinessDate_" + index;
            //var objBank = "hdnBank_" + index;

            document.getElementById('hdnFileName').value = document.getElementById(objReportName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(objReportPath).value;
            //document.getElementById('hdnBusinessDate').value = document.getElementById(objBusinessDate).value;                
            //document.getElementById('hdnBank').value = document.getElementById(objBank).value;	

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
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="slips_body" onLoad="showClock(3)">


        <table width="100%" style="min-width:900;min-height:600" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" class="slips_bgRepeat_center">
                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="slips_bgRepeat_left">
                        <tr>
                            <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="slips_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="102" valign="top" class="slips_header_center">

                                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="slips_header_left">
                                                            <tr>
                                                                <td valign="top"><table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0" class="slips_header_right">
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
                                                                                                                <td class="slips_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="slips_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuId : session_branchId%> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuName : session_branchName%></td>
                                                                                                                <td width="15">&nbsp;</td>
                                                                                                                <td valign="middle"><a href="<%=request.getContextPath()%>/pages/user/userProfile.jsp" title=" My Profile "><img src="<%=request.getContextPath()%>/images/user.png" width="18"
                                                                                                                                                                                                        height="22" border="0" align="middle" ></a></td>
                                                                                                                <td width="10"></td>
                                                                                                                <td class="slips_menubar_text">[ <a href="<%=request.getContextPath()%>/pages/logout.jsp" class="slips_menubar_link"><u>Logout</u></a> ]</td>
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
                                                    <td style="min-height:400" align="center" valign="top" class="slips_bgCommon">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td valign="top" nowrap class="slips_menubar_text_dark">Business Date : <%=webBusinessDate%></td>
                                                                                        <td width="10" valign="middle"></td>
                                                                                        <td valign="top" nowrap class="slips_menubar_text_dark">|&nbsp; Now : [ <%=currentDate%></td>
                                                                                        <td width="5" valign="middle">&nbsp;</td>
                                                                                        <td valign="top" class="slips_menubar_text_dark"><div id="showText" class="slips_menubar_text_dark"></div></td>
                                                                                        <td width="5" valign="top" nowrap class="slips_menubar_text_dark">&nbsp;]</td>

                                                                                        <td width="10" valign="middle"></td>
                                                                                        <%
                                                                                            String owWindowStartTime = window.getOW_cutontime() != null ? window.getOW_cutontime().substring(0, 2) + ":" + window.getOW_cutontime().substring(2) : "00:00";
                                                                                            String owWindowEndTime = window.getOW_cutofftime() != null ? window.getOW_cutofftime().substring(0, 2) + ":" + window.getOW_cutofftime().substring(2) : "00:00";

                                                                                            String iwWindowStartTime = window.getIW_cutontime() != null ? window.getIW_cutontime().substring(0, 2) + ":" + window.getIW_cutontime().substring(2) : "00:00";
                                                                                            String iwWindowEndTime = window.getIW_cutofftime() != null ? window.getIW_cutofftime().substring(0, 2) + ":" + window.getIW_cutofftime().substring(2) : "00:00";
                                                                                        %>

                                                                                        <td valign="top" nowrap class="slips_menubar_text_dark">| &nbsp; Session : <%=winSession%></td>
                                                                                        <td width="5" valign="middle"></td>

                                                                                        <td valign="top" nowrap class="slips_menubar_text_dark"><table border="0" cellspacing="0">
                                                                                                <tr height="12">
                                                                                                    <td valign="middle" nowrap class="slips_menubar_text_dark">[</td>
                                                                                                    <td valign="middle" nowrap class="slips_menubar_text_dark"><span class="slips_menubar_text_dark" title="Outward (OWNM) Window Start and End Time">OW (<%=owWindowStartTime%>-<%=owWindowEndTime%>)</span></td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle"><div id="actWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward (OWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward (OWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" nowrap class="slips_menubar_text_dark">| <span class="slips_menubar_text_dark" title="Inward (IWNM) Window Start and End Time">IW (<%=iwWindowStartTime%>-<%=iwWindowEndTime%>)</span>                                                                                          </td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle" class="slips_menubar_text"><div id="actWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (IWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward (IWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" class="slips_menubar_text_dark">]&nbsp;</td>
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
                                                                                        <td align="left" valign="top" class="slips_header_text">Outward Fund Transfer Reports - All Sessions</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="slips_header_text"><form id="frmOWDAllSessionFT" name="frmOWDAllSessionFT" method="post" action="OutwardAllSessionFT.jsp">
                                                                                                <table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="slips_table_boder" >
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" class="slips_tbl_header_text">Session : </td>
                                                                                                                                <td align="left" valign="middle" class="slips_tbl_common_text"><%
                                                                                                                                    
                                                                                                                                        if (noOfActiveSessions > 0)
                                                                                                                                        {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbSession" id="cmbSession"  class="slips_field_border" disabled>

                                                                                                                                        
                                                                                                                                        <option value="<%=DDM_Constants.status_all %>" >All</option>
                                                                                                                                        
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="slips_error">No Session Details Available!</span>
                                                                                                                                    <%  }

                                                                                                                                        
                                                                                                                                        

                                                                                                                                    %></td>
                                                                                                                                <td align="left" valign="middle" class="slips_tbl_header_text">Business Date :</td>
                                                                                                                                <td align="left" valign="middle" class="slips_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle">                                                                                                                    
                                                                                                                                          
                                                                                                                                                <select name="cmbBusinessDate" id="cmbBusinessDate" class="slips_field_border" >
                                                                                                                                                    <%
                                                                                                                                                        if (colPrevBusinessDates != null && colPrevBusinessDates.size() > 0)
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    
                                                                                                                                                    <%
                                                                                                                                                        
                                                                                                                                                            for (String bDate : colPrevBusinessDates)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=bDate%>" <%=(cmbBusinessDate != null && bDate.equals(cmbBusinessDate)) ? "selected" : ""%> > <%=bDate%></option>
                                                                                                                                                    <%
                                                                                                                                                        }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                                <%
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <span class="slips_error">Vaild 'Value Dates' not available!</span>
                                                                                                                                                <%
																																				}
                                                                                                                                                %>                                                                                                                                            </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                        </tr>
                                                                                                                              </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td colspan="4" align="right" valign="middle" class="slips_tbl_footer_text">                                                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="slips_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click 'Generate' to view and download reports.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Generate" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    frmOWDAllSessionFT.submit()"  class="slips_custom_button"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
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
                                                                                                                if (isSearchReq.equals("1"))
                                                                                                                {
                                                                                                                    if (colResult == null)
                                                                                                                    {

                                                                                                            %>

                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="slips_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="slips_Display_Error_msg">Error occurred while generating the Inward Fund Transfer Reports !</div></td>
                                                                                                            </tr>	

                                                                                                            <%                                                                                                                                                                                                        }

                                                                                                            else if (colResult.size() == 0)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="slips_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="slips_Display_Error_msg">No records available to generate Inward Fund Transfer Reports!</div></td>
                                                                                                            </tr>
                                                                                                            <%   }
                                                                                                            else if (colResult.size() > 0)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="slips_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="slips_table_boder" bgcolor="#FFFFFF">
                                                                                                                            <tr>
                                                                                                                                <td rowspan="2" class="slips_tbl_header_text"></td>
                                                                                                                                <td rowspan="2" align="center" class="slips_tbl_header_text_horizontal">Business<br/>
                                                                                                                                    Date<br><span class="slips_common_text_white">(Report Generated)</span></td>
                                                                                                                                <td rowspan="2"  class="slips_tbl_header_text_horizontal">Session</td>
                                                                                                                                <%
                                                                                                                                    if (isSubBankAvailable)
                                                                                                                                    {
                                                                                                                                %>
                                                                                                                                <%                                                                                                            }
                                                                                                                                %>
                                                                                                                                <!--td rowspan="2" align="center" bgcolor="#A9D1B9" class="slips_tbl_header_text">Inward<br/>Branch</td-->
                                                                                                                                <td rowspan="2"  class="slips_tbl_header_text_horizontal">Report<br/>
                                                                                                                                    Name</td>
                                                                                                                                <td rowspan="2" align="center" bgcolor="#FCCC67" class="slips_tbl_header_text_horizontal">Generated<br/>
                                                                                                                                    Time</td>
                                                                                                                                <td rowspan="2" align="center" bgcolor="#FCCC67" class="slips_tbl_header_text_horizontal">Generated<br/>
                                                                                                                                    By</td>
                                                                                                                                <td colspan="2" align="center" bgcolor="#FCCC67" class="slips_tbl_header_text_horizontal">Report Status</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="center" bgcolor="#FCCC67" class="slips_tbl_header_text_horizontal_small">Download</td>
                                                                                                                                <td align="center" bgcolor="#FCCC67" class="slips_tbl_header_text_horizontal_small">Size<br/>
                                                                                                                                    (Bytes)</td>
                                                                                                                            </tr>
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
                                                                                                                                <td align="right" class="slips_common_text" ><%=rowNum%>.</td>
                                                                                                                                <td align="center"  class="slips_common_text"><%=rpt.getBusinessDate()%></td>
                                                                                                                                <td  class="slips_common_text"><span class="slips_common_text" title="<%=rpt.getBankFullName()%>"><%=rpt.getBank() + " - " + rpt.getBankShortName()%></span></td>
                                                                                                                                <td  class="slips_common_text"><%=rpt.getReportName()%></td>
                                                                                                                                <td align="center"  class="slips_common_text"><%=rpt.getCreatedTime()%></td>
                                                                                                                                <td align="center"  class="slips_common_text"><%=rpt.getCreatedBy()%></td>
                                                                                                                                <td align="center"  class="slips_common_text"><input type="hidden" id="hdnFileName_<%=rowNum%>" name="hdnFileName_<%=rowNum%>" value="<%=rpt.getReportName()%>" />
                                                                                                                                    <input type="hidden" id="hdnFilePath_<%=rowNum%>" name="hdnFilePath_<%=rowNum%>" value="<%=rpt.getReportPath()%>" />
                                                                                                                                    <input type="hidden" id="hdnBusinessDate_<%=rowNum%>" name="hdnBusinessDate_<%=rowNum%>" value="<%=rpt.getBusinessDate()%>" />
                                                                                                                                    <input type="hidden" id="hdnBank_<%=rowNum%>" name="hdnBank_<%=rowNum%>" value="<%=rpt.getBank()%>" />
                                                                                                                                    <%
                                                                                                                                        if (isReportFileAvailable)
                                                                                                                                        {

                                                                                                                                                      //File reportFile = ne  
                                                                                                                                    %>
                                                                                                                                    <input type="button" name="btnDwnReport" id="btnDwnReport" value="Download" class="slips_custom_button_small" onClick="downloadReport(<%=rowNum%>)">
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="slips_error" title="Report Not Available">RNA</span>
                                                                                                                                    <%                                                                                                                }
                                                                                                                                    %></td>
                                                                                                                                <td align="right"  class="slips_common_text"><%=isReportFileAvailable == true ? reportSize : "<center>-</center>"%></td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                }

                                                                                                                            %>
                                                                                                                            <form id="frmDownload" name="frmDownload" method="post" target="_blank">
                                                                                                                                <tr  class="slips_common_text">
                                                                                                                                    <td height="20" align="right" bgcolor="#DCD6BE" ></td>
                                                                                                                                    <td align="center" bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                    <td align="center" bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                    <td align="center" bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                    <td align="center" bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                    <td align="center" bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                    <td bgcolor="#DCD6BE" class="slips_common_text"><input type="hidden" id="hdnFileName" name="hdnFileName"  />
                                                                                                                                        <input type="hidden" id="hdnFilePath" name="hdnFilePath"  />
                                                                                                                                        <input type="hidden" id="hdnBusinessDate" name="hdnBusinessDate"  />
                                                                                                                                        <input type="hidden" id="hdnBank" name="hdnBank"  /></td>
                                                                                                                                    <td bgcolor="#DCD6BE" class="slips_common_text">&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                            </form>
                                                                                                                        </table>
                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%                                                                                                                }
                                                                                                                }
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
                <td height="32" class="slips_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_footter_left">
                        <tr>
                            <td height="32">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_footter_right">
                                    <tr>
                                        <td height="32" valign="bottom">
                                            <table width="100%" height="32" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="10"></td>
                                                    <td valign="middle" class="slips_copyRight"></td>
                                                    <td align="right" valign="middle" class="slips_copyRight"></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td width="25"></td>
                                                    <td valign="middle" class="slips_copyRight">&copy; 2023 LankaPay (Pvt) Ltd. All rights reserved. | Tel: 011 2334455 | Mail: helpdesk.ddm@lankapay.net</td>
                                                    <td align="right" valign="middle" class="slips_copyRight">Developed By - Transnational Technology Solutions Lanka (Pvt) Ltd.</td>
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
