
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.MerchantDAO"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>

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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Add Bank' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
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
    boolean isOkToDisable_txtPrimaryAccNo = false;
    boolean result = false;
    boolean isValidAccountNo = false;

    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;

    String isReq = null;
    String merchantID = null;
    String merchantName = null;
    String merchantEmail = null;
    String primaryTelNo = null;
    String secondaryTelNo = null;
    String merchantPwd = null;
    String merchantRTPwd = null;
    String merchantBank = null;
    String merchantBranch = null;
    String primaryAccountNo = null;
    String primaryAccountName = null;
    String id = null;

    String msg = null;

    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
    }
    else if (isReq.equals("0"))
    {
        merchantID = request.getParameter("txtMerchantId");
        merchantName = request.getParameter("txtMerchantName");
        merchantEmail = request.getParameter("txtEmail");
        primaryTelNo = request.getParameter("txtPrimaryTel");
        secondaryTelNo = request.getParameter("txtSecondaryTel");
        merchantPwd = request.getParameter("txtPassword");
        merchantRTPwd = request.getParameter("txtReTypePassword");
        merchantBank = request.getParameter("cmbBank");
        merchantBranch = request.getParameter("cmbBranch");
        primaryAccountNo = request.getParameter("txtPrimaryAccNo");
        primaryAccountName = request.getParameter("txtPrimaryAccName");
        id = request.getParameter("txtID");

        if (merchantBank != null && !merchantBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(merchantBank, DDM_Constants.status_pending);
        }

    }
    else if (isReq.equals("1"))
    {
        merchantID = request.getParameter("txtMerchantId");
        merchantName = request.getParameter("txtMerchantName");
        merchantEmail = request.getParameter("txtEmail");
        primaryTelNo = request.getParameter("txtPrimaryTel");
        secondaryTelNo = request.getParameter("txtSecondaryTel");
        merchantPwd = request.getParameter("txtPassword");
        merchantRTPwd = request.getParameter("txtReTypePassword");
        merchantBank = request.getParameter("cmbBank");
        merchantBranch = request.getParameter("cmbBranch");
        primaryAccountNo = request.getParameter("txtPrimaryAccNo");
        primaryAccountName = request.getParameter("txtPrimaryAccName");
        id = request.getParameter("txtID");

        MerchantDAO merchantDAO = DAOFactory.getMerchantDAO();

        result = merchantDAO.addMerchant(new Merchant(merchantID, merchantName, merchantEmail, primaryTelNo, secondaryTelNo, merchantPwd, merchantBank, merchantBranch, primaryAccountNo, primaryAccountName, id, DDM_Constants.status_pending, session_userName));

        if (!result)
        {
            msg = merchantDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_add_new_merchant, "| Merchant ID - " + merchantID + ", Name - " + merchantName + ", Email - " + merchantEmail + ", Primary Tel. No. - " + primaryTelNo + ", Secondary Tel. No. - " + (secondaryTelNo!=null?secondaryTelNo:"n/a") + ", Bank - " + merchantBank + ", Branch - " + merchantBranch + ", Primary Acc. No. - " + primaryAccountNo + ", Primary Acc. Name - " + primaryAccountName + ", ID - " + id + "], Status - Pending | Process Status - Unsuccess (" + msg + ") | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_add_new_merchant, "| Merchant ID - " + merchantID + ", Name - " + merchantName + ", Email - " + merchantEmail + ", Primary Tel. No. - " + primaryTelNo + ", Secondary Tel. No. - " + (secondaryTelNo!=null?secondaryTelNo:"n/a") + ", Bank - " + merchantBank + ", Branch - " + merchantBranch + ", Primary Acc. No. - " + primaryAccountNo + ", Primary Acc. Name - " + primaryAccountName + ", ID - " + id + "], Status - Pending | Process Status - Success | Added By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>

<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Add Merchant</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery-1.4.2.min.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery.autocomplete.js"></script>

        <script language="javascript" type="text/JavaScript">


//            function clearRecords_onPageLoad()
//            {
//            document.getElementById('txtMerchantId').setAttribute("autocomplete","off");
//            document.getElementById('txtPrimaryAccNo').setAttribute("autocomplete","off");
//            document.getElementById('txtMerchantName').setAttribute("autocomplete","off");
//            document.getElementById('txtAddress').setAttribute("autocomplete","off");
//            document.getElementById('txtEmail').setAttribute("autocomplete","off");
//            document.getElementById('txtPrimaryTel').setAttribute("autocomplete","off");
//            document.getElementById('txtExt').setAttribute("autocomplete","off");
//            document.getElementById('txtFax').setAttribute("autocomplete","off");
//            showClock(3);
//            }

            function clearRecords()
            {
                document.getElementById('txtMerchantId').value = "";
                document.getElementById('txtMerchantName').value = "";
                document.getElementById('txtEmail').value = "";
                document.getElementById('txtPrimaryTel').value = "";
                document.getElementById('txtSecondaryTel').value = "";
                document.getElementById('txtPassword').value = "";
                document.getElementById('txtReTypePassword').value = "";
                
                document.getElementById('cmbBank').selectedIndex = "0";
                document.getElementById('cmbBranch').selectedIndex = "0";
                
                document.getElementById('txtPrimaryAccNo').value = "";
                document.getElementById('txtPrimaryAccName').value = "";
                document.getElementById('txtID').value = "";

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

            function cancel()
            {
            document.frmAddMerchant.action="<%=request.getContextPath()%>/pages/homepage.jsp";
            document.frmAddMerchant.submit();
            }

            function isVldAccountNo()
            {                
                hideMessage_onFocus();

                var numbers = /^[0-9]*$/;

                var accountNo = document.getElementById('txtPrimaryAccNo').value;

                if (!numbers.test(accountNo))
                {
                    document.getElementById('txtPrimaryAccNo').value = "";
                    alert("Invalid Primary Acc. No.!");
                }
            }

            function fieldValidation()
            {
                
                var merchantid = document.getElementById('txtMerchantId').value;
                var merchantname = document.getElementById('txtMerchantName').value;
                var merchantemail = document.getElementById('txtEmail').value;
                var merchantPT = document.getElementById('txtPrimaryTel').value;
                var merchantST = document.getElementById('txtSecondaryTel').value;
                
                var password = document.getElementById('txtPassword').value;
                var reType_password = document.getElementById('txtReTypePassword').value;
                
                var merchantBank = document.getElementById('cmbBank').value;
                var merchantBranch = document.getElementById('cmbBranch').value;
                
                var prAccNo = document.getElementById('txtPrimaryAccNo').value; 
                var prAccName = document.getElementById('txtPrimaryAccName').value;
                var objID = document.getElementById('txtID').value;

                

                var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";            
                var iTelNumbers = "0123456789,- ";
                var numbers = /^[0-9]*$/;

                if(isempty(merchantid))
                {
                alert("'Merchant ID' can not be empty!");
                document.getElementById('txtMerchantId').focus();
                return false;
                }
                else if(merchantid.length!=4)
                {
                alert("'Merchant ID' must contain only 4 characters!");
                document.getElementById('txtMerchantId').focus();
                return false;
                }                

                if(isempty(merchantname))
                {
                alert("'Merchant Name' can not be empty!");
                document.getElementById('txtMerchantName').focus();
                return false;
                }

                if(isempty(merchantemail))
                {
                alert("'Email' can not be empty!");
                document.getElementById('txtEmail').focus();
                return false;
                }
                else if(merchantemail.indexOf("@") < 1)
                {               
                alert("Invalid 'Email'! Please check and enter valid email address to proceed.");
                document.getElementById('txtEmail').focus();
                return false;
                }
                else if(merchantemail.indexOf("@") != merchantemail.lastIndexOf("@"))
                {
                alert("Invalid 'Email'! Please check and enter valid email address to proceed.");
                document.getElementById('txtEmail').focus();
                return false;                
                }
                else if(merchantemail.lastIndexOf(".") < 3)
                {               
                alert("Invalid 'Email'! Please check and enter valid email address to proceed.");
                document.getElementById('txtEmail').focus();
                return false;
                }

                if(isempty(merchantPT))
                {
                alert("'Primary Telephone No.' can not be empty!");
                document.getElementById('txtPrimaryTel').focus();
                return false;
                }
                else if(merchantPT.length < 10)
                {
                    alert ("Invalid 'Primary Telephone No.'!");
                    document.getElementById('txtPrimaryTel').focus();
                    return false;
                }
                else
                {                
                    for (var i = 0; i < merchantPT.length; i++) 
                    {
                        if (iTelNumbers.indexOf(merchantPT.charAt(i)) == -1) 
                        {
                        alert ("Invalid 'Primary Telephone No.'!");
                        document.getElementById('txtPrimaryTel').focus();
                        return false;
                        }
                    }                
                }
            
                if(!isempty(merchantST))
                {
                    if(merchantST.length < 10)
                    {
                        alert ("Invalid 'Secondary Telephone No.'!");
                        document.getElementById('txtSecondaryTel').focus();
                        return false;
                    }
                    else
                    {                
                        for (var i = 0; i < merchantST.length; i++) 
                        {
                            if (iTelNumbers.indexOf(merchantST.charAt(i)) == -1) 
                            {
                            alert ("Invalid 'Secondary Telephone No.'!");
                            document.getElementById('txtSecondaryTel').focus();
                            return false;
                            }
                        }                
                    }
                }
                
                if(isempty(password))
                {
                    alert("Password Can't be Empty!");
                    document.getElementById('txtPassword').focus();
                    return false;
                }				

                if(isempty(reType_password))
                {
                    alert("Confirm Password Can't be Empty!");
                    document.getElementById('txtReTypePassword').focus();
                    return false;
                }

                if(!password_Validation())
                {                    
                    document.getElementById('txtPassword').value="";
                    document.getElementById('txtReTypePassword').value="";                    
                    document.getElementById('txtPassword').focus();
                    return false;
                }
                
                if(merchantBank == null || merchantBank == "<%=DDM_Constants.status_all%>")
                {
                    alert("Select 'Primary Account Bank' to proceed.");
                    document.getElementById('cmbBank').focus();
                    return false;
                }
                
                if(merchantBranch == null || merchantBranch == "<%=DDM_Constants.status_all%>")
                {
                    alert("Select 'Primary Account Branch' to proceed.");
                    document.getElementById('cmbBranch').focus();
                    return false;
                }
                
            
                if(isempty(prAccNo))
                {
                    alert("'Primary Account No.' can not be empty!");
                    document.getElementById('txtPrimaryAccNo').focus();
                    return false;
                }            
                else if (!numbers.test(prAccNo)) 
                {
                    alert("'Primary Account No.' must contain numbers only!");
                    document.getElementById('txtPrimaryAccNo').focus();
                    return false;
                }
                
                if(isempty(prAccName))
                {
                    alert("'Primary Account Name' can not be empty!");
                    document.getElementById('txtPrimaryAccName').focus();
                    return false;
                }
                
                
                if(isempty(objID))
                {
                    alert("'ID' can not be empty!");
                    document.getElementById('txtID').focus();
                    return false;
                }
                else if(!numbers.test(objID)) 
                {
                    alert("'ID' must contain numbers only!");
                    document.getElementById('txtID').focus();
                    return false;
                }

                document.frmAddMerchant.action = "AddMerchant.jsp";
                document.frmAddMerchant.submit();
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
                                                                <td align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Add New Merchant</td>
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
                                                                                            <form method="post" name="frmAddMerchant" id="frmAddMerchant" action="AddMerchant.jsp">


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

                                                                                                                Merchant added successfully and pending for authorization! <span class="ddm_error">(Manager Level Authorization Is Mandatory)</span>                                                                                                          </div>
                                                                                                                <% }
                                                                                                                else
                                                                                                                {%>


                                                                                                            <div id="displayMsg_error" class="ddm_Display_Error_msg" >Merchant adding failed. - <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                                    <td><table border="0" cellspacing="1" cellpadding="5"  bgcolor="#FFFFFF">

                                                                                                              <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Merchant ID<span class="ddm_required_field"> *</span> :        </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">

                                                                                                                                    <input name="txtMerchantId" id="txtMerchantId" type="text" class="ddm_field_border"  onFocus="hideMessage_onFocus()"  value="<%=merchantID != null ? merchantID : ""%>" size="10" maxlength="4"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Merchant Name<span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input id="txtMerchantName" name="txtMerchantName" type="text" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantName != null ? merchantName : ""%>" size="100" maxlength="100"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Email<span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmail" id="txtEmail" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantEmail != null ? merchantEmail : ""%>" size="80" maxlength="100"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Primary Telephone No. <span  class="ddm_required_field">*</span> :                                                                                                                                    </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtPrimaryTel" id="txtPrimaryTel" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=primaryTelNo != null ? primaryTelNo : ""%>" size="20" maxlength="20"/>                                                                                                                                                                                                                              </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Secondary Telephone No. :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <input type="text" name="txtSecondaryTel" id="txtSecondaryTel" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=secondaryTelNo != null ? secondaryTelNo : ""%>" size="20" maxlength="20"/>          </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Password <span  class="ddm_required_field"> *</span> : </td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="password" name="txtPassword" id="txtPassword" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantPwd != null ? merchantPwd : ""%>" size="40" maxlength="50"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Confirm Password <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="password" name="txtReTypePassword" id="txtReTypePassword" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantRTPwd != null ? merchantRTPwd : ""%>" size="40" maxlength="50"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Primary Account Bank <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="isRequest(false);frmAddMerchant.submit()" <%=(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (merchantBank == null || (merchantBank != null && merchantBank.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected>-- Select --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- Select --</option>
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
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Primary Account Branch <span class="ddm_required_field"> *</span> :</td>
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
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Primary Account No. <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtPrimaryAccNo" id="txtPrimaryAccNo" maxlength="15" size="18" class="ddm_field_border" onChange="isVldAccountNo()" onFocus="isVldAccountNo()" onBlur="isVldAccountNo()" onKeyUp="isVldAccountNo()" onMouseUp="isVldAccountNo()" value="<%=primaryAccountNo != null ? primaryAccountNo : ""%>" <%=isOkToDisable_txtPrimaryAccNo ? "disabled" : ""%>>
                                                                                                                              <input type="hidden" name="hdnChangeCount" id="hdnChangeCount" value="0" />
                                                                                                                                    <input type="hidden" name="hdnPrevAccountNo" id="hdnPrevAccountNo" value="0" /></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Primary Account Name <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input id="txtPrimaryAccName" name="txtPrimaryAccName" type="text" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=primaryAccountName != null ? primaryAccountName : ""%>" size="100" maxlength="100"/></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">ID <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtID" id="txtID" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=id != null ? id : ""%>" size="20" maxlength="20"/></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td colspan="2" class="ddm_tbl_footer_text"><table border="0" align="right" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="button" value="&nbsp;&nbsp; Add &nbsp;&nbsp;" name="btnAdd" class="ddm_custom_button"
                                                                                                                                                       onclick="doSubmit()" <%=((isReq != null && isReq.equals("1")) && result) ? "disabled" : ""%> /></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td><input type="hidden" name="hdnReq" id="hdnReq" value="0" />
                                                                                                                                                <input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((isReq != null && isReq.equals("1")) && result) ? "Done" : "Cancel"%> &nbsp;&nbsp;" type="button" onClick="cancel()" class="ddm_custom_button" />                                                                                            </td></tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                  </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                                      </td>
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

    <!--
        <script>
            jQuery(function () {
                $("#txtMerchantId").autocomplete("getMerchantData.jsp");
            });
        </script>
    -->

</html>
<%
        }
    }
%>