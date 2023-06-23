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

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Reply_Message' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Add_Bank");
            }
        }
        else
        {


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

    String sMaxMsgLength = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_msg_max_length);
    int iMaxMsgLength = 500;

    String sAttachmentSize = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_msg_max_attachment_size);
    long lMaxAttachmentSize = 5242880; // defalut 5MB

    try
    {
        iMaxMsgLength = Integer.parseInt(sMaxMsgLength);
        lMaxAttachmentSize = Long.parseLong(sAttachmentSize);
    }
    catch (Exception e)
    {
        iMaxMsgLength = 500;
        lMaxAttachmentSize = 5242880;
    }


%>
<%    Collection<MsgPriority> colMsgPriority = null;
    String parentMsgId = null;
    String grandParentMsgId = null;
    String replyTo = null;
    String replyToName = null;
    String replySubject = null;
    //String msgHeaderFromBank = null;

    colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();

    parentMsgId = request.getParameter("hdn_parentMsgId");
    grandParentMsgId = request.getParameter("hdn_grandParentMsgId");
    replyTo = request.getParameter("hdn_replyTo");
    replyToName = request.getParameter("hdn_replyToName");
    replySubject = request.getParameter("hdn_replySubject");

    long lMsgParentId = -1;
    long lMsgGrandParentId = -1;

    try
    {
        lMsgParentId = Long.parseLong(parentMsgId);
        lMsgGrandParentId = Long.parseLong(grandParentMsgId);
    }
    catch (Exception e)
    {
        lMsgParentId = -1;
        lMsgGrandParentId = -1;
    }

    Collection<CustomMsg> colMsgHistory = DAOFactory.getCustomMsgDAO().getMessageHistoryDetails(lMsgGrandParentId, session_bankCode);

    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_init, "|Reply Message Initial, Message Id - " + parentMsgId + ", Reply To - " + replyTo + "(" + replyToName + "), Orginal Message Subject - " + replySubject + " | Visit By - " + session_userName + " (" + session_userTypeDesc + ") |"));

