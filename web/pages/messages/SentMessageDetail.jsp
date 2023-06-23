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
<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_batch_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>
<%
    CustomMsg cusMsg = null;
    long lMsgId = 0;
    String msgId = (String) request.getParameter("msgId");
    String reqPage = (String) request.getParameter("reqPage");

    String from = (String) request.getParameter("hdn_from");
    String createdBy = (String) request.getParameter("hdn_createdBy");
    String sentTime = (String) request.getParameter("hdn_createdTime");
    String subject = (String) request.getParameter("hdn_subject");
    String message = (String) request.getParameter("hdn_message");
    String priority = (String) request.getParameter("hdn_priority");

    String hdnMsgToBranch = (String) request.getParameter("hdnMsgToBranch");
    String hdnMsgToCounter = (String) request.getParameter("hdnMsgToCounter");
    String hdnPriority = (String) request.getParameter("hdnPriority");
    String hdnFromDate = (String) request.getParameter("hdnFromDate");
    String hdnToDate = (String) request.getParameter("hdnToDate");

    try
    {
        lMsgId = Long.parseLong(msgId);
    }
    catch (Exception ex)
    {
        System.out.println("WARNING:SentMessageDetail.jsp_invalid_msgId(convert_to_long_failed)--->" + ex.getMessage());
    }

    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_view_sent_msg_details, "| Message ID - " + msgId + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    cusMsg = DAOFactory.getCustomMsgDAO().getSentMassageDetails(lMsgId);
    Collection<CustomMsg> colCustomMsg = DAOFactory.getCustomMsgDAO().getToListAndReadDetails(Long.parseLong(msgId));

