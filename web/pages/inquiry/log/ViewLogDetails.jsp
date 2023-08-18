<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.logType.LogType" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.CommonUtils" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.report.Report" errorPage="../../../error.jsp"%>
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
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - View Log Details' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_Log_Details");
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
    String logType = null;
    String logText = null;
    String fromLogDate = null;
    String toLogDate = null;
    long totalRecordCount = 0;
    int totalPageCount = 0;
    int reqPageNo = 1;

    Collection<Log> colResult = null;
    Collection<LogType> colLogType = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colLogType = DAOFactory.getLogTypeDAO().getLogTypes();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        logType = DDM_Constants.status_all;
        logText = "";
        fromLogDate = webBusinessDate;
        toLogDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        logType = (String) request.getParameter("cmbLogType");
        logText = (String) request.getParameter("txtLogText");
        fromLogDate = (String) request.getParameter("txtFromLogDate");
        toLogDate = (String) request.getParameter("txtToLogDate");
    }
    else if (isSearchReq.equals("1"))
    {

        logType = (String) request.getParameter("cmbLogType");
        logText = (String) request.getParameter("txtLogText");

        //System.out.println("logText ---> " + logText);
        fromLogDate = (String) request.getParameter("txtFromLogDate");
        toLogDate = (String) request.getParameter("txtToLogDate");

        if (request.getParameter("hdnReqPageNo") != null)
        {
            reqPageNo = Integer.parseInt(request.getParameter("hdnReqPageNo"));
        }

        LogType lt = DAOFactory.getLogTypeDAO().getLogType(logType);

        totalRecordCount = DAOFactory.getLogDAO().getRecordCountLogDetails(logType, logText, fromLogDate, toLogDate);

        if (totalRecordCount > 0)
        {
            totalPageCount = (int) Math.ceil((Double.parseDouble(String.valueOf(totalRecordCount))) / DDM_Constants.noPageRecords);
            colResult = DAOFactory.getLogDAO().getLogDetails(logType, logText, fromLogDate, toLogDate, reqPageNo, DDM_Constants.noPageRecords);
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_functions_view_log_details, "| Search Criteria - (Log Type  : " + (lt != null ? lt.getDescription() : "All") + ", Log Text : " + (logText != null ? logText : "") + ", Log Date From : " + fromLogDate + ", Log Date To : " + toLogDate + ", Page No. - " + reqPageNo + ") | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_functions_view_log_details, "| Search Criteria - (Log Type  : " + (lt != null ? lt.getDescription() : "All") + ", Log Text : " + (logText != null ? logText : "") + ", Log Date From : " + fromLogDate + ", Log Date To : " + toLogDate + ") | Total Record Count - 0 | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Log Details</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />
        
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
            var from_elementId = 'txtFromLogDate';
            var to_elementId = 'txtToLogDate';

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

            function setReqPageNoForCombo2()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo2').value;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();
            }

            function setReqPageNoForCombo()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo').value;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();
            }

            function setReqPageNo(no)
            {
            document.getElementById('hdnReqPageNo').value = no;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();				
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3)">

        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>
         
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Log Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td>&nbsp;</td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="ddm_header_text"><form id="frmViewLogDetails" name="frmViewLogDetails" method="post" action="ViewLogDetails.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="1" cellpadding="4"  >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text" >Log Type :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text" ><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbLogType" id="cmbLogType" onChange="clearResultData();" class="ddm_field_border" >
                                                                                                                                        <%
                                                                                                                                            if (logType == null || (logType != null && logType.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colLogType != null && colLogType.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (LogType logtype : colLogType)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=logtype.getTypeId()%>" <%=(logType != null && logtype.getTypeId().equals(logType)) ? "selected" : ""%> > <%=logtype.getDescription()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                  <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No log type details available.</span>
                                                                                                                                    <%  }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }

                                                                                                                                    %>                                                                                                        </td>

                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Log Date :</td>
                                                                                                                                <td align="left" valign="top" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromLogDate" id="txtFromLogDate" type="text" onFocus="this.blur()" class="tcal" size="8" value="<%=(fromLogDate == null || fromLogDate.equals("0") || fromLogDate.equals(DDM_Constants.status_all)) ? "" : fromLogDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToLogDate" id="txtToLogDate" type="text" onFocus="this.blur()" class="tcal" size="8" value="<%=(toLogDate == null || toLogDate.equals("0") || toLogDate.equals(DDM_Constants.status_all)) ? "" : toLogDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Reset Dates &nbsp;&nbsp;" type="button" onClick="resetDates()" class="ddm_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text"><!--Inward Branch : -->Log Text :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><input name="txtLogText" type="text" id="txtLogText" size="73" maxlength="73" class="ddm_field_border" value="<%=logText%>" onFocus="clearResultData();"></td>
                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="ddm_tbl_footer_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /><input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="ddm_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="&nbsp;&nbsp; Search &nbsp;&nbsp;" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    frmViewLogDetails.submit()"  class="ddm_custom_button"/></td>
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
                                                                                                    <td>
                                                                                                        <%
                                                                                                            if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                                            {

                                                                                                        %>

                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%                                                                                                                if (totalRecordCount == 0)
                                                                                                                {

                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                            </tr>

                                                                                                            <%                                                                                               }
                                                                                                            else if (colResult.size() > DDM_Constants.maxWebRecords)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="ddm_error">Sorry! log Details view prevented due to too many records. (Max Viewable Records Count - <%=DDM_Constants.maxWebRecords%> , Current Records Count - <%=colResult.size()%>,   This can be lead to memory overflow in your machine.)<br/>Please refine your search criteria and Search again.</div></td>
                                                                                                            </tr>


                                                                                                            <%   }
                                                                                                            else
                                                                                                            {

                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="resultdata">
                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td align="right">

                                                                                                                                    <table width="100%" border="0" cellpadding="3" cellspacing="0" class="ddm_table_boder_print">
                                                                                                                                        <tr >
                                                                                                                                            <td width="25" align="right" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                  <td align="right" class="ddm_tbl_footer_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right" valign="middle" class="ddm_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16" /> 													<%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>

                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><select class="ddm_field_border_number" name="cmbPageNo" id="cmbPageNo" onChange="setReqPageNoForCombo()">
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                                                    {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                            </select></td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                                            <%}
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)" /><%}%> </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>

                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="center">
                                                                                                                                
                                                                                                                                
                                                                                                                                
                                                                                                                                <table class="ddm_table_boder_result" cellspacing="1" cellpadding="4" >
                                                                                                                                        <thead>
                                                                                                                                        <tr>
                                                                                                                                            <th align="right"></th>
                                                                                                                                            <th align="center">Log Type</th>
                                                                                                                                            <th align="center">Detail</th>
                                                                                                                                            <th align="center">Time</th>
                                                                                                                                        </tr>
                                                                                                                                        </thead>
                                                                                                                                        <tbody>
                                                                                                                                        <%
                                                                                                                                            int rowNum = 0;

                                                                                                                                            for (Log log : colResult)
                                                                                                                                            {
                                                                                                                                                rowNum++;


                                                                                                                                        %>

                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" ><%=rowNum%>.</td>
                                                                                                                                            <td ><%=log.getLogTypeDesc()%></td>
                                                                                                                                            <td ><%=log.getLogValue()%></td>
                                                                                                                                            <td align="center" nowrap><%=log.getLogtime()%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        </tbody>
                                                                                                                                        <tfoot>
                                                                                                                                        <tr><td></td><td></td><td></td><td></td></tr>
                                                                                                                                        </tfoot>
                                                                                                                                  </table>
                                                                                                                                
                                                                                                                              </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right">

                                                                                                                                    <table width="100%" border="0" cellpadding="3" cellspacing="0" class="ddm_table_boder_print">
                                                                                                                                  <tr >
                                                                                                                                            <td width="25" align="right" bgcolor="#DFE0E1" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                            <td align="right" bgcolor="#DFE0E1" class="ddm_tbl_footer_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right" valign="middle" class="ddm_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16"  /> 													<%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>

                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><select class="ddm_field_border_number" name="cmbPageNo2" id="cmbPageNo2" onChange="setReqPageNoForCombo2()">
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                                                    {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                            </select></td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                                            <%}
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)"/><%}%> </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                      </tr>
                                                                                                                                    </table>

                                                                                                                              </td>
                                                                                                                            </tr>
                                                                                                                        </table>

                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }
                                                                                                            %>
                                                                                                        </table>
                                                                                                        <%
                                                                                                            }
                                                                                                        %>

                                                                                                    </td>
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
