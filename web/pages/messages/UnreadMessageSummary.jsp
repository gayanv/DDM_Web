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
<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_web_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
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
    Collection<CustomMsg> colUnreadMsg = null;
    colUnreadMsg = DAOFactory.getCustomMsgDAO().getMessageList(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.msg_isred_no, DDM_Constants.status_all, DDM_Constants.status_all);

    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_view_new_msg_summary, "| New Message Summary | Result Count - " + colUnreadMsg.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

%>

<html>
    <head>        
        <title>LankaPay Direct Debit Mandate Exchange System - Message Inbox</title>
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

        <script>
            function Back()
            {
                document.BroadcastMessageList.action = "ComposeMessage.jsp"
                document.BroadcastMessageList.submit();
            }

            function showClock(type)
            {
                if (type == 1)
                {
                    clock(document.getElementById('showText'), type, null);
                }
                else if (type == 2)
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'), type, val);
                }
                else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=windowOW != null ? windowOW.getCutontimeHour() : null%>, <%=windowOW != null ? windowOW.getCutontimeMinutes() : null%>, <%=windowOW != null ? windowOW.getCutofftimeHour() : null%>, <%=windowOW != null ? windowOW.getCutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=windowIW != null ? windowIW.getCutontimeHour() : null%>, <%=windowIW != null ? windowIW.getCutontimeMinutes() : null%>, <%=windowIW != null ? windowIW.getCutofftimeHour() : null%>, <%=windowIW != null ? windowIW.getCutofftimeMinutes() : null%>, document.getElementById('actWindowOR'), document.getElementById('expWindowOR'), <%=windowOR != null ? windowOR.getCutontimeHour() : null%>, <%=windowOR != null ? windowOR.getCutontimeMinutes() : null%>, <%=windowOR != null ? windowOR.getCutofftimeHour() : null%>, <%=windowOR != null ? windowOR.getCutofftimeMinutes() : null%>, document.getElementById('actWindowIR'), document.getElementById('expWindowIR'), <%=windowIR != null ? windowIR.getCutontimeHour() : null%>, <%=windowIR != null ? windowIR.getCutontimeMinutes() : null%>, <%=windowIR != null ? windowIR.getCutofftimeHour() : null%>, <%=windowIR != null ? windowIR.getCutofftimeMinutes() : null%>);
                    clock(document.getElementById('showText'), type, val);
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
                                                                                        <td align="left" valign="top" class="slips_header_text">Inbox - Unread Message(s)</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="slips_header_text">



                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <%
                                                                                                    if (colUnreadMsg.isEmpty())
                                                                                                    {%>

                                                                                                <tr>
                                                                                                    <td class="slips_header_text" align="center"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center"><div id="noresultbanner" class="slips_header_small_text">No Records Available !</div></td>
                                                                                                </tr>
                                                                                                <%   }
                                                                                                else
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
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small" >From</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small">Subject</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small" >Message</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small" >Priority</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small">Status</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small">Attachment</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small">Created Time</td>
                                                                                                    <td align="center" class="slips_tbl_header_text_horizontal_small">&nbsp;</td>
                                                                                                              </tr>
                                                                                                                <%
                                                                                                                    int rowNum = 0;
                                                                                                                    String msgPart = null;
                                                                                                                    String msgSubjectPart = null;

                                                                                                                    for (CustomMsg customMsg : colUnreadMsg)
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

                                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">

                                                                                                                        <td align="right" class="slips_common_text"><%=rowNum%>.</td>
                                                                                                                        <td align="left" bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" class="slips_msg_from" ><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                        <td align="left" class="slips_msg_subject"><%=msgSubjectPart %></td>
                                                                                                                        <td align="left" class="slips_common_text" ><%=msgPart%></td>
                                                                                                                        <td align="center" class="slips_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                        <td align="center" class="slips_common_text">

                                                                                                                            <%
                                                                                                                                                                                                                                                                            if (msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes))
                                                                                                                                                                                                                                                                            {%>

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
                                                                                                                            %>                                                                                                                                    </td>
                                                                                                                        <td align="center" class="slips_header_text" >
                                                                                                                            <% if (msgHeader.getAttachmentOriginalName() != null)
                                                                                                                                            {%>  <img src="<%=request.getContextPath()%>/images/attachment_small.png" width="16"
                                                                                                                                 height="20" border="0" align="middle" > <%  }%>                                                                                                                                    </td>
                                                                                                                        <td align="center" class="slips_common_text"><%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%></td>
                                                                                                                        <td align="center" class="slips_tbl_header_text">


                                                                                                                            <input type="hidden" name="msgId" id="msgId" value="<%=msgHeader.getMsgId()%>">
                                                                                                                            <input type="hidden" name="msgHeaderFromBank" id="msgHeaderFromBank" value="<%=msgHeader.getMsgFromBank()%>">

                                                                                                                            <input type="hidden" name="msgParentId" id="msgParentId" value="<%=msgHeader.getMsgParentId()%>">
                                                                                                                            <input type="hidden" name="msgGrandParentId" id="msgGrandParentId" value="<%=msgHeader.getMsgGrandParentId()%>">
                                                                                                                            <input type="hidden" name="reqPage" id="reqPage" value="UnreadMessageSummary.jsp">
                                                                                                                            <input type="hidden" name="isAlreadyRed" id="isAlreadyRed" value="<%=msgBody.getIsRed()%>">
                                                                                                                            <input type="submit" name="btnRemarks" value="View" class="slips_custom_button_small">                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </form>


                                                                                                                <%}%>
                                                                                                      </table>
                                                                                                        </div></td>
                                                                                                </tr>
                                                                                                <%
                                                                                                    }
                                                                                                %>
                                                                                            </table>











                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>

                                                                                        <td align="center" valign="top">&nbsp;</td>


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

