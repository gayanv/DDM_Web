<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp" %>
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
        session_bankCode = (String) session.getAttribute("session_bankcode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

%>
<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>
<%
    //String msgFrom = null;
    String msgFromBank = null;
    String msgFromCounter = null;
    String priority = null;
    String readStatus = null;
    String fromDate = null;
    String toDate = null;

    String isInitReq = null;
    String isSearchReq = null;

    Collection<MsgPriority> colMsgPriority = null;
    Collection<Recipient> colMsgFromBank = null;
    Collection<Recipient> colMsgFromCounter = null;
    Collection<CustomMsg> colMsg = null;

    //isInitReq = (String) request.getParameter("hdnInitReq");
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();
    //colMsgFrom = DAOFactory.getBranchDAO().getBranch(bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
    //colMsgFrom = DAOFactory.getCustomMsgDAO().getAvailableRecipientList(userType, bankCode, branchId, counterCode);
    colMsgFromBank = DAOFactory.getCustomMsgDAO().getAvailableFullRecipientList(session_userType, session_bankCode);

    if (isSearchReq == null)
    {
        isSearchReq = "0";
        msgFromBank = DDM_Constants.status_all;
        priority = DDM_Constants.status_all;
        readStatus = DDM_Constants.status_all;
        fromDate = currentDate;
        toDate = currentDate;
        
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_search_inbox, "| Initail visit. | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {

        msgFromBank = (String) request.getParameter("cmbMsgFromBank");
        priority = (String) request.getParameter("cmbPriority");
        readStatus = (String) request.getParameter("cmbReadStatus");
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
            
            
            colMsg = DAOFactory.getCustomMsgDAO().getMessageList(msgFromBank, session_bankCode, priority, readStatus, fromDate, toDate);

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_search_inbox, "| From  - " + msgFromBank + ", Priority - " + priority + ", Read Status - " + readStatus + ", From Date - " + fromDate + ", To Date - " + toDate + "| Result Count - " + colMsg.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            
        }
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System </title>
        <link href="<%=request.getContextPath()%>/css/icps.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/icps.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>


        <script language="javascript" type="text/JavaScript">

            function doSubmit()
            {				
            if(validate())
            {
            document.frmMessageSummary.submit();
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
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=window != null ? window.getOW_cutontimeHour() : null%>, <%=window != null ? window.getOW_cutontimeMinutes() : null%>, <%=window != null ? window.getOW_cutofftimeHour() : null%>, <%=window != null ? window.getOW_cutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=window != null ? window.getIW_cutontimeHour() : null%>, <%=window != null ? window.getIW_cutontimeMinutes() : null%>, <%=window != null ? window.getIW_cutofftimeHour() : null%>, <%=window != null ? window.getIW_cutofftimeMinutes() : null%>);
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
        <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="slips_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="95" class="slips_header_center">

                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_header_left">
                                                            <tr>
                                                                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_header_right">
                                                                        <tr>
                                                                            <td><table height="95" width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td height="68"><table width="980" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="22"><table width="100%" height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                    <td valign="middle">

                                                                                                        <div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** UITS ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=session_menuName%>" vqp_uid0=<%=session_menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                                                                cdd__codebase<%=session_menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=session_menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=session_menuId%>" language="JavaScript">create_menu(<%=session_menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="middle"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="slips_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="slips_menubar_text"><b><%=session_userName%></b> - <%=session_bankName%></td>
                                                                                                                <td width="15">&nbsp;</td>
                                                                                                                <td valign="bottom"><a href="<%=request.getContextPath()%>/pages/user/userProfile.jsp" title=" My Profile "><img src="<%=request.getContextPath()%>/images/user.gif" width="18"
                                                                                                                                                                                                        height="22" border="0" align="middle" ></a></td>
                                                                                                                <td width="10"></td>
                                                                                                                <td class="slips_menubar_text">[ <a href="<%=request.getContextPath()%>/pages/logout.jsp" class="slips_sub_link"><u>Logout</u></a> ]</td>
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
                                                    <td  height="470" align="center" valign="top" class="slips_bgCommon">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                                                            <td width="15"></td>
                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td valign="top" nowrap class="slips_menubar_text">Business Date : <%=webBusinessDate%></td>
                                                                            <td width="10" valign="middle"></td>
                                                                            <td valign="top" nowrap class="slips_menubar_text">|&nbsp; Now : [ <%=currentDate%></td>
                                                                            <td width="5" valign="middle">&nbsp;</td>
                                                                            <td valign="top" class="slips_menubar_text"><div id="showText" class="slips_menubar_text"></div></td>
                                                                            <td width="5" valign="top" nowrap class="slips_menubar_text">&nbsp;]</td>

                                                                            <td width="10" valign="middle"></td>
                                                                            <%
                                                                                String owWindowStartTime = windowOW.getCutontime() != null ? windowOW.getCutontime().substring(0, 2) + ":" + windowOW.getCutontime().substring(2) : "00:00";
                                                                                String owWindowEndTime = windowOW.getCutofftime() != null ? windowOW.getCutofftime().substring(0, 2) + ":" + windowOW.getCutofftime().substring(2) : "00:00";

                                                                                String iwWindowStartTime = windowIW.getCutontime() != null ? windowIW.getCutontime().substring(0, 2) + ":" + windowIW.getCutontime().substring(2) : "00:00";
                                                                                String iwWindowEndTime = windowIW.getCutofftime() != null ? windowIW.getCutofftime().substring(0, 2) + ":" + windowIW.getCutofftime().substring(2) : "00:00";

                                                                                String orWindowStartTime = windowOR.getCutontime() != null ? windowOR.getCutontime().substring(0, 2) + ":" + windowOR.getCutontime().substring(2) : "00:00";
                                                                                String orWindowEndTime = windowOR.getCutofftime() != null ? windowOR.getCutofftime().substring(0, 2) + ":" + windowOR.getCutofftime().substring(2) : "00:00";

                                                                                String irWindowStartTime = windowIR.getCutontime() != null ? windowIR.getCutontime().substring(0, 2) + ":" + windowIR.getCutontime().substring(2) : "00:00";
                                                                                String irWindowEndTime = windowIR.getCutofftime() != null ? windowIR.getCutofftime().substring(0, 2) + ":" + windowIR.getCutofftime().substring(2) : "00:00";

                                                                            %>

                                                                            <td valign="top" nowrap class="slips_menubar_text">| &nbsp; Window :</td>
                                                                            <td width="5" valign="middle"></td>

                                                                            <td valign="top" nowrap class="slips_menubar_text"><table border="0" cellspacing="0">
                                                                                    <tr height="12">
                                                                                        <td valign="middle" nowrap class="slips_menubar_text">[</td>
                                                                                      <td valign="middle" nowrap class="slips_menubar_text"><span class="slips_menubar_text_small" title="Outward (OWNM) Window Start and End Time">OW (<%=owWindowStartTime%>-<%=owWindowEndTime%>)</span></td>
                                                                                        <td width="3" valign="middle"></td>
                                                                                        <td valign="middle"><div id="actWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward (OWNM) Window is active!" ></div>
                                                                                            <div id="expWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward (OWNM) Window is expired!" ></div></td>
                                                                                        <td valign="middle" nowrap class="slips_menubar_text">| <span class="slips_menubar_text_small" title="Inward (IWNM) Window Start and End Time">IW (<%=iwWindowStartTime%>-<%=iwWindowEndTime%>)</span>                                                                                          </td>
                                                                                        <td width="3" valign="middle"></td>
                                                                                        <td valign="middle" class="slips_menubar_text"><div id="actWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (IWNM) Window is active!" ></div>
                                                                                            <div id="expWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward (IWNM) Window is expired!" ></div></td>
                                                                                        <td valign="middle" class="slips_menubar_text">]&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr height="12">
                                                                                        <td valign="middle" nowrap class="slips_menubar_text">[</td>
                                                                                        <td valign="middle" nowrap class="slips_menubar_text"><span class="slips_menubar_text_small" title="Outward-Return (ORNM) Window Start and End Time">OR&nbsp;&nbsp;(<%=orWindowStartTime%>-<%=orWindowEndTime%>)</span></td>
                                                                                        <td width="3" valign="middle"></td>
                                                                                        <td valign="middle"><div id="actWindowOR" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward-Return (ONRM) Window is active!" ></div>
                                                                                            <div id="expWindowOR" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward-Return (ONRM) Window is expired!" ></div></td>
                                                                                        <td valign="middle" nowrap class="slips_menubar_text">| <span class="slips_menubar_text_small" title="Inward-Return (INRM) Window Start and End Time">IR&nbsp;&nbsp;(<%=irWindowStartTime%>-<%=irWindowEndTime%>)</span>                                                                                          </td>
                                                                                        <td width="3" valign="middle"></td>
                                                                                        <td valign="middle" class="slips_menubar_text"><div id="actWindowIR" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (INRM) Window is active!" ></div>
                                                                                            <div id="expWindowIR" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward-Return (INRM) Window is expired!" ></div></td>
                                                                                        <td valign="middle" class="slips_menubar_text">]</td>
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
                                                                                        <td align="left" valign="top" class="slips_header_text">Inbox -  Message Summary</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text"><form id="frmMessageSummary" name="frmMessageSummary" method="post" action="MessageSummary.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="slips_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <input type="hidden" name="hdnInitReq" id="hdnInitReq" value="<%=isInitReq%>" />
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="slips_tbl_header_text">From :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="slips_tbl_header_text"><%

                                                                                                                                    try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbMsgFromBank" class="slips_field_border" id="cmbMsgFromBank" onChange="isSearchRequest(false);
                                                                                                                                                    doSubmit();" >
                                                                                                                                        <%                                                                                                                    if (msgFromBank == null || msgFromBank.equals(DDM_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">- All Banks -</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">- All Banks -</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colMsgFromBank != null && colMsgFromBank.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Recipient branchSender : colMsgFromBank)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=branchSender.getRecipientCode()%>" <%=(msgFromBank != null && branchSender.getRecipientCode().equals(msgFromBank)) ? "selected" : ""%>   ><%=branchSender.getRecipientCode()%> - <%=branchSender.getRecipientName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="slips_error">No From Bank details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>



                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="slips_tbl_header_text">Priority :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="slips_tbl_header_text"><%                                                                                                          try
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
                                                                                                                                    <%                                                                    }
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


                                                                                                                                    %></td>


                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="slips_tbl_header_text">Read Status  :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="slips_tbl_header_text"><select name="cmbReadStatus" id="cmbReadStatus" class="slips_field_border" onChange="clearResultData()">
                                                                                                                                        <%                                                                                                                    if (readStatus == null)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=readStatus != null && readStatus.equals(DDM_Constants.status_all) ? "selected" : ""%> >-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.msg_isred_no%>" <%=readStatus != null && readStatus.equals(DDM_Constants.msg_isred_no) ? "selected" : ""%>>Unread</option>
                                                                                                                                        <option value="<%=DDM_Constants.msg_isred_yes%>" <%=readStatus != null && readStatus.equals(DDM_Constants.msg_isred_yes) ? "selected" : ""%>>Read</option>
                                                                                                                                    </select></td>

                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="slips_tbl_header_text">Sent Date :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="slips_tbl_header_text"><table border="0" cellspacing="0" cellpadding="0">
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
                                                                                                                                    </table>                                                                                                        </td>


                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CECED7" class="slips_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center"><div id="clickSearch" class="slips_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    doSubmit();"  class="slips_custom_button"/></td>
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
                                                                                                                if (isSearchReq.equals("1") && colMsg.size() == 0)
                                                                                                                {%>
                                                                                                            <tr>
                                                                                                                <td class="slips_header_text" align="center"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="slips_tbl_header_text">No Records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%                                                                                    }
                                                                                                            else if (isSearchReq.equals("1") && !colMsg.isEmpty())
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td class="slips_header_text" align="center"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="slips_table_boder" bgcolor="#FFFFFF">
                                                                                                                            <tr>
                                                                                                                                <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text" >From</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text">Subject</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text" >Message</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text" >Priority</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text">Status</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text">Attachment</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text">Created Time</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="slips_tbl_header_text">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                int rowNum = 0;
                                                                                                                                String msgSubjectPart = null;
                                                                                                                                String msgPart = null;

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

                                                                                                                            %>
                                                                                                                            <form name="frmMsgDetails" id="frmMsgDetails" action="MessageDetail.jsp" method="post">
                                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                    <td align="right" class="slips_common_text"><%=rowNum%>.</td>
                                                                                                                                    <td align="left" class="slips_msg_from" ><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                                    <td align="left" class="slips_msg_subject"><%=msgSubjectPart %></td>
                                                                                                                                    <td align="left" class="slips_common_text" ><%=msgPart %></td>
                                                                                                                                    <td align="center" class="slips_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                                    <td align="center" class="slips_common_text">
																																	
																																	<% 
																																	if(msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes))
																																	{ %>
                                                                                                                                    
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/read_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="You have already read this message!" >
                                                                                                                                    
                                                                                                                                    <%
																																	} 
																																	else 
																																	{
																																	%>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/unread_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="Unread Message" >
                                                                                                                                    <%
																																	}
																																	%>
                                                                                                                                    </td>
                                                                                                                                    <td align="center" class="slips_header_text" >
                                                                                                                                        <% if (msgHeader.getAttachmentOriginalName() != null)
                                                                                                                                            {%>  <img src="<%=request.getContextPath()%>/images/attachment_small.png" width="16"
                                                                                                                                             height="20" border="0" align="middle" > <%  }%>

                                                                                                                                    </td>
                                                                                                                                    <td align="center" class="slips_common_text"><%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%></td>
                                                                                                                                    <td align="center" class="slips_tbl_header_text">
                                                                                                                                        <input type="hidden" name="msgId" id="msgId" value="<%=msgHeader.getMsgId()%>">
                                                                                                                                        <input type="hidden" name="msgHeaderFromBank" id="msgHeaderFromBank" value="<%=msgHeader.getMsgFromBank()%>">
                                                                                                                                        
                                                                                                                                        <input type="hidden" name="msgParentId" id="msgParentId" value="<%=msgHeader.getMsgParentId()%>">
                                                                                                                                        <input type="hidden" name="msgGrandParentId" id="msgGrandParentId" value="<%=msgHeader.getMsgGrandParentId()%>">
                                                                                                                                        <input type="hidden" name="reqPage" id="reqPage" value="MessageSummary.jsp">
                                                                                                                                        <input type="hidden" name="isAlreadyRed" id="isAlreadyRed" value="<%=msgBody.getIsRed()%>">
                                                                                                                                        <input type="hidden" name="hdnMsgFromBank" id="hdnMsgFromBank" value="<%=msgFromBank%>" />   
                                                                                                                                        <input type="hidden" name="hdnPriority" id="hdnPriority" value="<%=priority%>" />
                                                                                                                                        <input type="hidden" name="hdnReadStatus" id="hdnReadStatus" value="<%=readStatus%>" />
                                                                                                                                        <input type="hidden" name="hdnFromDate" id="hdnFromDate" value="<%=fromDate%>" />
                                                                                                                                        <input type="hidden" name="hdnToDate" id="hdnToDate" value="<%=toDate%>" />
                                                                                                                                        <input type="submit" name="btnView" id="btnView" value="View" class="slips_custom_button_small">                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </form>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%
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
%>
