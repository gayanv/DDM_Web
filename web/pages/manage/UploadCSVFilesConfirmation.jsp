<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp" %>
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.*" errorPage="../../error.jsp" %>

<%@page import="lk.com.ttsl.pb.slips.services.utils.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.account.Account" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../../error.jsp"%>
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
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_cocuId = null;
    String session_cocuName = null;
    String session_menuId = null;
    String session_menuName = null;
    String session_OTP = null;

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
        session_OTP = (String) session.getAttribute("session_OTP");

%>

<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    String GetFileName = null;
    String newFileName = null;
    String newFileFullPath = null;
    String msg = null;
    String fileType = null;
    String vsFile = null;
    String vsFilePath = null;
    boolean fileUploadStatus = false;
    long initialfileSize = 0;

    String merchantID = null;
    String merchantAccNo = null;
    String merchantAccName = null;
    String merchantAccBank = null;
    String merchantAccBranch = null;

    String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
    //String lcplBusinessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_batch_businessdate);

    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    System.out.println("Inside UploadSLIPSFilesConfirmation.jsp ----> start");

    if (!isMultipart)
    {
        System.out.println("Not Multipart");
    }
    else
    {
        try
        {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List items = null;
            items = upload.parseRequest(request);

            Iterator itr = items.iterator();

            while (itr.hasNext())
            {
                FileItem item = (FileItem) itr.next();
                initialfileSize = item.getSize();

                if (item.isFormField())
                {
                    if (item.getFieldName().equals("cmbMerchantID"))
                    {
                        merchantID = item.getString();
                    }
                    if (item.getFieldName().equals("cmbAccountNo"))
                    {
                        merchantAccNo = item.getString();
                    }
                    if (item.getFieldName().equals("hdnOrgAccName"))
                    {
                        merchantAccName = item.getString();
                    }
                    if (item.getFieldName().equals("hdnOrgAccBank"))
                    {
                        merchantAccBank = item.getString();
                    }
                    if (item.getFieldName().equals("hdnOrgAccBranch"))
                    {
                        merchantAccBranch = item.getString();
                    }
                }
                else
                {
                    String itemName = item.getName();

                    System.out.println("itemName ------>" + itemName);

                    int pos = itemName.lastIndexOf(File.separator);
                    GetFileName = itemName.substring(pos + 1);

                    if (itemName.toUpperCase().endsWith(DDM_Constants.ddm_csv_file_suffix.toUpperCase()))
                    {
                        fileType = DDM_Constants.ddm_csv_file_Type;
                    }
                    else
                    {
                        fileType = "";
                    }

                    System.out.println("FileType ------> " + fileType);

                    String tmpCSVFilePath = PropertyLoader.getInstance().getCSVFileUploadPath() + businessDate;

                    System.out.println("tmpCSVFilePath ------> " + tmpCSVFilePath);

                    File fileTmpCSVFilePath = new File(tmpCSVFilePath);

                    if (!fileTmpCSVFilePath.exists())
                    {
                        System.out.println("fileTmpCSVFilePath not available and create the directory ------> " + tmpCSVFilePath);

                        fileTmpCSVFilePath.mkdirs();
                    }

                    newFileName = merchantID + "_" + merchantAccNo + "_" + businessDate + "_" + GetFileName;

                    if (DAOFactory.getDDMRequestDAO().isCSVFileAlreadyUploaded(newFileName))
                    {
                        msg = "Already uploaded CSV file!";
                        fileUploadStatus = false;
                    }
                    else
                    {
                        newFileFullPath = tmpCSVFilePath + File.separator + newFileName;

                        System.out.println("newFileFullPath ------> " + newFileFullPath);

                        File savedFile = new File(newFileFullPath);

                        if (savedFile.exists())
                        {
                            savedFile.delete();
                        }

                        item.write(savedFile);

                        if (savedFile.exists() && savedFile.canRead() && initialfileSize == savedFile.length())
                        {
                            fileUploadStatus = true;
                        }
                        else
                        {
                            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
                            fileUploadStatus = false;
                        }
                    }
                }
            }
        }
        catch (Exception e)
        {
            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
            fileUploadStatus = false;
            System.out.println(e.getMessage());
        }

        if (fileUploadStatus)
        {
            System.out.println("merchantAccName 1 ------> " + merchantAccName);

            CorporateCustomer cocu = DAOFactory.getCorporateCustomerDAO().getCorporateCustomerDetails(merchantID);

            if (cocu != null)
            {
                merchantAccName = cocu.getCoCuName();
            }

            System.out.println("fileUploadStatus ------> " + fileUploadStatus);
            System.out.println("merchantAccNo ------> " + merchantAccNo);
            System.out.println("merchantAccName 2 ------> " + merchantAccName);
            System.out.println("merchantAccBranch ------> " + merchantAccBranch);

            System.out.println("Start CSV File read and Processing ------> ");

            File fileSLIPS_Data = new File(newFileFullPath);

            FileReader fr = null;
            BufferedReader br = null;

            String accNos = "," + merchantAccNo;

            try
            {
                fr = new FileReader(fileSLIPS_Data);
                br = new BufferedReader(fr);
                String headerLine = br.readLine();

                String strLine = null;

                while ((strLine = br.readLine()) != null)
                {
                    if (strLine != null && strLine.length() > 22)
                    {
                        if (strLine.substring(0, 4).equals(DDM_Constants.default_bank_code))
                        {
                            accNos = accNos + "," + strLine.substring(4, 7).replaceAll(" ", "0") + strLine.substring(10, 22).replaceAll(" ", "0");
                        }
                    }
                }
            }
            catch (Exception e)
            {
                System.out.println("Error reading file - " + fileSLIPS_Data + "(" + e.getMessage() + ")");
            }
            finally
            {
                if (br != null)
                {
                    br.close();
                }

                if (fr != null)
                {
                    fr.close();
                }
            }

            System.out.println("accNos ------> " + accNos);

            if (accNos.startsWith(","))
            {
                accNos = accNos.replaceFirst(",", "");
            }

            System.out.println("Start CSV File Processing ########## ------> " + fileType);

            System.out.println("End SLIPS File Processing ##########@@@@@@@ ------> " + fileType);

//                vsFile = fileSLIPS_Data.getName().substring(0, fileSLIPS_Data.getName().lastIndexOf(".")) + "_ValidationSummary.txt";
//                vsFilePath = fileSLIPS_Data.getAbsolutePath().substring(0, fileSLIPS_Data.getAbsolutePath().lastIndexOf(".")) + "_ValidationSummary.txt";
            System.out.println("Start CSV File Processing ########## ------> " + fileType);

            if (fileUploadStatus)
            {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_csv_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded CSV File Name : (Original - " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Merchant Acc. No - " + (merchantAccNo != null ? merchantAccNo : "N/A") + " | Upload CSV file Status - Success | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            }
            else
            {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_csv_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded CSV File Name : " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Merchant Acc. No - " + (merchantAccNo != null ? merchantAccNo : "N/A") + " | Upload CSV file Status - Unsuccess (" + msg + ") | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            }
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_csv_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded CSV File Name : (Original - " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Merchant Acc. No - " + (merchantAccNo != null ? merchantAccNo : "N/A") + " | Upload CSV file Status - Unsuccess (" + msg + ") | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

%>

<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - SLIPS Data File Upload Summary</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/datetimepicker.js"></script>

        <script language="javascript" type="text/JavaScript">

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

            function doSubmit(val)
            { 
            if(val==1)
            {				
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/file/ViewDDARequestDetails.jsp";
            document.frmFileUploadingSummary.submit();
            }
            else if(val==2)
            {				
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/file/UploadCSVFiles.jsp";
            document.frmFileUploadingSummary.submit();
            }
            else
            {
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/homepage.jsp";
            document.frmFileUploadingSummary.submit();
            }
            }

            function downloadFile()
            {
            document.frmDownload.action="DownloadValidationSummary.jsp";
            document.frmDownload.submit();			
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

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="showClock(3)">
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">SLIPS Data  File Uploading Summary</td>
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
                                                                                            <form method="post" name="frmFileUploadingSummary" id="frmFileUploadingSummary" >


                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td align="center" class="ddm_Display_Error_msg">

                                                                                                            <%=fileUploadStatus == true ? "<span class=\"ddm_Display_Success_msg\">SLIPS Data file uploading process is completed.<br/>First please make sure to check the validation summary file inorder to identify transaction level validation details and status.</span>" : (msg != null ? msg : "")%></td>



                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="6" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=merchantID != null ? merchantID : ""%><input name="hdnCoCuID" id="hdnCoCuID" type="hidden" value="<%=merchantID%>"  ></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Merchant Acc. No  :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=merchantAccNo != null ? merchantAccNo : ""%><input name="hdnOrgAccNo" id="hdnOrgAccNo" type="hidden" value="<%=merchantAccNo%>"  ></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Original CSV File Name :        </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=GetFileName%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">System Assigned File Name :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=newFileName%><input name="hdnFileName" id="hdnFileName" type="hidden" value="<%=newFileName%>"  ></td>
                                                                                                                            </tr>


                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Validation Summary :</td>


                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        if (fileUploadStatus)
                                                                                                                                        {
                                                                                                                                    %>


                                                                                                                                    <input type="button" name="btnDwnReport" id="btnDwnReport" value="Download - <%=vsFile%>" class="ddm_custom_button_small" onClick="downloadFile()">
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    N/A
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    %>                                                                                                                                </td>
                                                                                                                            </tr>


                                                                                                                            <tr>
                                                                                                                                <td colspan="2" align="center" class="ddm_tbl_footer_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>                                                                                                                                                
                                                                                                                                                <input type="button" value="View Details and Confirm" name="btnUpload1" id="btnUpload1" class="ddm_custom_button"  onclick="doSubmit(1)" <%=(fileUploadStatus) ? "" : "disabled"%> />
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><input type="button" value="Go To Upload Page" name="btnUpload2" id="btnUpload2" class="ddm_custom_button"  onclick="doSubmit(2)" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>


                                                                                            </form>

                                                                                            <form id="frmDownload" name="frmDownload" method="post" target="_blank"><input type="hidden" id="hdnFileName" name="hdnFileName" value="<%=vsFile%>"  />
                                                                                                <input type="hidden" id="hdnFilePath" name="hdnFilePath" value="<%=vsFilePath%>"  /></form>

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
        // }
    }
%>