<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.message.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.header.MsgHeader" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.body.MsgBody" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.message.priority.MsgPriority" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.services.utils.*" errorPage="../../error.jsp"%>
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Add Bank' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
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
<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>
<%
    String strSubject = null;
    String strPriority = null;
    String strMessage = null;
    String strRecipient = null;
    String strRecipientCount = null;
    String strParentMsgId = null;
    String strGrandParentMsgId = null;
    String attachmentName = null;
    String fileExtension = null;
    String newFileName = null;
    String newFileFullPath = null;
    String msg = null;
    long newMsgId = 0;
    long parentMsgId = 0;
    long grandParentMsgId = 0;
    long initialfileSize = 0;
    boolean attachmentUploadStatus = false;

    Collection<CustomMsgTo> colMsgTo = null;
    Collection<CustomMsg> successList = null;
    Collection<CustomMsg> unsuccesList = null;
    int iRecipientCount = 0;
    boolean isAllSuccess = false;

    //strSubject = (String) request.getParameter("txtSubject");
    //strPriority = (String) request.getParameter("cmbPriority");
    //strMessage = (String) request.getParameter("txaMessage");
    //strRecipient = (String) request.getParameter("hdnSelectedRecipients");
    //strRecipientCount = (String) request.getParameter("hdnSelectedRecipientCount"); 
    String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
    //System.out.println("businessDate--->" + businessDate);

    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    //System.out.println("businessDate 1 --->" + businessDate);
    if (!isMultipart)
    {
        System.out.println("Not Multipart");
    }
    else
    {
        //System.out.println("businessDate 2 --->" + businessDate);

        try
        {
            //System.out.println("newFileFullPath ------> " + newFileFullPath);

            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List items = null;
            items = upload.parseRequest(request);

            Iterator itr = items.iterator();
            

            while (itr.hasNext())
            {
                FileItem item = (FileItem) itr.next();
                initialfileSize = item.getSize();

                if (item.isFormField())
                {
                    if (item.getFieldName().equals("txtSubject"))
                    {
                        strSubject = item.getString();
                    }

                    if (item.getFieldName().equals("cmbPriority"))
                    {
                        strPriority = item.getString();
                    }

                    if (item.getFieldName().equals("txaMessage"))
                    {
                        strMessage = item.getString();
                    }

                    if (item.getFieldName().equals("hdnSelectedRecipients"))
                    {
                        strRecipient = item.getString();
                    }

                    if (item.getFieldName().equals("hdnSelectedRecipientCount"))
                    {
                        strRecipientCount = item.getString();
                    }

                    if (item.getFieldName().equals("hdnParentMsgId"))
                    {
                        strParentMsgId = item.getString();

                        try
                        {
                            parentMsgId = Long.parseLong(strParentMsgId);
                        }
                        catch (Exception e)
                        {
                            parentMsgId = 0;
                        }
                    }

                    if (item.getFieldName().equals("hdnGrandParentMsgId"))
                    {
                        strGrandParentMsgId = item.getString();

                        try
                        {
                            grandParentMsgId = Long.parseLong(strGrandParentMsgId);
                        }
                        catch (Exception e)
                        {
                            grandParentMsgId = 0;
                        }
                    }

                }
                else
                {
                    String itemName = item.getName();

                    if (itemName != null && itemName.length() > 0)
                    {

                        int pos = itemName.lastIndexOf(DDM_Constants.directory_separator_windows);
                        attachmentName = itemName.substring(pos + 1);

                        fileExtension = attachmentName.substring(attachmentName.indexOf("."));

                        //System.out.println("file uploading path ------> " + config.getServletContext().getRealPath(ICPS_Constants.directory_onrm_uploaded_files));
                        String newONRMAdditionalNillDirectory = PropertyLoader.getInstance().getMessageAttachmentFilePath() + DDM_Constants.directory_separator + businessDate;
                        System.out.println("file uploading path ------> " + newONRMAdditionalNillDirectory);

                        File fileONRMAdditionalNillDirectory = new File(newONRMAdditionalNillDirectory);

                        if (!fileONRMAdditionalNillDirectory.exists())
                        {
                            fileONRMAdditionalNillDirectory.mkdirs();
                        }

                        newMsgId = DAOFactory.getCustomMsgDAO().getNewMsgId();

                        newFileName = "MsgAttachment_" + newMsgId + fileExtension;

                        newFileFullPath = newONRMAdditionalNillDirectory + DDM_Constants.directory_separator + newFileName;

                        System.out.println("newFileFullPath ------> " + newFileFullPath);
                        File savedFile = new File(newFileFullPath);

                        if (savedFile.exists())
                        {
                            savedFile.delete();
                            item.write(savedFile);
                        }
                        else
                        {
                            item.write(savedFile);
                        }

                        if (savedFile.exists() && savedFile.canRead() && initialfileSize == savedFile.length())
                        {

                            attachmentUploadStatus = true;

                        }
                        else
                        {
                            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
                            attachmentUploadStatus = false;
                        }

                    }

                }
            }
        }
        catch (Exception e)
        {
            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
            attachmentUploadStatus = false;
            System.out.println(e.getMessage());
        }

    }

    StringTokenizer st = new StringTokenizer(strRecipient, "*");

    if (st.countTokens() > 0)
    {
        colMsgTo = new java.util.ArrayList();

        while (st.hasMoreElements())
        {
            String msgTo = st.nextToken();
            System.out.println("msgTo =====> " + msgTo);

            if (msgTo != null && msgTo.length() == 4)
            {
                CustomMsgTo objMsgTo = new CustomMsgTo();
                objMsgTo.setMsgTo(msgTo);
                colMsgTo.add(objMsgTo);
                iRecipientCount++;
            }
        }
    }

    String strRecipints = "";

    for (CustomMsgTo cMsgTo : colMsgTo)
    {
        if (cMsgTo.getMsgTo() != null)
        {
            strRecipints += ", " + cMsgTo.getMsgTo();
        }
    }
    
    strRecipints = strRecipints.replaceFirst(", ", "");

    System.out.println("strRecipientCount ===> " + strRecipientCount + " and iRecipientCount ====> " + iRecipientCount);

    if (iRecipientCount == Integer.parseInt(strRecipientCount))
    {
        System.out.println("inside iRecipientCount == Integer.parseInt(strRecipientCount)");
        System.out.println("attachmentName---->" + attachmentName);

        if (attachmentName != null && attachmentName.length() > 0)
        {
            if (attachmentUploadStatus)
            {
                CustomMsgDAO customDAO = DAOFactory.getCustomMsgDAO();

                if ((parentMsgId > 0) && (grandParentMsgId > 0))
                {
                    if (customDAO.setMessagePerentDetails(newMsgId, parentMsgId, grandParentMsgId, session_bankCode, colMsgTo, strSubject, strMessage.trim(), strPriority, newFileName, attachmentName, newFileFullPath, session_userName))
                    {
                        System.out.println("Messages sent successesfuly!");
                        successList = customDAO.getSetMessagesList_Success();

                        if (successList.size() == Integer.parseInt(strRecipientCount))
                        {
                            isAllSuccess = true;
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", Reply To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Reply Status - Success | Reply By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                        }
                    }
                    else
                    {
                        System.out.println("Messages sending is not successesful!");
                        successList = customDAO.getSetMessagesList_Success();
                        unsuccesList = customDAO.getSetMessagesList_NotSuccess();

                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", Reply To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Reply Status - Unsuccess (Failed Count -" + unsuccesList.size() + ") | Reply By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                    }

                }
                else
                {

                    if (customDAO.setMessageDetails(newMsgId, session_bankCode, colMsgTo, strSubject, strMessage.trim(), strPriority, newFileName, attachmentName, newFileFullPath, session_userName))
                    {
                        System.out.println("Messages sent successesfuly!");
                        successList = customDAO.getSetMessagesList_Success();

                        if (successList.size() == Integer.parseInt(strRecipientCount))
                        {
                            isAllSuccess = true;

                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_compose_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Status - Success | Compose By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                        }
                    }
                    else
                    {
                        System.out.println("Messages sending is not successesful!");
                        successList = customDAO.getSetMessagesList_Success();
                        unsuccesList = customDAO.getSetMessagesList_NotSuccess();
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_compose_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Status - Unsuccess (Failed Count -" + unsuccesList.size() + ") | Compose By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                    }
                }

            }
            else
            {
                System.out.println("Messages sending is not successesful! Upload attachment failed.");
                msg = "Upload attachment failed!";
                isAllSuccess = false;
                if((parentMsgId > 0) && (grandParentMsgId > 0))
                {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", Reply To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Reply Status - Unsuccess (" + msg + ") | Reply By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }
                else
                {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_compose_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", To - " + strRecipints + ", Subject - " + strSubject + ", Atch. Name - " + attachmentName + ", Atch. Size - " + initialfileSize + " bytes | Sent Status - Unsuccess (" + msg + ") | Compose By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }
            }

        }
        else
        {
            System.out.println("inside else of attachmentName != null");

            newMsgId = DAOFactory.getCustomMsgDAO().getNewMsgId();

            CustomMsgDAO customDAO = DAOFactory.getCustomMsgDAO();

            if ((parentMsgId > 0) && (grandParentMsgId > 0))
            {
                if (customDAO.setMessagePerentDetails(newMsgId, parentMsgId, grandParentMsgId, session_bankCode, colMsgTo, strSubject, strMessage.trim(), strPriority, newFileName, attachmentName, newFileFullPath, session_userName))
                {
                    System.out.println("Messages sent successesfuly!");
                    successList = customDAO.getSetMessagesList_Success();

                    if (successList.size() == Integer.parseInt(strRecipientCount))
                    {
                        isAllSuccess = true;
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", Reply To - " + strRecipints + ", Subject - " + strSubject + ", Attachment - N/A | Sent Reply Status - Success | Reply By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                    }
                }
                else
                {
                    System.out.println("Messages sending is not successesful!");
                    successList = customDAO.getSetMessagesList_Success();
                    unsuccesList = customDAO.getSetMessagesList_NotSuccess();
                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_reply_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", Reply To - " + strRecipints + ", Subject - " + strSubject + ", Attachment - N/A | Sent Reply Status - Unsuccess (Failed Count -" + unsuccesList.size() + ") | Reply By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }

            }
            else
            {

                if (customDAO.setMessageDetails(newMsgId, session_bankCode, colMsgTo, strSubject, strMessage.trim(), strPriority, newFileName, attachmentName, newFileFullPath, session_userName))
                {
                    System.out.println("Messages sent successesfuly!");
                    successList = customDAO.getSetMessagesList_Success();

                    if (successList.size() == Integer.parseInt(strRecipientCount))
                    {
                        isAllSuccess = true;
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_compose_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", To - " + strRecipints + ", Subject - " + strSubject + ", Attachment - N/A | Sent Status - Success | Compose By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                    }
                }
                else
                {
                    System.out.println("Messages sending is not successesful!");
                    successList = customDAO.getSetMessagesList_Success();
                    unsuccesList = customDAO.getSetMessagesList_NotSuccess();
                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_message_compose_message_send, "| Message Id - " + parentMsgId + " Grand Parent Message Id - " + grandParentMsgId + ", To - " + strRecipints + ", Subject - " + strSubject + ", Attachment - N/A | Sent Status - Unsuccess (Failed Count -" + unsuccesList.size() + ") | Compose By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }
            }

        }
    }
    else
    {
        System.out.println("inside else of iRecipientCount == Integer.parseInt(strRecipientCount)");
    }

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


        <script language="JavaScript">

            function goBack()
            {
                document.frmMsgSendConfirm.action = "ComposeMessage.jsp";
                document.frmMsgSendConfirm.submit();
                return true;
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
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text">Send Message Confirmation</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="slips_header_text"><form method="post" name="frmMsgSendConfirm">
                                                                                                <table border="0" align="center" cellpadding="3" cellspacing="0"  >
                                                                                                    <%
                                                                                                        if (isAllSuccess == true)
                                                                                                        {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="slips_Display_Success_msg" align="center">Message Successfully Sent To The All Recipient(s)</td>
                                                                                                    </tr>
                                                                                                    <tr height="25" align="center" valign="top">
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="3" cellspacing="1" class="slips_table_boder">

                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">To (Recipient/s) :</td>
                                                                                                                    <tdclass="slips_tbl_common_text"><%
                                                                                                                        if (successList != null && !successList.isEmpty())
                                                                                                                        {
                                                                                                                            for (CustomMsg cMsg : successList)
                                                                                                                            {
                                                                                                                                MsgHeader msgHeader = cMsg.getMsgHeader();
                                                                                                                                MsgBody msgBody = cMsg.getMsgBody();

                                                                                                                        %>
                                                                                                                        <%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%>
                                                                                                                        <br>
                                                                                                                        <% }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                      <span class="slips_error">Sorry! Recipient(s) Details not available. </span>
                                                                                                                  <%}%>                                                                                            </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">From : </td>
                                                                                                                    <tdclass="slips_tbl_common_text"><%=session_userName%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Subject :</td>
                                                                                                                    <tdclass="slips_tbl_common_text"><%=strSubject%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Priority :</td>
                                                                                                                    <td class="slips_tbl_common_text"><%=DAOFactory.getMsgPriorityDAO().getPriority(strPriority) != null ? DAOFactory.getMsgPriorityDAO().getPriority(strPriority).getPriorityDesc() : "N/A"%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Message : </td>
                                                                                                                    <td class="slips_tbl_common_text"> <%=strMessage!=null?strMessage.replaceAll("\\r\\n|\\r|\\n", "<br>"):"N/A" %></td>
                                                                                                                </tr>




                                                                                                                <%
                                                                                                                    if (attachmentName != null)
                                                                                                                    {
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Attachment :</td>
                                                                                                                    <td class="slips_tbl_common_text">
                                                                                                                        <%=attachmentName%>                                                                                                                        </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td colspan="2" align="center" class="slips_tbl_footer_text"><input name="btnBack" id="btnBack" value="OK" type="button" onClick="goBack()"  class="slips_custom_button"/></td> 
                                                                                                                </tr>

                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="slips_Display_Error_msg" align="center">Error Occured While Sending the Messages. - <%=msg != null ? msg : ""%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="slips_Display_Error_msg" align="center">&nbsp;</td>
                                                                                                    </tr>


                                                                                                    <tr>
                                                                                                      <td class="slips_Display_Error_msg" align="center">

                                                                                                          <table border="0" align="center" cellpadding="3" cellspacing="1" class="slips_table_boder">

                                                                                                              <tr>
                                                                                                                <td bgcolor="#B3D5C0" class="slips_tbl_header_text">To (Recipient/s) :</td>
                                                                                                                    <tdclass="slips_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                              <td align="center" class="slips_success"><strong>Success List</strong></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><%
                                                                                                                                    if (successList != null && !successList.isEmpty())
                                                                                                                                    {
                                                                                                                                        for (CustomMsg cMsg : successList)
                                                                                                                                        {
                                                                                                                                            MsgHeader msgHeader = cMsg.getMsgHeader();
                                                                                                                                            MsgBody msgBody = cMsg.getMsgBody();

                                                                                                                                    %>
                                                                                                                                    <%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%>
                                                                                                                                    <br>
                                                                                                                                    <% }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                  <span class="slips_error">Sorry! Successful Recipient(s) Details not available. </span>
                                                                                                                                    <%}%>                                                                                            </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                              <td align="center" class="slips_error"><strong>Unsuccess List</strong></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><%
                                                                                                                                    if (unsuccesList != null && !unsuccesList.isEmpty())
                                                                                                                                    {
                                                                                                                                        for (CustomMsg cMsg : unsuccesList)
                                                                                                                                        {
                                                                                                                                            MsgHeader msgHeader = cMsg.getMsgHeader();
                                                                                                                                            MsgBody msgBody = cMsg.getMsgBody();

                                                                                                                                    %>
                                                                                                                                    <%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%>
                                                                                                                                    <br>
                                                                                                                                    <% }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                  <span class="slips_error">Sorry! Unsuccessful Recipient(s) Details not available. </span>
                                                                                                                                    <%}%>                                                                                            </td>
                                                                                                                            </tr>
                                                                                                                </table></td>
                                                                                                            </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">From : </td>
                                                                                                                    <tdclass="slips_tbl_common_text"><%=session_userName%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Subject :</td>
                                                                                                                    <tdclass="slips_tbl_common_text"><%=strSubject%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Priority :</td>
                                                                                                                    <td class="slips_tbl_common_text"><%=DAOFactory.getMsgPriorityDAO().getPriority(strPriority) != null ? DAOFactory.getMsgPriorityDAO().getPriority(strPriority).getPriorityDesc() : "N/A"%></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Message :</td>
                                                                                                                    <td class="slips_tbl_common_text"><%=strMessage!=null?strMessage.replaceAll("\\r\\n|\\r|\\n", "<br>"):"N/A" %></td>
                                                                                                                </tr>


                                                                                                                <%
                                                                                                                    if (attachmentName != null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                  <td bgcolor="#B3D5C0" class="slips_tbl_header_text">Attachment :</td>
                                                                                                                    <td class="slips_tbl_common_text">
                                                                                                                        <%=attachmentName%>                                                                                                                                                                                                                   </td>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td colspan="2" align="center" class="slips_tbl_footer_text"><input name="btnBack" id="btnBack" value="OK" type="button" onClick="goBack()"  class="slips_custom_button"/></td>
                                                                                                                </tr>
                                                                                                      </table>                                                                                </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        }
                                                                                                    %>
                                                                                                </table>  
                                                                                            </form></td>
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
