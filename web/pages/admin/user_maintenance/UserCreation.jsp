<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>

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
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Create Users' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Create_Users");
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
    Collection<UserLevel> colUserLevel = null;
    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<Merchant> colMerchant = null;

    String isReq = null;
    String newUserId = null;
    String newUserLevel = null;

    String newUserBank = null;
    String newUserBranch = null;
    String newUserMerchant = null;

    String newName = null;
    String newEmpID = null;
    String newNIC_Passport = null;
    String rbNIC_Passport = null;
    String newDesignation = null;
    String newEmail = null;
    String newContactNo = null;

    String newUserRemarks = null;
    String defaultPwd = null;
    String msg = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatusBasicDetails(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

    isReq = (String) request.getParameter("hdnReq");
    //System.out.println("isReq - " + isReq);

    if (isReq == null)
    {
        isReq = "0";
        newUserLevel = DDM_Constants.default_web_combo_select;
        newUserBank = DDM_Constants.default_web_combo_select;
        newUserBranch = DDM_Constants.default_web_combo_select;
    }
    else if (isReq.equals("0"))
    {
        newUserId = request.getParameter("txtUserName");
        newUserLevel = request.getParameter("cmbUserLevel");
        newUserBank = request.getParameter("cmbBank");
        newUserBranch = request.getParameter("cmbBranch");
        newUserMerchant = request.getParameter("cmbMerchant");
        newName = request.getParameter("txtName");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");

        newEmpID = request.getParameter("txtEmpID");
        newNIC_Passport = request.getParameter("txtNIC");
        rbNIC_Passport = request.getParameter("rbNICPassport");

        newUserRemarks = request.getParameter("txtaRemarks");

        if (newUserLevel != null)
        {
            if (newUserLevel.equals(DDM_Constants.user_type_bank_manager) || newUserLevel.equals(DDM_Constants.user_type_bank_user))
            {
                if (newUserBank != null && !newUserBank.equals(DDM_Constants.status_all))
                {
                    colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, DDM_Constants.status_pending);
                }
            }
            else if (newUserLevel.equals(DDM_Constants.user_type_merchant_su) || newUserLevel.equals(DDM_Constants.user_type_merchant_op))
            {
                newUserBank = DDM_Constants.default_bank_code;
                newUserBranch = DDM_Constants.default_branch_code;
                colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, DDM_Constants.status_pending);
            }
            else
            {
                newUserBank = DDM_Constants.lcpl_bank_code;
                newUserBranch = DDM_Constants.bank_default_branch_code;
                colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, DDM_Constants.status_pending);
            }

        }
        else
        {
            newUserBank = DDM_Constants.default_bank_code;
            newUserBranch = DDM_Constants.default_branch_code;
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, DDM_Constants.status_pending);
        }

        if (newUserBranch == null)
        {
            newUserBranch = DDM_Constants.bank_default_branch_code;
        }
        else
        {
            if (newUserBranch.equals(DDM_Constants.default_web_combo_select) || newUserBranch.equals(DDM_Constants.status_all) || newUserBranch.length() != 3)
            {
                newUserBranch = DDM_Constants.bank_default_branch_code;
            }
        }

        if (newUserMerchant == null)
        {
            newUserMerchant = DDM_Constants.default_coporate_customer_id;
        }
        else
        {
            if (newUserMerchant.equals(DDM_Constants.default_web_combo_select) || newUserMerchant.equals(DDM_Constants.status_all) || newUserMerchant.length() != 4)
            {
                newUserMerchant = DDM_Constants.default_coporate_customer_id;
            }
        }
    }
    else if (isReq.equals("1"))
    {

        newUserLevel = request.getParameter("cmbUserLevel");
        newUserBank = request.getParameter("cmbBank");
        newUserBranch = request.getParameter("cmbBranch");
        newUserMerchant = request.getParameter("cmbMerchant");

        System.out.println("newUserLevel ===> " + newUserLevel);
        System.out.println("newUserBank ===> " + newUserBank);
        System.out.println("newUserBranch ===> " + newUserBranch);

        if (newUserMerchant != null)
        {
            System.out.println("newUserMerchant ===> " + newUserMerchant);
        }
        else
        {
            System.out.println("newUserMerchant ===> is null");
        }

        if (newUserBranch == null)
        {
            newUserBranch = DDM_Constants.bank_default_branch_code;
        }
        else
        {
            if (newUserBranch.equals(DDM_Constants.default_web_combo_select) || newUserBranch.equals(DDM_Constants.status_all) || newUserBranch.length() != 3)
            {
                newUserBranch = DDM_Constants.bank_default_branch_code;
            }
        }

        if (newUserMerchant == null)
        {
            newUserMerchant = DDM_Constants.default_coporate_customer_id;
        }
        else
        {
            if (newUserMerchant.equals(DDM_Constants.default_web_combo_select) || newUserMerchant.equals(DDM_Constants.status_all) || newUserMerchant.length() != 4)
            {
                newUserMerchant = DDM_Constants.default_coporate_customer_id;
            }
        }

        newUserId = request.getParameter("txtUserName");
        newName = request.getParameter("txtName");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");

        newEmpID = request.getParameter("txtEmpID");
        newNIC_Passport = request.getParameter("txtNIC");
        rbNIC_Passport = request.getParameter("rbNICPassport");

        newUserRemarks = request.getParameter("txtaRemarks");

        if (newUserBank != null && !newUserBank.equals(DDM_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, DDM_Constants.status_pending);
        }

        User usr = new User();

        usr.setUserId(newUserId.trim());
        usr.setUserLevelId(newUserLevel);

        //defaultPwd = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);
        defaultPwd = "";
        usr.setPassword(defaultPwd);

        usr.setBankCode(newUserBank);
        usr.setBranchCode(newUserBranch);
        usr.setStatus(DDM_Constants.status_pending);
        usr.setCoCuId(newUserMerchant);
        usr.setName(newName);
        usr.setEmpId(newEmpID);
        usr.setDesignation(newDesignation);
        usr.setEmail(newEmail);
        usr.setContactNo(newContactNo);

        usr.setRemarks(newUserRemarks);
        usr.setCreatedBy(session_userName);
        usr.setIsInitialPassword(DDM_Constants.status_yes);
        usr.setNeedDownloadToBIM(DDM_Constants.status_yes);

        if (newNIC_Passport != null)
        {
            newNIC_Passport = newNIC_Passport.replaceFirst("N:", "").replaceFirst("P:", "");

            if (rbNIC_Passport != null)
            {
                if (rbNIC_Passport.equals("N"))
                {
                    newNIC_Passport = "N:" + newNIC_Passport;
                }
                else if (rbNIC_Passport.equals("P"))
                {
                    newNIC_Passport = "P:" + newNIC_Passport;
                }
                else
                {
                    newNIC_Passport = "";
                }
            }
            else
            {
                newNIC_Passport = "";
            }
        }
        else
        {
            newNIC_Passport = "";
        }

        usr.setNIC(newNIC_Passport);

        usr.setTokenSerial("");

        UserDAO userDAO = DAOFactory.getUserDAO();
        result = userDAO.addUser(usr);

        UserLevel usrlvl = DAOFactory.getUserLevelDAO().getUserLevel(newUserLevel);

        String newUserStatusDesc = "Pending";

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_add_new_user, "| Username - " + newUserId + ", Type - " + usrlvl.getUserLevelDesc() + ", Status - " + newUserStatusDesc + ", Bank - " + newUserBank + ", Branch - " + newUserBranch + ", Merchant - " + newUserMerchant + ", Name - " + newName + ", Emp ID - " + (newEmpID != null ? newEmpID : "") + ", Designation - " + newDesignation + ", Email - " + newEmail + ", Contact No. - " + newContactNo + ", Contact No. - " + newContactNo + ", NIC - " + (newNIC_Passport != null ? newNIC_Passport.replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Remarks - " + (newUserRemarks != null ? newUserRemarks : "") + " | Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_add_new_user, "| Username - " + newUserId + ", Type - " + usrlvl.getUserLevelDesc() + ", Status - " + newUserStatusDesc + ", Bank - " + newUserBank + ", Branch - " + newUserBranch + ", Merchant - " + newUserMerchant + ", Name - " + newName + ", Emp ID - " + (newEmpID != null ? newEmpID : "") + ", Designation - " + newDesignation + ", Email - " + newEmail + ", Contact No. - " + newContactNo + ", NIC - " + (newNIC_Passport != null ? newNIC_Passport.replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Remarks - " + (newUserRemarks != null ? newUserRemarks : "") + " | Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System- Create Users</title>
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


        <script language="javascript" type="text/JavaScript">

            function resetRecords()
            {   
            document.getElementById('cmbUserLevel').selectedIndex = 0;
            document.getElementById('cmbBank').selectedIndex = 0; 

            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').selectedIndex = 0; 
            }

            if(document.getElementById('cmbMerchant')!=null)
            {
            document.getElementById('cmbMerchant').selectedIndex = 0; 
            }

            document.getElementById('txtUserName').value = "";
            document.getElementById('txtName').value = "";
            document.getElementById('txtNIC').value = "";
            document.getElementById('txtEmpID').value = "";
            document.getElementById('txtDesignation').value = "";
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtContactNo').value = "";				
            document.getElementById('txtaRemarks').value = "";
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

            function fieldValidation()
            {
            var userLevel = document.getElementById('cmbUserLevel').value;
            var selbank = document.getElementById('cmbBank').value;
            var selBranch = "";
            var selMerchant = "";

            if(document.getElementById('cmbBranch') != null)
            {
            selBranch = document.getElementById('cmbBranch').value; 
            }

            if(document.getElementById('cmbMerchant') != null)
            {
            selMerchant = document.getElementById('cmbMerchant').value;
            }

            var v_username = document.getElementById('txtUserName').value;
            var v_name = document.getElementById('txtName').value;
            var v_nic = document.getElementById('txtNIC').value;
            var v_desig = document.getElementById('txtDesignation').value;  
            var v_email = document.getElementById('txtEmail').value;  
            var v_contactno = document.getElementById('txtContactNo').value;   

            if(userLevel == "<%=DDM_Constants.default_web_combo_select%>" || userLevel == null)
            {
            alert("Select User Type.");
            document.getElementById('cmbUserLevel').focus();
            return false;
            }

            if((userLevel == "<%=DDM_Constants.user_type_bank_manager%>" || userLevel == "<%=DDM_Constants.user_type_bank_user%>")  && selbank=="<%=DDM_Constants.default_web_combo_select%>")
            {
            alert("Please select the 'Bank' for the user.");
            document.getElementById('cmbBank').focus();
            return false;
            } 

            if((userLevel == "<%=DDM_Constants.user_type_merchant_su%>" || userLevel == "<%=DDM_Constants.user_type_merchant_su%>")  && selMerchant == "<%=DDM_Constants.default_web_combo_select%>")
            {
            alert("Please select the 'Merchant' for the user.");
            document.getElementById('cmbMerchant').focus();
            return false;
            }

            if(isempty(trim(v_username)))
            {
            alert("'Username' can not be empty!");
            document.getElementById('txtUserName').focus();
            return false;
            }

            if(isempty(trim(v_name)))
            {
            alert("'Name' can not be empty!");
            document.getElementById('txtName').focus();
            return false;
            }

            if(isempty(trim(v_nic)))
            {
            alert("'NIC/Password' can not be empty!");
            document.getElementById('txtNIC').focus();
            return false;
            }

            if(isempty(trim(v_desig)))
            {
            alert("Designation can not be empty!");
            document.getElementById('txtDesignation').focus();
            return false;
            }

            if(isempty(trim(v_email)))
            {
            alert("Email can not be empty!");
            document.getElementById('txtEmail').focus();
            return false;
            }

            if(isempty(trim(v_contactno)))
            {
            alert("'Contact No.' can not be empty!");
            document.getElementById('txtContactNo').focus();
            return false;
            }

            document.getElementById('cmbBank').disabled =false;

            document.frmCreateUser.action="UserCreation.jsp";
            document.frmCreateUser.submit();        
            }

            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            }

            function showDivisionArea()
            {        
            if('<%=isReq%>' == '0')
            {
            // alert("isReq");
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'none';                    
            }
            else 
            {
            if('<%=result%>' == 'true')
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            else
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error') != null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }
            }

            function isSearchRequest(status)
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


            function createUserSubmit()
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Create New User</td>
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
                                                                                            <form method="post" name="frmCreateUser" id="frmCreateUser">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                User Created Sucessfully and pending for authorization <span class="ddm_error">(Manager Level Authorization Is Mandatory)</span>  !


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="ddm_Display_Error_msg" >User Creation Failed.- <span class="ddm_error"><%=msg%></span></div>
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








                                                                                                            <table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td>




                                                                                                                        <table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">User Type <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                <select name="cmbUserLevel" id="cmbUserLevel" class="ddm_field_border" onChange="isSearchRequest(false);
                                                                                                                                                                frmCreateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <option value="<%=DDM_Constants.default_web_combo_select%>" <%=(newUserLevel != null && newUserLevel.equals(DDM_Constants.default_web_combo_select)) ? "selected" : ""%>>--Select User Type--</option>
                                                                                                                                                    <%for (UserLevel usrlvl : colUserLevel)
                                                                                                                                                        {%>
                                                                                                                                                    <option value=<%=usrlvl.getUserLevelId()%> <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                                    <%}%>
                                                                                                                                                </select>                             </td>
                                                                                                                                        </tr>



                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Bank <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">

                                                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <select name="cmbBank" id="cmbBank" class="ddm_field_border" onChange="isSearchRequest(false);frmCreateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                                                <option value="<%=DDM_Constants.default_web_combo_select%>" <%=(newUserBank != null && newUserBank.equals(DDM_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select Bank --</option>
                                                                                                                                                                <%
                                                                                                                                                                    if (colBank != null && colBank.size() > 0)
                                                                                                                                                                    {
                                                                                                                                                                        for (Bank bank : colBank)
                                                                                                                                                                        {%>
                                                                                                                                                                <option value="<%=bank.getBankCode()%>" <%=(newUserBank != null && bank.getBankCode().equals(newUserBank)) ? "selected" : ""%> ><%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                                                <%}
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                            </select></td>
                                                                                                                                                        <td>&nbsp;</td>
                                                                                                                                                        <td><select name="cmbBranch" id="cmbBranch" class="ddm_field_border" onFocus="hideMessage_onFocus()" style="visibility:hidden">                                                                                                                                       

                                                                                                                                                                <%
                                                                                                                                                                    if (colBranch != null && colBranch.size() > 0)
                                                                                                                                                                    {
                                                                                                                                                                        for (Branch branch : colBranch)
                                                                                                                                                                        {

                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=branch.getBranchCode()%>" <%=(newUserBranch != null && branch.getBranchCode().equals(newUserBranch)) ? "selected" : ""%> >
                                                                                                                                                                    <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                                                    <%
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                    %>
                                                                                                                                                            </select></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>                                                                                                                                                </td>
                                                                                                                                        </tr>

                                                                                                                                        <!-- Start table row for Merchant    -->
                                                                                                                                        <%
                                                                                                                                            if (newUserLevel != null && (newUserLevel.equals(DDM_Constants.user_type_merchant_su) || newUserLevel.equals(DDM_Constants.user_type_merchant_op)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Merchant <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                <select name="cmbMerchant" id="cmbMerchant" class="ddm_field_border"  onChange="clearResultData()" >
                                                                                                                                                    <option value="<%=DDM_Constants.default_web_combo_select%>" <%=(newUserMerchant != null && newUserMerchant.equals(DDM_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select Merchant --</option>
                                                                                                                                                    <%
                                                                                                                                                        if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                                        {
                                                                                                                                                            for (Merchant merchant : colMerchant)
                                                                                                                                                            {

                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=merchant.getMerchantID()%>" <%=(newUserMerchant != null && merchant.getMerchantID().equals(newUserMerchant)) ? "selected" : ""%> ><%=merchant.getMerchantID()%> - <%=merchant.getMerchantName()%></option>
                                                                                                                                                    <%
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>

                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>

                                                                                                                                        <!-- End table row for Merchant    -->


                                                                                                                                        <tr>
                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">
                                                                                                                                                Username <span class="ddm_required_field">*</span>  :        </td>

                                                                                                                                            <td width="185" valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text">
                                                                                                                                                <input name="txtUserName" type="text" class="ddm_field_border" id="txtUserName" onFocus="hideMessage_onFocus()" value="<%=(newUserId != null) ? newUserId : ""%>" size="25" maxlength="20"/> </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Name <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtName" id="txtName" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newName != null) ? newName : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">NIC | Passport No. <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="text" name="txtNIC" id="txtNIC" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newNIC_Passport != null) ? newNIC_Passport.replaceFirst("N:", "").replaceFirst("P:", "") : ""%>" size="20" maxlength="20"></td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input type="radio" name="rbNICPassport" id="rbNICPassport1" value="N"<%=rbNIC_Passport == null ? "checked" : ""%> <%=(rbNIC_Passport != null && rbNIC_Passport.equals("N")) ? "checked" : ""%> ></td>
                                                                                                                                                        <td width="3"></td>
                                                                                                                                                        <td class="ddm_common_text">NIC</td>
                                                                                                                                                        <td width="6"></td>
                                                                                                                                                        <td><input type="radio" name="rbNICPassport" id="rbNICPassport2" value="P" <%=(rbNIC_Passport != null && rbNIC_Passport.equals("P")) ? "checked" : ""%>></td>
                                                                                                                                                        <td width="3"></td>
                                                                                                                                                        <td class="ddm_common_text">Passport</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>                                                                                                                                          </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Employee ID <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmpID" id="txtEmpID" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmpID != null) ? newEmpID : ""%>" size="16" maxlength="15"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Designation <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtDesignation" id="txtDesignation" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newDesignation != null) ? newDesignation : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Email <span class="ddm_required_field">*</span> : </td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmail" id="txtEmail" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmail != null) ? newEmail : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Contact No. <span class="ddm_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtContactNo" id="txtContactNo" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newContactNo != null) ? newContactNo : ""%>" size="20" maxlength="20"></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Remarks :</td>
                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="60" onFocus="hideMessage_onFocus()" class="ddm_field_border"><%=(newUserRemarks != null) ? newUserRemarks : ""%></textarea></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" class="ddm_tbl_footer_text">                                                                                                                     
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Create &nbsp;&nbsp;" name="btnAdd" class="ddm_custom_button" <%=((isReq != null && isReq.equals("1")) && result) ? "disabled" : ""%> onClick="createUserSubmit()"/>                             </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Reset &nbsp;&nbsp;" type="button" onClick="resetRecords()" class="ddm_custom_button" />                                                            </td></tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>










                                                                                                        </td>
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
