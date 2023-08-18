
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.DecimalFormat" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.executionBatchHistory.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.ParameterDAO" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.executionBatch.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.executionBatchStatus.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>

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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - View Calendar Details' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_Calendar_Details");
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
    String isSearchReq = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;
    String status = null;
    String exeBatchId = null;

    Collection<ExecutionBatch> col_execBatch = null;
    Collection<ExecutionBatchStatus> col_execBatchStatus = null;
    Collection<ExecutionBatchHistory> col_execHistory = null;

    isSearchReq = (String) request.getParameter("hdnIsSearch");

    ExecutionBatchDAO exec_dao = DAOFactory.getExecutionBatchDAO();
    col_execBatch = exec_dao.getExecutionBatch();

    ExecutionBatchStatusDAO dao_exeStatus = DAOFactory.getExecutionBatchStatusDAO();
    col_execBatchStatus = dao_exeStatus.getExecutionBatchStatus();

    if (isSearchReq == null)
    {
        isSearchReq = "0";
        fromBusinessDate = "0";
        toBusinessDate = "0";
    }
    else
    {
        exeBatchId = (String) request.getParameter("cmbExeBatchName");
        status = (String) request.getParameter("cmbExeBatchStatus");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");

        if (isSearchReq.equals("1"))
        {
            if (fromBusinessDate == null || fromBusinessDate.equals(""))
            {
                fromBusinessDate = DDM_Constants.status_all;
            }

            if (toBusinessDate == null || toBusinessDate.equals(""))
            {
                toBusinessDate = DDM_Constants.status_all;
            }

            col_execHistory = DAOFactory.getExecutionBatchHistoryDAO().getExecutionBatchHistory(exeBatchId, status,
                    fromBusinessDate, toBusinessDate);
        }
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System | View Execution Batch History</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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


            function clearDates()
            {
            var from_elementId = 'txtFromBusinessDate';
            var to_elementId = 'txtToBusinessDate';

            document.getElementById(from_elementId).value = "";
            document.getElementById(to_elementId).value = "";

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
            else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
                    clock(document.getElementById('showText'), type, val);
                }
            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnIsSearch').value = "1";
            }
            }

            function doSubmit()
            {
            frmViewParameterHistory.submit();
            }


        </script>
    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="showClock(3)">
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Execution Batch History</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"><form name="frmViewExecutionBatchHistory" id="frmViewExecutionBatchHistory"
                                                                                                                                                      method="post" action="ViewExecutionBatchHistory.jsp">
                                                                                                <table border="0" align="center" cellspacing="0" cellpadding="0" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top"><table border="0" cellspacing="1" cellpadding="3">
                                                                                                                <tr>
                                                                                                                    <td valign="middle" class="ddm_tbl_header_text">Execution Batch Name :</td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_common_text"><select name="cmbExeBatchName" class="ddm_field_border" id="cmbExeBatchName">
                                                                                                                            <%
                                                                                                                    if (exeBatchId == null || exeBatchId.equals(DDM_Constants.status_all))
                                                                                                                    {%>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                            <%}
                                                                                                                else
                                                                                                                {%>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                            <%  }
                                                                                                                                if (col_execBatch != null && col_execBatch.size() > 0)
                                                                                                                                {

                                                                                                                                    for (ExecutionBatch exbatch : col_execBatch)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=exbatch.getBatchId()%>" <%=(exeBatchId != null && exbatch.getBatchId().equals(exeBatchId)) ? "selected" : ""%> > <%=exbatch.getBatchName()%> </option>
                                                                                                                            <% }
                                                                                                                    }%>
                                                                                                                        </select></td>
                                                                                                                </tr>
                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><select name="cmbExeBatchStatus" class="ddm_field_border" id="cmbExeBatchStatus">

                                                                                                                        <%
                                                                                                                if (status == null || status.equals(DDM_Constants.status_all))
                                                                                                                {%>
                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                        <%}
                                                                                                            else
                                                                                                            {%>
                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                        <%  }

                                                                                                                            if (col_execBatchStatus != null && col_execBatchStatus.size() > 0)
                                                                                                                            {

                                                                                                                                for (ExecutionBatchStatus exBatchStatus : col_execBatchStatus)
                                                                                                                                {

                                                                                                                        %>
                                                                                                                        <option value="<%=exBatchStatus.getStatusId()%>" <%=(status != null && exBatchStatus.getStatusId().equals(status)) ? "selected" : ""%> > <%=exBatchStatus.getStatusDesc()%> </option>
                                                                                                                        <% }
                                                                                                                }%>
                                                                                                                    </select></td>
                                                                                                                <tr>
                                                                                                                    <td valign="middle" class="ddm_tbl_header_text">Business Date :</td>
                                                                                                                    <td align="left" valign="middle" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text"
                                                                                                                                                           class="tcal" size="10" onFocus="this.blur()" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(DDM_Constants.status_all)) ? "" : fromBusinessDate%>">                                                </td>
                                                                                                                                <td width="10" valign="middle"></td>
                                                                                                                                <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text"
                                                                                                                                                           class="tcal" size="10" onFocus="this.blur()" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(DDM_Constants.status_all)) ? "" : toBusinessDate%>">                                                </td>
                                                                                                                                <td width="15" valign="middle"></td>
                                                                                                                                <td valign="middle"><input name="btnClear" id="btnClear" value="Clear Dates" type="button" onClick="clearDates()" class="ddm_custom_button_small" /></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td height="30" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" name="hdnIsSearch" id="hdnIsSearch" value="<%=isSearchReq%>" /></td>
                                                                                                                                <td><input name="btnSearch" id="btnSearch" value="Search Details" type="button"  onclick="isSearchRequest(true);
                                                                                                                            frmViewExecutionBatchHistory.submit()" class="ddm_custom_button"/></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>
                                                                                        </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                <%

                                                                                                    int col_size = 0;

                                                                                                    if (col_execHistory != null)
                                                                                                    {
                                                                                                        col_size = col_execHistory.size();
                                                                                                    }

                                                                                                    if (col_size == 0 && isSearchReq.equals("1"))
                                                                                                    {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text">No records Available!</td>
                                                                                                </tr>
                                                                                                <%
                                                                                                }
                                                                                                else if (col_size > 0)
                                                                                                {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td><table border="0" cellspacing="1" cellpadding="4" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                            <tr>
                                                                                                                <td class="ddm_tbl_header_text_horizontal"></td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Execution<br>
                                                                                                                    Batch Name</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">New<br>
                                                                                                                    Status</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Previous<br>
                                                                                                                    Status</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Executed<br>
                                                                                                                    By</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Module</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Modified<br>
                                                                                                                    By</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Modified<br>
                                                                                                                    Date</td>
                                                                                                            </tr>
                                                                                                            <input type="hidden" name="hdncol_size" id="hdncol_size" value="<%=col_size%>" />
                                                                                                            <%

                                                                                                                int rowNum = 0;
                                                                                                                for (ExecutionBatchHistory exhistory : col_execHistory)
                                                                                                                {
                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">

                                                                                                                <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                <td align="left" class="ddm_common_text"><%=exhistory.getBatchId()%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=exhistory.getNewStatus() == null ? "Not available" : exhistory.getNewStatus()%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=exhistory.getPreviousStatus() == null ? "Not available" : exhistory.getPreviousStatus()%></td>
                                                                                                                <td align="left" class="ddm_common_text"><%=exhistory.getExecutedBy() == null ? "Not available" : exhistory.getExecutedBy()%></td>
                                                                                                                <td align="left" class="ddm_common_text"><%=exhistory.getModule() == null ? "Not available" : exhistory.getModule()%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=exhistory.getModifiedby() == null ? "Not available" : exhistory.getModifiedby()%></td>
                                                                                                                <td align="left" class="ddm_common_text"><%=exhistory.getModifiedDate() == null ? "Not available" : exhistory.getModifiedDate()%></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }


                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <%                                    }
                                                                                                %>
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
</html>
<%
        }
    }
%>