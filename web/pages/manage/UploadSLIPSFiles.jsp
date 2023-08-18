
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.account.Account" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMap" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.file.FileInfo" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
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
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Upload SLIPS Files' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Upload_SLIPS_Files");
            }
        }
        else
        {

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
    Collection<CorporateCustomer> colCoCu = null;
    CorporateCustomer selectedCoCu = null;
    Collection<String> colNextValueDates = null;
    Collection<CorporateCustomerAccNoMap> colAccNoMap = null;

    Account act = null;

    // boolean isOkToDisable_cmbAccountNo = false;
    boolean result = false;
    boolean isValidAccountNo = false;

    String isReq = null;

    String cocuid = null;
    String orgAccountNo = null;
    String OrgAccountName = null;
    String OrgAccountAddress = null;
    String OrgAccountBranch = null;
    String radAFVD = null;
    String radCAVD = null;
    String cmbAutoFixValueDate = null;
    String cmbChangeAllValueDate = null;
    String slipFilePath = null;

    String isCUST1_Allowed = DDM_Constants.status_no;
    String isCUSTOUT_Allowed = DDM_Constants.status_no;
    String isDSLIPS_Allowed = DDM_Constants.status_no;
    String isFSLIPS_Allowed = DDM_Constants.status_no;

    String alreadyProcessingFiles = "";

    String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);

    System.out.println("UploadSLIPSFiles : businessDate -----> " + businessDate);
    
    
    if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
    {
        colCoCu = DAOFactory.getCorporateCustomerDAO().getCorporateCustomerBasicDetails(DDM_Constants.status_active, session_branchId);
    }
    else
    {
        colCoCu = DAOFactory.getCorporateCustomerDAO().getCorporateCustomerBasicDetails(DDM_Constants.status_active, DDM_Constants.status_all);
    }
    
    //System.out.println("UploadSLIPSFiles : colCoCu -----> " + colCoCu.size());

    colNextValueDates = DAOFactory.getBCMCalendarDAO().getNextVaildBusinessDates(businessDate, 14);
    
    //System.out.println("UploadSLIPSFiles : colNextValueDates -----> " + colNextValueDates.size());

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "-1";

        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            cocuid = session_cocuId;
        }
        else
        {
            cocuid = DDM_Constants.status_all;
        }

        orgAccountNo = DDM_Constants.status_all;
        OrgAccountName = "";
        OrgAccountAddress = "";
        OrgAccountBranch = "";
        slipFilePath = "";
        radAFVD = DDM_Constants.status_yes;
        radCAVD = DDM_Constants.status_no;
        cmbAutoFixValueDate = DDM_Constants.status_all;
        cmbChangeAllValueDate = DDM_Constants.status_all;
        
        //System.out.println("UploadSLIPSFiles : orgAccountNo -----> " + orgAccountNo);

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_file_init, "| Upload SLIPS Files - Initial | Visited By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }
    else
    {
        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            cocuid = session_cocuId;
        }
        else
        {
            cocuid = request.getParameter("hdnOrgCoCuId");
        }

        orgAccountNo = request.getParameter("hdnOrgAccountNo");
        slipFilePath = request.getParameter("hdnSlipFilePath");
        OrgAccountName = "";
        OrgAccountAddress = "";
        OrgAccountBranch = "";
        radAFVD = request.getParameter("hdnRadAFVD");
        radCAVD = request.getParameter("hdnRadCAVD");
        cmbAutoFixValueDate = request.getParameter("hdnCmbAFVD");
        cmbChangeAllValueDate = request.getParameter("hdnCmbCAVD");

        if (cocuid == null || (cocuid != null && cocuid.equals(DDM_Constants.status_all)))
        {
            orgAccountNo = DDM_Constants.status_all;
        }
        if (orgAccountNo == null)
        {
            orgAccountNo = DDM_Constants.status_all;
        }
        if (slipFilePath == null)
        {
            slipFilePath = "";
        }

        if ((orgAccountNo != null || !orgAccountNo.equals(DDM_Constants.status_all)) && (orgAccountNo.length() == 15))
        {
            System.out.println("SLIPS File Upload :::::::: Get Account details (Account no. ==> " + orgAccountNo);

            act = DAOFactory.getAccountDAO().getAccountDetails(DDM_Constants.status_all, orgAccountNo, DDM_Constants.status_active);

            if (act != null)
            {
                isValidAccountNo = true;
                OrgAccountName = act.getAccountHolderName().replace("'", "`");
                OrgAccountBranch = act.getBranchCode();

                if (act.getAccountHoderAddress1() != null)
                {
                    OrgAccountAddress += act.getAccountHoderAddress1() + ",";
                }

                if (act.getAccountHoderAddress2() != null)
                {
                    OrgAccountAddress += act.getAccountHoderAddress2() + ",";
                }

                if (act.getAccountHoderAddress3() != null)
                {
                    OrgAccountAddress += act.getAccountHoderAddress3() + ",";
                }

                if (act.getAccountHoderAddress4() != null)
                {
                    OrgAccountAddress += act.getAccountHoderAddress4() + ",";
                }

                OrgAccountAddress = OrgAccountAddress.replaceAll(",,,,", ",");
                OrgAccountAddress = OrgAccountAddress.replaceAll(",,,", ",");
                OrgAccountAddress = OrgAccountAddress.replaceAll(",,", ",");

                OrgAccountAddress = OrgAccountAddress.substring(0, (OrgAccountAddress.length() - 1));
            }
        }

        Collection<FileInfo> alreadyProcessingFileInfo = DAOFactory.getFileInfoDAO().getFileDetailsByCriteria(session_bankCode, DDM_Constants.status_all, cocuid, DDM_Constants.status_all, DDM_Constants.slip_file_status_processing, DDM_Constants.status_all, webBusinessDate, webBusinessDate);

        if (alreadyProcessingFileInfo != null && alreadyProcessingFileInfo.size() > 0)
        {
            for (FileInfo fi : alreadyProcessingFileInfo)
            {
                alreadyProcessingFiles = alreadyProcessingFiles + fi.getFileId() + ",";
            }
        }

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_file_init, "| Upload SLIPS Files - Account Search (Originator Acc. No - " + orgAccountNo + ", SLIPS File - " + slipFilePath + ")  | Searched By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }


