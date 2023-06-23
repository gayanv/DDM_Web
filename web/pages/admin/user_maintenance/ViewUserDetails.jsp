<%@page import="java.util.*,java.sql.*"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter"  %>
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - View User Details' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_User_Details");
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
    Collection<UserLevel> col_usrList = DAOFactory.getUserLevelDAO().getUserLevelDetails();

    String usrlvl = request.getParameter("cmbUsrLvl");

    if (usrlvl == null)
    {
        usrlvl = DDM_Constants.status_all;
    }

    UserLevel userLevel = DAOFactory.getUserLevelDAO().getUserLevel(usrlvl);

    Collection<User> colUser = DAOFactory.getUserDAO().getUserList(usrlvl);
    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_view_user_details, "| Search Criteria - (User Level : " + (userLevel != null ? userLevel.getUserLevelDesc() : "All") + ") | Result Count - " + colUser.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - View User Details</title>
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
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>

        <script language="javascript" type="text/JavaScript">




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
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** SLIPS ****</div>
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View User Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top" class="ddm_header_text"><form name="frmUserFilter"  id="frmUserFilter" method="post" action="ViewUserDetails.jsp">
                                                                                                <table class="ddm_table_boder" cellspacing="0" cellpadding="0" border="0">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                <tr>
                                                                                                                    <td width="80" align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text"> User Level :</td>
                                                                                                                    <td width="" align="left" valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"><select name="cmbUsrLvl" class="ddm_field_border" id="cmbUsrLvl" onChange="frmUserFilter.submit()">
                                                                                                                            <%
                                                                                                                                if (usrlvl == null || usrlvl.equals(DDM_Constants.status_all))
                                                                                                                                {%>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                            <%}
                                                                                                                            else
                                                                                                                            {%>
                                                                                                                            <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                            <%  }
                                                                                                                                if (col_usrList != null && col_usrList.size() > 0)
                                                                                                                                {

                                                                                                                                    for (UserLevel u : col_usrList)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=u.getUserLevelId()%>" <%=(usrlvl != null && u.getUserLevelId().equals(usrlvl)) ? "selected" : ""%> > <%=u.getUserLevelDesc()%> </option>
                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <%}%></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td align="center" valign="top"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table  border="0" cellspacing="0" cellpadding="0" >
                                                                                                <%
                                                                                                    if (colUser.size() > 0)
                                                                                                    {


                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center"><table  border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" >
                                                                                                            <tr>
                                                                                                                <td><table  border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small"></td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">User ID</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">User<br/>
                                                                                                                                Level</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Branch</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">CoCu<br/>ID</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Name</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Designation</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">E-Mail</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Contact<br/>
                                                                                                                                No.</td>
                                                                                                                            <!--td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Branch</td-->
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Status</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Last Login<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Created<br/>
                                                                                                                                By</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Created<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Modified<br/>
                                                                                                                                By</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Modified<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">PWD Reset<br/>
                                                                                                                                Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal_small">Init.<br/>
                                                                                                                                PWD</td>
                                                                                                                        </tr>
                                                                                                                        <%                                                                                                                            int rowNum = 0;
                                                                                                                            for (User usr : colUser)
                                                                                                                            {
                                                                                                                                rowNum++;

                                                                                                                                String userStat = null;

                                                                                                                                if (usr.getStatus() != null)
                                                                                                                                {
                                                                                                                                    if (usr.getStatus().equals(DDM_Constants.status_active))
                                                                                                                                    {
                                                                                                                                        userStat = "Active";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(DDM_Constants.status_deactive))
                                                                                                                                    {
                                                                                                                                        userStat = "Inactive";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(DDM_Constants.status_locked))
                                                                                                                                    {
                                                                                                                                        userStat = "Locked";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(DDM_Constants.status_expired))
                                                                                                                                    {
                                                                                                                                        userStat = "Expired";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(DDM_Constants.status_pending))
                                                                                                                                    {
                                                                                                                                        userStat = "Pending";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    userStat = "N/A";
                                                                                                                                }


                                                                                                                        %>
                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                            <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                            <td class="ddm_common_text"><%=usr.getUserId()%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=usr.getUserLevelDesc()%></td>
                                                                                                                            <td align="left" nowrap class="ddm_common_text"><%=usr.getBranchCode() %> - <%=usr.getBranchName()  %></td>
                                                                                                                            <td align="center" class="ddm_common_text"><span class="ddm_common_text" title="<%=usr.getCoCuName() %>"><%=usr.getCoCuId()!=null?usr.getCoCuId():"-" %></span></td>
                                                                                                                          <td class="ddm_common_text"><%=usr.getName() != null ? usr.getName() : "N/A"%></td>
                                                                                                                            <td class="ddm_common_text"><%=usr.getDesignation() != null ? usr.getDesignation() : "N/A"%></td>
                                                                                                                            <td class="ddm_common_text"><%=usr.getEmail() != null ? usr.getEmail() : "N/A"%></td>
                                                                                                                            <td class="ddm_common_text"><%=usr.getContactNo() != null ? usr.getContactNo() : "N/A"%></td>                                                                                                                            
                                                                                                                            <td class="ddm_common_text"><%=userStat%></td>
                                                                                                                            <td nowrap class="ddm_common_text"><%=usr.getLastSuccessfulLogin() != null ? usr.getLastSuccessfulLogin() : "N/A"%></td>
                                                                                                                            <td class="ddm_common_text"><%=usr.getCreatedBy()%></td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=usr.getCreatedDate()%></td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=(usr.getModifiedBy() != null) ? usr.getModifiedBy() : "N/A"%></td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=(usr.getModifiedDate() != null) ? usr.getModifiedDate() : "N/A"%></td>
                                                                                                                            <td align="center" nowrap class="ddm_common_text"><%=(usr.getLastPasswordResetDate() != null) ? usr.getLastPasswordResetDate() : "N/A"%></td>
                                                                                                                            <td align="center" class="ddm_common_text"><%=((usr.getIsInitialPassword() != null) && usr.getIsInitialPassword().equals(DDM_Constants.status_yes)) ? "Yes" : "No"%></td>
                                                                                                                        </tr>
                                                                                                                        <%}%>
                                                                                                              </table></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <%
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text">No Records Available!</td>
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
