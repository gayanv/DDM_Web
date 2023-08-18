<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.calendar.*" errorPage="../../../error.jsp"%>
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Add New Calendar Year' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Add_New_Calendar_Year");
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
    String isReq = null;
    String year = null;
    String msg = null;

    Collection<String> colAvailableYears = null;

    boolean result = false;

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";

        colAvailableYears = DAOFactory.getBCMCalendarDAO().getAvailableYears();
    }
    else if (isReq.equals("1"))
    {
        year = request.getParameter("cmbYear");

        BCMCalendarDAO calendarDAO = DAOFactory.getBCMCalendarDAO();

        result = calendarDAO.addBulkCalendarDetails(year, session_userName);

        if (!result)
        {
            msg = calendarDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_calendar_maintenance_add_calendar_year, "| Year - " + year + " | Process Status - Unsuccess (" + msg + ") | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            msg = calendarDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_calendar_maintenance_add_calendar_year, "| Year - " + year + " | Process Status - Success (" + msg + ") | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }

        colAvailableYears = DAOFactory.getBCMCalendarDAO().getAvailableYears();
    }
%>


<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - Add New Calendar Year</title>
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


            function clearRecords_onPageLoad()
            { 
            showClock(3);                
            }

            function clearRecords()
            {
            document.getElementById('txtDate').value = "";
            document.getElementById('cmbType').selectedIndex = 0;
            document.getElementById('cmbCategory').selectedIndex = 0;				
            document.getElementById('txtaRemarks').value = "";
            document.getElementById('hdnReq').value = "0";
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

            function fieldValidation()
            {
            document.frmAddBulkCalendarDetail.action="AddCalendarYear.jsp";
            document.frmAddBulkCalendarDetail.submit();
            return true;

            }

            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            }

            function showDivisionArea()
            {        
            if('<%=isReq%>' == '0')
            {
            // alert("isReq");
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'none';                    
            }
            else 
            {
            if('<%=result%>' == 'true')
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            else
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error') != null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }
            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            else
            {
            document.getElementById('hdnReq').value = "0";
            }			
            }		



            function addBulkCalDetailSubmit()
            {
            isRequest(true);                    
            fieldValidation();			
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

        </script>
    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="clearRecords_onPageLoad()">
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Add Calendar Year</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">
                                                                                            <form method="post" name="frmAddBulkCalendarDetail" id="frmAddBulkCalendarDetail">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                Calendar Details Updated Sucessfully. <span class="ddm_success"><%=msg%></span>


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="ddm_Display_Error_msg" >Calendar Details Updating Failed.- <span class="ddm_error"><%=msg%></span></div>
                                                                                                                <%                                                                                            }
                                                                                                                %>
                                                                                                            <input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" />
                                                                                                            <%
                                                                                                                }
                                                                                                            %></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">








                                                                                                            <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td>




                                                                                                                        <table border="0" cellspacing="0" cellpadding="0" >
                                                                                                                            <tr>
                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                        <tr>
                                                                                                                                            <td width="60" align="right" valign="middle" class="ddm_tbl_header_text">Year <span class="ddm_required_field">*</span>  :        </td>

                                                                                                                                            <td  align="left" valign="middle"class="ddm_tbl_common_text" style="min-width:120;"><%
                                                                                                                                                try
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <select name="cmbYear" id="cmbYear" onChange="isSearchRequest(false)" class="ddm_field_border" onFocus="hideMessage_onFocus()">

                                                                                                                                                    <%
                                                                                                                                                        if (colAvailableYears != null && colAvailableYears.size() > 0)
                                                                                                                                                        {
                                                                                                                                                            for (int i = 2012; i <= 2050; i++)
                                                                                                                                                            {
                                                                                                                                                                boolean notOkToPrint = false;

                                                                                                                                                                for (String avYear : colAvailableYears)
                                                                                                                                                                {
                                                                                                                                                                    if (Integer.parseInt(avYear) == i)
                                                                                                                                                                    {
                                                                                                                                                                        notOkToPrint = true;
                                                                                                                                                                    }
                                                                                                                                                                }

                                                                                                                                                                if (!notOkToPrint)
                                                                                                                                                                {


                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=i%>"> <%=i%></option>
                                                                                                                                                    <%

                                                                                                                                                            }

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

                                                                                                                                                %></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text">                                                                                                                      
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right"><input type="button" value="&nbsp;&nbsp; Add &nbsp;&nbsp;" name="btnAdd" class="ddm_custom_button" onClick="addBulkCalDetailSubmit()"/></td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Clear &nbsp;&nbsp;" type="button" onClick="clearRecords()" class="ddm_custom_button" />                                                            </td></tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>










                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>


                                                                                            </form>

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
