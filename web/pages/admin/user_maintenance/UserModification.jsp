<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../../error.jsp"%>


<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>

<%
    String session_userName = null;
    String session_userType = null;
    String session_userTypeDesc = null;
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
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            //session.invalidate();
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Modify User Details' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Modify_User_Details");
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
    Collection<Bank> colBank = null;
    Collection<Merchant> colMerchant = null;
    Collection<UserLevel> colUserLevel = null;
    Collection<User> col_user = null;
    

    User userDetails = null;

    String reqType = null;
    String selectedUsername = null;
    String selectedUserLevel = null;
    String selectedUserStatus = null;
    String selectedUserBank = null;
    String selectedUserMerchant = null;

    String userID = null;
    String newUserStatus = null;
    String newUserStatusDesc = null;
    String oldUserStatusDesc = null;
    String newUserBank = null;
    //String newUserBranch = null;
    String newMerchantId = null;
    String newUserLevel = null;
    String newUserLevelDesc = null;
    String newName = null;
    String newEmpID = null;
    String newDesignation = null;
    String newEmail = null;
    String newContactNo = null;
    String newRemarks = null;
    String newNIC = null;
    String rbNIC_Passport = null;
    //String newTokenSerial = null;
    String defaultPwd = null;
    String msg = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatusBasicDetails(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);

    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);

    reqType = (String) request.getParameter("hdnRequestType");
    //System.out.println("reqType - " + reqType);

    if (reqType == null)
    {
        reqType = "0";

        selectedUserLevel = DDM_Constants.status_all;
        selectedUserBank = DDM_Constants.status_all;
        selectedUserMerchant = DDM_Constants.status_all;
        selectedUserStatus = DDM_Constants.status_all;
        selectedUsername = DDM_Constants.default_web_combo_select;

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_pending + "'");
    }
    else if (reqType.equals("0"))
    {
        System.out.println("Inside 1111111111");

        selectedUserLevel = request.getParameter("search_cmbUserLevel");

        System.out.println("selectedUserLevel ====> " + selectedUserLevel);

        if (selectedUserLevel != null && !selectedUserLevel.equals(DDM_Constants.status_all))
        {
            if (selectedUserLevel.equals(DDM_Constants.user_type_merchant_su) || selectedUserLevel.equals(DDM_Constants.user_type_merchant_op))
            {
                selectedUserBank = DDM_Constants.status_all;
                selectedUserMerchant = (String) request.getParameter("search_cmbMerchant");
            }
            else if (selectedUserLevel.equals(DDM_Constants.user_type_bank_manager) || selectedUserLevel.equals(DDM_Constants.user_type_bank_user))
            {
                selectedUserBank = (String) request.getParameter("search_cmbBank");
                selectedUserMerchant = DDM_Constants.status_all;
            }
            else
            {
                selectedUserBank = DDM_Constants.lcpl_bank_code;
                selectedUserMerchant = DDM_Constants.status_all;
            }
        }
        else
        {
            selectedUserBank = DDM_Constants.status_all;
            selectedUserMerchant = DDM_Constants.status_all;
        }

        selectedUserStatus = request.getParameter("search_cmbUserStatus");
        selectedUsername = request.getParameter("search_cmbUserId");

        System.out.println("selectedUserLevel ====> " + selectedUserLevel);
        System.out.println("selectedUserBank ====> " + selectedUserBank);
        System.out.println("selectedUserMerchant ====> " + selectedUserMerchant);
        System.out.println("selectedUserStatus ====> " + selectedUserStatus);

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_pending + "'");

        if (selectedUsername != null && !selectedUsername.equals(DDM_Constants.default_web_combo_select))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, DDM_Constants.status_all);

            if (userDetails != null)
            {
                newUserLevel = request.getParameter("cmbUserLevel");

                if (newUserLevel == null || newUserLevel.equals(DDM_Constants.status_all))
                {
                    newUserLevel = userDetails.getUserLevelId();
                }

                newUserBank = request.getParameter("cmbBank");

                if (newUserBank == null || newUserBank.equals(DDM_Constants.status_all))
                {
                    newUserBank = userDetails.getBankCode();
                }

                newMerchantId = request.getParameter("cmbMerchant");

                if (newMerchantId == null || newMerchantId.equals(DDM_Constants.status_all))
                {
                    newMerchantId = userDetails.getCoCuId();
                }

                newUserStatus = request.getParameter("cmbUserStatus");

                if (newUserStatus == null || newUserStatus.equals(DDM_Constants.status_all))
                {
                    newUserStatus = userDetails.getStatus();
                }

                newUserStatusDesc = newUserStatus != null ? newUserStatus.equals(DDM_Constants.status_active) ? "Active" : newUserStatus.equals(DDM_Constants.status_deactive) ? "Deactive" : newUserStatus.equals(DDM_Constants.status_locked) ? "Locked" : newUserStatus.equals(DDM_Constants.status_expired) ? "Expired" : newUserStatus.equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";
                oldUserStatusDesc = userDetails.getStatus() != null ? userDetails.getStatus().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatus().equals(DDM_Constants.status_deactive) ? "Deactive" : userDetails.getStatus().equals(DDM_Constants.status_locked) ? "Locked" : userDetails.getStatus().equals(DDM_Constants.status_expired) ? "Expired" : userDetails.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";

                newName = userDetails.getName();
                newEmpID = userDetails.getEmpId();
                newDesignation = userDetails.getDesignation();
                newEmail = userDetails.getEmail();
                newContactNo = userDetails.getContactNo();
                newNIC = userDetails.getNIC();
                //newTokenSerial = userDetails.getTokenSerial();
                newRemarks = userDetails.getRemarks();

                if (userDetails.getNIC() != null)
                {
                    if (userDetails.getNIC().startsWith("N:"))
                    {
                        rbNIC_Passport = "N";
                    }
                    else if (userDetails.getNIC().startsWith("P:"))
                    {
                        rbNIC_Passport = "P";
                    }
                    else
                    {
                        rbNIC_Passport = "N";
                    }
                }
                else
                {
                    rbNIC_Passport = "N";
                }
            }
        }
    }
    else if (reqType.equals("1"))
    {
        selectedUserLevel = request.getParameter("search_cmbUserLevel");

        if (selectedUserLevel != null && !selectedUserLevel.equals(DDM_Constants.status_all))
        {
            if (selectedUserLevel.equals(DDM_Constants.user_type_merchant_su) || selectedUserLevel.equals(DDM_Constants.user_type_merchant_op))
            {
                selectedUserBank = DDM_Constants.status_all;
                selectedUserMerchant = (String) request.getParameter("search_cmbMerchant");
            }
            else if (selectedUserLevel.equals(DDM_Constants.user_type_bank_manager) || selectedUserLevel.equals(DDM_Constants.user_type_bank_user))
            {
                selectedUserBank = (String) request.getParameter("search_cmbBank");
                selectedUserMerchant = DDM_Constants.status_all;
            }
            else
            {
                selectedUserBank = DDM_Constants.lcpl_bank_code;
                selectedUserMerchant = DDM_Constants.status_all;
            }
        }
        else
        {
            selectedUserBank = DDM_Constants.status_all;
            selectedUserMerchant = DDM_Constants.status_all;
        }

        selectedUserStatus = request.getParameter("search_cmbUserStatus");
        selectedUsername = request.getParameter("search_cmbUserId");

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, DDM_Constants.status_all, selectedUserMerchant, selectedUserStatus), "'" + DDM_Constants.status_pending + "'");

        if (selectedUsername != null && !selectedUsername.equals(DDM_Constants.default_web_combo_select))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, DDM_Constants.status_all);
        }

        userID = request.getParameter("hdnUsername");
        newUserLevel = request.getParameter("cmbUserLevel");

        if (newUserLevel == null)
        {
            newUserLevel = userDetails.getUserLevelId();
        }

        newUserStatus = request.getParameter("cmbUserStatus");

        if (newUserStatus == null)
        {
            newUserStatus = userDetails.getStatus();
        }

        newUserStatusDesc = newUserStatus != null ? newUserStatus.equals(DDM_Constants.status_active) ? "Active" : newUserStatus.equals(DDM_Constants.status_deactive) ? "Deactive" : newUserStatus.equals(DDM_Constants.status_locked) ? "Locked" : newUserStatus.equals(DDM_Constants.status_expired) ? "Expired" : newUserStatus.equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";
        oldUserStatusDesc = userDetails.getStatus() != null ? userDetails.getStatus().equals(DDM_Constants.status_active) ? "Active" : userDetails.getStatus().equals(DDM_Constants.status_deactive) ? "Deactive" : userDetails.getStatus().equals(DDM_Constants.status_locked) ? "Locked" : userDetails.getStatus().equals(DDM_Constants.status_expired) ? "Expired" : userDetails.getStatus().equals(DDM_Constants.status_pending) ? "Pending" : "N/A" : "N/A";

        newUserBank = request.getParameter("cmbBank");
        newMerchantId = request.getParameter("cmbMerchant");

        newName = request.getParameter("txtName");
        newEmpID = request.getParameter("txtEmpID");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");
        newNIC = request.getParameter("txtNIC");
        rbNIC_Passport = request.getParameter("rbNICPassport");
        newRemarks = request.getParameter("txtaRemarks");

        User usr = new User();

        usr.setUserId(userID);
        usr.setUserLevelId(newUserLevel);
        usr.setStatus(newUserStatus);
        usr.setBankCode(newUserBank);
        usr.setBranchCode(DDM_Constants.bank_default_branch_code);
        usr.setCoCuId(newMerchantId);
        usr.setName(newName);
        usr.setEmpId(newEmpID);
        usr.setDesignation(newDesignation);
        usr.setEmail(newEmail);
        usr.setContactNo(newContactNo);

        if (newNIC != null)
        {
            newNIC = newNIC.replaceFirst("N:", "").replaceFirst("P:", "");

            if (rbNIC_Passport != null)
            {
                if (rbNIC_Passport.equals("N"))
                {
                    newNIC = "N:" + newNIC;
                }
                else if (rbNIC_Passport.equals("P"))
                {
                    newNIC = "P:" + newNIC;
                }
                else
                {
                    newNIC = "";
                }
            }
            else
            {
                newNIC = "";
            }
        }

        usr.setNIC(newNIC);
        usr.setTokenSerial("");
        usr.setRemarks(newRemarks);
        usr.setNeedDownloadToBIM(DDM_Constants.status_yes);
        usr.setModifiedBy(session_userName);

        UserDAO userDAO = DAOFactory.getUserDAO();
        result = userDAO.updateUser(usr);

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_modify_user_details, "| Username - " + userDetails.getUserId() + ", User Type - (New : " + (newUserLevel != null ? newUserLevel : "") + " , Old :" + (userDetails.getUserLevelDesc() != null ? userDetails.getUserLevelDesc() : "") + "), Bank - (New : " + (newUserBank != null ? newUserBank : "") + ", Old : " + userDetails.getBankCode() + "), Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + (newName != null ? newName : "") + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + (newDesignation != null ? newDesignation : "") + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + (newEmail != null ? newEmail : "") + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + (newContactNo != null ? newContactNo : "") + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), NIC - (New : " + (newNIC != null ? newNIC.replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Old : " + (userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "") + "), Remarks - (New : " + (newRemarks != null ? newRemarks : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_user_maintenance_modify_user_details, "| Username - " + userDetails.getUserId() + ", User Type - (New : " + (newUserLevel != null ? newUserLevel : "") + " , Old :" + (userDetails.getUserLevelDesc() != null ? userDetails.getUserLevelDesc() : "") + "), Bank - (New : " + (newUserBank != null ? newUserBank : "") + ", Old : " + userDetails.getBankCode() + "), Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + (newName != null ? newName : "") + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + (newDesignation != null ? newDesignation : "") + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + (newEmail != null ? newEmail : "") + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + (newContactNo != null ? newContactNo : "") + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), NIC - (New : " + (newNIC != null ? newNIC.replaceFirst("N:", "").replaceFirst("P:", "") : "") + ", Old : " + (userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "") + "), Remarks - (New : " + (newRemarks != null ? newRemarks : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Modify User Details</title>
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
                document.getElementById('cmbUserStatus').selectedIndex = 0;
                document.getElementById('txtName').value = '<%=newName!=null?newName:""%>';
                document.getElementById('txtEmpID').value = '<%=newEmpID!=null?newEmpID:""%>';
                document.getElementById('txtDesignation').value = "<%=newDesignation!=null?newDesignation:""%>";
                document.getElementById('txtEmail').value = "<%=newEmail!=null?newEmail:""%>";
                document.getElementById('txtContactNo').value = "<%=newContactNo!=null?newContactNo:""%>";	
                document.getElementById('txtNIC').value = "<%=newNIC!=null?newNIC:""%>";				
                document.getElementById('txtaRemarks').value = "<%=newRemarks!=null?newRemarks:""%>";
            }

            function password_Validation()
            {               
                var password = document.getElementById('txtUserPassword').value;
                var reType_password = document.getElementById('txtReTypePassword').value;

                if(password != reType_password)
                {
                    return false;
                }
                else
                {
                    return true;
                }
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

            var status = document.getElementById('cmbUserStatus').value;
            var val_bank = document.getElementById('cmbBank').value;
            var v_name = document.getElementById('txtName').value;
            var v_desig = document.getElementById('txtDesignation').value;  
            var v_email = document.getElementById('txtEmail').value;  
            var v_contactno = document.getElementById('txtContactNo').value;
            var val_NIC = document.getElementById('txtNIC').value;


            // var val_TokenSerial = document.getElementById('txtTokenSerial').value;



            if(document.getElementById('cmbUserLevel') != null)
            {
            var val_userLevel = document.getElementById('cmbUserLevel').value;

            if(val_userLevel == "<%=DDM_Constants.status_all%>" || val_userLevel == null)
            {
            alert("Select valid 'User Type' for the user.");
            document.getElementById('cmbUserLevel').focus();
            return false;
            }
            }

            if(document.getElementById('cmbBank')!=null)
            {
                if (val_bank=="<%=DDM_Constants.status_all%>")
                {
                    alert("Please Select the appropriate 'Bank' for the user!");
                    document.getElementById('cmbBank').focus();
                    return false;
                } 
            }


            if(document.getElementById('cmbMerchant')!=null)
            {
                var sel_cocuid = document.getElementById('cmbMerchant').value; 

                if (sel_cocuid=="<%=DDM_Constants.status_all%>")
                {
                    alert("Please Select the appropriate 'Merchant' for the user!");
                    document.getElementById('cmbMerchant').focus();
                    return false;
                } 

            }


            if(status == "<%=DDM_Constants.status_all%>" || status == null)
            {
                alert("Select Status of the user.");
                document.getElementById('cmbUserStatus').focus();
                return false;
            }                

            else if(isempty(trim(v_name)))
            {
            alert("Name Can't be Empty");
            document.getElementById('txtName').value = "";
            document.getElementById('txtName').focus();
            return false;
            }

            else if(isempty(trim(v_desig)))
            {
            alert("Designation Can't be Empty");
            document.getElementById('txtDesignation').value = "";
            document.getElementById('txtDesignation').focus();
            return false;
            }

            else if(isempty(trim(v_email)))
            {
            alert("E-Mail Can't be Empty");
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtEmail').focus();
            return false;
            }

            else if(isempty(trim(v_contactno)))
            {
            alert("Contact No. Can't be Empty");
            document.getElementById('txtContactNo').value = "";
            document.getElementById('txtContactNo').focus();
            return false;
            }


            var val_rbNIC_Password = 'N';

            if (document.getElementById("rbNICPassport1").checked) 
            {
            val_rbNIC_Password = document.getElementById("rbNICPassport1").value;    
            }
            else if (document.getElementById("rbNICPassport2").checked) 
            {
            val_rbNIC_Password = document.getElementById("rbNICPassport2").value;    
            }

            if(val_rbNIC_Password == 'N')
            {                
            if(isempty(trim(val_NIC)))
            {
            alert("NIC Can't be Empty!");
            document.getElementById('txtNIC').focus();
            return false;
            }
            else if(!(val_NIC.length==10 || val_NIC.length==12))
            {
            alert("Invalid NIC! Please provide a vaild NIC.");
            document.getElementById('txtNIC').focus();
            return false;                
            }
            }
            else if(val_rbNIC_Password == 'P')
            {
            if(isempty(trim(val_NIC)))
            {
            alert("Passpot No. Can't be Empty!");
            document.getElementById('txtNIC').focus();
            return false;
            }
            }

            setRequestType(true);        
            document.frmModifyUser.action="UserModification.jsp";
            document.frmModifyUser.submit();
            return true;

            }

            function showDivisionArea()
            {        
            if('<%=reqType%>' == '0')
            {
            // alert("reqType");
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
            //resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser(1);
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            //resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser(1);
            }
            }
            }


            function doSearchUser(type)
            {
                
                if(type == 1)
                {
                    if(document.getElementById('cmbUserLevel')!=null)
                    {        
                        document.getElementById('cmbUserLevel').selectedIndex = 0;
                    }

                    if(document.getElementById('cmbBank')!=null)
                    {
                        document.getElementById('cmbBank').selectedIndex = 0;
                    }

                    if(document.getElementById('cmbMerchant')!=null)
                    {
                        document.getElementById('cmbMerchant').selectedIndex = 0;
                    }

                    if(document.getElementById('cmbUserStatus')!=null)
                    {
                        document.getElementById('cmbUserStatus').selectedIndex = 0;
                    }
                }

                setRequestType(false);
                document.frmModifyUser.action="UserModification.jsp";
                document.frmModifyUser.submit();                    
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

            function isSearchRequest(status)
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


            function updateUserDetails()
            {                                   
            fieldValidation();			
            }
            
            function Done()
            {
                document.getElementById('search_cmbUserId').selectedIndex = 0;
                setRequestType(false);
                doSearchUser(1);
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Modify User Details</td>
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
                                                                                            <form method="post" name="frmModifyUser" id="frmModifyUser" action="UserModification.jsp">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center"><table border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder" >

                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#A4B7CA"  class="ddm_tbl_header_text">User Type :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text">
                                                                                                                                    <select name="search_cmbUserLevel" id="search_cmbUserLevel" class="ddm_field_border" onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()" >
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserLevel != null && selectedUserLevel.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <%
                                                                                                                                            for (UserLevel usrlvl : colUserLevel)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value=<%=usrlvl.getUserLevelId()%> <%=(selectedUserLevel != null && usrlvl.getUserLevelId().equals(selectedUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>

                                                                                                                                    <input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" />                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Bank : </td>
                                                                                                                                <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                    <select name="search_cmbBank" id="search_cmbBank" class="ddm_field_border" onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()" <%=(selectedUserLevel.equals(DDM_Constants.user_type_bank_manager) || selectedUserLevel.equals(DDM_Constants.user_type_bank_user)) ? "" : "disabled"%>>

                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(newUserBank != null && newUserBank.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>


                                                                                                                                        <%

                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bk : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bk.getBankCode()%>" <%=(newUserBank != null && bk.getBankCode().equals(newUserBank)) ? "selected" : ""%> >
                                                                                                                                            <%=bk.getBankCode() + " - " + bk.getBankFullName()%>
                                                                                                                                        </option>
                                                                                                                                        <%

                                                                                                                                                }
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                <td valign="middle"class="ddm_tbl_common_text">
                                                                                                                                    <select name="search_cmbMerchant" id="search_cmbMerchant" class="ddm_field_border"  onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()" <%=(selectedUserLevel.equals(DDM_Constants.user_type_merchant_su) || selectedUserLevel.equals(DDM_Constants.user_type_merchant_op)) ? "" : "disabled"%> >
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserMerchant != null && selectedUserMerchant.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <%
                                                                                                                                            if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Merchant merchant : colMerchant)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchant.getMerchantID()%>" <%=(selectedUserMerchant != null && merchant.getMerchantID().equals(selectedUserMerchant)) ? "selected" : ""%> ><%=merchant.getMerchantID()%> - <%=merchant.getMerchantName()%></option>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><select name="search_cmbUserStatus" id="search_cmbUserStatus" class="ddm_field_border" onChange="setRequestType(false);frmModifyUser.submit();" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_active%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_active)) ? "selected" : ""%>>Active</option>                                                                                                                                        
                                                                                                                                        <option value="<%=DDM_Constants.status_expired%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_deactive%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_locked%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                        <option value="<%=DDM_Constants.status_pending%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(DDM_Constants.status_pending)) ? "selected" : ""%>>Pending</option>
                                                                                                                                    </select></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">User ID :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"> 
                                                                                                                                    <select name="search_cmbUserId" class="ddm_field_border" id="search_cmbUserId" onChange="setRequestType(false);doSearchUser(2);" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="<%=DDM_Constants.default_web_combo_select%>" <%=(selectedUsername != null && selectedUsername.equals(DDM_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select User --</option>

                                                                                                                                        <%
                                                                                                                                            if (col_user != null && col_user.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (User u : col_user)
                                                                                                                                                {
                                                                                                                                                    if (u != null && !(u.getUserId().equals(session_userName)))
                                                                                                                                                    {
                                                                                                                                        %>                                                                                                                                        
                                                                                                                                        <option value="<%=u.getUserId()%>" <%=(selectedUsername != null && u.getUserId().equals(selectedUsername)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                        <%
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>  </td></tr>

                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center">





                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (userDetails == null)
                                                                                                                    {
                                                                                                                        if(!selectedUsername.equals(DDM_Constants.default_web_combo_select))
                                                                                                                        {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                                </tr>

                                                                                                                <%                                                                                    							}}
                                                                                                                else
                                                                                                                {
                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><div id="resultdata"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td align="center">
                                                                                                                                        <%
                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="ddm_Display_Success_msg" >

                                                                                                                                            User Details Modified Successfully.


                                                                                                                                            <span class="ddm_error">(Manager Level Authorization Is Mandatory!)</span></div>
                                                                                                                                            <% }
                                                                                                                                            else
                                                                                                                                            {%>


                                                                                                                                        <div id="displayMsg_error" class="ddm_Display_Error_msg" >User Details Modification Failed.- <span class="ddm_error"><%=msg%></span></div>
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

                                                                                                                                                    <table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA"class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                                                            <td align="center" valign="middle" bgcolor="#A4B7CA"class="ddm_tbl_header_text_horizontal">New Value</td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">
                                                                                                                                                                User ID :        </td>

                                                                                                                                                            <td colspan="2" valign="middle" bgcolor="#E1E3EC"class="ddm_tbl_common_text"><%=userDetails.getUserId()%>                                                                                                                                                              <input type="hidden" name="hdnUsername" id="hdnUsername" class="ddm_success" value="<%=userDetails.getUserId()%>" /></td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">User Type :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getUserLevelDesc()%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"> <input type="hidden" name="hdnUserType" id="hdnUserType" class="ddm_success" value="<%=userDetails.getUserLevelId()%>" />
                                                                                                                                                                <select name="cmbUserLevel" id="cmbUserLevel" class="ddm_field_border" onChange="doSearchUser(2)" onFocus="hideMessage_onFocus()">
                                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(newUserLevel != null && newUserLevel.equals(DDM_Constants.status_all)) ? "selected" : ""%>>--Select User Type--</option>
                                                                                                                                                                    <%
                                                                                                                                                                        for (UserLevel usrlvl : colUserLevel)
                                                                                                                                                                        {

                                                                                                                                                                    %>
                                                                                                                                                                    <option value=<%=usrlvl.getUserLevelId()%> <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                                                    <%

                                                                                                                                                                        }
                                                                                                                                                                    %>
                                                                                                                                                                </select></td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Bank : </td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getBankCode()%> - <%=userDetails.getBankFullName()%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">
                                                                                                                                                                <select name="cmbBank" id="cmbBank" class="ddm_field_border" onFocus="hideMessage_onFocus()" <%=(newUserLevel.equals(DDM_Constants.user_type_bank_manager) || newUserLevel.equals(DDM_Constants.user_type_bank_user)) ? "" : "disabled"%>>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(newUserBank == null || newUserBank.equals(DDM_Constants.status_all)) ? "selected" : ""%>>-- Select Bank --</option>
                                                                                                                                                                    <%
                                                                                                                                                                        if (colBank != null && colBank.size() > 0)
                                                                                                                                                                        {
                                                                                                                                                                            for (Bank bk : colBank)
                                                                                                                                                                            {
                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=bk.getBankCode()%>" <%=(newUserBank != null && bk.getBankCode().equals(newUserBank)) ? "selected" : ""%>><%=bk.getBankCode() + " - " + bk.getBankFullName()%> </option>
                                                                                                                                                                    <%
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                    %>
                                                                                                                                                                </select>
                                                                                                                                                            </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <%
                                                                                                                                                            if (newUserLevel != null && (newUserLevel.equals(DDM_Constants.user_type_merchant_su) || newUserLevel.equals(DDM_Constants.user_type_merchant_op)))
                                                                                                                                                            {

                                                                                                                                                        %>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getCoCuId()%> - <%=userDetails.getCoCuName()%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                                          try
                                                                                                                                                                {
                                                                                                                                                                %>
                                                                                                                                                                <select name="cmbMerchant" id="cmbMerchant" class="ddm_field_border" onChange="doSearchUser(2)" onFocus="hideMessage_onFocus()" >
                                                                                                                                                                    <%
                                                                                                                                                                        if (newMerchantId == null || (newMerchantId != null && newMerchantId.equals(DDM_Constants.status_all)))
                                                                                                                                                                        {
                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" selected="selected">-- Select Merchant --</option>
                                                                                                                                                                    <%                                                                                                                        }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=DDM_Constants.default_web_combo_select%>" <%=(newMerchantId != null && newMerchantId.equals(DDM_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select Merchant --</option>
                                                                                                                                                                    <%                                                                                                                                                            }
                                                                                                                                                                    %>
                                                                                                                                                                    <%
                                                                                                                                                                        if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                                                        {
                                                                                                                                                                            for (Merchant merchant : colMerchant)
                                                                                                                                                                            {


                                                                                                                                                                    %>
                                                                                                                                                                    <option value="<%=merchant.getMerchantID()%>" <%=(newMerchantId != null && merchant.getMerchantID().equals(newMerchantId)) ? "selected" : ""%> ><%=merchant.getMerchantID()%> - <%=merchant.getMerchantName()%></option>


                                                                                                                                                                    <%

                                                                                                                                                                        }
                                                                                                                                                                    %>
                                                                                                                                                                </select>
                                                                                                                                                                <%
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                %>
                                                                                                                                                                <span class="ddm_error">No Merchant details available.</span>
                                                                                                                                                                <%}
                                                                                                                                                                    }
                                                                                                                                                                    catch (Exception e)
                                                                                                                                                                    {
                                                                                                                                                                        System.out.println(e.getMessage());
                                                                                                                                                                    }
                                                                                                                                                                %>                                                                                                                                                            </td>
                                                                                                                                                        </tr>

                                                                                                                                                        <%
                                                                                                                                                            }
                                                                                                                                                        %>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                                            <td colspan="2" valign="middle" bgcolor="#E1E3EC" class="ddm_tbl_common_text"><%=oldUserStatusDesc%>&nbsp;


                                                                                                                                                                <select name="cmbUserStatus" id="cmbUserStatus" class="ddm_field_border" onFocus="hideMessage_onFocus()" style="visibility:hidden">
                                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_all)) ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_active%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_deactive%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_expired%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_locked%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                                                    <option value="<%=DDM_Constants.status_pending%>" <%=(newUserStatus != null && newUserStatus.equals(DDM_Constants.status_pending)) ? "selected" : ""%>>Pending</option>
                                                                                                                                                                </select>                                                                                                                                                            </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Name <span class="ddm_required_field">*</span> :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getName() != null ? userDetails.getName() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtName" id="txtName" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newName != null) ? newName : (userDetails.getName() != null ? userDetails.getName() : "N/A")%>" size="80" maxlength="200" ></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Employee ID :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmpId() != null ? userDetails.getEmpId() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmpID" id="txtEmpID" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmpID != null) ? newEmpID : (userDetails.getEmpId() != null ? userDetails.getEmpId() : "N/A")%>" size="16" maxlength="15"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Designation <span class="ddm_required_field">*</span> :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getDesignation() != null ? userDetails.getDesignation() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtDesignation" id="txtDesignation" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newDesignation != null) ? newDesignation : (userDetails.getDesignation() != null ? userDetails.getDesignation() : "N/A")%>" size="80" maxlength="200"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">E-Mail <span class="ddm_required_field">*</span> : </td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getEmail() != null ? userDetails.getEmail() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtEmail" id="txtEmail" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmail != null) ? newEmail : (userDetails.getEmail() != null ? userDetails.getEmail() : "N/A")%>" size="80" maxlength="200"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Contact No. <span class="ddm_required_field">*</span> :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getContactNo() != null ? userDetails.getContactNo() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><input type="text" name="txtContactNo" id="txtContactNo" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newContactNo != null) ? newContactNo : (userDetails.getContactNo() != null ? userDetails.getContactNo() : "")%>" size="20" maxlength="20"></td>
                                                                                                                                                        </tr>


                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">NIC <span class="ddm_required_field">*</span> :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text">

                                                                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td><input type="text" name="txtNIC" id="txtNIC" class="ddm_field_border" onFocus="hideMessage_onFocus()" value="<%=(newNIC != null) ? newNIC : (userDetails.getNIC() != null ? userDetails.getNIC().replaceFirst("N:", "").replaceFirst("P:", "") : "")%>" size="20" maxlength="20"></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                        <td><input type="radio" name="rbNICPassport" id="rbNICPassport1" value="N" <%=rbNIC_Passport.equals("N") ? "checked" : ""%>></td>
                                                                                                                                                                        <td width="3"></td>
                                                                                                                                                                        <td class="ddm_common_text">NIC</td>
                                                                                                                                                                        <td width="6"></td>
                                                                                                                                                                        <td><input type="radio" name="rbNICPassport" id="rbNICPassport2" value="P" <%=rbNIC_Passport.equals("P") ? "checked" : ""%>></td>
                                                                                                                                                                        <td width="3"></td>
                                                                                                                                                                        <td class="ddm_common_text">Passport</td>
                                                                                                                                                                    </tr>
                                                                                                                                                                </table>                                                                                                                                                            </td>
                                                                                                                                                        </tr>




                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Remarks :</td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><%=userDetails.getRemarks() != null ? userDetails.getRemarks() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#E1E3EC" valign="middle" class="ddm_tbl_common_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="60" onFocus="hideMessage_onFocus()" class="ddm_field_border"><%=(newRemarks != null) ? newRemarks : ""%></textarea></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td height="35" colspan="3" align="right" valign="middle" bgcolor="#CDCDCD" class="ddm_tbl_footer_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td><input type="button" value="&nbsp;&nbsp; Update &nbsp;&nbsp;" name="btnUpdate" id="btnUpdate" class="ddm_custom_button" onClick="updateUserDetails()" <%=((reqType != null && reqType.equals("1")) && result) ? "disabled" : ""%>/></td>
                                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=reqType%>" /></td>
                                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; <%=((reqType != null && reqType.equals("1")) && result) ? "Done" : "Reset"%>  &nbsp;&nbsp;" type="button" onClick="<%=((reqType != null && reqType.equals("1")) && result) ? "Done()" : "resetRecords()"%>" class="ddm_custom_button" />                                                            </td></tr>
                                                                                                                                                                </table></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table>


                                                                                                                                                </td>
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
                                                                                                            %>                                                                                





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