%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System </title>
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
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jspdf.debug.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jspdf.min.js"></script> 
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/html2canvas.js"></script> 


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
            else if (type == 3)
            {
                var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
                clock(document.getElementById('showText'), type, val);
            }

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
            }


            function formSubmit()
            {
            var actionPage = document.getElementById('hdnReqPage').value;

            document.frmBack.action = actionPage;
            document.frmBack.submit();

            }

            function downloadFile()
            {
            //var actionPage = document.getElementById('hdnReqPage').value;

            document.frmBack.action = "DownloadAttachment.jsp";
            document.frmBack.submit();
            }

            function doPrint()
            { 
            var disp_setting="toolbar=yes,location=no,directories=no,menubar=no,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 

            var elemId = 'printableArea';
            var content_vlue = document.getElementById(elemId).innerHTML; 

            var docprint = window.open("","",disp_setting); 
            docprint.document.open(); 
            docprint.document.write('<html><head><title>Sent Message Details</title><link href="../../css/ddm.css" rel="stylesheet" type="text/css" />'); 
            //docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../../../js/tableenhance.js" />');
            docprint.document.write('</head><body onLoad="self.print();self.close()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus(); 

            }

            function dwMsgDetailPDF() 
            {

            var disp_setting="toolbar=yes,location=no,directories=no,menubar=no,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 

            var elemId = 'printableArea';
            var content_vlue = document.getElementById(elemId).innerHTML; 

            var docprint = window.open("","",disp_setting); 
            //docprint.document.open(); 
            docprint.document.write('<html><head><title>Message Trail</title><link href="../../css/ddm.css" rel="stylesheet" type="text/css" />'); 
            docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../js/jspdf.debug.js">');
            docprint.document.write('<'+'/'+'script>');
            docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../js/html2canvas.js">');
            docprint.document.write('<'+'/'+'script>');
            docprint.document.write('<script language="javascript" type="text/JavaScript">');
            docprint.document.write('function dwPDF()');
            docprint.document.write('{');
            docprint.document.write('var doc = new jsPDF("p", "mm", "a4"); ');
            docprint.document.write('var options = {pagesplit: true, background: "#ffffff"}; ');
            docprint.document.write('doc.addHTML(document.body,options,function(){doc.save("MessageDetails.pdf");}); ');
            //docprint.document.write('window.open("", "_self", "").close(); ');
            docprint.document.write('}');
            docprint.document.write('<'+'/'+'script>'); 
            docprint.document.write('</head><body onLoad="dwPDF()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus(); 
            //docprint.close();
            //setTimeout(docprint.close(),2000);

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
                                                                                        <td align="left" valign="top" class="slips_header_text">Sent Message Details</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="20" height="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text"></td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">



                                                                                            <form name="frmBack" id="frmBack" method="post">

                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top">


                                                                                                            <%
                                                                                                                if (msgId != null)
                                                                                                                {


                                                                                                            %>



                                                                                                            <table border="0" cellspacing="0" cellpadding="0" class="slips_table_boder" >
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td><div id="printableArea" ><table border="0" cellspacing="1" cellpadding="3"  >
                                              <tr>
                                                                                                                                                <td width="75" align="left" class="slips_tbl_header_text">From  :</td>
                                                                                                                        <td class="slips_tbl_common_text"><%=from%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">To Details :</td>
                                                                                                                                                <td class="slips_tbl_common_text">


                                                                                                                                                    <%
                                                                                                                                                        if (colCustomMsg != null && !colCustomMsg.isEmpty())
                                                                                                                                                        {
                                                                                                                                                    %>

                                                                                                                                                  <table class="slips_table_boder_light" border="0" cellspacing="1" cellpadding="3">

                                                                                                                                                        <%
                                                                                                                                                            for (CustomMsg customMsg : colCustomMsg)
                                                                                                                                                            {
                                                                                                                                                                MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                                                        %>

                                                                                                                                                        <tr>
                                                                                                                                                          <td bgcolor="#FFFFCA" class="slips_common_text"><span class="slips_common_text" title="Recipient"><%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%></span></td>
                                                                                                                                                            <td bgcolor="#F3ECE4" class="slips_common_text"><span class="slips_common_text" title="Message Status"><%=msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes) ? "Read" : "Unread"%></span></td>
                                                                                                                                                            <td bgcolor="#FFFFCA" class="slips_common_text"><span class="slips_common_text" title="Red By"><%=msgBody.getRedBy() != null ? msgBody.getRedBy() : ""%></span></td>
                                                                                                                                                            <td bgcolor="#F3ECE4" class="slips_common_text"><span class="slips_common_text" title="Red Time"><%=msgBody.getRedTime() != null ? msgBody.getRedTime() : ""%></span></td>
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
                                                                                                                                                    No Recipient Records were found!

                                                                                                                                              <%                                                                                                                                                                                                                            }


                                                                                                                                                    %>                                                                                                        </td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Sent Time:</td>
                                                                                                                                                <td class="slips_tbl_common_text"><%=sentTime%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Created By :</td>
                                                                                                                                                <td class="slips_tbl_common_text"><%=createdBy%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Subject :</td>
                                                                                                                                                <td class="slips_tbl_common_text"><%=subject%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Message :</td>
                                                                                                                                                <td class="slips_tbl_common_text" ><%=message != null ? message.replaceAll("\\r\\n|\\r|\\n", "<br>") : "N/A"%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Priority :</td>
                                                                                                                                                <td class="slips_tbl_common_text" ><%=priority%></td>
                                                                                                                                  </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" class="slips_tbl_header_text">Attachment :</td>
                                                                                                                                                <td class="slips_tbl_common_text" >


                                                                                                                                                <% if (cusMsg.getMsgHeader().getAttachmentPath() != null)
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    <input type="hidden" id="hdnFileName" name="hdnFileName" value="<%=cusMsg.getMsgHeader().getAttachmentOriginalName() != null ? cusMsg.getMsgHeader().getAttachmentOriginalName() : ""%>" />
                                                                                                                                                    <input type="hidden" id="hdnFilePath" name="hdnFilePath" value="<%=cusMsg.getMsgHeader().getAttachmentPath() != null ? cusMsg.getMsgHeader().getAttachmentPath() : ""%>" /> 

                                                                                                                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td ><input type="image" name="btnDwnReport" id="btnDwnReport" src="<%=request.getContextPath()%>/images/attachment.png" width="18"
                                                                                                                                                                        height="24" border="0" align="middle" title="Download Attachment" onClick="downloadFile()"></td>
                                                                                                                                                            <td width="5">&nbsp;</td>
                                                                                                                                                            <td class="slips_common_text"><%=cusMsg.getMsgHeader().getAttachmentOriginalName()%></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table>


                                                                                                                                                    <% }
                                                                                                                                                    else
                                                                                                                                                    { %>N/A<% }%>


                                                                                                                                                </td>
                                                                                                                                  </tr>

                                                                                                                                        </table>
                                                                                                                                    </div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="35" colspan="2" align="center" bgcolor="#CECED7" class="slips_tbl_footer_text">
                                                                                                                                    <input type="hidden" name="cmbMsgToBank" id="cmbMsgToBank" value="<%=hdnMsgToBranch%>" />

                                                                                                                                    <input type="hidden" name="cmbPriority" id="cmbPriority" value="<%=hdnPriority%>" />
                                                                                                                                    <input type="hidden" name="txtFromSentDate" id="txtFromSentDate" value="<%=hdnFromDate%>" />
                                                                                                                                    <input type="hidden" name="txtToSentDate" id="txtToSentDate" value="<%=hdnToDate%>" />                                                                                                                                    
                                                                                                                                    <input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="1" />
                                                                                                                                    <input type="hidden" name="hdnReqPage" id="hdnReqPage" value="<%=reqPage%>" />                                                                                                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input name="btnBack" id="btnBack" value="Back" type="button" onClick="formSubmit()"  class="slips_custom_button"/>                                                    </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                            <td width="10"><img name="pdfview" id="pdfview"src="<%=request.getContextPath()%>/images/dwPdf.png" width="22" height="22" title="Download Message Trail as a PDF" onClick="dwMsgDetailPDF()" style="cursor:pointer" /></td>
                                                                                                                                            <td width=10">&nbsp;</td>
                                                                                                                                            <td width="10"><img name="btnPrint" id="btnPrint" src="<%=request.getContextPath()%>/images/printer_large.png" width="24" height="22" title="Print Message Details" onClick="doPrint()" style="cursor:pointer" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>


                                                                                                            <%
                                                                                                            }
                                                                                                            else
                                                                                                            {

                                                                                                            %><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td class="slips_header_small_text">Sorry ! No Records were found. 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center">                              <input type="hidden" name="cmbMsgToBank" id="cmbMsgToBank" value="<%=hdnMsgToBranch%>" />

                                                                                                                        <input type="hidden" name="cmbPriority" id="cmbPriority" value="<%=hdnPriority%>" />
                                                                                                                        <input type="hidden" name="txtFromSentDate" id="txtFromSentDate" value="<%=hdnFromDate%>" />
                                                                                                                        <input type="hidden" name="txtToSentDate" id="txtToSentDate" value="<%=hdnToDate%>" />                                                                                                                        
                                                                                                                        <input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="1" />
                                                                                                                        <input type="hidden" name="hdnReqPage" id="hdnReqPage" value="<%=reqPage%>" /></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="btnBack" id="btnBack" value="Back" type="button" onClick="formSubmit()"  class="slips_custom_button"/>                                                    </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table>

                                                                                                            <%
                                                                                                                }
                                                                                                            %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>

                                                                                            </form>


                                                                                        </td>
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