%>

<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - Upload SLIPS Data Files</title>        
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/autocomplete.css" rel="stylesheet" type="text/css" /> 
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />  


        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/datetimepicker.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery-1.4.2.min.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jquery.autocomplete.js"></script>
        <script language="javascript" type="text/JavaScript">


            function clearRecords_onPageLoad()
            {
                //document.getElementById('slipsFile').setAttribute("autocomplete","off");
                //document.getElementById('txtDescription').setAttribute("autocomplete","off");
                showClock(3);
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
                var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=window != null ? window.getOW_cutontimeHour() : null%>, <%=window != null ? window.getOW_cutontimeMinutes() : null%>, <%=window != null ? window.getOW_cutofftimeHour() : null%>, <%=window != null ? window.getOW_cutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=window != null ? window.getIW_cutontimeHour() : null%>, <%=window != null ? window.getIW_cutontimeMinutes() : null%>, <%=window != null ? window.getIW_cutofftimeHour() : null%>, <%=window != null ? window.getIW_cutofftimeMinutes() : null%>);
                clock(document.getElementById('showText'), type, val);
                }
            }



            function isSearchRequest(status)
            {
                if (status)
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
			
            function enablecCmbAFVD()
            {
                var obj_radAFVD = document.getElementById('radAFVD');
                var obj_radCAVD = document.getElementById('radCAVD');

                var obj_cmbAFVD = document.getElementById('cmbAFVD');
                var obj_cmbCAVD = document.getElementById('cmbCAVD');

                if(obj_radAFVD!=null && obj_radCAVD!=null)
                {
                    if(obj_radAFVD.checked)
                    {					
                        obj_radAFVD.value = '<%=DDM_Constants.status_yes%>';
                        obj_radCAVD.value = '<%=DDM_Constants.status_no %>';
                        obj_radCAVD.checked = false;
                        
                        obj_cmbAFVD.disabled = false;                        
                        obj_cmbCAVD.disabled = true;						
                    }
                    else
                    {
                        obj_radAFVD.value = '<%=DDM_Constants.status_no %>';
                        obj_radCAVD.value = '<%=DDM_Constants.status_yes %>';
                        obj_radCAVD.checked = true;
                        
                        obj_cmbAFVD.disabled = true; 
                        obj_cmbCAVD.disabled = false;
                    }				
                }
            }

            function enableCmbCAVD()
            { 
            	var obj_radAFVD = document.getElementById('radAFVD');
                var obj_radCAVD = document.getElementById('radCAVD');
				
                var obj_cmbAFVD = document.getElementById('cmbAFVD');
                var obj_cmbCAVD = document.getElementById('cmbCAVD');

                if(obj_radAFVD!=null && obj_radCAVD!=null)
                {  
                    if(obj_radCAVD.checked)
                    {
                        obj_radAFVD.value = '<%=DDM_Constants.status_no %>';
                        obj_radCAVD.value = '<%=DDM_Constants.status_yes %>';
                        obj_radAFVD.checked = false;
                        
                        obj_cmbAFVD.disabled = true;                        
                        obj_cmbCAVD.disabled = false;
                    }
                    else
                    {
                        obj_radAFVD.value = '<%=DDM_Constants.status_yes %>';
                        obj_radCAVD.value = '<%=DDM_Constants.status_no %>';
                        obj_radAFVD.checked = true;
                        
                        obj_cmbAFVD.disabled = false; 
                        obj_cmbCAVD.disabled = true;
                    }                    
                } 
            }

            function doSearch()
            {
                isSearchRequest(true);
                document.getElementById('hdnOrgCoCuId').value = document.getElementById('cmbCoCuID').value;
                document.getElementById('hdnOrgAccountNo').value = document.getElementById('cmbAccountNo').value;
                document.getElementById('hdnSlipFilePath').value = document.getElementById('slipsFile').value;
                document.frmUploadSlipsFilesSearch.action = "UploadSLIPSFiles.jsp";
                document.frmUploadSlipsFilesSearch.submit();
            	return true;			
            }


            function doSubmit()
            {
                var orgAccNo = document.getElementById('cmbAccountNo').value;
                var slipsFilePath = document.getElementById('slipsFile').value;
                
			
                var obj_radAFVD = document.getElementById('radAFVD');
                var obj_radCAVD = document.getElementById('radCAVD');
				
                var obj_cmbAFVD = document.getElementById('cmbAFVD');
                var obj_cmbCAVD = document.getElementById('cmbCAVD');

                var iNumbers = "0123456789";
                var numbers = /^[0-9]*$/;

                if(orgAccNo==null || orgAccNo=='<%=DDM_Constants.status_all%>')
                {
                alert("Please select valid Originator Account No!");
                document.getElementById('cmbAccountNo').focus();
                return false;
                }

                if(obj_radAFVD!=null && obj_cmbAFVD!=null)
                {
                    if(obj_radAFVD.checked == true)
                    {
                        if(obj_cmbAFVD.value == '<%=DDM_Constants.status_all%>')
                        {
                            alert("You have checked 'Automatically Fixed Value Dates' option, so please select a valid 'Value Date'!");
                            obj_cmbAFVD.focus();
                            return false;                            
                        }                        
                    }                    
                }
                
                if(obj_radCAVD!=null && obj_cmbCAVD!=null)
                {
                    if(obj_radCAVD.checked == true)
                    {
                        if(obj_cmbCAVD.value == '<%=DDM_Constants.status_all%>')
                        {
                            alert("You have checked 'Change All Value Dates' option, so please select a valid 'Value Date'!");
                            obj_cmbCAVD.focus();
                            return false;                            
                        }                        
                    }                    
                }

                if(isempty(slipsFilePath))
                {
                    alert("Please select a valid SLIPS file to upload!");
                    document.getElementById('slipsFile').focus();
                    return false;
                }
                else
                {
                    var objFile = document.getElementById('slipsFile');
                    var fileSize = objFile.files[0].size;
                    
                    if(fileSize > 5242880)
                    {
                        alert("Selected 'SLIPS File' exceeds the maximum allowed file size! \nPlease select a 'SLIPS File' which not exceed 5 MB.");
                        document.getElementById('slipsFile').focus();
                        return false;                        
                    }
                
                
                    var slipsFileName;
                    var slipsFileExtension;
                    var correctCertExtension1 = ".txt";
                    var correctCertExtension2 = ".txt";
                    var isValidSlipsFile = false;

                    var val_IsCUST1Allowed = document.getElementById('hdnIsCUST1Allowed').value;
                    var val_IsCUSTOUTAllowed = document.getElementById('hdnIsCUSTOUTAllowed').value;
                    var val_IsDSLIPSAllowed = document.getElementById('hdnIsDSLIPSAllowed').value;
                    var val_IsFSLIPSAllowed = document.getElementById('hdnIsFSLIPSAllowed').value;

                    slipsFileName = slipsFilePath.substring(slipsFilePath.lastIndexOf("\\")+1);

                    slipsFileExtension = slipsFileName.substring(slipsFileName.lastIndexOf("."));

                    //alert('slipsFileExtension ----> ' + slipsFileExtension)

                    if (val_IsCUST1Allowed=='<%=DDM_Constants.status_yes%>' && (slipsFileName.toUpperCase().endsWith('<%=DDM_Constants.ddm_cust1_file_suffix.toUpperCase()%>')))
                    {
                        isValidSlipsFile = true;
                    }
                    else if (val_IsDSLIPSAllowed=='<%=DDM_Constants.status_yes%>' && (slipsFileName.toUpperCase().endsWith('<%=DDM_Constants.ddm_dddm_file_suffix.toUpperCase()%>')))
                    {
                        isValidSlipsFile = true;
                    }
                    else if (val_IsFSLIPSAllowed=='<%=DDM_Constants.status_yes%>' && (slipsFileName.toUpperCase().endsWith('<%=DDM_Constants.ddm_fddm_file_suffix.toUpperCase()%>')))
                    {
                        isValidSlipsFile = true;
                    }
                    else if (val_IsCUSTOUTAllowed=='<%=DDM_Constants.status_yes%>' && (slipsFileName.toUpperCase().endsWith('<%=DDM_Constants.ddm_custout_file_suffix1.toUpperCase()%>')))
                    {
                        isValidSlipsFile = true;
                    }
                    else if (val_IsCUSTOUTAllowed=='<%=DDM_Constants.status_yes%>' && (slipsFileName.toUpperCase().indexOf('<%=DDM_Constants.ddm_custout_file_suffix2.toUpperCase()%>')>=0))
                    {
                        isValidSlipsFile = true;
                    }       


                    if(isValidSlipsFile)
                    {
                        if((slipsFileExtension.toUpperCase() == correctCertExtension1.toUpperCase())  || (slipsFileExtension.toUpperCase() == correctCertExtension2.toUpperCase()))
                        {
                            isValidSlipsFile = true;
                        }
                        else
                        {
                            isValidSlipsFile = false;
                            alert("Invalid file type! \nFile exension should be either '.txt' and select a valid SLIPS data file to upload.");
                        } 
                    }
                    else
                    {                    
                        alert("Invalid file type! \nPlease ensure the slips file type is allowed for the 'Corporate Customer' and select a valid SLIPS data file to upload.");
                    }

                    if(isValidSlipsFile)
                    {
                        var valNewFileName = '<%=cocuid%>' + '_' + '<%=orgAccountNo%>' + "_" + '<%=businessDate%>' + '_' + slipsFileName;     
                        var valAlreadyProcessingFiles = '<%=alreadyProcessingFiles%>';

                        if(valAlreadyProcessingFiles.toUpperCase().indexOf(valNewFileName.toUpperCase())>=0)
                        {
                            var answer1 = confirm("Another same-named SLIPS data file is currently in processing status!\nDo you really want to delete previous data and upload this SLIPS data file to the system? \nPress 'OK' to delete previous data and upload the file or 'Cancel' for select another file.");                

                            if(answer1)
                            {

                                document.getElementById('cmbCoCuID').disabled = false;
                                document.frmUploadSlipsFiles.action="UploadSLIPSFilesConfirmation.jsp";
                                document.getElementById('btnUpload').disabled = true;
                                document.frmUploadSlipsFiles.submit();
                            }                
                        }
                        else
                        {
                            var answer2 = confirm("Do you really want to upload this SLIPS data file to the system? \n Press 'OK' to upload the file or 'Cancel' for select another file.");

                            if(answer2)
                            {
                                document.getElementById('cmbCoCuID').disabled = false;
                                document.frmUploadSlipsFiles.action="UploadSLIPSFilesConfirmation.jsp";
                                document.getElementById('btnUpload').disabled = true;
                                document.frmUploadSlipsFiles.submit();
                            }

                        }
                    }          

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

                                                                                        <td width="10" valign="middle"></td>
                                                                                        <%
                                                                                            String owWindowStartTime = window.getOW_cutontime() != null ? window.getOW_cutontime().substring(0, 2) + ":" + window.getOW_cutontime().substring(2) : "00:00";
                                                                                            String owWindowEndTime = window.getOW_cutofftime() != null ? window.getOW_cutofftime().substring(0, 2) + ":" + window.getOW_cutofftime().substring(2) : "00:00";

                                                                                            String iwWindowStartTime = window.getIW_cutontime() != null ? window.getIW_cutontime().substring(0, 2) + ":" + window.getIW_cutontime().substring(2) : "00:00";
                                                                                            String iwWindowEndTime = window.getIW_cutofftime() != null ? window.getIW_cutofftime().substring(0, 2) + ":" + window.getIW_cutofftime().substring(2) : "00:00";
                                                                                        %>

                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">| &nbsp; Session : <%=winSession%></td>
                                                                                        <td width="5" valign="middle"></td>

                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark"><table border="0" cellspacing="0">
                                                                                                <tr height="12">
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark">[</td>
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark"><span class="ddm_menubar_text_dark" title="Outward (OWNM) Window Start and End Time">OW (<%=owWindowStartTime%>-<%=owWindowEndTime%>)</span></td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle"><div id="actWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward (OWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward (OWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark">| <span class="ddm_menubar_text_dark" title="Inward (IWNM) Window Start and End Time">IW (<%=iwWindowStartTime%>-<%=iwWindowEndTime%>)</span>                                                                                          </td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle" class="ddm_menubar_text"><div id="actWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (IWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward (IWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" class="ddm_menubar_text_dark">]&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Upload SLIPS Files</td>
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
                                                                                            <form method="post" name="frmUploadSlipsFiles" id="frmUploadSlipsFiles" enctype="multipart/form-data">





                                                                                                <table border="0" cellspacing="1" cellpadding="1">




                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="5" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Corporate Customer ID : </td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%

                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbCoCuID" id="cmbCoCuID" class="ddm_field_border" onChange="doSearch()" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (cocuid == null || (cocuid != null && cocuid.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- Select --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- Select --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colCoCu != null && colCoCu.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (CorporateCustomer cocu : colCoCu)
                                                                                                                                                {

                                                                                                                                                    if (cocuid != null && cocu.getCoCuID().equals(cocuid))
                                                                                                                                                    {
                                                                                                                                                        selectedCoCu = cocu;
                                                                                                                                                        colAccNoMap = DAOFactory.getCorporateCustomerAccNoMapDAO().getCorporateCustomerAccounts(cocuid, DDM_Constants.status_active);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=cocu.getCoCuID()%>" selected > <%=cocu.getCoCuID() + " - " + cocu.getCoCuName()%></option>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=cocu.getCoCuID()%>" > <%=cocu.getCoCuID() + " - " + cocu.getCoCuName()%></option>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No corporate customer details available!</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %>                                                                                                        

                                                                                                                                    <%
                                                                                                                                        if (selectedCoCu != null)
                                                                                                                                        {
                                                                                                                                            if (selectedCoCu.getIs_CUST1_Allowed() != null && selectedCoCu.getIs_CUST1_Allowed().equals(DDM_Constants.status_yes))
                                                                                                                                            {
                                                                                                                                                isCUST1_Allowed = DDM_Constants.status_yes;
                                                                                                                                            }

                                                                                                                                            if (selectedCoCu.getIs_CUSTOUT_Allowed() != null && selectedCoCu.getIs_CUSTOUT_Allowed().equals(DDM_Constants.status_yes))
                                                                                                                                            {
                                                                                                                                                isCUSTOUT_Allowed = DDM_Constants.status_yes;
                                                                                                                                            }

                                                                                                                                            if (selectedCoCu.getIs_DSLIPS_Allowed() != null && selectedCoCu.getIs_DSLIPS_Allowed().equals(DDM_Constants.status_yes))
                                                                                                                                            {
                                                                                                                                                isDSLIPS_Allowed = DDM_Constants.status_yes;
                                                                                                                                            }

                                                                                                                                            if (selectedCoCu.getIs_FSLIPS_Allowed() != null && selectedCoCu.getIs_FSLIPS_Allowed().equals(DDM_Constants.status_yes))
                                                                                                                                            {
                                                                                                                                                isFSLIPS_Allowed = DDM_Constants.status_yes;
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>

                                                                                                                                    <input type="hidden" name="hdnIsCUST1Allowed" id="hdnIsCUST1Allowed" value="<%=isCUST1_Allowed%>" /> 
                                                                                                                                    <input type="hidden" name="hdnIsCUSTOUTAllowed" id="hdnIsCUSTOUTAllowed" value="<%=isCUSTOUT_Allowed%>" />
                                                                                                                                    <input type="hidden" name="hdnIsDSLIPSAllowed" id="hdnIsDSLIPSAllowed" value="<%=isDSLIPS_Allowed%>" />
                                                                                                                                    <input type="hidden" name="hdnIsFSLIPSAllowed" id="hdnIsFSLIPSAllowed" value="<%=isFSLIPS_Allowed%>" />                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. No :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbAccountNo" id="cmbAccountNo" class="ddm_field_border" onChange="doSearch()" >
                                                                                                                                        <%
                                                                                                                                            if (orgAccountNo == null || (orgAccountNo != null && orgAccountNo.equals(DDM_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- Select Account No. --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- Select Account No. --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colAccNoMap != null && colAccNoMap.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (CorporateCustomerAccNoMap coCuAccNoMap : colAccNoMap)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=coCuAccNoMap.getAccNo()%>" <%=(orgAccountNo != null && coCuAccNoMap.getAccNo().equals(orgAccountNo)) ? "selected" : ""%> > <%=coCuAccNoMap.getAccNo() + " - " + coCuAccNoMap.getAccName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No active accounts available for this corporate customer.</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %>                                                                                                        </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. Name :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=OrgAccountName%> <input type="hidden" name="hdnOrgAccName" id="hdnOrgAccName" value="<%=OrgAccountName%>" /></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. Address :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=OrgAccountAddress%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. Branch : </td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=OrgAccountBranch%><input type="hidden" name="hdnOrgAccBranch" id="hdnOrgAccBranch" value="<%=OrgAccountBranch%>" /></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Automatically Fixed Value Dates :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input id="radAFVD" name="radVD" type="radio" value="AFVD" onClick="enablecCmbAFVD()"></td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><%
                                                                                                                                                try
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <select name="cmbAFVD" id="cmbAFVD" class="ddm_field_border" disabled>
                                                                                                                                                    <%
                                                                                                                                                        if (cmbAutoFixValueDate == null || (cmbAutoFixValueDate != null && cmbAutoFixValueDate.equals(DDM_Constants.status_all)))
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" selected="selected">-- Select Value Date --</option>
                                                                                                                                                    <%                                                                                                                        }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>">-- Select Value Date --</option>
                                                                                                                                                    <%                                                                                                                                                            }
                                                                                                                                                    %>
                                                                                                                                                    <%
                                                                                                                                                        if (colNextValueDates != null && colNextValueDates.size() > 0)
                                                                                                                                                        {
                                                                                                                                                            for (String valueDates : colNextValueDates)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=valueDates%>" <%=(cmbAutoFixValueDate != null && valueDates.equals(cmbAutoFixValueDate)) ? "selected" : ""%> > <%=valueDates%></option>
                                                                                                                                                    <%
                                                                                                                                                        }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                                <%
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <span class="ddm_error">Valid 'Value Dates' not available!</span>
                                                                                                                                                <%}
                                                                                                                                                    }
                                                                                                                                                    catch (Exception e)
                                                                                                                                                    {
                                                                                                                                                        System.out.println(e.getMessage());
                                                                                                                                                    }
                                                                                                                                                %>                                                                                                        </td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                              <td valign="middle" class="ddm_tbl_header_text">Change All Value Dates : </td>
                                                                                                                              <td valign="middle" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input id="radCAVD" name="radVD" type="radio" value="CAVD" onClick="enableCmbCAVD()"></td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><%
                                                                                                                                                try
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <select name="cmbCAVD" id="cmbCAVD" class="ddm_field_border" disabled>
                                                                                                                                                    <%
                                                                                                                                                        if (cmbChangeAllValueDate == null || (cmbChangeAllValueDate != null && cmbChangeAllValueDate.equals(DDM_Constants.status_all)))
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>" selected="selected">-- Select Value Date --</option>
                                                                                                                                                    <%                                                                                                                        }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=DDM_Constants.status_all%>">-- Select Value Date --</option>
                                                                                                                                                    <%                                                                                                                                                            }
                                                                                                                                                    %>
                                                                                                                                                    <%
                                                                                                                                                        if (colNextValueDates != null && colNextValueDates.size() > 0)
                                                                                                                                                        {
                                                                                                                                                            for (String valueDates : colNextValueDates)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=valueDates%>" <%=(cmbChangeAllValueDate != null && valueDates.equals(cmbChangeAllValueDate)) ? "selected" : ""%> > <%=valueDates%></option>
                                                                                                                                                    <%
                                                                                                                                                        }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                                <%
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <span class="ddm_error">Valid 'Value Dates' not available!</span>
                                                                                                                                                <%}
                                                                                                                                                    }
                                                                                                                                                    catch (Exception e)
                                                                                                                                                    {
                                                                                                                                                        System.out.println(e.getMessage());
                                                                                                                                                    }
                                                                                                                                                %>                                                                                                        </td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    SLIPS File <span class="ddm_required_field">*</span> :        </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">

                                                                                                                                    <input name="slipsFile" id="slipsFile" type="file" class="ddm_field_border"  size="100" value="<%=slipFilePath%>" ></td>
                                                                                                                            </tr>


                                                                                                                            <tr>
                                                                                                                                <td colspan="2" align="center" class="ddm_tbl_footer_text"><input type="button" value="Upload" name="btnUpload" id="btnUpload" class="ddm_custom_button"  onclick="doSubmit()" /></td>
                                                                                                                            </tr>
                                                                                                                  </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>


                                                                                                </table>


                                                                                            </form>

                                                                                            <form  method="post" name="frmUploadSlipsFilesSearch" id="frmUploadSlipsFilesSearch">		                                                                         						<input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" />
                                                                                                <input type="hidden" name="hdnOrgCoCuId" id="hdnOrgCoCuId" value="<%=cocuid %>" />
                                                                                                <input type="hidden" name="hdnOrgAccountNo" id="hdnOrgAccountNo" value="<%=orgAccountNo %>" />
                                                                                                <input type="hidden" name="hdnSlipFilePath" id="hdnSlipFilePath" value="<%=slipFilePath %>" /> 
                                                                                                <input type="hidden" name="hdnRadAFVD" id="hdnRadAFVD" value="<%=radAFVD %>" />
                                                                                                <input type="hidden" name="hdnRadCAVD" id="hdnRadCAVD" value="<%=radCAVD %>" />
                                                                                                <input type="hidden" name="hdnCmbAFVD" id="hdnCmbAFVD" value="<%=cmbAutoFixValueDate %>" />
                                                                                                <input type="hidden" name="hdnCmbCAVD" id="hdnCmbCAVD" value="<%=cmbChangeAllValueDate %>" />
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