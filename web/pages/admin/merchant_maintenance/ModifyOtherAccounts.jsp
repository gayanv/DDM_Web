
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
    String session_merchantName_New = null;
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Modify Merchant - Modify Other Accounts' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Modify_Merchant_Modify_Other_Accounts");
            }
        }
        else
        {
            session.setAttribute("session_addOtherAccountOK", DDM_Constants.status_yes);

%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%

    Collection<MerchantAccNoMap> colAccNoMap = null;
    Merchant objMerchant = null;
    MerchantAccNoMap objMerchantAccNoMap = null;

    String reqType = null;

    String selectedOtherAcc = null;

    String merchantID = null;
    String merchantName = null; 
    
    String merchantOtherAccBank = null; 
    String merchantOtherAccBranch = null; 
    String merchantOtherAccNo = null; 
    String merchantOtherAccName = null; 
    String merchantOtherAccStatus = null; 

    String merchantOtherAccStatus_New = null;


    String msg = null;

    boolean result = false;

    reqType = (String) request.getParameter("hdnRequestType");
    
    merchantID = (String) request.getParameter("mid");
    
    

    if (merchantID != null)
    {
        objMerchant = DAOFactory.getMerchantDAO().getMerchantDetails(merchantID);

        if (objMerchant != null)
        {
            merchantName = objMerchant.getMerchantName();
        }
    }

    colAccNoMap = objMerchant.getColAccNoMap();

    if (reqType == null)
    {
        selectedOtherAcc = DDM_Constants.status_all;        
    }
    else if (reqType.equals("0"))
    {
        selectedOtherAcc = (String) request.getParameter("search_cmbOtherAcc");

        System.out.println("selectedOtherAcc 1 ===> " + selectedOtherAcc);


        if (!selectedOtherAcc.equals(DDM_Constants.status_all))
        {
            objMerchantAccNoMap = DAOFactory.getMerchantAccNoMapDAO().getMerchantAccount(selectedOtherAcc);
        }

        if (objMerchantAccNoMap != null)
        {
            merchantID = objMerchantAccNoMap.getMerchantID();
            merchantOtherAccBank = objMerchantAccNoMap.getBank();
            merchantOtherAccBranch = objMerchantAccNoMap.getBranch();
            merchantOtherAccNo = objMerchantAccNoMap.getAcNo();
            merchantOtherAccName = objMerchantAccNoMap.getAcName();
            merchantOtherAccStatus = objMerchantAccNoMap.getStatus();            
        }
    }
    else if (reqType.equals("1"))
    {
        selectedOtherAcc = (String) request.getParameter("search_cmbOtherAcc");

        System.out.println("selectedOtherAcc 1 ===> " + selectedOtherAcc);

        if (!selectedOtherAcc.equals(DDM_Constants.status_all))
        {
            objMerchantAccNoMap = DAOFactory.getMerchantAccNoMapDAO().getMerchantAccount(selectedOtherAcc);
        }
        
        if (objMerchantAccNoMap != null)
        {
            merchantID = objMerchantAccNoMap.getMerchantID();
            merchantOtherAccBank = objMerchantAccNoMap.getBank();
            merchantOtherAccBranch = objMerchantAccNoMap.getBranch();
            merchantOtherAccNo = objMerchantAccNoMap.getAcNo();
            merchantOtherAccName = objMerchantAccNoMap.getAcName();
            merchantOtherAccStatus = objMerchantAccNoMap.getStatus();     
            
            merchantOtherAccStatus_New = (String) request.getParameter("cmbStatus");

        MerchantAccNoMapDAO merchantAccNoMapDAO = DAOFactory.getMerchantAccNoMapDAO();

        MerchantAccNoMap objMerchantAccNoMap_New= new MerchantAccNoMap();

        objMerchantAccNoMap_New.setMerchantID(merchantID);
        objMerchantAccNoMap_New.setBank(merchantOtherAccBank);
        objMerchantAccNoMap_New.setBranch(merchantOtherAccBranch);
        objMerchantAccNoMap_New.setAcNo(merchantOtherAccNo);
        objMerchantAccNoMap_New.setStatus(merchantOtherAccStatus_New);
        objMerchantAccNoMap_New.setModifiedBy(session_userName);

        result = merchantAccNoMapDAO.modifyMerchantAccNoMap(objMerchantAccNoMap_New);

        if (!result)
        {
            msg = merchantAccNoMapDAO.getMsg();

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Modify Other Account Details | Merchant ID - " + merchantID + ", "
                    + "Bank - " + merchantOtherAccBank  + ", Branch - " + merchantOtherAccBranch + ", Acc No. - " + merchantOtherAccNo                  
                    + "Status - (New : " + (merchantOtherAccStatus_New.equals(DDM_Constants.status_active) ? "Active" : merchantOtherAccStatus_New.equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ", Old : " + (objMerchant.getStatus().equals(DDM_Constants.status_active) ? "Active" : objMerchant.getStatus().equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ") | "
                    + "Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));

        }
        else
        {

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Modify Other Account Details | Merchant ID - " + merchantID + ", "
                    + "Bank - " + merchantOtherAccBank  + ", Branch - " + merchantOtherAccBranch + ", Acc No. - " + merchantOtherAccNo                  
                    + "Status - (New : " + (merchantOtherAccStatus_New.equals(DDM_Constants.status_active) ? "Active" : merchantOtherAccStatus_New.equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ", Old : " + (objMerchant.getStatus().equals(DDM_Constants.status_active) ? "Active" : objMerchant.getStatus().equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ") | "
                    + "Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));

        }
        }
        {
        
        }

        

        
    }
%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Modify Merchant Details</title>
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

            function clearRecords()
            {
            document.getElementById('txtShortName').value = "";
            document.getElementById('txtFullName').value = "";	

            if(document.getElementById('txtPassword')!=null)
            {

            document.getElementById('txtPassword').value = "";
            document.getElementById('txtReTypePassword').value = "";
            }


            document.getElementById('cmbStatus').selectedIndex = 0;
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

            function cancel()
            {
				window.close();s
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

            function fieldValidation()
            {
            
                //var merchantid = document.getElementById('txtMerchantId').value;
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
                var objStatus = document.getElementById('cmbStatus').value;
                

                var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";            
                var iTelNumbers = "0123456789,- ";
                var numbers = /^[0-9]*$/;

//                if(isempty(merchantid))
//                {
//                alert("'Merchant ID' can not be empty!");
//                document.getElementById('txtMerchantId').focus();
//                return false;
//                }
//                else if(merchantid.length!=4)
//                {
//                alert("'Merchant ID' must contain only 4 characters!");
//                document.getElementById('txtMerchantId').focus();
//                return false;
//                }                

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
                
                if(!isempty(password))
                {
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
                }				

                
                
                if(objStatus == null || objStatus == "<%=DDM_Constants.status_all%>")
                {
                    alert("Select appropriate 'Merchant Status' to proceed.");
                    document.getElementById('cmbStatus').focus();
                    return false;
                }
                
                

                document.frmModifyOtherAccounts.action="ModifyOtherAccounts.jsp";
                document.frmModifyOtherAccounts.submit();
            }			

            function doSearch()
            {                
                var cmbMerchantVal = document.getElementById('search_cmbOtherAcc').value;

                if(cmbMerchantVal==null || cmbMerchantVal=="<%=DDM_Constants.status_all%>")
                {
                clearResultData();
                return false;
                }
                else
                {
                setRequestType(false);
                document.frmModifyOtherAccounts.action="ModifyOtherAccounts.jsp";
                document.frmModifyOtherAccounts.submit();				
                }			
            }

            function doUpdate()
            {
                setRequestType(true);                    
                fieldValidation();				
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
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="ddm_header_text">Modify Other Accounts - (Merchant : <%=merchantID%> - <%=merchantName%>)</td>
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
                                                                                            <form name="frmModifyOtherAccounts" id="frmModifyOtherAccounts" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">


                                                                                                            <table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Other Account :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="search_cmbOtherAcc" id="search_cmbOtherAcc" class="ddm_field_border" onChange="doSearch()" >
                                                                                                                                        <%
                                                                                                                                            if (selectedOtherAcc == null || (selectedOtherAcc != null && selectedOtherAcc.equals(DDM_Constants.status_all)))
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
                                                                                                                                            if (colAccNoMap != null && colAccNoMap.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (MerchantAccNoMap objAccNoMap : colAccNoMap)
                                                                                                                                                {
                                                                                                                                                    String concatPK = (objAccNoMap.getMerchantID() + objAccNoMap.getBank() + objAccNoMap.getBranch() + objAccNoMap.getAcNo());
                                                                                                                                        %>
                                                                                                                                        <option value="<%=concatPK%>" <%=(selectedOtherAcc != null && concatPK.equals(selectedOtherAcc)) ? "selected" : ""%> > <%=objAccNoMap.getBank() %> - <%=objAccNoMap.getBranch() %> - <%=objAccNoMap.getAcNo() %></option>
                                                                                                                                        <%

                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No merchant account details available!</span>
                                                                                                                                    <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /><input name="mid" id="mid" type="hidden" value="<%=merchantID%>" /></td>
                                                                                                                            </tr>
                                                                                                                  </table></td>
                                                                                                                </tr>
                                                                                                            </table>


                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">
                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (objMerchant == null)
                                                                                                                    {

                                                                                                                        if (!selectedOtherAcc.equals(DDM_Constants.status_all))
                                                                                                                        {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }
                                                                                                                }
                                                                                                                else
                                                                                                                {

                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><div id="resultdata"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td align="center">
                                                                                                                                        <%                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                                            Merchant Other Account Details modified Successfully.
                                                                                                                                            <%                                                                                                                                                if (!(session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su)))
                                                                                                                                                {
                                                                                                                                            %>



                                                                                                                                            <span class="ddm_error">(Manager Level Authorization Is Mandatory!)</span> 
                                                                                                                                            <%
                                                                                                                                                }
                                                                                                                                            %>
                                                                                                                                        </div>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {%>


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >Merchant Other Account Details modification Failed.- <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                                                    <td align="center" valign="middle">

                                                                                                                                        <table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                                            <tr>
                                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="5" bgcolor="#FFFFFF">
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal">New Value</td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Merchant ID :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchantAccNoMap.getMerchantID()%>                                                                                
                                                                                                                                                                <input type="hidden" name="hdnMerchantAccPK" id="hdnMerchantAccPK" class="ddm_success" value="<%=selectedOtherAcc %>" readonly/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Merchant Name :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=merchantName %>  </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Account Bank :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchantAccNoMap.getBank() != null ? objMerchantAccNoMap.getBank(): "N/A"%>  - <%=objMerchantAccNoMap.getBankName() != null ? objMerchantAccNoMap.getBankName() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Account Branch :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchantAccNoMap.getBranch() != null ? objMerchantAccNoMap.getBranch() : "N/A"%> - <%=objMerchantAccNoMap.getBranchName()!= null ? objMerchantAccNoMap.getBranchName() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Account No. :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchantAccNoMap.getAcNo() != null ? objMerchantAccNoMap.getAcNo() : "N/A"%></td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Account Name </td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchantAccNoMap.getAcName() != null ? objMerchantAccNoMap.getAcName() : "N/A"%></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Is Primary<span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=(objMerchantAccNoMap.getIsPrimary()!=null?objMerchantAccNoMap.getIsPrimary().equals(DDM_Constants.status_yes )?"Yes":"No":"No") %></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Merchant Status<span  class="ddm_required_field"> * </span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                                <%
                                                                                                                                                                    String stat = null;

                                                                                                                                                                    if (objMerchant.getStatus() == null)
                                                                                                                                                                    {
                                                                                                                                                                        stat = "N/A";
                                                                                                                                                                    }
                                                                                                                                                                    else if (objMerchant.getStatus().equals(DDM_Constants.status_active))
                                                                                                                                                                    {
                                                                                                                                                                        stat = "Active";
                                                                                                                                                                    }
                                                                                                                                                                    else if (objMerchant.getStatus().equals(DDM_Constants.status_deactive))
                                                                                                                                                                    {
                                                                                                                                                                        stat = "Inactive";
                                                                                                                                                                    }
                                                                                                                                                                    else if (objMerchant.getStatus().equals(DDM_Constants.status_pending))
                                                                                                                                                                    {
                                                                                                                                                                        stat = "Approval Pending";
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        stat = "Other";
                                                                                                                                                                    }
                                                                                                                                                                %>

                                                                                                                                                                <%=stat%>                                                                                                                        </td>
                                                                                                                                                            <td class="ddm_tbl_common_text">
                                                                                                                                                                <select name="cmbStatus" id="cmbStatus" class="ddm_field_border" onFocus="hideMessage_onFocus()" > 
                                                                                                                                                                    <option value="<%=DDM_Constants.status_all %>" <%=(merchantOtherAccStatus_New != null && merchantOtherAccStatus_New.equals(DDM_Constants.status_active))? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_active %>" <%=(merchantOtherAccStatus_New != null && merchantOtherAccStatus_New.equals(DDM_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_deactive%>" <%=(merchantOtherAccStatus_New != null && merchantOtherAccStatus_New.equals(DDM_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                                </select>                                                                                </td>
                                                                                                                                                        </tr>                                                                                                                                                        

                                                                                                                                                        <tr>  <td height="35" colspan="3" align="right" class="ddm_tbl_footer_text">



                                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Update &nbsp;&nbsp;" onClick="doUpdate()" class="ddm_custom_button" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>>                             </td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                        <td><input type="button" name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((reqType != null && reqType.equals("1")) && result) ? "Done" : "Close"%> &nbsp;&nbsp;" class="ddm_custom_button" onClick="cancel()"/>                                                            </td></tr>
                                                                                                                                                                </table>

                                                                                                                                                            </td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table></td>
                                                                                                                                            </tr>
                                                                                                                                        </table>



                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%                                                                                                                }
                                                                                                            %>                                                                                </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                </td>
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