
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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Modify Merchant Details' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Modify_Merchant_Details");
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
    Collection<Bank> colBank = null;
    Collection<Bank> colBankNew = null;
    Collection<Branch> colBranch = null;
    Collection<Branch> colBranchNew = null;
    Collection<Merchant> colMerchant = null;
    Collection<MerchantAccNoMap> colAccNoMap = null;
    Merchant objMerchant = null;

    String reqType = null;

    String selectedBank = null;
    String selectedBranch = null;
    String selectedMerchant = null;

    String merchantID = null;
    String merchantName_New = null;
    String merchantEmail_New = null;
    String merchantPrimaryTelNo_New = null;
    String merchantSecondaryTelNo_New = null;
    String merchantPwd_New = null;
    String merchantRTPwd_New = null;
    String merchantBank_New = null;
    String merchantBranch_New = null;
    String merchantPrimaryAccountNo_New = null;
    String merchantPrimaryAccountName_New = null;
    String id = null;
    String status = null;
    String modificationRemarks = null;

    boolean isOkToDisable_txtPrimaryAccNo = false;
    boolean isValidAccountNo = false;

    String msg = null;

    boolean result = false;

    reqType = (String) request.getParameter("hdnRequestType");

    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colBankNew = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);

    if (reqType == null)
    {
        selectedBank = DDM_Constants.status_all;
        selectedBranch = DDM_Constants.status_all;
        selectedMerchant = DDM_Constants.status_all;

        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);
    }
    else if (reqType.equals("0"))
    {
        selectedBank = (String) request.getParameter("search_cmbBank");
        selectedBranch = (String) request.getParameter("search_cmbBranch");
        selectedMerchant = (String) request.getParameter("search_cmbMerchant");

        System.out.println("selectedBank 1 ===> " + selectedBank);
        System.out.println("selectedBranch 1 ===> " + selectedBranch);
        System.out.println("selectedMerchant 1 ===> " + selectedMerchant);

        if (!selectedBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(selectedBank, DDM_Constants.status_pending);
        }

        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, selectedBank, selectedBranch);

        if (!selectedMerchant.equals(DDM_Constants.status_all))
        {
            objMerchant = DAOFactory.getMerchantDAO().getMerchantDetails(selectedMerchant);
        }

        if (objMerchant != null)
        {
            merchantID = objMerchant.getMerchantID();
            merchantName_New = objMerchant.getMerchantName();
            merchantEmail_New = objMerchant.getEmail();
            merchantPrimaryTelNo_New = objMerchant.getPrimaryTP();
            merchantSecondaryTelNo_New = objMerchant.getSecondaryTP();
            merchantPwd_New = objMerchant.getPassword();
            merchantBank_New = objMerchant.getBankCode();
            merchantBranch_New = objMerchant.getBranchCode();
            merchantPrimaryAccountNo_New = objMerchant.getPrimaryAccountNo();
            merchantPrimaryAccountName_New = objMerchant.getPrimaryAccountName();
            id = objMerchant.getId();
            status = objMerchant.getStatus();
            modificationRemarks = objMerchant.getModificationRemarks();

            colBranchNew = DAOFactory.getBranchDAO().getBranchNotInStatus(objMerchant.getBankCode(), DDM_Constants.status_pending);
        }
    }
    else if (reqType.equals("1"))
    {
        selectedBank = (String) request.getParameter("search_cmbBank");
        selectedBranch = (String) request.getParameter("search_cmbBranch");
        selectedMerchant = (String) request.getParameter("search_cmbMerchant");

        System.out.println("selectedBank 2 ===> " + selectedBank);
        System.out.println("selectedBranch 2 ===> " + selectedBranch);
        System.out.println("selectedMerchant 2 ===> " + selectedMerchant);

        if (!selectedBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(selectedBank, DDM_Constants.status_pending);
        }

        colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatus(DDM_Constants.status_pending, selectedBank, selectedBranch);

        objMerchant = DAOFactory.getMerchantDAO().getMerchantDetails(selectedMerchant);

        if (objMerchant != null)
        {
            colBranchNew = DAOFactory.getBranchDAO().getBranchNotInStatus(objMerchant.getBankCode(), DDM_Constants.status_pending);
        }

        merchantID = objMerchant.getMerchantID();
        merchantName_New = (String) request.getParameter("txtMerchantName");
        merchantEmail_New = (String) request.getParameter("txtEmail");
        merchantPrimaryTelNo_New = (String) request.getParameter("txtPrimaryTel");
        merchantSecondaryTelNo_New = (String) request.getParameter("txtSecondaryTel");

        merchantPwd_New = request.getParameter("txtPassword");
        merchantRTPwd_New = request.getParameter("txtReTypePassword");

        merchantBank_New = (String) request.getParameter("cmbBank");
        merchantBranch_New = (String) request.getParameter("cmbBranch");
        merchantPrimaryAccountNo_New = (String) request.getParameter("txtPrimaryAccNo");
        merchantPrimaryAccountName_New = (String) request.getParameter("txtPrimaryAccName");
        id = (String) request.getParameter("txtID");
        status = (String) request.getParameter("cmbStatus");
        modificationRemarks = (String) request.getParameter("txtaModificationRemarks");

        MerchantDAO merchantDAO = DAOFactory.getMerchantDAO();

        Merchant objMerchant_New = new Merchant();

        objMerchant_New.setMerchantID(merchantID);
        objMerchant_New.setMerchantName(merchantName_New);
        objMerchant_New.setEmail(merchantEmail_New);
        objMerchant_New.setPrimaryTP(merchantPrimaryTelNo_New);
        objMerchant_New.setSecondaryTP(merchantSecondaryTelNo_New);

        if (merchantPwd_New != null && !merchantPwd_New.isEmpty())
        {
            objMerchant_New.setPassword(merchantPwd_New);
        }

        objMerchant_New.setBankCode(merchantBank_New);
        objMerchant_New.setBranchCode(merchantBranch_New);
        objMerchant_New.setPrimaryAccountNo(merchantPrimaryAccountNo_New);
        objMerchant_New.setPrimaryAccountName(merchantPrimaryAccountName_New);
        objMerchant_New.setId(id);
        objMerchant_New.setStatus(status);
        objMerchant_New.setModificationRemarks(modificationRemarks);
        objMerchant_New.setModifiedBy(session_userName);

        result = merchantDAO.modifyMerchant(objMerchant_New);

        if (!result)
        {
            msg = merchantDAO.getMsg();

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Merchant ID - " + merchantID + ", "
                    + "Name - (New : " + merchantName_New + ", Old : " + objMerchant.getMerchantName() + "), "
                    + "Email - (New :" + merchantEmail_New + ", Old : " + objMerchant.getEmail() + "), "
                    + "Primary Tel. No. - (New : " + merchantPrimaryTelNo_New + ", Old : " + objMerchant.getPrimaryTP() + "), "
                    + "Secondary Tel. No. - (New : " + (merchantSecondaryTelNo_New != null ? merchantSecondaryTelNo_New : "n/a") + ", Old : " + (objMerchant.getSecondaryTP() != null ? objMerchant.getSecondaryTP() : "n/a") + "), "
                    + "Bank - (New : " + merchantBank_New + ", Old : " + objMerchant.getBankCode() + "), "
                    + "Branch - (New : " + merchantBranch_New + ", Old : " + objMerchant.getBranchCode() + "), "
                    + "Primary Acc. No. - (New : " + merchantPrimaryAccountNo_New + ", Old : " + objMerchant.getPrimaryAccountNo() + "), "
                    + "Primary Acc. Name - (New : " + merchantPrimaryAccountName_New + ", Old : " + objMerchant.getPrimaryAccountName() + "), "
                    + "ID - (New : " + merchantID + ", Old : " + objMerchant.getId() + "), "
                    + "Status - (New : " + status + ", Old : " + (objMerchant.getStatus().equals(DDM_Constants.status_active) ? "Active" : objMerchant.getStatus().equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ") | "
                    + "Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));

        }
        else
        {

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_merchant_maintenance_modify_merchant_details, "| Merchant ID - " + merchantID + ", "
                    + "Name - (New : " + merchantName_New + ", Old : " + objMerchant.getMerchantName() + "), "
                    + "Email - (New :" + merchantEmail_New + ", Old : " + objMerchant.getEmail() + "), "
                    + "Primary Tel. No. - (New : " + merchantPrimaryTelNo_New + ", Old : " + objMerchant.getPrimaryTP() + "), "
                    + "Secondary Tel. No. - (New : " + (merchantSecondaryTelNo_New != null ? merchantSecondaryTelNo_New : "n/a") + ", Old : " + (objMerchant.getSecondaryTP() != null ? objMerchant.getSecondaryTP() : "n/a") + "), "
                    + "Bank - (New : " + merchantBank_New + ", Old : " + objMerchant.getBankCode() + "), "
                    + "Branch - (New : " + merchantBranch_New + ", Old : " + objMerchant.getBranchCode() + "), "
                    + "Primary Acc. No. - (New : " + merchantPrimaryAccountNo_New + ", Old : " + objMerchant.getPrimaryAccountNo() + "), "
                    + "Primary Acc. Name - (New : " + merchantPrimaryAccountName_New + ", Old : " + objMerchant.getPrimaryAccountName() + "), "
                    + "ID - (New : " + merchantID + ", Old : " + objMerchant.getId() + "), "
                    + "Status - (New : " + status + ", Old : " + (objMerchant.getStatus().equals(DDM_Constants.status_active) ? "Active" : objMerchant.getStatus().equals(DDM_Constants.status_deactive) ? "Inactive" : "Pending") + ") | "
                    + "Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));

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
            document.frmModifyMerchant.action="<%=request.getContextPath()%>/pages/homepage.jsp";
            document.frmModifyMerchant.submit();
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
                
                

                document.frmModifyMerchant.action="ModifyMerchant.jsp";
                document.frmModifyMerchant.submit();
            }			

            function doSearch()
            {                
                var cmbMerchantVal = document.getElementById('search_cmbMerchant').value;

                if(cmbMerchantVal==null || cmbMerchantVal=="<%=DDM_Constants.status_all%>")
                {
                clearResultData();
                return false;
                }
                else
                {
                setRequestType(false);
                document.frmModifyMerchant.action="ModifyMerchant.jsp";
                document.frmModifyMerchant.submit();				
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Modify Merchant Details</td>
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
                                                                                            <form name="frmModifyMerchant" id="frmModifyMerchant" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">


                                                                                                            <table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Bank :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="search_cmbBank" id="search_cmbBank" class="ddm_field_border" onChange="setRequestType(false);frmModifyMerchant.submit()" >
                                                                                                                                        <%
                                                                                                                                            if (selectedBank == null || (selectedBank != null && selectedBank.equals(DDM_Constants.status_all)))
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
                                                                                                                                        <option value="<%=bk.getBankCode()%>" <%=(selectedBank != null && bk.getBankCode().equals(selectedBank)) ? "selected" : ""%> > <%=bk.getBankCode() + " - " + bk.getBankFullName()%></option>
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
                                                                                                                                    <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Branch :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="search_cmbBranch" id="search_cmbBranch" class="ddm_field_border" onChange="setRequestType(false);frmModifyMerchant.submit()" >
                                                                                                                                        <%
                                                                                                                                            if (selectedBranch == null || (selectedBranch != null && selectedBranch.equals(DDM_Constants.status_all)))
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
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(selectedBranch != null && branch.getBranchCode().equals(selectedBranch)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
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
                                                                                                                                    <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="search_cmbMerchant" id="search_cmbMerchant" class="ddm_field_border" onChange="doSearch()" >
                                                                                                                                        <%
                                                                                                                                            if (selectedMerchant == null || (selectedMerchant != null && selectedMerchant.equals(DDM_Constants.status_all)))
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
                                                                                                                                            if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Merchant objMerch : colMerchant)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=objMerch.getMerchantID()%>" <%=(selectedMerchant != null && objMerch.getMerchantID().equals(selectedMerchant)) ? "selected" : ""%> > <%=objMerch.getMerchantID() + " - " + objMerch.getMerchantName()%></option>
                                                                                                                                        <%

                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No merchant details available!</span>
                                                                                                                                    <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /></td>
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

                                                                                                                        if (!selectedMerchant.equals(DDM_Constants.status_all))
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

                                                                                                                                            Merchant details modified Successfully.
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


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >Merchant details modification Failed.- <span class="ddm_error"><%=msg%></span></div>
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
                                                                                                                                                            <td colspan="2" align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getMerchantID()%>                                                                                
                                                                                                                                                                <input type="hidden" name="hdnMerchantID" id="hdnMerchantID" class="ddm_success" value="<%=objMerchant.getMerchantID()%>" /></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Merchant Name <span  class="ddm_required_field">* </span>:</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getMerchantName()%>  </td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input id="txtMerchantName" name="txtMerchantName" type="text" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantName_New != null ? merchantName_New : ""%>" size="100" maxlength="100"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Email<span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getEmail() != null ? objMerchant.getEmail() : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmail" id="txtEmail" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantEmail_New != null ? merchantEmail_New : ""%>" size="80" maxlength="100"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Primary Telephone No. <span  class="ddm_required_field">*</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getPrimaryTP() != null ? objMerchant.getPrimaryTP() : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtPrimaryTel" id="txtPrimaryTel" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantPrimaryTelNo_New != null ? merchantPrimaryTelNo_New : ""%>" size="20" maxlength="20"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Secondary Telephone No. :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getSecondaryTP() != null ? objMerchant.getSecondaryTP() : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtSecondaryTel" id="txtSecondaryTel" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantSecondaryTelNo_New != null ? merchantSecondaryTelNo_New : ""%>" size="20" maxlength="20"/></td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Primary Account Bank  <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getBankCode() != null ? objMerchant.getBankCode() : "N/A"%> - <%=objMerchant.getBankName() != null ? objMerchant.getBankName() : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                                <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="isRequest(false);frmModifyMerchant.submit()" >

                                                                                                                                                                    <%
                                                                                                                                                                        if (colBankNew != null && colBankNew.size() > 0)
                                                                                                                                                                        {
                                                                                                                                                                            for (Bank bk : colBankNew)
                                                                                                                                                                            {
                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=bk.getBankCode()%>" <%=(merchantBank_New != null && bk.getBankCode().equals(merchantBank_New)) ? "selected" : ""%> > <%=bk.getBankCode() + " - " + bk.getBankFullName()%></option>
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
                                                                                                                                                                <%
                                                                                                                                                                    }

                                                                                                                                                                %></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Primary Account Branch <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getBranchCode() != null ? objMerchant.getBranchCode() : "N/A"%> - <%=objMerchant.getBranchName() != null ? objMerchant.getBranchName() : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text">

                                                                                                                                                                <select name="cmbBranch" id="cmbBranch" class="ddm_field_border" >                                                                                                                                                                    
                                                                                                                                                                    <%
                                                                                                                                                                        if (colBranchNew != null && colBranchNew.size() > 0)
                                                                                                                                                                        {
                                                                                                                                                                            for (Branch branch : colBranchNew)
                                                                                                                                                                            {
                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=branch.getBranchCode()%>" <%=(merchantBranch_New != null && branch.getBranchCode().equals(merchantBranch_New)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
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
                                                                                                                                                                <%
                                                                                                                                                                    }
                                                                                                                                                                %>                                                                                                                                                            </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Primary Account No. <span  class="ddm_required_field">* </span>:</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getPrimaryAccountNo()%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtPrimaryAccNo" id="txtPrimaryAccNo" maxlength="15" size="18" class="ddm_field_border" onChange="isVldAccountNo()" onFocus="isVldAccountNo()" onBlur="isVldAccountNo()" onKeyUp="isVldAccountNo()" onMouseUp="isVldAccountNo()" value="<%=merchantPrimaryAccountNo_New != null ? merchantPrimaryAccountNo_New : ""%>" > 


                                                                                                                                                                <input type="hidden" name="hdnChangeCount" id="hdnChangeCount" value="0" />
                                                                                                                                                                <input type="hidden" name="hdnPrevAccountNo" id="hdnPrevAccountNo" value="0" /></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Primary Account Name <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=objMerchant.getPrimaryAccountName()%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input id="txtPrimaryAccName" name="txtPrimaryAccName" type="text" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantPrimaryAccountName_New != null ? merchantPrimaryAccountName_New : ""%>" size="100" maxlength="100"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Other Accounts :<span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text">

                                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">


                                                                                                                                                                    <%
                                                                                                                                                                        colAccNoMap = objMerchant.getColAccNoMap();

                                                                                                                                                                        if (colAccNoMap != null && colAccNoMap.size() > 1)
                                                                                                                                                                        {
                                                                                                                                                                    %>
                                                                                                                                                                    <tr><td>

                                                                                                                                                                            <table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                                                <%
                                                                                                                                                                                    for (MerchantAccNoMap merchantAccNoMap : colAccNoMap)
                                                                                                                                                                                    {
                                                                                                                                                                                        if (!((merchantAccNoMap != null) && (merchantAccNoMap.getIsPrimary() != null) && (merchantAccNoMap.getIsPrimary().equals(DDM_Constants.status_yes))))
                                                                                                                                                                                        {
                                                                                                                                                                                %>

                                                                                                                                                                                <tr>
                                                                                                                                                                                    <td class="ddm_common_text"><%=merchantAccNoMap.getAcNo()%></td>
                                                                                                                                                                                    <td class="ddm_common_text"><%=merchantAccNoMap.getAcName() != null ? merchantAccNoMap.getAcName() : "N/A"%></td>
                                                                                                                                                                                    <td class="ddm_common_text">(<%=merchantAccNoMap.getStatus() != null ? merchantAccNoMap.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : merchantAccNoMap.getStatus().equals(DDM_Constants.status_active) ? "Active" : "Inactive" : "N/A"%>)</td>
                                                                                                                                                                                    <td class="ddm_common_text">&nbsp;</td>
                                                                                                                                                                                </tr>

                                                                                                                                                                                <%
                                                                                                                                                                                        }
                                                                                                                                                                                    }
                                                                                                                                                                                %>
                                                                                                                                                                            </table>

                                                                                                                                                                        </td></tr>
                                                                                                                                                                        <%
                                                                                                                                                                        }
                                                                                                                                                                        else
                                                                                                                                                                        {
                                                                                                                                                                        %>
                                                                                                                                                                    <tr><td align="center" class="ddm_header_small_text">
                                                                                                                                                                            Not Available
                                                                                                                                                                        </td>
                                                                                                                                                                    </tr>
                                                                                                                                                                    <%
                                                                                                                                                                        }
                                                                                                                                                                    %>                                                                                                                                            	
                                                                                                                                                                </table>                                                                                                                                                </td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td width="10" align="center">&nbsp;</td>
                                                                                                                                                                        <td align="center"><input type="button" name="btnAddAccount" id="btnAddAccount" value="&nbsp;&nbsp; Add More Accounts &nbsp;&nbsp;" alt="Add New Account For The Mmerchant" class="ddm_custom_button_small" width="30" onClick="javascript:window.open('AddOtherAccounts.jsp?mid=<%=merchantID%>', 'AddOtherAccounts', 'width=960,height=650,location=0,status=0,manubar=0,resizable=1,scrollbars=1,toolbar=0')" ></td>
                                                                                                                                                                        <td width="10" align="center">&nbsp;</td>
                                                                                                                                                                        <td align="center"><input type="button" name="btnAddAccount" id="btnAddAccount" value="&nbsp;&nbsp; Modify Other Accounts &nbsp;&nbsp;" alt="Add New Account For The Mmerchant" class="ddm_custom_button_small" width="30" onClick="javascript:window.open('ModifyOtherAccounts.jsp?mid=<%=merchantID%>', 'ModifyOtherAccounts', 'width=960,height=650,location=0,status=0,manubar=0,resizable=1,scrollbars=1,toolbar=0')" ></td>
                                                                                                                                                                    </tr></table></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">ID <span  class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><span class="ddm_common_text"><%=objMerchant.getId()%></span></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtID" id="txtID" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=id != null ? id : ""%>" size="20" maxlength="20"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Password <span  class="ddm_required_field"> *</span> : </td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><%=merchantPwd_New != null ? "************" : "N/A"%></td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="password" name="txtPassword" id="txtPassword" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%= (reqType != null && reqType.equals("1") && merchantPwd_New != null) ? merchantPwd_New : ""%>" size="40" maxlength="50"/></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td class="ddm_tbl_header_text">Confirm Password <span class="ddm_required_field"> *</span> :</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text">&nbsp;</td>
                                                                                                                                                            <td align="left" valign="middle" class="ddm_tbl_common_text"><input type="password" name="txtReTypePassword" id="txtReTypePassword" class="ddm_field_border" onFocus="hideMessage_onFocus()"  value="<%=merchantRTPwd_New != null ? merchantRTPwd_New : ""%>" size="40" maxlength="50"/></td>
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
                                                                                                                                                                    <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_active%>" <%=status != null && status.equals(DDM_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_deactive%>" <%=status != null && status.equals(DDM_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                                </select>                                                                                </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                          <td class="ddm_tbl_header_text">Modification Remarks :</td>
                                                                                                                                                          <td align="left" valign="middle" class="ddm_tbl_common_text"><%=modificationRemarks != null ? modificationRemarks : "N/A"%></td>
                                                                                                                                                          <td class="ddm_tbl_common_text"><textarea name="txtaModificationRemarks" id="txtaModificationRemarks" class="ddm_field_border" cols="60" rows="4"><%= (reqType != null && reqType.equals("1") && modificationRemarks != null) ? modificationRemarks : ""%></textarea></td>
                                                                                                                                                        </tr>                                                                                                                                                        

                                                                                                                                                        <tr>  <td height="35" colspan="3" align="right" class="ddm_tbl_footer_text">



                                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Update &nbsp;&nbsp;" onClick="doUpdate()" class="ddm_custom_button" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>>                             </td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                        <td><input type="button" name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((reqType != null && reqType.equals("1")) && result) ? "Done" : "Cancel"%> &nbsp;&nbsp;" class="ddm_custom_button" onClick="cancel()"/>                                                            </td></tr>
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