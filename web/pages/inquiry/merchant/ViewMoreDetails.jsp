<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp" %>

<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMap" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.emaillist.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.services.email.SendHTMLEmail2" errorPage="../../../error.jsp"%>

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

//        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());
//
//        if (!isAccessOK)
//        {
//            //session.invalidate();
//            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Authorize Modified Bank' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
//            {
//                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
//            }
//            else
//            {
//                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Authorize_Modified_Bank");
//            }
//
//        }
//        else
//        {

%>

<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    
    String cocuid = (String) request.getParameter("hdnCoCuID");
    String searchStatus = (String) request.getParameter("hdnCoCuStatus");

    CorporateCustomer objCoCu = DAOFactory.getCorporateCustomerDAO().getCorporateCustomerDetails(cocuid);
    Collection<CorporateCustomerAccNoMap> colAccNoMap = null;

%>
<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - View Corporate Customer Details</title>

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

            function setRequestType(status) 
            {
            if(status) 
            {
            document.getElementById('hdnRequestType').value = "1";
            }
            else 
            {
            document.getElementById('hdnRequestType').value = "0";
            }
            }


            function clearRecords_onPageLoad()
            {                

            if(document.getElementById('txtPassword')!=null)
            {
            document.getElementById('txtPassword').setAttribute("autocomplete","off");
            }

            if(document.getElementById('txtReTypePassword')!=null)
            {
            document.getElementById('txtReTypePassword').setAttribute("autocomplete","off");
            }

            showClock(3);
            }

            function back()
            {
				//clearResultData();
				document.frmViewMoreDetails.action="ViewCustomer.jsp";
				document.frmViewMoreDetails.submit();
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
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error')!= null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }

            }

            if(document.getElementById('displayMsg_success')!=null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }                
            }



            function doSearch()
            {	
            setRequestType(false);
            document.frmViewMoreDetails.action="AuthModifiedBank.jsp";
            document.frmViewMoreDetails.submit();					
            }

            function doUpdate()
            {
            setRequestType(true);
            document.frmViewMoreDetails.action="AuthModifiedBank.jsp";
            document.frmViewMoreDetails.submit(); 				
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

            function findSpaces(str)
            {               
            var status = false;
            var strTrimed = this.trim(str);

            for (var i=0;i<strTrimed.length;i++)
            {
            if(strTrimed[i]== " ")
            {
            status = true;
            break;
            }
            }

            return status;                
            }

            function trim(str) 
            {
            return str.replace(/^\s+|\s+$/g,"");
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View Merchant Details</td>
                                                                                      <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="center" valign="top" class="ddm_header_text">
                                                                                            <form name="frmViewMoreDetails" id="frmViewMoreDetails" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><input name="rbStatus" id="rbStatus" type="hidden" value="<%=searchStatus %>"></td>
                                                                                                  </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">
                                                                                                            

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (objCoCu == null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center" class="ddm_header_small_text">No records Available !</td>
                                                                                                              </tr>
                                                                                                                <tr>
                                                                                                                    <td height="100" align="center"></td>
                                                                                                              </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" name="btnBack1" id="btnBack1" value="&nbsp;&nbsp; Back &nbsp;&nbsp;" class="ddm_custom_button" onClick="back()"/></td></tr>
                                                                                                                                                    </table></td>
                                                                                                                </tr>

                                                                                                                <%                                                                                    
                                                                                                                    }
                                                                                                                else
                                                                                                                {

                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td height="10"></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td align="center" valign="middle">

                                                                                                                                        <table border="0" cellspacing="1" cellpadding="5" class="ddm_table_boder" bgcolor="#FFFFFF">

                                                                                                                                            <tr>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text">&nbsp;</td>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                                                <td align="center" valign="middle" class="ddm_tbl_header_text_horizontal"> Modified Value</td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Corporate Customer ID :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getCoCuID() %></td>
                                                                                                                                                <td class="ddm_tbl_common_text">&nbsp;</td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Name :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getCoCuName() != null ? objCoCu.getCoCuName() : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getCoCuNameModify()!= null ? objCoCu.getCoCuNameModify() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Primary Account No. :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getPrimaryAccNo() != null ? objCoCu.getPrimaryAccNo() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getPrimaryAccNoModify()!= null ? objCoCu.getPrimaryAccNoModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Other Accounts : </td>
                                                                                                                                              <td class="ddm_tbl_common_text">
																																			  <%
                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                          colAccNoMap = objCoCu.getColAccNoMap();
                                                                                                                                                                                                                                                                                          
																																			  if (colAccNoMap!=null && colAccNoMap.size()>0)
																																			  {
                                                                                                                                                                                                                                                                                              
																																			  
																																			  %>
                                                                                                                                                <table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                <%
                                                                                                                                                for (CorporateCustomerAccNoMap coCuAccNoMap : colAccNoMap)
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                    
                                                                                                                                                    <tr>
                                                                                                                                                  <td class="ddm_common_text"><%=coCuAccNoMap.getAccNo() %></td>
                                                                                                                                                  <td class="ddm_common_text"><%=coCuAccNoMap.getAccName() != null ? coCuAccNoMap.getAccName() : "N/A"%></td>
                                                                                                                                                  <td class="ddm_common_text">(<%=coCuAccNoMap.getStatus() != null ? coCuAccNoMap.getStatus().equals(DDM_Constants.status_active)?"Active": "Inactive" : "N/A"%>)</td>
                                                                                                                                                </tr>
                                                                                                                                                <%
                                                                                                                                                                                                                                                                                          }
                                                                                                                                                %>
                                                                                                                                                
                                                                                                                                              </table>
                                                                                                                                              <%
																																			  }
																																			  else
																																			  {
																																			  %>
                                                                                                                                              N/A
                                                                                                                                              <%
																																			  }
																																			  %>
                                                                                                                                              
                                                                                                                                              </td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%
                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                          colAccNoMap = objCoCu.getColAccNoMap();
                                                                                                                                                                                                                                                                                          
																																			  if (colAccNoMap!=null && colAccNoMap.size()>0)
																																			  {
                                                                                                                                                                                                                                                                                              
																																			  
																																			  %>
                                                                                                                                                <table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                <%
                                                                                                                                                for (CorporateCustomerAccNoMap coCuAccNoMap : colAccNoMap)
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                    
                                                                                                                                                    <tr>
                                                                                                                                                  <td class="ddm_common_text"><%=coCuAccNoMap.getStatusModify()!= null ? coCuAccNoMap.getStatusModify().equals(DDM_Constants.status_active)?"Active": "Inactive" : "N/A"%></td>
                                                                                                                                                </tr>
                                                                                                                                                <%
                                                                                                                                                                                                                                                                                          }
                                                                                                                                                %>
                                                                                                                                              </table>
                                                                                                                                              <%
																																			  }
																																			  else
																																			  {
																																			  %>
                                                                                                                                              N/A
                                                                                                                                              <%
																																			  }
																																			  %>
                                                                                                                                              
                                                                                                                                              </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Address : </td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getCoCuAddress() != null ? objCoCu.getCoCuAddress() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getCoCuAddressModify()!= null ? objCoCu.getCoCuAddressModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Email :</td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getEmail() != null ? objCoCu.getEmail() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getEmailModify()!= null ? objCoCu.getEmailModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Telephone :</td>                                                                                                                                                
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getTelephone() != null ? objCoCu.getTelephone() : "N/A"%></td>
                                                                                                                                                <td class="ddm_tbl_common_text"><%=objCoCu.getTelephoneModify()!= null ? objCoCu.getTelephoneModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Extension :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getExtension() != null ? objCoCu.getExtension() : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getExtensionModify()!= null ? objCoCu.getExtensionModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Fax :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getFax() != null ? objCoCu.getFax() : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getFaxModify()!= null ? objCoCu.getFaxModify(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Is CUST1 Allowed :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_CUST1_Allowed()!= null ? objCoCu.getIs_CUST1_Allowed().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_CUST1_AllowedModify()!= null ? objCoCu.getIs_CUST1_AllowedModify().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Is CUSTOUT Allowed :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_CUSTOUT_Allowed()!= null ? objCoCu.getIs_CUSTOUT_Allowed().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_CUSTOUT_AllowedModify()!= null ? objCoCu.getIs_CUSTOUT_AllowedModify().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Is DSLIPS Allowed :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_DSLIPS_Allowed()!= null ? objCoCu.getIs_DSLIPS_Allowed().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_DSLIPS_AllowedModify()!= null ? objCoCu.getIs_DSLIPS_AllowedModify().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Is FSLIPS Allowed :</td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_FSLIPS_Allowed()!= null ? objCoCu.getIs_FSLIPS_Allowed().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=objCoCu.getIs_FSLIPS_AllowedModify()!= null ? objCoCu.getIs_FSLIPS_AllowedModify().equals(DDM_Constants.status_yes)?"Yes": "No" : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                              
                                                                                                                                              <%
                                                                                                                                                    String stat = null;
                                                                                                                                                    String statModify = null;

                                                                                                                                                    if (objCoCu.getStatus() == null)
                                                                                                                                                    {
                                                                                                                                                        stat = "N/A";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatus().equals(DDM_Constants.status_active))
                                                                                                                                                    {
                                                                                                                                                        stat = "Active";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatus().equals(DDM_Constants.status_deactive))
                                                                                                                                                    {
                                                                                                                                                        stat = "Inactive";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatus().equals(DDM_Constants.status_pending))
                                                                                                                                                    {
                                                                                                                                                        stat = "Pending for Authorization";
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        stat = "Other";
                                                                                                                                                    }

                                                                                                                                                    if (objCoCu.getStatusModify() == null)
                                                                                                                                                    {
                                                                                                                                                        statModify = "N/A";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatusModify().equals(DDM_Constants.status_active))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Active";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatusModify().equals(DDM_Constants.status_deactive))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Inactive";
                                                                                                                                                    }
                                                                                                                                                    else if (objCoCu.getStatusModify().equals(DDM_Constants.status_pending))
                                                                                                                                                    {
                                                                                                                                                        statModify = "Pending for Authorization";
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        statModify = "Other";
                                                                                                                                                    }


                                                                                                                                                %>
                                                                                                                                              
                                                                                                                                              <td class="ddm_tbl_common_text"><%=stat %></td>
                                                                                                                                              <td class="ddm_tbl_common_text"><%=statModify %></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td height="10" colspan="3" align="left" valign="middle" class="ddm_tbl_footer_text"></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Created By :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getCreatedBy()!= null ? objCoCu.getCreatedBy() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Created Date :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getCreatedDate()!= null ? objCoCu.getCreatedDate() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Authorized By :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getAuthorizedBy()!= null ? objCoCu.getAuthorizedBy() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Authorized Date :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getAuthorizedDate()!= null ? objCoCu.getAuthorizedDate() : "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Modified By :</td>
                                                                                                                                                <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getModifiedBy()!= null ? objCoCu.getModifiedBy(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Modified Date :</td>
                                                                                                                                                <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getModifiedDate()!= null ? objCoCu.getModifiedDate(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Modification Authorized By :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getModificationAuthBy()!= null ? objCoCu.getModificationAuthBy(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                              <td align="left" valign="middle" class="ddm_tbl_header_text">Modification Authorized Date :</td>
                                                                                                                                              <td colspan="2" class="ddm_tbl_common_text"><%=objCoCu.getModificationAuthDate()!= null ? objCoCu.getModificationAuthDate(): "N/A"%></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>  <td height="35" colspan="3" align="center" class="ddm_tbl_footer_text">




                                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" name="btnBack2" id="btnBack2" value="&nbsp;&nbsp; Back &nbsp;&nbsp;" class="ddm_custom_button" onClick="back()"/></td></tr>
                                                                                                                                                    </table>

                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>                                                                                                            </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                                                                                                                    </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                                                                                                           </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15">&nbsp;</td>
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
    // }   
    }
%>