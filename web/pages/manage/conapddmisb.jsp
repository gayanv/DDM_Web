
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequest" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequestDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
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

        if (!(session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user)))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
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
<%    String cbrIdList = null;
    //String cbrIdList_Over10Chb = null;
    String cbrIdListRejected = null;

    String cbrIdList_Remarks = null;
    String cbrIdListRejected_Remarks = null;

    //String[] strBatchIdArray = null;
    //String[] strBatchIdArrayRejected = null;
    ArrayList<String> vtApprovedIds = null;
    ArrayList<String> vtRejectedIds = null;

    HashMap<String, String> hmApprovedReqRemarks = null;
    HashMap<String, String> hmRejectedReqRemarks = null;

    Collection<DDMRequest> successList = new ArrayList();
    Collection<DDMRequest> unsuccessList = new ArrayList();

    cbrIdList = (String) request.getParameter("hdnApprovedCBRIDs");
    cbrIdListRejected = (String) request.getParameter("hdnRejectedCBRIDs");

    cbrIdList_Remarks = (String) request.getParameter("hdnRemarks");
    cbrIdListRejected_Remarks = (String) request.getParameter("hdnRemarksRejected");

//    System.out.println("cbrIdList###" + cbrIdList);
//    System.out.println("cbrIdListRejected###" + cbrIdListRejected);
    try
    {
        StringTokenizer stz_approved = new StringTokenizer(cbrIdList, "|");

        while (stz_approved != null && stz_approved.hasMoreElements())
        {
            if (vtApprovedIds == null)
            {
                vtApprovedIds = new ArrayList();
            }

            vtApprovedIds.add((String) stz_approved.nextElement());
        }

        StringTokenizer stz_ApprovedRIdRemarks = new StringTokenizer(cbrIdList_Remarks, "~");

        while (stz_ApprovedRIdRemarks != null && stz_ApprovedRIdRemarks.hasMoreElements())
        {
            if (hmApprovedReqRemarks == null)
            {
                hmApprovedReqRemarks = new HashMap();
            }

            String tempVal = (String) stz_ApprovedRIdRemarks.nextElement();

            String strReqId = null;
            String strRemarks = null;

            if (tempVal != null)
            {
                strReqId = tempVal.substring(0, tempVal.indexOf("|"));
                strRemarks = tempVal.substring(tempVal.indexOf("|") + 1);

                if (strReqId != null && strReqId.length() > 0)
                {
                    hmApprovedReqRemarks.put(strReqId, strRemarks);
                }
            }
        }

        StringTokenizer stz_rejected = new StringTokenizer(cbrIdListRejected, "|");

        while (stz_rejected != null && stz_rejected.hasMoreElements())
        {
            if (vtRejectedIds == null)
            {
                vtRejectedIds = new ArrayList();
            }

            vtRejectedIds.add((String) stz_rejected.nextElement());
        }

        StringTokenizer stz_PMRIdRemarks = new StringTokenizer(cbrIdListRejected_Remarks, "~");

        while (stz_PMRIdRemarks != null && stz_PMRIdRemarks.hasMoreElements())
        {
            if (hmRejectedReqRemarks == null)
            {
                hmRejectedReqRemarks = new HashMap();
            }

            String tempVal = (String) stz_PMRIdRemarks.nextElement();

            String strReqId = null;
            String strRemarks = null;

            if (tempVal != null)
            {
                strReqId = tempVal.substring(0, tempVal.indexOf("|"));
                strRemarks = tempVal.substring(tempVal.indexOf("|") + 1);

                if (strReqId != null && strReqId.length() > 0)
                {
                    hmRejectedReqRemarks.put(strReqId, strRemarks);
                }
            }
        }

        String curDDMR_Stat = null;
        String newDDMR_Stat = null;
        String newDDMR_StatRejected = null;

        curDDMR_Stat = DDM_Constants.ddm_request_status_02;
        newDDMR_Stat = DDM_Constants.ddm_request_status_03;
        newDDMR_StatRejected = DDM_Constants.ddm_request_status_11;

        if (vtApprovedIds != null)
        {
            for (String ddmrID : vtApprovedIds)
            {
                //System.out.println("ddmrID_Approved ---> " + ddmrID);                
                DDMRequestDAO DDMR_DAO = DAOFactory.getDDMRequestDAO();

                String remark = null;

                if (hmApprovedReqRemarks != null)
                {
                    remark = hmApprovedReqRemarks.get(ddmrID);
                }
                //System.out.println("going to execute DDMR_DAO.updateStatus2 (newDDMR_Stat) ---> " +newDDMR_Stat);
                boolean result = DDMR_DAO.updateDDMRequestStatus(ddmrID, curDDMR_Stat, newDDMR_Stat, session_userName, remark);

                //System.out.println("after execute DDMR_DAO.updateStatus2 (ddmrID) ---> " + ddmrID);
                if (result)
                {
                    DDMRequest ddmr = DAOFactory.getDDMRequestDAO().getDDARequestDetails(ddmrID);
                    successList.add(ddmr);

                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_ddm_request_issuing_bank_approval, "| DDM Id - " + ddmrID + ",  Approver Bank - " + session_bankCode + ", Approver Branch - " + session_branchId + " (" + session_branchName + " ), Approval Status - " + newDDMR_Stat + " | Process Status - Success | Approved By - " + session_userName + " (" + session_userTypeDesc + ") |"));

                }
                else
                {
                    String msg = DDMR_DAO.getMsg();

                    DDMRequest ddmr = DAOFactory.getDDMRequestDAO().getDDARequestDetails(ddmrID);
                    System.out.println("Approved : DAOFactory.getDDMRequestDAO().updateDDMRequestStatus is not ok ----> ");
                    unsuccessList.add(ddmr);

                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_ddm_request_issuing_bank_approval, "| DDM Id - " + ddmrID + "  Approver Bank - " + session_bankCode + ", Approver Branch - " + session_branchId + " (" + session_branchName + " ), Approval Status - " + newDDMR_Stat + " | Process Status - Unsuccess (" + msg + ") | Approved By - " + session_userName + " (" + session_userTypeDesc + ") |"));

                }
            }
        }

        if (vtRejectedIds != null)
        {
            for (String ddmrID : vtRejectedIds)
            {
                //System.out.println("ddmrID_Rejected ---> " + ddmrID);
                DDMRequestDAO DDMR_DAO = DAOFactory.getDDMRequestDAO();

                String remark = null;

                if (hmRejectedReqRemarks != null)
                {
                    remark = hmRejectedReqRemarks.get(ddmrID);
                }

                boolean result = DDMR_DAO.updateDDMRequestStatus(ddmrID, curDDMR_Stat, newDDMR_StatRejected, session_userName, remark);

                if (result)
                {
                    DDMRequest ddmr = DAOFactory.getDDMRequestDAO().getDDARequestDetails(ddmrID);
                    successList.add(ddmr);

                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_ddm_request_issuing_bank_approval, "| DDM Id - " + ddmrID + ", Approver Bank - " + session_bankCode + ", Approver Branch - " + session_branchId + " (" + session_branchName + " ), Approval Status - " + newDDMR_StatRejected + " | Process Status - Success | Rejected By - " + session_userName + " (" + session_userTypeDesc + ") |"));

                }
                else
                {
                    String msg = DDMR_DAO.getMsg();

                    DDMRequest ddmr = DAOFactory.getDDMRequestDAO().getDDARequestDetails(ddmrID);
                    System.out.println("Rejected : DAOFactory.getDDMRequestDAO().updateDDMRequestStatus is not ok ----> ");
                    unsuccessList.add(ddmr);

                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_ddm_request_issuing_bank_approval, "| DDM Id - " + ddmrID + ", Approver Bank - " + session_bankCode + ", Approver Branch - " + session_branchId + " (" + session_branchName + " ), Approval Status - " + newDDMR_StatRejected + " | Process Status - Unsuccess (" + msg + ") | Rejected By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }
            }
        }
    }
    catch (Exception e)
    {
        System.out.println(e.getMessage());
    }