%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Reply Message</title>
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


            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else document.getElementById('hdnSearchReq').value = "0";
            }

            function isInitReq(status) 
            {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";
            }
            }


            function Set_Length(obj)
            {
            if (obj.value.length<= <%=iMaxMsgLength%>)
            {

            document.getElementById('Count').value=(<%=iMaxMsgLength%> - obj.value.length);
            }

            return;
            }

            function Get_Length(obj)
            {
            if (obj.value.length><%=iMaxMsgLength%>) 
            {
            alert("Message Length is Over the Limit. Maximum is " + <%=iMaxMsgLength%> + " Characters.");
            obj.value= obj.value.substring(0,<%=iMaxMsgLength%>);		
            obj.focus();
            }

            return;
            }






            function Save()
            {
            document.getElementById('hdnSelectedRecipients').value = '';
            document.getElementById('hdnSelectedRecipients').value = <%=replyTo%>+'*';
            document.getElementById('hdnSelectedRecipientCount').value=1;

            if (isempty(document.getElementById('txtSubject').value)) 
            {
            alert("Message Subject Can't be Blank.");
            document.getElementById('txtSubject').focus();
            return false;
            }
            if (document.getElementById('cmbPriority').value=='<%=DDM_Constants.status_all%>') 
            {
            alert("Please Select a Priority Level.");
            document.getElementById('.cmbPriority').focus();
            return false;
            }                
            if (isempty(document.getElementById('txaMessage').value)) 
            {
            alert("Message Body Can't be Blank!");
            document.getElementById('txaMessage').focus();
            return false;
            }
            else if(document.getElementById('txaMessage').value.length > <%=iMaxMsgLength%>)
            {
            document.getElementById('txaMessage').value = document.getElementById('txaMessage').value.substring(1,<%=iMaxMsgLength%>);
            alert("Message Length is Over the Limit. Maximum is " + <%=iMaxMsgLength%> + " Characters.");
            document.getElementById('txaMessage').focus();
            return false;                
            }

            if(!isAttachmentSizeOK())
            {
            return false;                
            }

            if(confirm("Are you sure 'You Want To Reply The Message'?"))
            {
            //var messageTxt = document.getElementById('txaMessage').value;
            //document.getElementById('txaMessage').value = messageTxt.replace(/[\r\n]+/g,"<br>");
            document.frmComposeMsg.action="SendMessages.jsp";
            document.frmComposeMsg.submit();
            return true;
            }
            else
            {
            document.getElementById('hdnSelectedRecipients').value = '';
            return false;
            }
            }

            function goBack()
            {
            document.frmComposeMsg.action="../homepage.jsp";
            document.frmComposeMsg.submit();
            }

            function Reset()
            {                
            document.getElementById('txtSubject').value = '';
            document.getElementById('cmbPriority').selectedIndex = 0;
            document.getElementById('txaMessage').value = '';
            document.getElementById('Count').value='<%=iMaxMsgLength%>';
            document.getElementById('attachedFile').value='';    
            }

            function RemoveAttachment()
            {
            if( document.getElementById('attachedFile')!= null && !isempty(document.getElementById('attachedFile').value))
            {
            document.getElementById('attachedFile').value='';
            document.getElementById('attachedFile').focus();
            document.getElementById('btnRemove').disabled=true;
            }				
            }

            function isAttachmentSizeOK() 
            {
            var fileInput =  document.getElementById('attachedFile');
            var maxAttchSize = <%=lMaxAttachmentSize%>;

            if(fileInput!=null&& fileInput.files[0]!=null)
            {
            try
            {
            var valAttachSize = fileInput.files[0].size;            
            //alert("1.Method - " + valAttachSize);  // Size returned in bytes.

            if(valAttachSize > 0)
            {
            document.getElementById('btnRemove').disabled=false;
            }

            if(valAttachSize < maxAttchSize)
            {
            return true;
            }
            else
            {
            alert("Attachment size is over the maximum limit. Your attachment must be less than - " + <%=lMaxAttachmentSize%> + " Bytes.");
            document.getElementById('attachedFile').value='';
            document.getElementById('attachedFile').focus();
            return false;

            }
            }
            catch(e)
            {

            var objFSO = new ActiveXObject("Scripting.FileSystemObject");
            var e = objFSO.getFile(fileInput.value);
            var fileSize = e.size;

            //alert("2.Method - " + fileSize);  

            if(fileSize > 0)
            {
            document.getElementById('btnRemove').disabled=false;
            }

            if(fileSize < maxAttchSize)
            {
            return true;
            }
            else
            {
            alert("Attachment size is over the maximum limit. Your attachment must be less than - " + <%=lMaxAttachmentSize%> + " Bytes.");
            document.getElementById('attachedFile').value='';
            document.getElementById('attachedFile').focus();
            return false;
            }
            }

            }
            else
            {
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


            function loadDefaultMsg()
            {                
            var col2 = document.getElementsByClassName("collapsible");
            var defaultMsg = document.getElementById('hdnDefaultMsg').value;
            col2[defaultMsg-1].click();
            }

            function downloadFile(seqId)
            {
            //var actionPage = document.getElementById('hdnReqPage').value;

            var elemId_hdnFileName = 'hdnFileName_' + seqId;
            var elemId_hdnFilePath = 'hdnFilePath_' + seqId;

            document.getElementById('hdnFileName').value = document.getElementById(elemId_hdnFileName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(elemId_hdnFilePath).value;

            document.frmBack.action = "DownloadAttachment.jsp";
            document.frmBack.submit();
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="slips_body" onLoad="showClock(3);
    loadDefaultMsg()">
        <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" ><table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="slips_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="95" class="slips_header_center"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="slips_header_left">
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
                                                                    </table></td>
                                                            </tr>
                                                        </table></td>
                                                </tr>
                                                <tr>
                                                    <td  height="470" align="center" valign="top" class="slips_bgCommon"><table width="100%" border="0" cellpadding="0" cellspacing="0">
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
                                                                                        <td align="left" valign="top" class="slips_header_text">Reply  Message</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                      <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="slips_header_text">

                                                                                            <table style="min-width:800" border="0" cellpadding="0" cellspacing="0">


                                                                                                <form name="frmComposeMsg" id="frmComposeMsg" method="post" enctype="multipart/form-data">


                                                                                                    <tr>
                                                                                                        <td align="center"><table border="0" cellspacing="0" cellpadding="0" class="slips_table_boder" align="center">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top"><table border="0" cellspacing="1" cellpadding="3" >
                                                              <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text" >To <span class="slips_common_text_white">(Recipient/s)</span> :</td>
                                                                                                <td align="left" valign="middle" class="slips_tbl_common_text">
                                                                                                                                    <%=replyTo%> - <%=replyToName%>
                                                                                                                                    <input type="hidden" name="hdnSelectedRecipients" id="hdnSelectedRecipients" >
                                                                                                                                    <input type="hidden" name="hdnSelectedRecipientCount" id="hdnSelectedRecipientCount" >
                                                                                                                                    <input type="hidden" name="hdnParentMsgId" id="hdnParentMsgId" value="<%=parentMsgId%>" >
                                                                                                                                    <input type="hidden" name="hdnGrandParentMsgId" id="hdnGrandParentMsgId" value="<%=grandParentMsgId%>" >                                                                                                                    </td>
                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text" > Subject : </td>
                                                                                                                              <td align="left" valign="middle" class="slips_tbl_common_text" ><input name="txtSubject" type="text" class="slips_field_border" id="txtSubject" size="80" maxlength="100" value="<%=replySubject%>"/></td>
                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text" >Priority : </td>
                                                                                                                              <td align="left" valign="middle" class="slips_tbl_common_text" ><%

                                                                                                                                    try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbPriority" class="slips_field_border" id="cmbPriority" >
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" >-Select-</option>
                                                                                                                                        <%

                                                                                                                                            if (colMsgPriority != null && !colMsgPriority.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (MsgPriority msgPriority : colMsgPriority)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <option value="<%=msgPriority.getPriorityLevel()%>" ><%=msgPriority.getPriorityDesc()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                        }
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


                                                                                                                                    %>                                                                                                                    </td>
                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text" > Message : </td>
                                                                                                                          <td align="left" valign="middle" class="slips_tbl_common_text" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><textarea cols="80" rows="4" name="txaMessage" id="txaMessage" class="slips_field_border" onKeydown="Get_Length(this.form.txaMessage)" onKeyup="Set_Length(this.form.txaMessage)"></textarea>                                                                                                                                </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td valign="bottom"><span title="Characters Left">
                                                                                                                                                    <input name="Count" type="text" class="slips_field_border" id="Count"  value="<%=iMaxMsgLength%>" maxlength="5" readonly size="1" disabled >
                                                                                                                                                </span></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="slips_tbl_header_text">Attachment :</td>
                                                                                                                      <td align="left" valign="middle"  class="slips_tbl_common_text">
                      <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input name="attachedFile" id="attachedFile" type="file" class="slips_field_border_attachment"  size="75" onChange="isAttachmentSizeOK()"></td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td align="center" valign="middle"><img src="<%=request.getContextPath()%>/images/close.gif" width="10" height="10"name="btnRemove" id="btnRemove" value="Remove"  title="Remove Attachment" onClick="RemoveAttachment()"  class="gradualshine" disabled /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                    </td>
                                                                                                                      </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" colspan="2" class="slips_tbl_footer_text">
                                                                                                      <table border="0" cellpadding="3" cellspacing="1">
                                                                                                                                        <tr>
                                                                                                                                            <td><input name="btnSave" id="btnSave" value="Send" type="button" onClick="Save()"  class="slips_custom_button"/></td>
                                                                                                                                            <td><input name="btnReset" id="btnReset" value="Reset" type="button" onClick="Reset()" class="slips_custom_button"/></td>
                                                                                                                                            <td><input name="btnCancel" id="btnCancel" value="Cancel" type="button" onClick="goBack()"  class="slips_custom_button"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                      </tr>
                                                                                                                        </table></td>
                                                                                                            </table></td>
                                                                                                    </tr>




                                                                                                </form>

                                                                                                <form name="frmBack" id="frmBack" method="post">
                                                                                                    <tr>
                                                                                                        <td height="10"><input type="hidden" name="hdnFileName" id="hdnFileName"  />
                                                                                                            <input type="hidden" name="hdnFilePath" id="hdnFilePath"  /> </td>
                                                                                                    </tr>
                                                                                                </form>

                                                                                                <tr>
                                                                                                    <td align="center"> <!-- loop start -->

                                                                                                        <%
                                                                                                            if (colMsgHistory != null && colMsgHistory.size() > 0)
                                                                                                            {
                                                                                                                int i = 0;
                                                                                                                String msgPart = null;
                                                                                                                for (CustomMsg customMsg : colMsgHistory)
                                                                                                                {

                                                                                                                    if (customMsg != null)
                                                                                                                    {
                                                                                                                        boolean isOkTOLoad = false;

                                                                                                                        //System.out.println("customMsg.getMsgBody().getMsgToBank() ---> " + customMsg.getMsgBody().getMsgToBank());
                                                                                                                        if (!(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_bank_user)))
                                                                                                                        {
                                                                                                                            if (customMsg.getMsgHeader().getMsgFromBank().equals(DDM_Constants.default_bank_code))
                                                                                                                            {
                                                                                                                                //System.out.println("inside (customMsg.getMsgHeader().getMsgFromBank().equals(DDM_Constants.default_bank_code)) ---> ");

                                                                                                                                if (customMsg.getMsgBody().getMsgToBank().equals(replyTo))
                                                                                                                                {
                                                                                                                                    //System.out.println("inside (customMsg.getMsgBody().getMsgToBank().equals(replyTo)) ---> ");
                                                                                                                                    isOkTOLoad = true;
                                                                                                                                }
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                if (customMsg.getMsgBody().getMsgToBank().equals(DDM_Constants.default_bank_code))
                                                                                                                                {
                                                                                                                                    if (customMsg.getMsgHeader().getMsgFromBank().equals(replyTo))
                                                                                                                                    {
                                                                                                                                        isOkTOLoad = true;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            isOkTOLoad = true;
                                                                                                                        }

                                                                                                                        System.out.println("isOkTOLoad ---> " + isOkTOLoad);

                                                                                                                        if (isOkTOLoad == true)
                                                                                                                        {

                                                                                                                            i++;

                                                                                                                            MsgHeader msgHeader = customMsg.getMsgHeader();
                                                                                                                            MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                            MsgPriority msgPriority = customMsg.getMsgPriority();


                                                                                                        %>

                                                                                                        <button class="collapsible">


                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td width="30" align="center" nowrap class="slips_msg_from"> <% if (msgHeader.getMsgId() == lMsgParentId)
                                                                                                                        {%><img src="<%=request.getContextPath()%>/images/reply.png" name="imgReply" id="imgReply" width="25" height="20" title="You are replying to this message." ><%  }
                                                                                                                        else
                                                                                                                        {%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                                                        <%}%></td>
                                                                                                                    <td width="250" nowrap class="slips_msg_from" ><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td align="left" class="slips_msg_subject"><%=msgHeader.getSubject()%></td>
                                                                                                                    <td width="5" >&nbsp;</td>
                                                                                                                    <td width="120" align="left" nowrap class="slips_common_text"><%=msgHeader.getCreatedTime()%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </button>

                                                                                                        <div class="content">


                                                                                                            <table border="0" cellspacing="0" cellpadding="0" >
                                                                                                                <tr>
                                                                                                                    <td>


                                                                                                                        <table border="0" cellspacing="0" cellpadding="0" class="slips_table_boder" >
                                                                                                                            <tr>
                                                                                                                                <td>








                                                                                                                                    <table border="0" cellspacing="1" cellpadding="5" style="min-width:800">
                                                                                                          <tr>
                                                                                                                                            <td width="75" align="left" class="slips_tbl_header_text">From  :</td>
                                                                                                                                    <td class="slips_tbl_common_text"><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">To  :</td>
                                                                                                                                            <td class="slips_tbl_common_text"><%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Sent Time:</td>
                                                                                                                                            <td class="slips_tbl_common_text"><%=msgHeader.getCreatedTime()%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Created By :</td>
                                                                                                                                            <td class="slips_tbl_common_text"><%=msgHeader.getCreatedBy()%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Subject :</td>
                                                                                                                                            <td class="slips_tbl_common_text"><%=msgHeader.getSubject()%>
                                                                                                                                                <input type="hidden" name="hdnDefaultMsg" id="hdnDefaultMsg" value="<%=i%>" />
                                                                                                                                                <%
                                                                                                                                                    if (msgHeader.getMsgId() == lMsgParentId)
                                                                                                                                                    {
                                                                                                                                                %>
                                                                                                                                          <%
                                                                                                                                                    }
                                                                                                                                                %></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Message :</td>
                                                                                                                                            <td class="slips_tbl_common_text" ><%=msgBody.getBody() != null ? msgBody.getBody().replaceAll("\\r\\n|\\r|\\n", "<br>") : "N/A"%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Priority :</td>
                                                                                                                                            <td class="slips_tbl_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                                      </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" class="slips_tbl_header_text">Attachment : </td>
                                                                                                                                          <td class="slips_tbl_common_text" ><% if (msgHeader.getAttachmentPath() != null)
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <input type="hidden" id="hdnFileName_<%=i%>" name="hdnFileName_<%=i%>" value="<%=msgHeader.getAttachmentOriginalName() != null ? msgHeader.getAttachmentOriginalName() : ""%>" />
                                                                                                                                                <input type="hidden" id="hdnFilePath_<%=i%>" name="hdnFilePath_<%=i%>" value="<%=msgHeader.getAttachmentPath() != null ? msgHeader.getAttachmentPath() : ""%>" /> 

                                                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td ><input type="image" name="btnDwnReport" id="btnDwnReport" src="<%=request.getContextPath()%>/images/attachment.png" width="18"
                                                                                                                                                                    height="24" border="0" align="middle" title="Download Attachment" onClick="downloadFile(<%=i%>)"></td>
                                                                                                                                                        <td width="5">&nbsp;</td>
                                                                                                                                                        <td class="slips_common_text"><%=msgHeader.getAttachmentOriginalName()%></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>


                                                                                                                                                <% }
                                                                                                                                      else
                                                                                                                                      { %>N/A<% }%>                                                                                                                              </td>
                                                                                                                                      </tr>
                                                                                                                                    </table>                                                                                                                  </td>
                                                                                                                            </tr>
                                                                                                                        </table>                                                                                                            </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td height="5"></td>
                                                                                                                </tr>
                                                                                                            </table>


                                                                                                        </div> 

                                                                                                        <%
                                                                                                            }
                                                                                                        %>


                                                                                                        <%
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                        %>

                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="slips_header_small_text">Sorry ! No Records were found.                                                                                                                    </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center">&nbsp;</td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                        <tr>
                                                                                                                            <td><input name="btnBack" id="btnBack" value="Back" type="button" onClick="formSubmit(<%=i%>)"  class="slips_custom_button"/>                                                    </td>
                                                                                                                        </tr>
                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                        </table>



                                                                                                        <%
                                                                                                            }

                                                                                                        %>

                                                                                                        <%    }

                                                                                                            }
                                                                                                        %>

                                                                                                        <script>
                                                                                                            var coll = document.getElementsByClassName("collapsible");
                                                                                                            var i;

                                                                                                            for (i = 0; i < coll.length; i++) {
                                                                                                                coll[i].addEventListener("click", function () {
                                                                                                                    this.classList.toggle("active");
                                                                                                                    var content = this.nextElementSibling;
                                                                                                                    if (content.style.maxHeight) {
                                                                                                                        content.style.maxHeight = null;
                                                                                                                    } else {
                                                                                                                        content.style.maxHeight = content.scrollHeight + "px";
                                                                                                                    }
                                                                                                                });
                                                                                                            }
                                                                                                        </script>





                                                                                                        <!-- loop end --></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="50" align="center" valign="top"></td>
                                                            </tr>
                                                        </table></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
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
