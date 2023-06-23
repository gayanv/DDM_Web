
<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../../error.jsp"%>

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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - View Bank (Admin)' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_Bank_Admin");
            }
        }
        else
        {


%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    ParameterDAO para_dao = DAOFactory.getParameterDAO();
    Collection<Parameter> col = para_dao.getAllParamterValues();

    String bankStatus = (String) request.getParameter("rbStatus");

    Collection<Bank> col_bank = null;

    if (bankStatus != null)
    {
        col_bank = DAOFactory.getBankDAO().getBank(bankStatus);
        String bankStatusDesc = bankStatus.equals(DDM_Constants.status_active) ? "Active" : bankStatus.equals(DDM_Constants.status_deactive) ? "Deactive" : bankStatus.equals(DDM_Constants.status_all) ? "All" : "N/A";
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_view_bank_details, "| Search Criteria - (Bank Status : " + bankStatusDesc + ") | Result Count - " + col_bank.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {
        col_bank = DAOFactory.getBankDAO().getBank(DDM_Constants.status_all);
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_view_bank_details, "| Search Criteria - (Bank Status : All) | Result Count - " + col_bank.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - View Bank</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>

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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View Bank Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">


                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td height="15" align="center" valign="middle"><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                                            <tr>
                                                                                                                <td align="center" valign="middle">





                                                                                                                    <form name="frmBankFilter" method="post" action="ViewBank.jsp">


                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="ddm_table_boder" bgcolor="#FFFFFF" align="center">
                                                                                                                            <tr>
                                                                                                                                <td width="80" align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text"> Bank Status</td>
                                                                                                                                <td width="" align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><table  border="0" cellpadding="0" cellspacing="0" >
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_all%>" id="rbAll" onClick="frmBankFilter.submit()" <%=(bankStatus == null || (bankStatus != null && bankStatus.equals(DDM_Constants.status_all))) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">All</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_active%>" id="rbActive" onClick="frmBankFilter.submit()" <%=(bankStatus != null && bankStatus.equals(DDM_Constants.status_active)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Active</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_deactive%>" id="rbDeactive" onClick="frmBankFilter.submit()" <%=(bankStatus != null && bankStatus.equals(DDM_Constants.status_deactive)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Inactive</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_pending%>" id="rbPending" onClick="frmBankFilter.submit()" <%=(bankStatus != null && bankStatus.equals(DDM_Constants.status_pending)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Pending</td>
                                                                                                                                  </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </form>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <tr><td height="15"></td>
                                                                                                </tr>

                                                                                                <%
                                                                                                    int col_size = col_bank.size();

                                                                                                    if (col_size == 0)
                                                                                                    {
                                                                                                %>
                                                                                                <tr><td colspan="4" align="center" class="ddm_header_small_text">No records Available !</td>
                                                                                                </tr>
                                                                                                <%}
                                                                                                else
                                                                                                {%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="middle">
                                                                                                        <table class="ddm_table_boder_result" cellspacing="1" cellpadding="4" >
                                                                                                            <thead>
                                                                                                            <tr>
                                                                                                                <th class="ddm_tbl_header_text_horizontal_small"></th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Bank Code</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Short Name<br>
                                                                                                                    (Current)</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Short Name<br>
                                                                                                                    (Modified)</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Full Name<br>
                                                                                                                    (Current)</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Full Name<br>
                                                                                                                    (Modified)</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Status<br>
                                                                                                                    (Current)</th>
                                                                                                                <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal_small">Status<br>
                                                                                                                    (Modified)</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Created<br>
                                                                                                                    By</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Created<br>
                                                                                                                    Time</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Authorized<br>
                                                                                                                    By</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Authorized<br>
                                                                                                                    Time</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Modified<br>
                                                                                                                    By</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Modified<br>
                                                                                                                    Time</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Modification<br>
                                                                                                                    Authorized<br>
                                                                                                                    By</th>
                                                                                                                <th align="center" class="ddm_tbl_header_text_horizontal_small">Modification<br>
                                                                                                                    Authorized<br>
                                                                                                                    Time</th>
                                                                                                            </tr>
                                                                                                            </thead>
                                                                                                            <tbody>
                                                                                                            <%
                                                                                                                int rowNum = 0;
                                                                                                                for (Bank b : col_bank)
                                                                                                                {
                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                <td align="center" class="ddm_common_text"><%=b.getBankCode() != null ? b.getBankCode() : "N/A"%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=b.getShortName() != null ? b.getShortName() : "N/A"%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=b.getShortNameModify() != null ? b.getShortNameModify() : "N/A"%></td>
                                                                                                                <td align="left" class="ddm_common_text"><%=b.getBankFullName() != null ? b.getBankFullName() : "N/A"%></td>
                                                                                                                <td align="left" class="ddm_common_text"><%=b.getBankFullNameModify() != null ? b.getBankFullNameModify() : "N/A"%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=b.getStatus() != null ? b.getStatus().equals(DDM_Constants.status_active) ? "Active" : b.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                                <td align="center" class="ddm_common_text"><%=b.getStatusModify() != null ? b.getStatusModify().equals(DDM_Constants.status_active) ? "Active" : b.getStatusModify().equals(DDM_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                                <td  class="ddm_common_text"><%=b.getCreatedBy() != null ? b.getCreatedBy() : "N/A"%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=b.getCreatedDate() != null ? b.getCreatedDate() : "N/A"%></td>
                                                                                                                <td  class="ddm_common_text"><%=b.getAuthorizedBy() != null ? b.getAuthorizedBy() : "N/A"%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=b.getAuthorizedDate() != null ? b.getAuthorizedDate() : "N/A"%></td>
                                                                                                                <td  class="ddm_common_text"><%=b.getModifiedBy() != null ? b.getModifiedBy() : "N/A"%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=b.getModifiedDate() != null ? b.getModifiedDate() : "N/A"%></td>
                                                                                                                <td  class="ddm_common_text"><%=b.getModificationAuthBy() != null ? b.getModificationAuthBy() : "N/A"%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=b.getModificationAuthDate() != null ? b.getModificationAuthDate() : "N/A"%></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }


                                                                                                            %>
                                                                                                            </tbody>
                                                                                                        </table>                                                                            </td>
                                                                                                </tr>

                                                                                                <%                                                                            }

                                                                                                %>


                                                                                            </table>                                                        </td>
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
<%        }
    }
%>