<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../../error.jsp" %>
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Add Branch' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Add_Bank");
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
    String isReq = null;
    String bankCode = null;
    String branchCode = null;
    String brName = null;
    String status = null;
    String msg = null;
    boolean result = false;

    Collection<Bank> colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
    }
    else if (isReq.equals("1"))
    {
        bankCode = (String) request.getParameter("cmbBank");
        branchCode = (String) request.getParameter("txtBranchCode");
        brName = (String) request.getParameter("txtBranchName");
        //status = (String) request.getParameter("cmbStatus");

        BranchDAO branchDAO = DAOFactory.getBranchDAO();

        result = branchDAO.addBranch(new Branch(bankCode, branchCode, brName.trim(), DDM_Constants.status_pending, session_userName));

        if (!result)
        {
            msg = branchDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_add_new_branch, "| Bank Code - " + bankCode + ", Branch Code - " + branchCode + ", Branch Name - " + brName + " | Process Status - Unsuccess (" + msg + ") | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_bank_branch_maintenance_add_new_branch, "| Bank Code - " + bankCode + ", Branch Code - " + branchCode + ", Branch Name - " + brName + " | Process Status - Success | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>

<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Add Branch</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>


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

//            function clearRecords_onPageLoad()
//            {
//            document.getElementById('txtBranchCode').setAttribute("autocomplete","off");
//            document.getElementById('txtBranchName').setAttribute("autocomplete","off");
//
//            showClock(3);
//            }

            function clearRecords()
            {
            document.getElementById('cmbBank').selectedIndex="0";
            document.getElementById('txtBranchCode').value="";
            document.getElementById('txtBranchName').value="";
            //document.getElementById('cmbStatus').selectedIndex="0";
            }


            function fieldValidation()
            {
            var bankcode = document.getElementById('cmbBank').value;
            var branchcode = document.getElementById('txtBranchCode').value;
            var branchname = document.getElementById('txtBranchName').value;
            //var status = document.getElementById('cmbStatus').value;


            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;


            if(bankcode==null || bankcode=="-1")
            {
            alert("Select Bank Code");
            document.getElementById('cmbBank').focus();
            return false;
            }

            if(isempty(branchcode))
            {
            alert("Branch Code Can't be Empty");
            document.getElementById('txtBranchCode').focus();
            return false;
            }
            else if (!numbers.test(branchcode)) 
            {
            alert("Branch Code should contain Numbers Only");
            return false;
            }
            else if(branchcode.length!=3)
            {
            alert("Branch Code should contain only 3 digit");
            document.getElementById('txtBranchCode').focus();
            return false;
            }               

            if(isempty(branchname))
            {
            alert("Branch Name can not be empty!");
            document.getElementById('txtBranchName').focus();
            return false;
            }

            /*
            if(status==null || status=="-1")
            {
            alert("Select Branch Status");
            document.getElementById('cmbStatus').focus();
            return false;                   

            }
            else
            {*/
            document.frmNewBranch.action="AddBranch.jsp";
            document.frmNewBranch.submit();
            //return true;            
            //}	

            }


            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error')!= null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success')!=null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }                
            }


            function doSubmit()
            {
            isRequest(true);                    
            fieldValidation();			
            }


            function IsNumeric(strString)
            {
            // var strString=document.BranchDataUploader.NoofCDs.value;
            var strValidChars = "0123456789";
            var strChar;
            var blnResult = true;

            if (strString.length == 0)
            {
            return false;
            }

            //  test strString consists of valid characters listed above
            for (var i = 0; i <= strString.length && blnResult == true; i++)
            {

            strChar = strString.charAt(i);
            alert(strChar);
            if (strValidChars.indexOf(strChar) == -1)
            {
            blnResult = false;
            break;
            }
            }

            return blnResult;
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Add New Branch</td>
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

                                                                                            <form  id="frmNewBranch" name="frmNewBranch"  method="post" >
                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                Branch added sucessfully and pending for authorization <span class="ddm_error">(Manager Level Authorization Is Mandatory)</span>  !                                                                                                           </div>
                                                                                                                <% }
                                                                                                                else
                                                                                                                {%>


                                                                                                            <div id="displayMsg_error" class="ddm_Display_Error_msg" >Branch adding failed. - <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                        <td align="center" valign="middle"><table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >

                                                                                                                            <tr>
                                                                                                                                <td valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">
                                                                                                                                    Bank <span class="ddm_required_field">*</span> :        </td>

                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text">

                                                                                                                                    <select name="cmbBank" id="cmbBank" class="ddm_field_border" onFocus="hideMessage_onFocus()">

                                                                                                                                        <option value="-1" <%=(bankCode == null || bankCode.equals("-1")) ? "selected" : ""%>>-- Select Bank --</option>

                                                                                                                                        <%
                                                                                                                                            if (colBank != null && !colBank.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (Bank bank : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%>><%=bank.getBankCode()%> - <%=bank.getBankFullName()%></option>

                                                                                                                                        <% }%>
                                                                                                                                    </select>
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    <span class="ddm_error">No bank details available.</span>
                                                                                                                                    <%}%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#A4B7CA" valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Branch Code<span  class="ddm_required_field">*</span> :</td>

                                                                                                                                <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">

                                                                                                                                    <input name="txtBranchCode" type="text" class="ddm_field_border" id="txtBranchCode" onFocus="hideMessage_onFocus()"  value="<%=branchCode != null ? branchCode : ""%>" size="6" maxlength="3"/>                                                                                          </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#A4B7CA" valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Branch Name<span  class="ddm_required_field">* </span>:</td>
                                                                                                                                <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <input name="txtBranchName" type="text" class="ddm_field_border" id="txtBranchName" onFocus="hideMessage_onFocus()"
                                                                                                                                           value="<%=brName != null ? brName : ""%>" size="25" maxlength="24"/>          </td>
                                                                                                                            </tr>
                                                                                                                            <!--tr>
                                                                                                                                <td bgcolor="#A4B7CA" valign="middle" class="ddm_tbl_header_text">Status : </td>
                                                                                                                                <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="ddm_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_active%>" <%=status != null && status.equals(DDM_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_deactive%>" <%=status != null && status.equals(DDM_Constants.status_deactive) ? "selected" : ""%>>De-active</option>
                                                                                                                                    </select>                                                                                                      </td>
                                                                                                                            </tr-->
                                                                                                                            <tr>
                                                                                                                                <td colspan="2" class="ddm_tbl_footer_text"><table border="0" align="right" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="button" value="&nbsp;&nbsp; Add &nbsp;&nbsp;" name="btnAdd" class="ddm_custom_button"
                                                                                                                                                       onclick="doSubmit()"/></td>
                                                                                                                                            <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="0" /></td>
                                                                                                                                            <td>
                                                                                                                                                <input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Clear &nbsp;&nbsp;" type="button" onClick="clearRecords()" class="ddm_custom_button" />                                                                                            </td></tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
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
