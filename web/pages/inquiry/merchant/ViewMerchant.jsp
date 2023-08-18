
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
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
    String session_merchantId = null;
    String session_merchantName = null;
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - View Merchant Details (Admin)' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_Merchant_Details_By_Admin");
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
    
    String bankCode = null;
    String branchCode = null;
    String merchantStatus = null;    

    bankCode = (String) request.getParameter("cmbBank");
    branchCode = (String) request.getParameter("cmbBranch");
    merchantStatus = (String) request.getParameter("rbStatus");    

    Collection<Bank> colBank= null;
    Collection<Branch> colBranch = null;
    Collection<Merchant> colMerchant = null;
    
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    if (merchantStatus != null)
    {
        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            bankCode = session_bankCode;
            branchCode = session_branchId;            
        }
        else if(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
        {
            bankCode = session_bankCode;
        }
        else
        {
        }
        
        colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, DDM_Constants.status_pending);
        colMerchant = DAOFactory.getMerchantDAO().getMerchantBasicDetails(merchantStatus, bankCode, branchCode);
        
        String merchantStatusDesc = merchantStatus.equals(DDM_Constants.status_active) ? "Active" : merchantStatus.equals(DDM_Constants.status_deactive) ? "Inactive" : merchantStatus.equals(DDM_Constants.status_pending) ? "Pending" : merchantStatus.equals(DDM_Constants.status_all) ? "All" : "N/A";
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_view_merchant_details, "| Search Criteria - (Merchant Status : " + merchantStatusDesc + ", Branch : " + branchCode + ") | Result Count - " + colMerchant.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }
    else
    {
        if ( session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            bankCode = session_bankCode;
            branchCode = session_branchId;
            merchantStatus = DDM_Constants.status_all;
        }
        else if(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
        {
            bankCode = session_bankCode;
            branchCode = DDM_Constants.status_all;
            merchantStatus = DDM_Constants.status_all;
        }
        else
        {
            bankCode = DDM_Constants.status_all;
            branchCode = DDM_Constants.status_all;
            merchantStatus = DDM_Constants.status_all;
        }

        colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, DDM_Constants.status_pending);
        colMerchant = DAOFactory.getMerchantDAO().getMerchantBasicDetails(merchantStatus, bankCode, branchCode);
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_view_merchant_details, "| Search Criteria - (Merchant Status : All, Bank : " + bankCode + ", Branch : " + branchCode + ") | Result Count - " + colMerchant.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }
%>