%>
<html>
    <head>
        <title>CBRPS Web</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/autocomplete.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>
        <script language="javascript" type="text/JavaScript">		


            function submitOnholdBatches()
            {

            var itemCount = document.getElementById('hdnNoOfItems').value;
            var batchIdCollection = null;
            var noOfselectedItems = 0;

            for(var i =1; i<=itemCount; i++)
            {

            var chbElement = 'chbBatch_'+ i;

            if(document.getElementById(chbElement).checked)
            {
            noOfselectedItems++;
            batchIdCollection = batchIdCollection + document.getElementById(chbElement).value + ':';
            }				
            }

            if(noOfselectedItems > 0)
            {
            document.getElementById('hdnOnholdItems').value = batchIdCollection;
            frmUpdateOnholdBatches.submit();
            }
            else
            {
            alert('Please select at least one batch !');
            }

            }


            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnIsSearch').value = "1";
            }
            else
            {
            document.getElementById('hdnIsSearch').value = "0";
            }

            }

            function setTabId(id)
            {
            if(id == 0)
            {
            document.getElementById('hdnTabId').value = "0";
            }
            else if(id == 1)
            {
            document.getElementById('hdnTabId').value = "1";
            }

            }

            function doSubmit()
            {

            if(validate())
            {
            frmFindOnholdBatches.submit();
            }

            }


            function validate()
            {

            if (document.getElementById('hdnTabId').value == "1")
            {
            if(isempty(document.getElementById('txtBatchNo').value))
            {
            alert('Please enter a valid Batch No.');
            return false;
            }
            else
            {
            return true;
            }
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
            else if(type==2)
            {
            var val = new Array(<%=serverTime%>);
            clock(document.getElementById('showText'),type,val);
            }
            else if(type==3)
            {
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
            clock(document.getElementById('showText'),type,val);
            }
            }


        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3)">

        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>

        <table width="100%" height="100%" style="min-width:900;min-height:600"  align="center" border="0" cellpadding="0" cellspacing="0" >
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
                                                                                        <td width="10"></td>
                                                                                        <%
                                                                                            String userTypeDescription = "Issuing Bank";

                                                                                        %>

                                                                                        <td align="left" valign="top" class="ddm_header_text">New DDM Request(s) - <%=userTypeDescription%> Approval</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">
                                                                                            <%
                                                                                                if (successList != null && successList.size() > 0)
                                                                                                {

                                                                                            %>
                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_Display_Success_msg">Following DDM Requests Successfully Approved / Rejected.</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center"><table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                            <tr><td>





                                                                                                                    <table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text_horizontal_small"></td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Req.<br/>
                                                                                                                                Time</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Merchant</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Bank</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Branch</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Account No.</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Account Name</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Bank</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Branch</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Account No.</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Account Name</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Max<br/>
                                                                                                                                Limit</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Start<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">End<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Frequency</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Purpose</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Reference</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">New<br>
                                                                                                                                Status</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">Remarks</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">By</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">Time</td>
                                                                                                                        </tr>
                                                                                                                        <%                                                                                                                int rowNum = 0;
                                                                                                                            double maxLimit = 0;
                                                                                                                            double grandTotalMaxLimit = 0;

                                                                                                                            for (DDMRequest ddmrSuccess : successList)
                                                                                                                            {
                                                                                                                                rowNum++;

                                                                                                                                String strMaxLimit = ddmrSuccess.getMaxLimit();

                                                                                                                                try
                                                                                                                                {
                                                                                                                                    maxLimit = Double.parseDouble(strMaxLimit);
                                                                                                                                }
                                                                                                                                catch (Exception ex)
                                                                                                                                {
                                                                                                                                    maxLimit = 0;
                                                                                                                                }

                                                                                                                                grandTotalMaxLimit = grandTotalMaxLimit + maxLimit;

                                                                                                                        %>
                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                            <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=ddmrSuccess.getCreatedDate()%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=ddmrSuccess.getMerchantID()%> - <%=ddmrSuccess.getMerchantName()%></td>

                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrSuccess.getIssuningBankCode() %> - <%=ddmrSuccess.getIssuningBankName()%>"><%=ddmrSuccess.getIssuningBankCode()%> - <%=ddmrSuccess.getIssuningBankShortName()%></td>
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrSuccess.getIssuningBranch()%> - <%=ddmrSuccess.getIssuningBranchName()%>"><%=ddmrSuccess.getIssuningBranch()%> - <%=ddmrSuccess.getIssuningBranchName().length() > 10 ? (ddmrSuccess.getIssuningBranchName().substring(0, 8) + "..") : ddmrSuccess.getIssuningBranchName()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getIssuningAccountNumber()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getIssuningAccountName()%></td>                                                                                                                                 
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrSuccess.getAcquiringBankCode()%> - <%=ddmrSuccess.getAcquiringBankName()%>"><%=ddmrSuccess.getAcquiringBankCode()%> - <%=ddmrSuccess.getAcquiringBankShortName()%></td>
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrSuccess.getAcquiringBranch()%> - <%=ddmrSuccess.getAcquiringBranchName()%>"><%=ddmrSuccess.getAcquiringBranch()%> - <%=ddmrSuccess.getAcquiringBranchName().length() > 10 ? (ddmrSuccess.getAcquiringBranchName().substring(0, 8) + "..") : ddmrSuccess.getAcquiringBranchName()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getAcquiringAccountNumber()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getAcquiringAccountName()%></td>
                                                                                                                            <td class="ddm_common_text" align="right" ><%=strMaxLimit%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getStartDate()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrSuccess.getEndDate()%></td>
                                                                                                                            <%
                                                                                                                                String strFrequency = "";

                                                                                                                                if (ddmrSuccess.getFrequency() != null)
                                                                                                                                {
                                                                                                                                    if (ddmrSuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_daily))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Daily";
                                                                                                                                    }
                                                                                                                                    else if (ddmrSuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_weekly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Weekly";
                                                                                                                                    }
                                                                                                                                    else if (ddmrSuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_monthly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Monthly";
                                                                                                                                    }
                                                                                                                                    else if (ddmrSuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_yearly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Yearly";
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        strFrequency = "n/a";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    strFrequency = "n/a";
                                                                                                                                }
                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text" align="center" ><%=strFrequency%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=(ddmrSuccess.getPurpose() != null) ? ddmrSuccess.getPurpose() : ""%></td>
                                                                                                                            <td class="ddm_common_text"><%=(ddmrSuccess.getReference() != null) ? ddmrSuccess.getReference() : ""%></td>
                                                                                                                            <td class="ddm_common_text"><span class="ddm_common_text" title="<%=ddmrSuccess.getStatusDesc()%>"><%=ddmrSuccess.getStatusDesc()%></span></td>
                                                                                                                                <%
                                                                                                                                    String strRemarks = ddmrSuccess.getIssuingBankAcceptedRemarks();

                                                                                                                                %>

                                                                                                                            <td class="ddm_common_text"><%=(strRemarks != null) ? strRemarks : ""%></td>
                                                                                                                            <%
                                                                                                                                String strBy = ddmrSuccess.getIssuingBankAcceptedBy();

                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text"><%=(strBy != null) ? strBy : ""%></td>


                                                                                                                            <%
                                                                                                                                String strTime = ddmrSuccess.getIssuingBankAcceptedOn();

                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text"><%=(strTime != null) ? strTime : ""%></td>
                                                                                                                        </tr>
                                                                                                                        <%

                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text">Grand Total</td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                        </tr>
                                                                                                                    </table>



                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>



                                                                                            <% }%>


                                                                                            <%
                                                                                                if (unsuccessList != null && unsuccessList.size() > 0)
                                                                                                {

                                                                                            %>
                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_Display_Error_msg">Error occurred while Approving / Rejecting following DDM Requests.</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td><table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                            <tr><td>





                                                                                                                    <table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_header_text_horizontal_small"></td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Req.<br/>
                                                                                                                                Time</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Merchant</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Bank</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Branch</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Account No.</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                Account Name</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Bank</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Branch</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Account No.</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                Account Name</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Max<br/>
                                                                                                                                Limit</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Start<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">End<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Frequency</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Purpose</td>
                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal_small">Reference</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">
                                                                                                                                Status</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">Remarks</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">By</td>
                                                                                                                            <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal_small">Time</td>
                                                                                                                        </tr>
                                                                                                                        <%                                                                                                                int rowNum = 0;
                                                                                                                            double maxLimit = 0;
                                                                                                                            double grandTotalMaxLimit = 0;

                                                                                                                            for (DDMRequest ddmrUnsuccess : unsuccessList)
                                                                                                                            {
                                                                                                                                rowNum++;
                                                                                                                                String strMaxLimit = ddmrUnsuccess.getMaxLimit();

                                                                                                                                try
                                                                                                                                {
                                                                                                                                    maxLimit = Double.parseDouble(strMaxLimit);
                                                                                                                                }
                                                                                                                                catch (Exception ex)
                                                                                                                                {
                                                                                                                                    maxLimit = 0;
                                                                                                                                }

                                                                                                                                grandTotalMaxLimit = grandTotalMaxLimit + maxLimit;

                                                                                                                        %>
                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                            <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=ddmrUnsuccess.getCreatedDate()%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=ddmrUnsuccess.getMerchantID()%> - <%=ddmrUnsuccess.getMerchantName()%></td>

                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrUnsuccess.getIssuningBankCode() %> - <%=ddmrUnsuccess.getIssuningBankName()%>"><%=ddmrUnsuccess.getIssuningBankCode()%> - <%=ddmrUnsuccess.getIssuningBankShortName()%></td>
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrUnsuccess.getIssuningBranch()%> - <%=ddmrUnsuccess.getIssuningBranchName()%>"><%=ddmrUnsuccess.getIssuningBranch()%> - <%=ddmrUnsuccess.getIssuningBranchName().length() > 10 ? (ddmrUnsuccess.getIssuningBranchName().substring(0, 8) + "..") : ddmrUnsuccess.getIssuningBranchName()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getIssuningAccountNumber()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getIssuningAccountName()%></td>                                                                                                                                 
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrUnsuccess.getAcquiringBankCode()%> - <%=ddmrUnsuccess.getAcquiringBankName()%>"><%=ddmrUnsuccess.getAcquiringBankCode()%> - <%=ddmrUnsuccess.getAcquiringBankShortName()%></td>
                                                                                                                            <td nowrap class="ddm_common_text" title="<%=ddmrUnsuccess.getAcquiringBranch()%> - <%=ddmrUnsuccess.getAcquiringBranchName()%>"><%=ddmrUnsuccess.getAcquiringBranch()%> - <%=ddmrUnsuccess.getAcquiringBranchName().length() > 10 ? (ddmrUnsuccess.getAcquiringBranchName().substring(0, 8) + "..") : ddmrUnsuccess.getAcquiringBranchName()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getAcquiringAccountNumber()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getAcquiringAccountName()%></td>
                                                                                                                            <td class="ddm_common_text" align="right" ><%=strMaxLimit%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getStartDate()%></td>
                                                                                                                            <td class="ddm_common_text"><%=ddmrUnsuccess.getEndDate()%></td>
                                                                                                                            <%
                                                                                                                                String strFrequency = "";

                                                                                                                                if (ddmrUnsuccess.getFrequency() != null)
                                                                                                                                {
                                                                                                                                    if (ddmrUnsuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_daily))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Daily";
                                                                                                                                    }
                                                                                                                                    else if (ddmrUnsuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_weekly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Weekly";
                                                                                                                                    }
                                                                                                                                    else if (ddmrUnsuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_monthly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Monthly";
                                                                                                                                    }
                                                                                                                                    else if (ddmrUnsuccess.getFrequency().equals(DDM_Constants.ddm_request_frequency_yearly))
                                                                                                                                    {
                                                                                                                                        strFrequency = "Yearly";
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        strFrequency = "n/a";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    strFrequency = "n/a";
                                                                                                                                }
                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text" align="center" ><%=strFrequency%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=(ddmrUnsuccess.getPurpose() != null) ? ddmrUnsuccess.getPurpose() : ""%></td>
                                                                                                                            <td class="ddm_common_text"><%=(ddmrUnsuccess.getReference() != null) ? ddmrUnsuccess.getReference() : ""%></td>
                                                                                                                            <td align="center" class="ddm_common_text"><span class="ddm_common_text" title="<%=ddmrUnsuccess.getStatusDesc()%>"><%=ddmrUnsuccess.getStatus()%></span></td>
                                                                                                                                <%
                                                                                                                                    String strRemarks = ddmrUnsuccess.getIssuingBankAcceptedRemarks();

                                                                                                                                %>

                                                                                                                            <td class="ddm_common_text"><%=(strRemarks != null) ? strRemarks : ""%></td>
                                                                                                                            <%
                                                                                                                                String strBy = ddmrUnsuccess.getIssuingBankAcceptedBy();

                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text"><%=(strBy != null) ? strBy : ""%></td>


                                                                                                                            <%
                                                                                                                                String strTime = ddmrUnsuccess.getIssuingBankAcceptedOn();

                                                                                                                            %>

                                                                                                                            <td class="ddm_common_text"><%=(strTime != null) ? strTime : ""%></td>
                                                                                                                        </tr>
                                                                                                                        <%

                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <tr>
                                                                                                                            <td class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">Grand Total</td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="right" class="ddm_tbl_footer_text"></td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                            <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                        </tr>
                                                                                                                    </table>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>

                                                                                            <% }
                                                                                            %>                                                                            </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><a href="apddmisb.jsp" target="_self"><input name="btnBack" id="btnBack" value="&nbsp;&nbsp; Back &nbsp;&nbsp;" type="button" class="ddm_custom_button" /></a></td>
                                                                                        <td></td>
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

    <script language="javascript">floatItem("GotoDown", 40, 40, "right", 2, "top", 125);</script>
    <script language="javascript">floatItem("GotoTop", 40, 40, "right", 2, "bottom", 25);</script>

</html>
<%
        }

    }
%>
