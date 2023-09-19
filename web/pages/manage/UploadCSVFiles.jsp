
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.account.Account" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
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
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - New DDM Request(s) Acquiring Bank Approval' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=New_DDM_Requests_Acquiring_Bank_Approval");
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
    Collection<Merchant> colMerchant = null;
    Merchant selectedMerchant = null;
    Collection<MerchantAccNoMap> colAccNoMap = null;

    String isReq = null;

    String merchantID = null;
    String orgAccountNo = null;
    String OrgAccountName = null;
    String OrgAccountBranch = null;

    String csvFilePath = null;

    String alreadyProcessingFiles = "";

    String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);

    System.out.println("UploadSLIPSFiles : businessDate -----> " + businessDate);
    
    
    if (session_userType.equals(DDM_Constants.user_type_bank_manager) || session_userType.equals(DDM_Constants.user_type_bank_user) || session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
    {
        colMerchant = DAOFactory.getMerchantDAO().getMerchant(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_active);
    }
    else
    {
        colMerchant = DAOFactory.getMerchantDAO().getMerchant(DDM_Constants.status_all, session_bankCode, DDM_Constants.status_all, DDM_Constants.status_active);
    }
    
    System.out.println("UploadCSVFiles : colMerchant -----> " + colMerchant.size());

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "-1";

        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            merchantID = session_cocuId;
        }
        else
        {
            merchantID = DDM_Constants.status_all;
        }

        orgAccountNo = DDM_Constants.status_all;
        OrgAccountName = "";
        OrgAccountBranch = "";
        csvFilePath = "";
        
        //System.out.println("UploadSLIPSFiles : orgAccountNo -----> " + orgAccountNo);

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_csv_file_init, "| Upload DDM CSV Files - Initial | Visited By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }
    else
    {
        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
        {
            merchantID = session_cocuId;
        }
        else
        {
            merchantID = request.getParameter("hdnMerchantId");
        }

        orgAccountNo = request.getParameter("hdnMerchantAccountNo");
        csvFilePath = request.getParameter("hdnCSVFilePath");
        OrgAccountName = "";
        OrgAccountBranch = "";

        if (merchantID == null || (merchantID != null && merchantID.equals(DDM_Constants.status_all)))
        {
            orgAccountNo = DDM_Constants.status_all;
        }
        if (orgAccountNo == null)
        {
            orgAccountNo = DDM_Constants.status_all;
        }
        if (csvFilePath == null)
        {
            csvFilePath = "";
        }


//        Collection<FileInfo> alreadyProcessingFileInfo = DAOFactory.getFileInfoDAO().getFileDetailsByCriteria(session_bankCode, DDM_Constants.status_all, merchantID, DDM_Constants.status_all, DDM_Constants.slip_file_status_processing, DDM_Constants.status_all, webBusinessDate, webBusinessDate);
//
//        if (alreadyProcessingFileInfo != null && alreadyProcessingFileInfo.size() > 0)
//        {
//            for (FileInfo fi : alreadyProcessingFileInfo)
//            {
//                alreadyProcessingFiles = alreadyProcessingFiles + fi.getFileId() + ",";
//            }
//        }

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_csv_file_init, "| Upload DDM CSV Files - Account Search (Originator Acc. No - " + orgAccountNo + ", SLIPS File - " + csvFilePath + ")  | Searched By - " + session_userName + " (" + session_userTypeDesc + ") |"));

    }


%>