<html>
    <head>
    <title>LankaPay Direct Debit Mandate Exchange System - View Merchant Details</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tcal.css" rel="stylesheet" type="text/css" />      
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


            function doViewMoreDetails(rowVal)
            {
            var objMerchantID = "hdnMerchantID_" + rowVal;

            document.getElementById('hdnMerchantID').value = document.getElementById(objMerchantID).value;                    

            document.frmViewMoreDetails.submit();
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
                                                                                                                <td class="ddm_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_merchantId : session_branchId%> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_merchantName : session_branchName%></td>
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View Merchant Details</td>
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
                                                                                                    <td height="15" align="center" valign="middle">
                                                                                                    
                                                                                                    <form name="frmViewMerchant" method="post" action="ViewMerchant.jsp">
                                                                                                    <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                            <tr>
                                                                                                                <td align="center" valign="middle">





                                                                                                                    


                                                                                                                        <table  border="0" cellspacing="1" cellpadding="4" >
                                                                                                                            <tr>
                                                                                                                              <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Bank :</td>
                                                                                                                              <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="frmViewMerchant.submit()" <%=(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (bankCode == null || (bankCode != null && bankCode.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bk : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bk.getBankCode() %>" <%=(bankCode != null && bk.getBankCode().equals(bankCode)) ? "selected" : ""%> > <%=bk.getBankCode() + " - " + bk.getBankFullName() %></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No bank details available.</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Branch :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBranch" id="cmbBranch" class="ddm_field_border" onChange="frmViewMerchant.submit()" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (branchCode == null || (branchCode != null && branchCode.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colBranch != null && colBranch.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Branch branch : colBranch)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(branchCode != null && branch.getBranchCode().equals(branchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No branch details available.</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text"> Merchant Status :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><table  border="0" cellpadding="0" cellspacing="0" >
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_all%>" id="rbAll" onClick="frmViewMerchant.submit()" <%=(merchantStatus == null || (merchantStatus != null && merchantStatus.equals(DDM_Constants.status_all))) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">All</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_active%>" id="rbActive" onClick="frmViewMerchant.submit()" <%=(merchantStatus != null && merchantStatus.equals(DDM_Constants.status_active)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Active</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_deactive%>" id="rbDeactive" onClick="frmViewMerchant.submit()" <%=(merchantStatus != null && merchantStatus.equals(DDM_Constants.status_deactive)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Inactive</td>
                                                                                                                                          <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=DDM_Constants.status_pending%>" id="rbPending" onClick="frmViewMerchant.submit()" <%=(merchantStatus != null && merchantStatus.equals(DDM_Constants.status_pending)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="ddm_common_text_bold_large">Pending</td>
                                                                                                                                  </tr>
                                                                                                                                    </table>                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                  
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                        
                                                                                                        </form>
                                                                                                        
                                                                                                        
                                                                                                        </td>
                                                                                                </tr>
                                                                                                <tr><td height="15"></td>
                                                                                                </tr>

                                                                                                <%
                                                                                                    int col_size = colMerchant.size();

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
                                                                                                        <table border="0" cellspacing="1" cellpadding="4" class="ddm_table_boder_result">
                                                                                                            <thead>
                                                                                                            <tr>
                                                                                                                <th ></th>
                                                                                                                <th align="center" valign="middle" >Merchant<br>ID</th>
                                                                                                                <th align="center" valign="middle" >Merchant<br>Name</th>
                                                                                                                <th align="center" valign="middle" >Email</th>
                                                                                                                <th align="center" valign="middle" >Primary<br/>Contact No.</th>
                                                                                                                <th align="center" valign="middle" >Secondary<br/>Contact No.</th>
                                                                                                                <th align="center" valign="middle" >Bank</th>
                                                                                                                <th align="center" valign="middle" >Branch</th>
                                                                                                                <th align="center" valign="middle" >Primary<br/>Acc. No.</th>
                                                                                                                <th align="center" valign="middle" >Primary<br/>Acc. Name</th>
                                                                                                                <th align="center" valign="middle" >ID</th>
                                                                                                                <th align="center" valign="middle" >Status</th>
                                                                                                                <th align="center" >&nbsp;</th>
                                                                                                            </tr>
                                                                                                            </thead>
                                                                                                            <tbody>
                                                                                                            
                                                                                                            
                                                                                                            <%
                                                                                                                int rowNum = 0;
                                                                                                                for (Merchant merchant : colMerchant)
                                                                                                                {
                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                              <td align="right" ><%=rowNum%>.</td>
                                                                                                                <td align="center" ><%=merchant.getMerchantID()%></td>
                                                                                                                <td ><%=merchant.getMerchantName() != null ? merchant.getMerchantName() : "N/A"%></td>
                                                                                                                <td ><%=merchant.getEmail() != null ? merchant.getEmail() : "N/A"%></td>
                                                                                                                <td ><%=merchant.getPrimaryTP() != null ? merchant.getPrimaryTP() : "N/A"%></td>
                                                                                                                <td ><%=merchant.getSecondaryTP() != null ? merchant.getSecondaryTP() : "N/A"%></td>
                                                                                                                <td  title="<%=merchant.getBankCode() %> - <%=merchant.getBankName() %>"><%=merchant.getBankCode() %> - <%=merchant.getBankShortName() %></td>
                                                                                                                <td nowrap  title="<%=merchant.getBranchCode() %> - <%=merchant.getBranchName() %>"><%=merchant.getBranchCode() %> - <%=merchant.getBranchName().length() > 10 ? (merchant.getBranchName().substring(0, 8) + "..") : merchant.getBranchName()%></td>
                                                                                                                <td ><%=merchant.getPrimaryAccountNo() != null ? merchant.getPrimaryAccountNo() : "N/A"%></td>
                                                                                                              <td ><%=merchant.getPrimaryAccountName()!= null ? merchant.getPrimaryAccountName(): "N/A"%></td>
                                                                                                              <td ><%=merchant.getId()!= null ? merchant.getId(): "N/A"%></td>
                                                                                                                <td ><%=merchant.getStatus() != null ? merchant.getStatus().equals(DDM_Constants.status_active) ? "Active" : merchant.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                              <td align="center"  ><input name="hdnMerchantID_<%=rowNum%>" id="hdnMerchantID_<%=rowNum%>" type="hidden" value="<%=merchant.getMerchantID()%>"  ><input type="button" name="btnConfirm" id="btnConfirm" value="&nbsp;&nbsp; View More &nbsp;&nbsp;" alt="View more details about corporate customer" class="ddm_custom_button_small" onClick="doViewMoreDetails(<%=rowNum%>)" width="30"></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }


                                                                                                            %>
                                                                                                            </tbody>
                                                                                                                                        <tfoot>
                                                                                                                                        <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                                                                                                        </tfoot>
                                                                                                            
                                                                                                        </table>

                                                                                                        <form method="post" name="frmViewMoreDetails" id="frmViewMoreDetails" action="ViewMoreDetails.jsp" ><input name="hdnMerchantID" id="hdnMerchantID" type="hidden"><input name="hdnMerchantStatus" id="hdnMerchantStatus" type="hidden" value="<%=merchantStatus%>"  >
                                                                                                        </form>

                                                                                                  </td>
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
    
    <script language="javascript">floatItem("GotoDown",40,40,"right",2,"top",125);</script>
    <script language="javascript">floatItem("GotoTop",40,40,"right",2,"bottom",25);</script>
    
</html>
<%        }
    }
%>