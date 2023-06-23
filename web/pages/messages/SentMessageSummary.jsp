<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.message.CustomMsg" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.message.Recipient" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.header.MsgHeader" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.body.MsgBody" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.priority.MsgPriority" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.window.Window" errorPage="../../error.jsp"%>
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
    String session_bankCode = null;
    String session_bankName = null;
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
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
        session_bankCode = (String) session.getAttribute("session_bankcode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        if (session_userType.equals(DDM_Constants.user_type_common_bim_user))
        {
            //session.invalidate();
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Sent Message Summary' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Sent_Message_Summary");
            }
        }
        else
        {

%>
<%          
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_web_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    Window windowOW = DAOFactory.getWindowDAO().getWindow(session_bankCode, DDM_Constants.transaction_type_normal);
    Window windowIW = DAOFactory.getWindowDAO().getWindow(session_bankCode, DDM_Constants.transaction_type_inward);
    Window windowOR = DAOFactory.getWindowDAO().getWindow(session_bankCode, DDM_Constants.transaction_type_return);
    Window windowIR = DAOFactory.getWindowDAO().getWindow(session_bankCode, DDM_Constants.transaction_type_inwardreturn);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>
<%
    String msgToBank = null;
    //String msgToCounter = null;
    //String msgToShow = null;
    String priority = null;
    String fromDate = null;
    String toDate = null;

    String isInitReq = null;
    String isSearchReq = null;

    Collection<MsgPriority> colMsgPriority = null;
    Collection<Recipient> colMsgToBank = null;
    Collection<CustomMsg> colMsg = null;

    //isInitReq = (String) request.getParameter("hdnInitReq");
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();
    //colMsgTo = DAOFactory.getBranchDAO().getBranch(bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
    //colMsgToBank = DAOFactory.getBranchDAO().getBranch(bankCode, DDM_Constants.status_all, DDM_Constants.status_active);
    colMsgToBank = DAOFactory.getCustomMsgDAO().getAvailableFullRecipientList(session_userType, session_bankCode);

    if (isSearchReq == null)
    {
        isSearchReq = "0";
        msgToBank = DDM_Constants.status_all;
        fromDate = currentDate;
        toDate = currentDate;

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_search_outbox, "| Initail visit. | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {
        msgToBank = (String) request.getParameter("cmbMsgToBank");

//        if (msgToBank.equals(DDM_Constants.status_all))
//        {
//            msgToShow = msgToBank;
//        }
        priority = (String) request.getParameter("cmbPriority");
        fromDate = (String) request.getParameter("txtFromSentDate");
        toDate = (String) request.getParameter("txtToSentDate");

        if (isSearchReq.equals("1"))
        {
            if (fromDate == null || fromDate.equals(""))
            {
                fromDate = DDM_Constants.status_all;
            }

            if (toDate == null || toDate.equals(""))
            {
                toDate = DDM_Constants.status_all;
            }

            colMsg = DAOFactory.getCustomMsgDAO().getSentMassageList(session_bankCode, msgToBank, priority, fromDate, toDate);
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_search_outbox, "| To  - " + msgToBank + ", Priority - " + priority + ", From Date - " + fromDate + ", To Date - " + toDate + "| Result Count - " + colMsg.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>
<html>
    <head>
        <title>OUSDPS Web (Version 1.2.0 - 2018)</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>        

        <script language="javascript" type="text/JavaScript">

            function doSubmit(val)
            {				
            if(val=='0')
            {
            if(validate())
            {
            document.frmSentMessageSummary.submit();
            }
            }
            else if(val=='1')
            {
            document.frmSentMessageSummary.submit();
            }


            }

            function validate()
            {
            var fromDateValue = null;
            var toDateValue = null;

            fromDateValue = document.getElementById('txtFromSentDate').value;
            toDateValue = document.getElementById('txtToSentDate').value;

            if(dateValidate(fromDateValue, toDateValue))
            {
            return true;
            }
            else
            {
            //alert('From date should be lesser than To date.');
            return false;
            }

            }

            function dateValidate(fromDate, toDate)
            {
            var from_date = new Date();
            var to_date = new Date();

            if(fromDate != null && fromDate.length > 0)
            {
            if(toDate != null && toDate.length > 0)
            {
            from_date.setFullYear(fromDate.substring(0,4), (parseInt(fromDate.substring(5,7)))-1, fromDate.substring(8,10));
            to_date.setFullYear(toDate.substring(0,4), (parseInt(toDate.substring(5,7)))-1, toDate.substring(8,10));

            if(from_date.getTime() <= to_date.getTime())
            {
            if((to_date.getTime()-from_date.getTime()) <= 16070400000)
            {
            return true;
            }
            else
            {
            alert('From-Date and To-Date gap must be less than or equal to 186 days!');
            return false;
            }
            }
            else
            {
            alert('From-Date should be lesser than To-Date!');
            return false;
            }
            }
            else
            {
            alert('To-Date Can not be empty!');
            return true;
            }                    
            }
            else
            {
            alert('From-Date Can not be empty!');
            return true;
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
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=windowOW != null ? windowOW.getCutontimeHour() : null%>, <%=windowOW != null ? windowOW.getCutontimeMinutes() : null%>, <%=windowOW != null ? windowOW.getCutofftimeHour() : null%>, <%=windowOW != null ? windowOW.getCutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=windowIW != null ? windowIW.getCutontimeHour() : null%>, <%=windowIW != null ? windowIW.getCutontimeMinutes() : null%>, <%=windowIW != null ? windowIW.getCutofftimeHour() : null%>, <%=windowIW != null ? windowIW.getCutofftimeMinutes() : null%>, document.getElementById('actWindowOR'), document.getElementById('expWindowOR'), <%=windowOR != null ? windowOR.getCutontimeHour() : null%>, <%=windowOR != null ? windowOR.getCutontimeMinutes() : null%>, <%=windowOR != null ? windowOR.getCutofftimeHour() : null%>, <%=windowOR != null ? windowOR.getCutofftimeMinutes() : null%>, document.getElementById('actWindowIR'), document.getElementById('expWindowIR'), <%=windowIR != null ? windowIR.getCutontimeHour() : null%>, <%=windowIR != null ? windowIR.getCutontimeMinutes() : null%>, <%=windowIR != null ? windowIR.getCutofftimeHour() : null%>, <%=windowIR != null ? windowIR.getCutofftimeMinutes() : null%>);
            clock(document.getElementById('showText'), type, val);
            }

            }

            function clearDates()
            {
            var from_elementId = 'txtFromSentDate';
            var to_elementId = 'txtToSentDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";

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
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** SLIPS ****</div>
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
                                                                <td align="center" valign="top"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text">Outbox -  Message Summary</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text"><form id="frmSentMessageSummary" name="frmSentMessageSummary" method="post" action="SentMessageSummary.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="slips_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                      <!-- input type="hidden" name="hdnInitReq" id="hdnInitReq" value="<%=isInitReq%>" /-->
<tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text">To :</td>
                                                                                              <td valign="middle" class="slips_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbMsgToBank" class="slips_field_border" id="cmbMsgToBank" onChange="isSearchRequest(false);
                                                                                                                                                    doSubmit(1);">
                                                                                                                                        <%                                                                                                                    if (msgToBank == null || msgToBank.equals(DDM_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">- Any Recipient(s) -</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">- Any Recipient(s) -</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colMsgToBank != null && colMsgToBank.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Recipient branchRecipient : colMsgToBank)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=branchRecipient.getRecipientCode()%>" <%=(msgToBank != null && branchRecipient.getRecipientCode().equals(msgToBank)) ? "selected" : ""%> ><%=branchRecipient.getRecipientCode()%> - <%=branchRecipient.getRecipientName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="slips_error">No To details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>



                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text">Priority :</td>
                                                                                                                          <td valign="middle" class="slips_tbl_common_text"><%                                                                                                          try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbPriority" class="slips_field_border" id="cmbPriority" onChange="clearResultData()">
                                                                                                                                        <%                                                                                                                    if (priority == null || priority.equals(DDM_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colMsgPriority != null && !colMsgPriority.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (MsgPriority msgPriority : colMsgPriority)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <option value="<%=msgPriority.getPriorityLevel()%>" <%=(priority != null && msgPriority.getPriorityLevel().equals(priority)) ? "selected" : ""%> ><%=msgPriority.getPriorityDesc()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                            }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="slips_error">No priority details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %>                                                                                                        </td>



                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text">Sent Date :</td>
                                                                                                              <td valign="middle" class="slips_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromSentDate" id="txtFromSentDate" type="text"
                                                                                                                                                                       class="tcal" size="8" onFocus="this.blur();
                                                                                                                                                                               clearResultData();" value="<%=(fromDate == null || fromDate.equals("0") || fromDate.equals(DDM_Constants.status_all)) ? "" : fromDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToSentDate" id="txtToSentDate" type="text"
                                                                                                                                                                       class="tcal" size="8" onFocus="this.blur();
                                                                                                                                                                               clearResultData();" value="<%=(toDate == null || toDate.equals("0") || toDate.equals(DDM_Constants.status_all)) ? "" : toDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="clearDates()" class="slips_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>


                                                                                                                      </tr>
                                                                                                                            <tr>

                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CECED7" class="slips_tbl_footer_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center"><div id="clickSearch" class="slips_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    doSubmit(0);"  class="slips_custom_button"/></td>
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

                                                                                                                    if (colMsg == null || (colMsg != null && colMsg.isEmpty()))
                                                                                                                    {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="25" align="center" class="slips_header_text"></td>
                                                                                                      </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="slips_header_small_text">No Records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                            }

                                                                                                            else if (colMsg != null && !colMsg.isEmpty())
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td class="slips_header_text" align="center"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="slips_table_boder" bgcolor="#FFFFFF">
                                                                                              <tr>
                                                                                                                                <td align="right" class="slips_tbl_header_text_horizontal_small"></td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small" >To</td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small">Subject</td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small" >Message</td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small" >Priority</td>
                                                                                          <td align="center" class="slips_tbl_header_text_horizontal_small">Recipient<br/>
                                                                                                                                    Count</td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small">Attachment</td>
                                                                                          <td align="center" class="slips_tbl_header_text_horizontal_small">Created<br/>
                                                                                                                                    By</td>
                                                                                          <td align="center" class="slips_tbl_header_text_horizontal_small">Created<br/>
                                                                                                                                    Time</td>
                                                                                                                <td align="center" class="slips_tbl_header_text_horizontal_small">&nbsp;</td>
                                                                                                                          </tr>
                                                                                                                            <%
                                                                                                                                int rowNum = 0;
                                                                                                                                String msgSubjectPart = null;
                                                                                                                                String msgPart = null;
                                                                                                                                String strTo = null;

                                                                                                                                for (CustomMsg customMsg : colMsg)
                                                                                                                                {
                                                                                                                                    rowNum++;

                                                                                                                                    MsgHeader msgHeader = customMsg.getMsgHeader();
                                                                                                                                    MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                                    MsgPriority msgPriority = customMsg.getMsgPriority();

                                                                                                                                    if ((msgHeader != null) && (msgHeader.getSubject() != null))
                                                                                                                                    {
                                                                                                                                        if (msgHeader.getSubject().length() > 35)
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject().substring(0, 31) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgSubjectPart = "";
                                                                                                                                    }

                                                                                                                                    if ((msgBody != null) && (msgBody.getBody() != null))
                                                                                                                                    {
                                                                                                                                        if (msgBody.getBody().length() > 25)
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody().substring(0, 21) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgPart = "";
                                                                                                                                    }

                                                                                                                                    if (msgToBank.equals(DDM_Constants.status_all))
                                                                                                                                    {

                                                                                                                                        if (msgHeader.getRecipientCount() > 1)
                                                                                                                                        {
                                                                                                                                            strTo = "Multiple Recipients - [" + msgHeader.getRecipientCount() + "]";
                                                                                                                                        }
                                                                                                                                        else if (msgHeader.getRecipientCount() == 1)
                                                                                                                                        {
                                                                                                                                            CustomMsg cMsg = DAOFactory.getCustomMsgDAO().getToListAndReadDetails(msgHeader.getMsgId()).isEmpty() ? null : DAOFactory.getCustomMsgDAO().getToListAndReadDetails(msgHeader.getMsgId()).iterator().next();

                                                                                                                                            if (cMsg != null && cMsg.getMsgBody() != null)
                                                                                                                                            {
                                                                                                                                                strTo = cMsg.getMsgBody().getMsgToBank() + " - " + cMsg.getMsgBody().getMsgToBankName();
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                strTo = "N/A";
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            strTo = "N/A";
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        Bank bk = DAOFactory.getBankDAO().getBankDetails(msgToBank);

                                                                                                                                        if (msgHeader.getRecipientCount() > 1)
                                                                                                                                        {
                                                                                                                                            strTo = bk.getBankCode() + " - " + bk.getBankFullName() + " and more....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            strTo = bk.getBankCode() + " - " + bk.getBankFullName();
                                                                                                                                        }
                                                                                                                                    }

                                                                                                                            %>
                                                                                                                            <form name="frmMsgDetails" id="frmMsgDetails" action="SentMessageDetail.jsp" method="post">
                                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                    <td align="right" class="slips_common_text"><%=rowNum%>.</td>

                                                                                                                                    <td class="slips_msg_from" ><%=strTo%> <input type="hidden" name="hdn_from" id="hdn_from" value="<%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%>"></td>
                                                                                                                                    <td class="slips_msg_subject"><%=msgSubjectPart%><input type="hidden" name="hdn_subject" id="hdn_subject" value="<%=msgHeader.getSubject() == null ? "N/A" : msgHeader.getSubject()%>"></td>
                                                                                                                                    <td class="slips_common_text" ><%=msgPart == null ? "N/A" : msgPart%><input type="hidden" name="hdn_message" id="hdn_message" value="<%=msgBody.getBody() == null ? "N/A" : msgBody.getBody()%>"></td>
                                                                                                                                    <td class="slips_common_text" ><%=msgPriority.getPriorityDesc()%>
                                                                                                                                        <input type="hidden" name="hdn_priority" id="hdn_priority" value="<%=msgPriority.getPriorityDesc()%>"></td>
                                                                                                                                    <td align="center" class="slips_common_text"><%=msgHeader.getRecipientCount()%><input type="hidden" name="hdn_recipientCount" id="hdn_recipientCount" value="<%=msgHeader.getRecipientCount()%>"></td>
                                                                                                                                        <td align="center" class="slips_common_text" ><% if (msgHeader.getAttachmentOriginalName() != null)
                                                                                                                                        {%>  <img src="<%=request.getContextPath()%>/images/attachment_small.png" width="16"
                                                                                                                                             height="20" border="0" align="middle" > <%  }%></td>
                                                                                                                                    <td align="left" class="slips_common_text" ><%=msgHeader.getCreatedBy()%><input type="hidden" name="hdn_createdBy" id="hdn_createdBy" value="<%=msgHeader.getCreatedBy()%>"></td>
                                                                                                                                    <td align="center" class="slips_common_text"><%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%><input type="hidden" name="hdn_createdTime" id="hdn_createdTime" value="<%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%>"></td>
                                                                                                                                    <td align="center" class="slips_tbl_header_text"><input type="hidden" name="msgId" id="msgId" value="<%=msgHeader.getMsgId()%>">
                                                                                                                                        <input type="hidden" name="reqPage" id="reqPage" value="SentMessageSummary.jsp">

                                                                                                                                        <input type="hidden" name="hdnMsgToBranch" id="hdnMsgToBranch" value="<%=msgToBank%>" />
                                                                                                                                        <input type="hidden" name="hdnPriority" id="hdnPriority" value="<%=priority%>" />

                                                                                                                                        <input type="hidden" name="hdnFromDate" id="hdnFromDate" value="<%=fromDate%>" />
                                                                                                                                        <input type="hidden" name="hdnToDate" id="hdnToDate" value="<%=toDate%>" />
                                                                                                                                        <input type="submit" name="btnRemarks" value="View" class="slips_custom_button_small">                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </form>
                                                                                                                            <%}%>
                                                                                                                  </table>
                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                    }
                                                                                                                }
                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="50" align="center" valign="top"></td>
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
                <td height="35" class="slips_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_footter_left">
                        <tr>
                            <td height="35">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_footter_right">
                                    <tr>
                                        <td height="35">
                                            <table width="100%" height="35" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="25"></td>
                                                    <td align="center" class="slips_copyRight">&copy; 2015 LankaClear. All rights reserved.| Contact Us: +94 11 2356900 | info@lankaclear.com</td>
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