<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - Upload CSV Files</title>        
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
                showClock(3);
            }

            function showClock(type)
            {                
                if (type == 1)
                {
                    clock(document.getElementById('showText'), type, null);
                } else if (type == 2)
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'), type, val);
                } else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>);
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
			
            
            function doSearch()
            {
                isSearchRequest(true);
                document.getElementById('hdnMerchantId').value = document.getElementById('cmbMerchantID').value;
                document.getElementById('hdnMerchantAccountNo').value = document.getElementById('cmbAccountNo').value;
                document.getElementById('hdnCSVFilePath').value = document.getElementById('f_CSVFile').value;
                document.frmUploadSlipsFilesSearch.action = "UploadSLIPSFiles.jsp";
                document.frmUploadSlipsFilesSearch.submit();
            	return true;			
            }


            function doSubmit()
            {
                var orgAccNo = document.getElementById('cmbAccountNo').value;
                var f_CSVFilePath = document.getElementById('f_CSVFile').value;
                
			
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


                if(isempty(f_CSVFilePath))
                {
                    alert("Please select a valid CSV file to upload!");
                    document.getElementById('f_CSVFile').focus();
                    return false;
                }
                else
                {
                    var objFile = document.getElementById('f_CSVFile');
                    var fileSize = objFile.files[0].size;
                    
                    if(fileSize > 5242880)
                    {
                        alert("Selected 'CSV File' exceeds the maximum allowed file size! \nPlease select a 'CSV File' which not exceed 5 MB.");
                        document.getElementById('f_CSVFile').focus();
                        return false;                        
                    }
                
                
                    var f_CSVFileName;
                    var f_CSVFileExtension;
                    var correctCertExtension = ".csv";
                    var isValidCSVFile = false;


                    f_CSVFileName = f_CSVFilePath.substring(f_CSVFilePath.lastIndexOf("\\")+1);

                    f_CSVFileExtension = f_CSVFileName.substring(f_CSVFileName.lastIndexOf("."));

                    //alert('f_CSVFileExtension ----> ' + f_CSVFileExtension)                        
                    
                    if(f_CSVFileExtension.toUpperCase() == correctCertExtension.toUpperCase())
                    {
                        isValidCSVFile = true;
                    }
                    else
                    {
                        isValidCSVFile = false;
                        alert("Invalid file type! \nFile exension should be either '.csv' and select a valid CSV file to upload.");
                        return false;
                    }                     

                    if(isValidCSVFile)
                    {
                        var valNewFileName = '<%=merchantID%>' + '_' + '<%=orgAccountNo%>' + "_" + '<%=businessDate%>' + '_' + f_CSVFileName;     
                        var valAlreadyProcessingFiles = '<%=alreadyProcessingFiles%>';

                        if(valAlreadyProcessingFiles.toUpperCase().indexOf(valNewFileName.toUpperCase())>=0)
                        { 
                            alert("Already uploaded CSV file! \nPlease select a new CSV file to upload.");
                            return false;               
                        }
                        else
                        {
                            var answer = confirm("Do you really want to upload this SLIPS data file to the system? \n Press 'OK' to upload the file or 'Cancel' for select another file.");

                            if(answer)
                            {
                                document.getElementById('cmbMerchantID').disabled = false;
                                document.frmUploadSlipsFiles.action="UploadCSVFilesConfirmation.jsp";
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Upload CSV Files</td>
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
                                                                                                                                    <select name="cmbMerchantID" id="cmbMerchantID" class="ddm_field_border" onChange="doSearch()" <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (merchantID == null || (merchantID != null && merchantID.equals(DDM_Constants.status_all)))
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
                                                                                                                                            if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Merchant merchant : colMerchant)
                                                                                                                                                {
                                                                                                                                                    if (merchantID != null && merchant.getMerchantID().equals(merchantID))
                                                                                                                                                    {
                                                                                                                                                        selectedMerchant = merchant;
                                                                                                                                                        colAccNoMap = DAOFactory.getMerchantAccNoMapDAO().getMerchantAccounts(merchantID, DDM_Constants.status_active);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchant.getMerchantID() %>" selected > <%=merchant.getMerchantID() + " - " + merchant.getMerchantName() %></option>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchant.getMerchantID()%>" > <%=merchant.getMerchantID() + " - " + merchant.getMerchantName()%></option>
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
                                                                                                                                    <span class="ddm_error">No merchant details available!</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %>                                                                                                                                                                                                                                                                    </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. No :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbAccountNo" id="cmbAccountNo" class="ddm_field_border" onChange="doSearch()" >
                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                            if (colAccNoMap != null && colAccNoMap.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (MerchantAccNoMap merchantAccNoMap : colAccNoMap)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchantAccNoMap.getAcNo()%>" <%=(orgAccountNo != null && merchantAccNoMap.getAcNo().equals(orgAccountNo)) ? "selected" : ""%> > <%=merchantAccNoMap.getAcNo() + " - " + merchantAccNoMap.getAcName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No active accounts available for this merchant.</span>
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
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. Branch : </td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=OrgAccountBranch%><input type="hidden" name="hdnOrgAccBranch" id="hdnOrgAccBranch" value="<%=OrgAccountBranch%>" /></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    SLIPS File <span class="ddm_required_field">*</span> :        </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">

                                                                                                                                    <input name="f_CSVFile" id="f_CSVFile" type="file" class="ddm_field_border"  size="100" value="<%=csvFilePath%>" ></td>
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
                                                                                                <input type="hidden" name="hdnMerchantId" id="hdnMerchantId" value="<%=merchantID %>" />
                                                                                                <input type="hidden" name="hdnMerchantAccountNo" id="hdnMerchantAccountNo" value="<%=orgAccountNo %>" />
                                                                                                <input type="hidden" name="hdnCSVFilePath" id="hdnCSVFilePath" value="<%=csvFilePath %>" /> 
                                                                                                
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