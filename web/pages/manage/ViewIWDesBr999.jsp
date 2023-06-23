<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.returnreason.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.owdetails.OWDetails" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.window.Window" errorPage="../../error.jsp"%>
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
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_cocuId = null;
    String session_cocuName = null;

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
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");


%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    String fileID = null;
    String bDate = null;
    long totalRecordCount = 0;

    Collection<OWDetails> colResult = null;

    fileID = (String) request.getParameter("fileId");
    bDate = (String) request.getParameter("bDate");

    totalRecordCount = DAOFactory.getOWDetailsDAO().getRecordCountIWDetailsWithDesBr999(fileID, bDate, DDM_Constants.status_all);

    System.out.print("totalRejectedRecordCount ---> " + totalRecordCount);

    if (totalRecordCount < DDM_Constants.noPageRecords)
    {
        colResult = DAOFactory.getOWDetailsDAO().getIWDetailsWithDesBr999(fileID, webBusinessDate, DDM_Constants.status_all);

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_data_view_iw_des_br_999, "| File Id - " + fileID + " | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_data_view_iw_des_br_999, "| File Id - " + fileID + " | Record Count - " + totalRecordCount + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }

%>


<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - View Return Reasons</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
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
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=window != null ? window.getOW_cutontimeHour() : null%>, <%=window != null ? window.getOW_cutontimeMinutes() : null%>, <%=window != null ? window.getOW_cutofftimeHour() : null%>, <%=window != null ? window.getOW_cutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=window != null ? window.getIW_cutontimeHour() : null%>, <%=window != null ? window.getIW_cutontimeMinutes() : null%>, <%=window != null ? window.getIW_cutofftimeHour() : null%>, <%=window != null ? window.getIW_cutofftimeMinutes() : null%>);
            clock(document.getElementById('showText'), type, val);
            }
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
                                                                                        <td width="15">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"> View Inward Transaction Details Where Destination Branch 999 - (File : <%=fileID%>)</td>
                                                                                        <td width="15">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" ></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">









                                                                                            <table border="0" cellspacing="0" cellpadding="0" >

                                                                                                <%
                                                                                                    if (totalRecordCount > DDM_Constants.noPageRecords)
                                                                                                    {

                                                                                                %>

                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_error">Sorry! Details view prevented due to too many records. (Max Viewable Records Count - <%=DDM_Constants.noPageRecords%> , Current Records Count - <%=colResult.size()%>, This can be lead to memory overflow in your machine.)</td>
                                                                                                </tr>


                                                                                                <%
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    if (colResult != null && colResult.size() == 0)
                                                                                                    {
                                                                                                %>

                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text">No Records Available!</td>
                                                                                                </tr>

                                                                                                <%  }
                                                                                                else if (colResult.size() > 0)
                                                                                                {


                                                                                                %>


                                                                                                <tr><td>





                                                                                                        <table  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                            <tr>
                                                                                                                <td align="right" class="ddm_tbl_header_text_horizontal"></td>
                                                                                                                <!--td align="center" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Out.<br/>Bk-Br</td-->
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                    Bank-Branch</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                    Account No.</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                    Account Name</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Current<br/>Destination<br/>
                                                                                                                    Bank-Branch</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Original<br/>Destination<br/>
                                                                                                                    Bank-Branch</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Current<br/>Destination<br/>Account No.</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Original<br/>Destination<br/>Account No.</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Destination<br/>
                                                                                                                    Account Name</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >TC</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >RC</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Value<br/>
                                                                                                                    Date</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Cur.<br/>
                                                                                                                    Code</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Amount</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Part.</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Ref.</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Validation<br/>Status</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal" >Reject<br/>Codes</td>
                                                                                                            </tr>
                                                                                                            <%                                                                                                                                            int rowNum = 0;
                                                                                                                //int itemCountCredit = 0;
                                                                                                                //int itemCountDebit = 0;

                                                                                                                long totalAmount = 0;
                                                                                                                //long totalAmountDebit = 0;

                                                                                                                for (OWDetails owdetails : colResult)
                                                                                                                {
                                                                                                                    rowNum++;

                                                                                                                    //itemCountCredit += owdetails.getItemCountCredit();
                                                                                                                    //itemCountDebit += owdetails.getItemCountDebit();
                                                                                                                    totalAmount += owdetails.getAmount();
                                                                                                                    //totalAmountCredit += owdetails.getAmountCredit();
%>

                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="right" class="ddm_common_text" ><%=rowNum%>.</td>
                                                                                                                  <!--td align="center"  class="ddm_common_text"><%=owdetails.getOwBank()%>-<%=owdetails.getOwBranch()%></td-->
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getOrgAcNoDec()%></td>
                                                                                                                <td  class="ddm_common_text"><%=owdetails.getOrgAcNameDec()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getOriDesBranchcode()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getDesAcNoDec()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getOriDesAcNo()%></td>
                                                                                                              <td  class="ddm_common_text"><%=owdetails.getDesAcNameDec()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getTc()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getRc()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getValueDate()%></td>
                                                                                                                <td align="center"  class="ddm_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                                <td align="right"  class="ddm_common_text"><%=new DecimalFormat("###,##0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                                <td  class="ddm_common_text"><%=owdetails.getParticulars()%></td>
                                                                                                                <td  class="ddm_common_text"><%=owdetails.getReference()%></td>



                                                                                                              <td  class="ddm_common_text"><%=owdetails.getStatusDesc() != null ? owdetails.getStatusDesc() : "N/A"%></td>
                                                                                                              <td align="center" nowrap  class="ddm_common_text"><%=owdetails.getRJCodes() != null ? owdetails.getRJCodes().equals("00") ? "-" : owdetails.getRJCodes() : "-"%></td>
                                                                                                            </tr>
                                                                                                            <!--/form-->
                                                                                                            <%
                                                                                                                }

                                                                                                            %>
                                                                                                            <tr  class="ddm_common_text">
                                                                                                                <td height="20" align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal" ></td>
                                                                                                                <!--td align="center" bgcolor="#B4C4D3" class="ddm_common_text">&nbsp;</td-->
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">Total</td>
                                                                                                                <td align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text"><%=new DecimalFormat("###,##0.00").format((new Long(totalAmount).doubleValue()) / 100)%></td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                            </tr>
                                                                                                        </table>

                                                                                                    </td>
                                                                                                </tr>


                                                                                                <%
                                                                                                        }
                                                                                                    }

                                                                                                %>
                                                                                            </table>                                                              </td>
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
<%    }
%>