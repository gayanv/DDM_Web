<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.calendar.BCMCalendar" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
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
    String year = null;
    String month = null;
    String day = null;
    String type = null;

    Collection<String> colAvailableYears = null;
    Collection<BCMCalendar> colCalendar = null;

    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colAvailableYears = DAOFactory.getBCMCalendarDAO().getAvailableYears();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        year = "" + customDate.getYear();
        month = DDM_Constants.status_all;
        day = DDM_Constants.status_all;
        type = DDM_Constants.status_all;

    }
    else if (isSearchReq.equals("1"))
    {

        year = (String) request.getParameter("cmbYear");
        month = (String) request.getParameter("cmbMonth");
        day = (String) request.getParameter("cmbDay");
        type = (String) request.getParameter("cmbType");

        //System.out.println("year - " + year + "    month - " + month + "    day - " + day + "    type - " + type);
        colCalendar = DAOFactory.getBCMCalendarDAO().getCalendarDetails(year, month, day, type);;

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_calendar_maintenance_view_calendar_details, "| Search Criteria - (Year : " + year + " Month : " + month + " Day : " + day + " Type : " + type + ") | Result Count - " + colCalendar.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }


%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - View Calendar Details</title>
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/tableenhance.js"></script>
        
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

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else 
            {document.getElementById('hdnSearchReq').value = "0";
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View Calendar Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text">
                                                                                            <form id="frmViewCalendar" name="frmViewCalendar" method="post" action="ViewCalendarDetails.jsp" >
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top" >

                                                                                                            <table border="0" cellpadding="5" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text" > Year :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text" ><%
                                                                                                                        try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="cmbYear" id="cmbYear" onChange="isSearchRequest(false);
                                                                                                                                        clearResultData()" class="ddm_field_border" >

                                                                                                                            <%
                                                                                                                                if (colAvailableYears != null && colAvailableYears.size() > 0)
                                                                                                                                {
                                                                                                                                    for (String avYear : colAvailableYears)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=avYear%>" <%=(year != null && avYear.equals(year)) ? "selected" : ""%> > <%=avYear%></option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="ddm_error">No Years details available.</span>
                                                                                                                        <%  }

                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }

                                                                                                                        %>                                                                                            </td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Month  :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text" >
                                                                                                                        <select name="cmbMonth" id="cmbMonth" class="ddm_field_border" onChange="clearResultData();">
                                                                                                                            <% %>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" <%=(month != null && month.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="1" <%=(month != null && month.equals("1")) ? "selected" : ""%>>01 - January</option>
                                                                                                                            <option value="2" <%=(month != null && month.equals("2")) ? "selected" : ""%>>02 - February</option>
                                                                                                                            <option value="3" <%=(month != null && month.equals("3")) ? "selected" : ""%>>03 - March</option>
                                                                                                                            <option value="4" <%=(month != null && month.equals("4")) ? "selected" : ""%>>04 - April</option>
                                                                                                                            <option value="5" <%=(month != null && month.equals("5")) ? "selected" : ""%>>05 - May</option>
                                                                                                                            <option value="6" <%=(month != null && month.equals("6")) ? "selected" : ""%>>06 - June</option>
                                                                                                                            <option value="7" <%=(month != null && month.equals("7")) ? "selected" : ""%>>07 - July</option>
                                                                                                                            <option value="8" <%=(month != null && month.equals("8")) ? "selected" : ""%>>08 - August</option>
                                                                                                                            <option value="9" <%=(month != null && month.equals("9")) ? "selected" : ""%>>09 - September</option>
                                                                                                                            <option value="10" <%=(month != null && month.equals("10")) ? "selected" : ""%>>10 - October</option>
                                                                                                                            <option value="11" <%=(month != null && month.equals("11")) ? "selected" : ""%>>11 - November</option>
                                                                                                                            <option value="12" <%=(month != null && month.equals("12")) ? "selected" : ""%>>12 - December</option>
                                                                                                                        </select></td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text" >Day :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text" ><select name="cmbDay" id="cmbDay" class="ddm_field_border" onChange="clearResultData();">
                                                                                                                            <%%>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" <%=(day != null && day.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <%
                                                                                                                                for (int i = 1; i < 32; i++)
                                                                                                                                {
                                                                                                                                    if (i < 10)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=day.equals("" + i) ? "selected" : ""%>><%="0" + i%></option>
                                                                                                                            <%
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=day.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                        <%
                                                                                                                                    }
                                                                                                                                }%>
                                                                                                                        </select></td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text" >Type :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text" ><select name="cmbType" id="cmbType" class="ddm_field_border" onChange="clearResultData();">                                                                                                    
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" <%=(type != null && month.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="<%=DDM_Constants.calendar_day_type_fbd%>" <%=(type != null && type.equals(DDM_Constants.calendar_day_type_fbd)) ? "selected" : ""%>><%=DDM_Constants.calendar_day_type_fbd%></option>
                                                                                                                            <option value="<%=DDM_Constants.calendar_day_type_nbd%>" <%=(type != null && type.equals(DDM_Constants.calendar_day_type_nbd)) ? "selected" : ""%>><%=DDM_Constants.calendar_day_type_nbd%></option>
                                                                                                                            <option value="<%=DDM_Constants.calendar_day_type_pbd%>" <%=(type != null && type.equals(DDM_Constants.calendar_day_type_pbd)) ? "selected" : ""%>><%=DDM_Constants.calendar_day_type_pbd%></option>
                                                                                                                        </select></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="8" align="right" valign="middle" bgcolor="#CDCDCD" class="ddm_tbl_footer_text" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                <td align="center">                                                                                                                     
                                                                                                                                    <div id="clickSearch" class="ddm_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input name="btnSearch" id="btnSearch" value="&nbsp;&nbsp; Search &nbsp;&nbsp;" type="button" onClick="isSearchRequest(true);
                                                                                                                                        frmViewCalendar.submit()"  class="ddm_custom_button"/></td>
                                                                                                                            </tr></table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                </table>


                                                                                            </form>
                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>

                                                                                        <td align="center" valign="top">
                                                                                            <table>
                                                                                                <% if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                                    {

                                                                                                        if (colCalendar.isEmpty())
                                                                                                        {

                                                                                                %>
                                                                                                <tr>
                                                                                                    <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td class="ddm_header_text" align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                </tr>
                                                                                                <%                                                                        }
                                                                                                else
                                                                                                {

                                                                                                %>
                                                                                                <tr>
                                                                                                    <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                </tr>

                                                                                                <td> 

                                                                                                    <div id="resultdata">
                                                                                                        <table border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                            <tr bgcolor="#A4B7CA" class="ddm_tbl_header_text" align="center">
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal"></th>

                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Date</th>
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Day Name</th>
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Type</th>
                                                                                                                <!--th>Category</th-->
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Remarks</th>
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Last<br/>
                                                                                                                    Modified By</th>
                                                                                                                <th bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">Last<br/>
                                                                                                                    Modified Date</th>
                                                                                                            </tr>
                                                                                                            <%                                                                                                                int rowNum = 0;
                                                                                                                for (BCMCalendar cal : colCalendar)
                                                                                                                {
                                                                                                                    rowNum++;

                                                                                                                    //System.out.println("window.getBankcode() ---> " + window.getBankcode());

                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">


                                                                                                                <td align="right" class="ddm_common_text" ><%=rowNum%>.</td>

                                                                                                                <td align="center" class="ddm_common_text"><%=cal.getCalenderDate()%></td>
                                                                                                                <td class="ddm_common_text"><%=cal.getDay()%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=cal.getDayType()%></td>
                                                                                                                  <!--td align="center" class="ddm_common_text"><%=cal.getDayCategory()%></td-->
                                                                                                                <td class="ddm_common_text"><%=cal.getRemarks() == null || cal.getRemarks().length() <= 0 ? "N/A" : cal.getRemarks()%></td>
                                                                                                                <td class="ddm_common_text"><%=cal.getModifiedby() == null || cal.getModifiedby().length() <= 0 ? "N/A" : cal.getModifiedby()%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=cal.getModifieddate() == null || cal.getModifieddate().length() <= 0 ? "N/A" : cal.getModifieddate()%></td>
                                                                                                          </tr>
                                                                                                            <% }%>
                                                                                                        </table>
                                                                                                    </div>

                                                                                                </td></tr>
                                                                                                <%
                                                                                                        }

                                                                                                    }
                                                                                                %>


                                                                                </table>


                                                                            </td>


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
