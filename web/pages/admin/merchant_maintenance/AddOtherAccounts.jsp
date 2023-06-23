
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.MerchantDAO"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMapDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>%>

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
    String session_merchantName_New = null;
    String session_menuId = null;
    String session_menuName = null;

    String session_addOtherAccountOK = null;

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

        session_addOtherAccountOK = (String) session.getAttribute("session_addOtherAccountOK");

        if (!(session_addOtherAccountOK != null && session_addOtherAccountOK.equals(DDM_Constants.status_yes)))
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Modify Merchant - Add More Other Accounts | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Modify_Merchant_Add_More_Other_Accounts");
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
    boolean result = false;

    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;

    Merchant objMerchant = null;

    String isReq = null;
    String merchantID = null;
    String merchantName = null;
    String merchantBank = null;
    String merchantBranch = null;
    String merchantOtherAccNo = null;
    String merchantOtherAccName = null;
    String isPrimary = null;
    String msg = null;

    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    isReq = (String) request.getParameter("hdnReq");

    merchantID = (String) request.getParameter("mid");
    
    

    if (merchantID != null)
    {
        objMerchant = DAOFactory.getMerchantDAO().getMerchantDetails(merchantID);

        if (objMerchant != null)
        {
            merchantName = objMerchant.getMerchantName();
        }
    }

    if (isReq == null)
    {
        isReq = "0";

        merchantBank = DDM_Constants.status_all;
        merchantBranch = DDM_Constants.status_all;
        merchantOtherAccNo = "";
        merchantOtherAccName = "";
        isPrimary = DDM_Constants.status_no;
    }
    else if (isReq.equals("0"))
    {
        merchantBank = request.getParameter("cmbBank");
        merchantBranch = request.getParameter("cmbBranch");
        merchantOtherAccNo = request.getParameter("txtOtherAccNo");
        merchantOtherAccName = request.getParameter("txtOtherAccName");
        isPrimary = request.getParameter("cmbIsPrimary");

        if (merchantBank != null && !merchantBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(merchantBank, DDM_Constants.status_pending);
        }
    }
    else if (isReq.equals("1"))
    {        
        merchantBank = request.getParameter("cmbBank");
        merchantBranch = request.getParameter("cmbBranch");
        merchantOtherAccNo = request.getParameter("txtOtherAccNo");
        merchantOtherAccName = request.getParameter("txtOtherAccName");
        isPrimary = request.getParameter("cmbIsPrimary");
        
        if (merchantBank != null && !merchantBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(merchantBank, DDM_Constants.status_pending);
        }

        MerchantAccNoMapDAO mAccNoMapDAO = DAOFactory.getMerchantAccNoMapDAO();

        result = mAccNoMapDAO.addMerchantAccNoMap(new MerchantAccNoMap(merchantID, merchantBank, merchantBranch, merchantOtherAccNo, merchantOtherAccName, isPrimary, DDM_Constants.status_pending, session_userName));

        if (!result)
        {
            msg = mAccNoMapDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Add Other Account Details | Merchant ID - " + merchantID + ", Name - " + merchantName + ", Bank - " + merchantBank + ", Branch - " + merchantBranch + ", Other Acc. No. - " + merchantOtherAccNo + ", Other Acc. Name - " + merchantOtherAccName + ", Is Primary - " + (isPrimary != null ? isPrimary.equals(DDM_Constants.status_yes) ? "Yes" : "No" : "N/A") + ", Status - Pending | Process Status - Unsuccess (" + msg + ") | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Add Other Account Details | Merchant ID - " + merchantID + ", Name - " + merchantName + ", Bank - " + merchantBank + ", Branch - " + merchantBranch + ", Other Acc. No. - " + merchantOtherAccNo + ", Other Acc. Name - " + merchantOtherAccName + ", Is Primary - " + (isPrimary != null ? isPrimary.equals(DDM_Constants.status_yes) ? "Yes" : "No" : "N/A") + ", Status - Pending | Process Status - Success | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }


%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Modify Merchant Add More Other Accounts</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery-1.4.2.min.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery.autocomplete.js"></script>

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

            function cancel()
            {
            	window.close()
            }

            function isVldAccountNo()
            {                
            hideMessage_onFocus();

            var numbers = /^[0-9]*$/;

            var accountNo = document.getElementById('txtPrimaryAccNo').value;
            var changeCount = document.getElementById('hdnChangeCount').value;
            var prevAccountNo = document.getElementById('hdnPrevAccountNo').value;

            if (!numbers.test(accountNo))
            {
            document.getElementById('txtPrimaryAccNo').value = "";
            }
            else
            {
            if (accountNo.length > 5)
            {
            if (changeCount > 0)
            {
            if (prevAccountNo != accountNo)
            {

            isRequest(false);

            document.frmModifyMerchantAddOtherAccount.action = "AddMerchant.jsp";
            document.frmModifyMerchantAddOtherAccount.submit();
            }
            }
            }
            }

            document.getElementById('hdnChangeCount').value = "" + (parseInt(changeCount) + 1);
            document.getElementById('hdnPrevAccountNo').value = accountNo;

            //alert('hdnChangeCount value ---> ' + document.getElementById('hdnChangeCount').value);

            }

            function fieldValidation()
            {
                
                var merchantid = document.getElementById('mid').value;

                var merchantBank = document.getElementById('cmbBank').value;
                var merchantBranch = document.getElementById('cmbBranch').value;

                var othAccNo = document.getElementById('txtOtherAccNo').value; 
                var othAccName = document.getElementById('txtOtherAccName').value;

                var isPrimary = document.getElementById('cmbIsPrimary').value;

                var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";            
                var iTelNumbers = "0123456789,- ";
                var numbers = /^[0-9]*$/;


                if(merchantBank == null || merchantBank == "-1")
                {
                alert("Select 'Bank' to proceed.");
                document.getElementById('cmbBank').focus();
                return false;
                }

                if(merchantBranch == null || merchantBranch == "-1")
                {
                alert("Select 'Branch' to proceed.");
                document.getElementById('cmbBranch').focus();
                return false;
                }


                if(isempty(othAccNo))
                {
                    alert("'Other Account No.' can not be empty!");
                    document.getElementById('txtOtherAccNo').focus();
                    return false;
                }            
                else if (!numbers.test(othAccNo)) 
                {
                    alert("'Other Account No.' must contain numbers only!");
                    document.getElementById('txtOtherAccNo').focus();
                    return false;
                }

                if(isempty(othAccName))
                {
                    alert("'Other Account Name' can not be empty!");
                    document.getElementById('txtOtherAccName').focus();
                    return false;
                }

                document.frmModifyMerchantAddOtherAccount.action = "AddOtherAccounts.jsp";
                document.frmModifyMerchantAddOtherAccount.submit();
            }

            function isRequest(status)
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

            function password_Validation()
            {

            var password = document.getElementById('txtPassword').value;
            var reType_password = document.getElementById('txtReTypePassword').value;

            var numbers = /^[0-9]*$/;

            //                if (!numbers.test(password)) 
            //                {
            //                    alert("Password should contain numbers Only");
            //                    return false;
            //                }				
            //                if(password.length!=8)
            //                {
            //                    alert("Password should contain only 8 digit");
            //                    return false;
            //                }				
            if(findSpaces(password))
            {
            alert("Spaces not allowed for the password!")
            return false;
            }

            if(password != reType_password)
            {
            alert("Password does not match with the Re-type Password!");
            return false;
            }
            else
            {
            return true;
            }            
            }

            function doSubmit()
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
                                                                                                                <td class="ddm_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_merchantId : session_branchId%> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_merchantName_New : session_branchName%></td>
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
                                                                                        <td width="15">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"> Add More Accounts - (Merchant : <%=merchantID%> - <%=merchantName%>)</td>
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









                                                                                            <form method="post" name="frmModifyMerchantAddOtherAccount" id="frmModifyMerchantAddOtherAccount" action="AddOtherAccounts.jsp">


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

                                                                                                                'Merchant Other Account' added successfully and pending for authorization! <span class="ddm_error">(Manager Level Authorization Is Mandatory)</span>                                                                                                          </div>
                                                                                                                <% }
                                                                                                                else
                                                                                                                {%>


                                                                                                            <div id="displayMsg_error" class="ddm_Display_Error_msg" >'Merchant Other Account' adding failed. - <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                                    <td><table border="0" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF" >

                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Merchant :</td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">

                                                                                                                                    <%=merchantID%> - <%=merchantName%><input name="mid" id="mid" type="hidden" value="<%=merchantID%>" /></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Bank <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="isRequest(false);frmModifyMerchantAddOtherAccount.submit()" <%=(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (merchantBank == null || (merchantBank != null && merchantBank.equals(DDM_Constants.status_all)))
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
                                                                                                                                        <option value="<%=bk.getBankCode()%>" <%=(merchantBank != null && bk.getBankCode().equals(merchantBank)) ? "selected" : ""%> > <%=bk.getBankCode() + " - " + bk.getBankFullName()%></option>
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
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Branch <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBranch" id="cmbBranch" class="ddm_field_border" onChange="hideMessage_onFocus()" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (merchantBranch == null || (merchantBranch != null && merchantBranch.equals(DDM_Constants.status_all)))
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
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(merchantBranch != null && branch.getBranchCode().equals(merchantBranch)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
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
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Other Account No. <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtOtherAccNo" id="txtOtherAccNo" maxlength="15" size="18" class="ddm_field_border" onChange="isVldAccountNo()" onFocus="isVldAccountNo()" onBlur="isVldAccountNo()" onKeyUp="isVldAccountNo()" onMouseUp="isVldAccountNo()" value="<%=(merchantOtherAccNo != null ? merchantOtherAccNo : "")%>" > 


                                                                                                                                    <input type="hidden" name="hdnChangeCount" id="hdnChangeCount" value="0" />
                                                                                                                                    <input type="hidden" name="hdnPrevAccountNo" id="hdnPrevAccountNo" value="0" /></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Other Account Name <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input id="txtOtherAccName" name="txtOtherAccName" type="text" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantOtherAccName != null ? merchantOtherAccName : ""%>" size="100" maxlength="100"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Is Primary Account <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><select name="cmbIsPrimary" id="cmbIsPrimary" class="ddm_field_border" onChange="hideMessage_onFocus()" >
                                                                                                                                        <option value="<%=DDM_Constants.status_no%>" <%=(isPrimary != null && isPrimary.equals(DDM_Constants.status_no)) ? "selected" : ""%>> No </option>
                                                                                                                                        <option value="<%=DDM_Constants.status_yes%>" <%=(isPrimary != null && isPrimary.equals(DDM_Constants.status_yes)) ? "selected" : ""%>> Yes </option>
                                                                                                                                    </select></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td colspan="2" class="ddm_tbl_footer_text"><table border="0" align="right" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="button" value="&nbsp;&nbsp; Add &nbsp;&nbsp;" name="btnAdd" class="ddm_custom_button"
                                                                                                                                                       onclick="doSubmit()" <%=((isReq != null && isReq.equals("1")) && result) ? "disabled" : ""%> /></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td><input type="hidden" name="hdnReq" id="hdnReq" value="0" />
                                                                                                                                                <input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((isReq != null && isReq.equals("1")) && result) ? "Done" : "Close"%> &nbsp;&nbsp; " type="button" onClick="cancel()" class="ddm_custom_button" />                                                                                            </td></tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                              </td>
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