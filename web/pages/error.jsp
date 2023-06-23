<%@page import="java.sql.*,java.util.*,java.io.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="../error.jsp"%> 

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<%
    String msg = null;
    msg = (String) request.getParameter("msg");

    if (msg != null)
    {
        if (msg.equals("em"))
        {
            msg = "Error occured while sending the email with the login OTP code!";
        }
        else
        {
            msg = "";
        }

    }
    else
    {
        msg = "";
    }


%>
<%    String session_userName = null;
    String session_userTypeDesc = null;

    session_userName = (String) session.getAttribute("session_userName");
    session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");

    if (session_userName == null || session_userName.equals("null"))
    {
        //session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        System.out.println("session_userName (error page) --> " + session_userName);
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_redirect_to_error_page, "| Unknown Error | Affected To - " + session_userName + " (" + session_userTypeDesc + ") |"));
        DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_no);
        session.invalidate();
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System  - Error</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../js/fade.js"></script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
                                                                                                    <td align="left"><div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** cits ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/reLoginMenu.js" vqp_uid0=399999>cdd__codebase = "<%=request.getContextPath()%>/js/";cdd__codebase399999 = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/reLoginMenu.js"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="399999" language="JavaScript">create_menu(399999)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="bottom">&nbsp;</td>
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
                                                        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="150" align="right" valign="top">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="100" align="center" valign="middle" class="ddm_special_msg_text">Error!</td>
                                                            <tr>
                                                                <td height="15" align="center" valign="middle" ></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" valign="middle" class="ddm_Display_Error_msg"><%=msg != null ? msg : ""%></td>
                                                            </tr>

                                                            <tr>
                                                                <td style="min-height:150"></td>
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