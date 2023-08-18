<%@page import="java.sql.*,java.util.*,java.io.*,java.text.DecimalFormat" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequest"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userlevelfunctionmap.UserLevelFunctionMap" errorPage="../error.jsp" %>

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Cache-Control", "no-store"); //Directs caches not to store the page under any circumstance
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
        //session.invalidate();
        response.sendRedirect("sessionExpired.jsp");
    }
    else
    {
        System.out.println(" home page session_userName  ---> " + session_userName);

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

        int pwdValidityPeriod = -1;

        pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(session_userName);

        System.out.println(" pwdValidityPeriod  ---> " + pwdValidityPeriod);

        if (pwdValidityPeriod < 0)
        {
            DAOFactory.getUserDAO().setUserStatus(session_userName, DDM_Constants.status_expired, false);
            //session.invalidate();
            response.sendRedirect("pages/userAccountExpired.jsp");
        }
        else
        {
            int pwdExpireWarningDays = DDM_Constants.default_pwd_expire_warning_days;

            String strPwdExpireWarningDays = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_PwdExpireWarningDays);

            System.out.println(" strPwdExpireWarningDays  ---> " + strPwdExpireWarningDays);

            if (strPwdExpireWarningDays != null)
            {
                try
                {
                    pwdExpireWarningDays = Integer.parseInt(strPwdExpireWarningDays);
                }
                catch (Exception e)
                {
                    pwdExpireWarningDays = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                pwdExpireWarningDays = DDM_Constants.user_pwd_expire_duration;
            }

            System.out.println(" pwdExpireWarningDays  ---> " + pwdExpireWarningDays);
%>

<%
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);

    System.out.println(" After  ---> updateUserVisitStat");
%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Welcome</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../css/tcal.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/javascript">

            function showClock(type)
            {
                if (type == 1)
                {
                    clock(document.getElementById('showText'), type, null);
                } else if (type == 2)
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'), type, val);
                } else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
                    clock(document.getElementById('showText'), type, val);
                }

            }

            function checkPwdValidity(days)
            {
                if (days <= <%=pwdExpireWarningDays%>)
                {
                    if (days == 0)
                    {
                        var confirmVal = confirm("Your current password will be expired after today! Do you want to change the password?");

                        if (confirmVal == true)
                        {
                            window.location = "user/userProfile.jsp";
                        }
                    } else
                    {
                        var msg = "Your current password will be expired after " + days + " days! Do you want to change the password?";

                        var confirmVal = confirm(msg);

                        if (confirmVal == true)
                        {
                            window.location = "user/userProfile.jsp";
                        }
                    }
                }
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3);checkPwdValidity(<%=pwdValidityPeriod%>)">
        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>

        <table width="100%" style="min-width:900;min-height:600;" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
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
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** DDM ****</div>
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
                                                                                                                <td class="ddm_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuId : session_bankCode %> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuName : session_bankName %></td>
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
                                                    <td style="min-height:400" align="center" valign="top" class="ddm_bgHome">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td align="right" valign="top" class="ddm_menubar_text"><table width="200" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>

                                                                                                    <td align="right" valign="top" width="500"></td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                        <td width="10" valign="middle" nowrap class="ddm_menubar_text"></td>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">Business Date : <%=webBusinessDate%></td>
                                                                                        <td width="10" valign="middle"></td>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">|&nbsp; Now : [ <%=currentDate%></td>
                                                                                        <td width="5" valign="middle">&nbsp;</td>
                                                                                        <td valign="top" class="ddm_menubar_text_dark"><div id="showText" class="ddm_menubar_text_dark"></div></td>
                                                                                        <td width="5" valign="top" nowrap class="ddm_menubar_text_dark">&nbsp;]</td>

                                                                                        <td width="10" valign="middle"></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" valign="middle"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td height="5"></td>
                                                                          <td align="left" valign="top" ></td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="30">&nbsp;</td>
                                                                            <td align="left" valign="top" >

                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                              <tr>
                                                                                        <td align="left" valign="top"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                    <td align="left" valign="top"><table border="0" cellspacing="0" cellpadding="0">


                                                                                                            <!-- SLA Exceeded - Issuing Bank -->
                                                                                                            <tr>
                                                                                                              <td height="25" valign="top"><span class="ddm_common_text_bold_large">DDA Request Summary</span></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                              <td height="25">
                                                                                                                  <%
                                                                                                                        Collection<DDMRequest> colDDMReqSummary = null;

                                                                                                                        if (session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_administrator) || session_userType.equals(DDM_Constants.user_type_ddm_operator) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                                                                                                                        {
                                                                                                                            colDDMReqSummary = DAOFactory.getDDMRequestDAO().getDDAReqSummaryByMerchant(DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
                                                                                                                        {
                                                                                                                            colDDMReqSummary = DAOFactory.getDDMRequestDAO().getDDAReqSummaryByMerchant(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            colDDMReqSummary = DAOFactory.getDDMRequestDAO().getDDAReqSummaryByMerchant(session_cocuId, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }

                                                                                                                        if (colDDMReqSummary != null && colDDMReqSummary.size() > 0)
                                                                                                                        {
                                                                                                                    %>
                                                                                                                <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder_result2">
                                                                                                                  <thead>
                                                                                                                    <tr>
                                                                                                                        <th align="center" valign="middle" >Merchant</th>
                                                                                                                        <th align="center" valign="middle" title="Ongoing Requests" nowrap>Ongoing</th>
                                                                                                                        <th align="center" valign="middle" nowrap title="Completed Requests">Complete</th>
                                                                                                                        <th align="center" valign="middle" nowrap title="Rejected Requests">Reject</th>
                                                                                                                        <th align="center" valign="middle" nowrap title="SLA Breached Requests">SLA Bre.</th>
                                                                                                                        <th align="center" valign="middle" nowrap title="Terminated Requests">Terminate</th>
                                                                                                                    </tr>
                                                                                                                  </thead>
                                                                                                                  <tbody>
                                                                                                                    
                                                                                                                    <%
                                                                                                                                int rowNum = 0;
                                                                                                                                

                                                                                                                                for (DDMRequest ddmr : colDDMReqSummary)
                                                                                                                                {                                                                                                                            
                                                                                                                                    rowNum++;
                                                                                                                    %>
                                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                        <td align="center" class="ddm_sub_link_large">
                                                                                                                        <%
																														if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_ddm_req_issuing_bank)))
																														{
																														%>
                                                                                                                        <a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_inquiry_sla_breach_ddm_req_inquiry)%>?hdnIsSearch=1&cmbMerchant=<%=ddmr.getMerchantID()%>" title="<%=ddmr.getMerchantName() %>" class="ddm_sub_link_large"><%=ddmr.getMerchantID()%></a>
                                                                                                                        <%
																														}
																														else
																														{
																														%>
                                                                                                                        <%=ddmr.getMerchantID()%>																														
																														<%
																														}
																														%>
                                                                                                                        </td>
                                                                                                                      <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getOngoingReqCount() %></td>
                                                                                                                                  <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getCompletedReqCount() %></td>
                                                                                                                                  <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getRejectedReqCount() %></td>
                                                                                                                                  <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getSLABreachedReqCount() %></td>
                                                                                                                                  <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getTerminatedReqCount() %></td>
                                                                                                                    </tr> 
                                                                                                                    <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                  </tbody>
                                                                                                                  <tfoot>
                                                                                                                    <tr><td></td><td></td>
                                                                                                                                  <td></td>
                                                                                                                                  <td></td>
                                                                                                                                  <td></td>
                                                                                                                                  <td></td>
                                                                                                                    </tr>
                                                                                                                  </tfoot>
                                                                                                                </table>
  
                                                                                                                <%                                                                                                                       }
                                                                                                                    else
                                                                                                                    {
                                                                                                                    %> 
                                                                                                                
                                                                                                                <br/>
                                                                                                                <span class="ddm_Display_Success_msg">No Records Available!</span>
                                                                                                              <%
                                                                                                                        }
                                                                                                                    %>                                                                                                                </td>
                                                                                                      </tr>
                                                                                                            <tr>
                                                                                                              <td height="10">&nbsp;</td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td height="25" valign="top"><span class="ddm_common_text_bold_large">SLA Exceeded - Issuing Bank</span></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                <%
                                                                                                                        Collection<DDMRequest> colSLABreachIsuBK = null;

                                                                                                                        if (session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_administrator) || session_userType.equals(DDM_Constants.user_type_ddm_operator) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                                                                                                                        {
                                                                                                                            colSLABreachIsuBK = DAOFactory.getDDMRequestDAO().getSLABreachByIssuingBankDDAReqSummary(DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
                                                                                                                        {
                                                                                                                            colSLABreachIsuBK = DAOFactory.getDDMRequestDAO().getSLABreachByIssuingBankDDAReqSummary(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
                                                                                                                        {
                                                                                                                            colSLABreachIsuBK = DAOFactory.getDDMRequestDAO().getSLABreachByIssuingBankDDAReqSummary(session_cocuId, DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }

                                                                                                                        if (colSLABreachIsuBK != null && colSLABreachIsuBK.size() > 0)
                                                                                                                        {
                                                                                                                    %>
                                                                                                                    <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder_result2">
                                                                                                                        <thead>
                                                                                                                            <tr>
                                                                                                                                <th align="center" valign="middle">&nbsp; Bank &nbsp;</th>
                                                                                                                              <th align="center" valign="middle" title="Number of SLA Exceeded Requests" nowrap>&nbsp;No. Of Req.&nbsp;</th>
                                                                                                                                <th align="center" valign="middle" nowrap title="Average SLA Exceeded Days">&nbsp;Avg SLA Ex. Days&nbsp;</th>
                                                                                                                            </tr>
                                                                                                                        </thead>
                                                                                                                        <tbody>

                                                                                                                            <%
                                                                                                                                int rowNum = 0;

                                                                                                                                for (DDMRequest ddmr : colSLABreachIsuBK)
                                                                                                                                {
                                                                                                                                    rowNum++;                                                                                                                            
                                                                                                                            %>
                                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                <td align="center" class="ddm_sub_link_large"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_inquiry_sla_breach_ddm_req_issuing_bank)%>?hdnIsSearch=1&cmbIssuingBank=<%=ddmr.getIssuningBankCode()%>&cmbIssuingBranch=<%=DDM_Constants.status_all%>" title="<%=ddmr.getIssuningBankName()%>" class="ddm_sub_link_large"><%=ddmr.getIssuningBankCode()%></a></td>
                                                                                                                                <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getSLABreachedIsuBkReqCount()%></td>
                                                                                                                                <td align="right" class="ddm_Display_Error_msg"><%=new DecimalFormat("###,##0.00").format(ddmr.getSLABreachedIsuBkReqAvgExceedDays())%></td>
                                                                                                                            </tr>  
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </tbody>
                                                                                                                        <tfoot>
                                                                                                                            <tr><td></td><td></td>
                                                                                                                                <td></td>
                                                                                                                            </tr>
                                                                                                                        </tfoot>
                                                                                                                    </table>

                                                                                                                    <%                                                                                                                       }
                                                                                                                    else
                                                                                                                    {
                                                                                                                    %> 

                                                                                                                    <br/>
                                                                                                                    <span class="ddm_Display_Success_msg">No Records Available!</span>
                                                                                                              <%
                                                                                                                        }
                                                                                                                    %>                                                                                                                </td>
                                                                                                      </tr>

                                                                                                            <!-- End SLA Exceed Issuing Bank-->

                                                                                                            <tr>
                                                                                                                <td height="10">&nbsp;</td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td height="25" valign="top"><span class="ddm_common_text_bold_large">SLA Exceeded - Acquiring Bank</span></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                <%
                                                                                                                        Collection<DDMRequest> colSLABreachAcqBK = null;

                                                                                                                        if (session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_administrator) || session_userType.equals(DDM_Constants.user_type_ddm_operator) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                                                                                                                        {
                                                                                                                            colSLABreachAcqBK = DAOFactory.getDDMRequestDAO().getSLABreachByAcquiringBankDDAReqSummary(DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user))
                                                                                                                        {
                                                                                                                            colSLABreachAcqBK = DAOFactory.getDDMRequestDAO().getSLABreachByAcquiringBankDDAReqSummary(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            colSLABreachAcqBK = DAOFactory.getDDMRequestDAO().getSLABreachByAcquiringBankDDAReqSummary(session_cocuId, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_all);
                                                                                                                        }

                                                                                                                        if (colSLABreachAcqBK != null && colSLABreachAcqBK.size() > 0)
                                                                                                                        {
                                                                                                                    %>
                                                                                                                    <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder_result2">
                                                                                                                        <thead>
                                                                                                                            <tr>
                                                                                                                                <th align="center" valign="middle">&nbsp; Bank &nbsp;</th>
                                                                                                                              <th align="center" valign="middle" title="Number of SLA Exceeded Requests" nowrap>&nbsp;No. Of Req.&nbsp;</th>
                                                                                                                                <th align="center" valign="middle" title="Average SLA Exceeded Days" nowrap>&nbsp;Avg SLA Ex. Days&nbsp;</th>
                                                                                                                            </tr>
                                                                                                                        </thead>
                                                                                                                        <tbody>

                                                                                                                            <%
                                                                                                                                int rowNum = 0;
                                                                                                                                

                                                                                                                                for (DDMRequest ddmr : colSLABreachAcqBK)
                                                                                                                                {
                                                                                                                                    rowNum++;
                                                                                                                            %>
                                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                <td align="center" class="ddm_sub_link_large">
                                                                                                                                <a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_inquiry_sla_breach_ddm_req_acquiring_bank)%>?hdnIsSearch=1&cmbAcquiringBank=<%=ddmr.getAcquiringBankCode()%>&cmbAcquiringBranch=<%=DDM_Constants.status_all%>" title="<%=ddmr.getAcquiringBankName()%>" class="ddm_sub_link_large"><%=ddmr.getAcquiringBankCode()%></a>
                                                                                                                                </td>
                                                                                                                                <td align="right" class="ddm_Display_Error_msg"><%=ddmr.getSLABreachedAcqBkReqCount()%></td>
                                                                                                                                <td align="right" class="ddm_Display_Error_msg"><%=new DecimalFormat("###,##0.00").format(ddmr.getSLABreachedAcqBkReqAvgExceedDays())%></td>
                                                                                                                            </tr>                                                                                                           

                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </tbody>
                                                                                                                        <tfoot>
                                                                                                                            <tr><td></td><td></td>
                                                                                                                                <td></td>
                                                                                                                            </tr>
                                                                                                                        </tfoot>
                                                                                                                    </table>

                                                                                                                    <%
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                    %> 

                                                                                                                    <br/>
                                                                                                                    <span class="ddm_Display_Success_msg">No Records Available!</span>
                                                                                                                    <%
                                                                                                                        }
                                                                                                                    %>                                                                                                                </td>
                                                                                                      </tr>
                                                                                                  </table></td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                <td width="25">&nbsp;</td>
                                                                                        <td align="left" valign="top"><%

                                                                                            boolean isOKToShowThingsToDo = false;
                                                                                            // Admin Functions
                                                                                            boolean isOKToShowAuthNewBank = false;
                                                                                            boolean isOKToShowAuthModifiedBank = false;
                                                                                            boolean isOKToShowAuthNewBranch = false;
                                                                                            boolean isOKToShowAuthModifiedBranch = false;
                                                                                            boolean isOKToShowAuthNewMerchant = false;
                                                                                            boolean isOKToShowAuthModifiedMerchant = false;
                                                                                            boolean isOKToShowAuthModifiedParam = false;
                                                                                            boolean isOKToShowAuthModifiedULFM = false;
                                                                                            boolean isOKToShowAuthNewUsers = false;
                                                                                            boolean isOKToShowAuthModifiedUsers = false;

                                                                                            boolean isOKToShowAuthPendingDDMReq_IssuingBank = false;
                                                                                            boolean isOKToShowAuthPendingDDMReq_AcquiringBank = false;
                                                                                            boolean isOKToShowAuthPendingDDMReq_Terminated = false;

                                                                                            int noOfPending_AuthNewBank = 0;
                                                                                            int noOfPending_AuthModifiedBank = 0;
                                                                                            int noOfPending_AuthNewBranch = 0;
                                                                                            int noOfPending_AuthModifiedBranch = 0;
                                                                                            int noOfPending_AuthNewMerchant = 0;
                                                                                            int noOfPending_AuthModifiedMerchant = 0;
                                                                                            int noOfPending_AuthModifiedParam = 0;
                                                                                            int noOfPending_AuthNewUsers = 0;
                                                                                            int noOfPending_AuthModifiedUsers = 0;
                                                                                            int noOfPending_AuthModifiedULFM = 0;

                                                                                            int noOfPending_AuthPendingDDMReq_IssuingBank = 0;
                                                                                            int noOfPending_AuthPendingDDMReq_AcquiringBank = 0;
                                                                                            int noOfPending_AuthPendingDDMReq_Terminated = 0;

                                                                                            String prevBusinessDate = DAOFactory.getBCMCalendarDAO().getPreviousBusinessDate(webBusinessDate, 14);

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_new_bank)))
                                                                                            {
                                                                                                Collection<Bank> colBankNew = DAOFactory.getBankDAO().getAuthPendingBank(session_userName);

                                                                                                if (colBankNew != null && colBankNew.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthNewBank = true;

                                                                                                    noOfPending_AuthNewBank = colBankNew.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_bank)))
                                                                                            {
                                                                                                Collection<Bank> colBankModified = DAOFactory.getBankDAO().getAuthPendingModifiedBank(session_userName);

                                                                                                if (colBankModified != null && colBankModified.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedBank = true;

                                                                                                    noOfPending_AuthModifiedBank = colBankModified.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_new_branch)))
                                                                                            {
                                                                                                Collection<Branch> colBranchNew = DAOFactory.getBranchDAO().getAuthPendingBranches(DDM_Constants.status_all, session_userName);

                                                                                                if (colBranchNew != null && colBranchNew.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthNewBranch = true;

                                                                                                    noOfPending_AuthNewBranch = colBranchNew.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_branch)))
                                                                                            {
                                                                                                Collection<Branch> colBranchModified = DAOFactory.getBranchDAO().getAuthPendingModifiedBranches(DDM_Constants.status_all, session_userName);

                                                                                                if (colBranchModified != null && colBranchModified.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedBranch = true;

                                                                                                    noOfPending_AuthModifiedBranch = colBranchModified.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_new_merchant)))
                                                                                            {
                                                                                                Collection<Merchant> colMerchantNew = DAOFactory.getMerchantDAO().getAuthPendingMerchant(session_userName);

                                                                                                if (colMerchantNew != null && colMerchantNew.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthNewMerchant = true;

                                                                                                    noOfPending_AuthNewMerchant = colMerchantNew.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_merchant)))
                                                                                            {
                                                                                                Collection<Merchant> colMerchantModified = DAOFactory.getMerchantDAO().getAuthPendingModifiedMerchant(session_userName);

                                                                                                if (colMerchantModified != null && colMerchantModified.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedMerchant = true;

                                                                                                    noOfPending_AuthModifiedMerchant = colMerchantModified.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_params)))
                                                                                            {
                                                                                                Collection<Parameter> colParamModified = DAOFactory.getParameterDAO().getAuthPendingModifiedParams(session_userName);

                                                                                                if (colParamModified != null && colParamModified.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedParam = true;

                                                                                                    noOfPending_AuthModifiedParam = colParamModified.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_userlevel_functionmap)))
                                                                                            {
                                                                                                Collection<UserLevelFunctionMap> colULFM = DAOFactory.getUserLevelFunctionMapDAO().getAuthPendingModifiedFunctionMap(DDM_Constants.status_all, session_userName);

                                                                                                if (colULFM != null && colULFM.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedULFM = true;

                                                                                                    noOfPending_AuthModifiedULFM = colULFM.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_new_user)))
                                                                                            {
                                                                                                Collection<User> colNewUser = DAOFactory.getUserDAO().getAuthPendingUsers(session_userName, session_userType);

                                                                                                if (colNewUser != null && colNewUser.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthNewUsers = true;

                                                                                                    noOfPending_AuthNewUsers = colNewUser.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_modified_user)))
                                                                                            {
                                                                                                Collection<User> colModifiedUser = DAOFactory.getUserDAO().getAuthPendingModifiedUser(session_userName, DDM_Constants.status_user_modify_details, session_userType);

                                                                                                if (colModifiedUser != null && colModifiedUser.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthModifiedUsers = true;

                                                                                                    noOfPending_AuthModifiedUsers = colModifiedUser.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_ddm_req_issuing_bank)))
                                                                                            {
                                                                                                Collection<DDMRequest> colDDMReqIssuingBank = DAOFactory.getDDMRequestDAO().getDDARequestDetailsForIssuingBankApproval(session_bankCode);

                                                                                                if (colDDMReqIssuingBank != null && colDDMReqIssuingBank.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthPendingDDMReq_IssuingBank = true;                                                                                                    

                                                                                                    noOfPending_AuthPendingDDMReq_IssuingBank = colDDMReqIssuingBank.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_ddm_req_acquiring_bank)))
                                                                                            {
                                                                                                Collection<DDMRequest> colDDMReqAcquiringBank = DAOFactory.getDDMRequestDAO().getDDARequestDetailsForAcquiringBankApproval(session_bankCode);

                                                                                                if (colDDMReqAcquiringBank != null && colDDMReqAcquiringBank.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthPendingDDMReq_AcquiringBank = true;

                                                                                                    noOfPending_AuthPendingDDMReq_AcquiringBank = colDDMReqAcquiringBank.size();
                                                                                                }
                                                                                            }

                                                                                            if (DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, (DDM_Constants.directory_previous + DDM_Constants.ddm_main_finction_path_auth_ddm_req_terminated)))
                                                                                            {
                                                                                                Collection<DDMRequest> colDDMReqTerminated = DAOFactory.getDDMRequestDAO().getDDARequestDetailsForAcquiringBankApproval(session_bankCode);

                                                                                                if (colDDMReqTerminated != null && colDDMReqTerminated.size() > 0)
                                                                                                {
                                                                                                    isOKToShowThingsToDo = true;
                                                                                                    isOKToShowAuthPendingDDMReq_Terminated = true;

                                                                                                    noOfPending_AuthPendingDDMReq_Terminated = colDDMReqTerminated.size();
                                                                                                }
                                                                                            }

                                                                                            if (isOKToShowThingsToDo)
                                                                                            {

                                                                                                int rowNum = 0;

                                                                                            %>


                                                                                            <table border="0" cellspacing="0" cellpadding="0">

                                                                                                <tr>
                                                                                                  <td height="25">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>

                                                                                                        <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder_result">

                                                                                                            <thead>
                                                                                                                <tr>
                                                                                                                    <th colspan="2" align="center" bgcolor="#FFC71A" ><span class="ddm_header_small_text">Things To Do</span></th>
                                                                                                                </tr>
                                                                                                            </thead>
                                                                                                            <tbody>

                                                                                                                <%                                                                                                                if (isOKToShowAuthPendingDDMReq_AcquiringBank)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>
                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_ddm_req_acquiring_bank)%>" title="DDM Requests For Approve As Acquiring Bank" class="ddm_sub_link">DDM Requests For Approve As Acquiring Bank (<%=noOfPending_AuthPendingDDMReq_AcquiringBank%>)</a></td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthPendingDDMReq_IssuingBank)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_ddm_req_issuing_bank)%>" title="DDM Requests For Approve As Issuing Bank" class="ddm_sub_link">DDM Requests For Approve As Issuing Bank (<%=noOfPending_AuthPendingDDMReq_IssuingBank%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthPendingDDMReq_Terminated)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_ddm_req_terminated)%>" title="Authorization Pending - Terminated DDM Requets" class="ddm_sub_link">Terminated DDM Requests For Approve (<%=noOfPending_AuthPendingDDMReq_Terminated%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }

                                                                                                                    if (isOKToShowAuthNewBank)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_new_bank)%>" title="Approve New Bank" class="ddm_sub_link">Approve New Bank (<%=noOfPending_AuthNewBank%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthModifiedBank)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_bank)%>" title="Approve Modified Bank" class="ddm_sub_link">Approve Modified Bank (<%=noOfPending_AuthModifiedBank%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthNewBranch)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_new_branch)%>" title="Approve New Branch" class="ddm_sub_link">Approve New Branch (<%=noOfPending_AuthNewBranch%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthModifiedBranch)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_branch)%>" title="Approve Modified Branch" class="ddm_sub_link">Approve Modified Branch (<%=noOfPending_AuthModifiedBranch%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthNewMerchant)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_new_merchant)%>" title="Approve New Merchant" class="ddm_sub_link">Approve New Merchant (<%=noOfPending_AuthNewMerchant%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthModifiedMerchant)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_merchant)%>" title="Approve Modified Merchant" class="ddm_sub_link">Approve Modified Merchant (<%=noOfPending_AuthModifiedMerchant%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }

                                                                                                                    if (isOKToShowAuthModifiedParam)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_params)%>" title="Approve Modified Parameter" class="ddm_sub_link">Approve Modified Parameter (<%=noOfPending_AuthModifiedParam%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthNewUsers)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_new_user)%>" title="Approve New Users" class="ddm_sub_link">Approve New Users (<%=noOfPending_AuthNewUsers%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthModifiedUsers)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_user)%>" title="Approve Modified Users" class="ddm_sub_link">Approve Modified Users (<%=noOfPending_AuthModifiedUsers%>)</a></td>
                                                                                                                </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                    if (isOKToShowAuthModifiedULFM)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>

                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td><img src="../images/user_accept.png" width="16"                                          height="16" border="0" align="middle" ></td>
                                                                                                                    <td class="ddm_sub_link"><a href="<%=(request.getContextPath() + DDM_Constants.ddm_main_finction_path_auth_modified_userlevel_functionmap)%>" title="Approve Modified User Level Functions" class="ddm_sub_link">Approve Modified User Level Functions (<%=noOfPending_AuthModifiedULFM%>)</a></td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </tbody>
                                                                                                            <tfoot>
                                                                                                                <tr><td></td><td></td></tr>
                                                                                                            </tfoot>
                                                                                                        </table>                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <%
                                                                                                }
                                                                                            %></td>
                                                                                        <td width="150" align="right" valign="top">&nbsp;</td>
                                                                              </tr>
                                                                                </table>






                                                                          </td>
                                                                            <td width="30">&nbsp;</td>
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
