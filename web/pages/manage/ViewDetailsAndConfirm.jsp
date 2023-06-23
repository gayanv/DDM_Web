
>
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
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

        if (session_userType.equals(DDM_Constants.user_type_ddm_administrator) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'View and Confirm SLIPS Transactions' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=View_and_Confirm_SLIPS_Transactions");
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
    boolean confirmStatus = false;
    boolean duplicatesAvailable = false;
    boolean isOkToConfirm = false;

    String cocuID = null;
    String fileID = null;
    String fileBDate = null;
    String batchNo = null;
    String orgAccNo = null;
    String afvd = null;

    String hdnConfirmRequest = null;
    String hdnAlreadyConfirmed = null;
    long totalRecordCount = 0;
    int totalPageCount = 0;
    int reqPageNo = 1;
    long validTrCountForConfirmation = 0;
    long invalidPBAccounts = 0;
    long invalidValueDates = 0;
    long invalidOther = 0;
    long totalTransactionAmount = 0;

    FileInfo fileInfo = null;

    Collection<OWDetails> colResult = null;
    Collection<FileInfo> colDupFile = null;

    Collection<OWDetails> colIWDesBr999 = null;

    if (request.getParameter("hdnReqPageNo") != null)
    {
        reqPageNo = Integer.parseInt(request.getParameter("hdnReqPageNo"));
    }

    hdnConfirmRequest = (String) request.getParameter("hdnConfirmRequest");
    hdnAlreadyConfirmed = (String) request.getParameter("hdnAlreadyConfirmed");

    cocuID = (String) request.getParameter("hdnCoCuID");
    fileID = (String) request.getParameter("hdnFileName");
    fileBDate = (String) request.getParameter("hdnFileBDate");
    batchNo = (String) request.getParameter("hdnBatchNo");
    orgAccNo = (String) request.getParameter("hdnOrgAccNo");
    afvd = (String) request.getParameter("hdnAFVD");

    if (fileBDate == null)
    {
        fileBDate = webBusinessDate;
    }

    if (hdnConfirmRequest == null)
    {
        hdnConfirmRequest = "0";
    }

    if (hdnAlreadyConfirmed == null)
    {
        hdnAlreadyConfirmed = "0";
    }

    System.out.println("hdnConfirmRequest--->" + hdnConfirmRequest);
    System.out.println("hdnAlreadyConfirmed--->" + hdnAlreadyConfirmed);

    if (cocuID == null)
    {
        cocuID = DDM_Constants.status_all;
    }

    if (batchNo == null)
    {
        batchNo = DDM_Constants.status_all;
    }

    if (orgAccNo == null)
    {
        orgAccNo = DDM_Constants.status_all;
    }

    if (afvd == null)
    {
        afvd = DDM_Constants.status_all;
    }

    System.out.println("cocuID--->" + cocuID);
    System.out.println("fileID--->" + fileID);
    System.out.println("fileBDate--->" + fileBDate);
    System.out.println("orgAccNo--->" + orgAccNo);

    fileInfo = DAOFactory.getFileInfoDAO().getFileDetails(fileID, fileBDate, DDM_Constants.status_all, DDM_Constants.status_all);

    String fromDate = DAOFactory.getBCMCalendarDAO().getPreviousBusinessDate(webBusinessDate, 14);

    totalRecordCount = DAOFactory.getOWDetailsDAO().getRecordCountOWDetails(fileID, fileBDate, batchNo);

    validTrCountForConfirmation = DAOFactory.getOWDetailsDAO().getRecordCountOWDetails(fileID, fileBDate, batchNo, DDM_Constants.ddm_transaction_status_00);

    invalidOther = DAOFactory.getOWDetailsDAO().getRecordCountOWDetails(fileID, fileBDate, batchNo, DDM_Constants.ddm_transaction_status_09);
    invalidPBAccounts = DAOFactory.getOWDetailsDAO().getRecordCountOWDetailsByRejectCode(fileID, fileBDate, batchNo, DDM_Constants.ddm_reject_code_invalid_pb_account);
    invalidValueDates = DAOFactory.getOWDetailsDAO().getRecordCountOWDetailsByRejectCode(fileID, fileBDate, batchNo, DDM_Constants.ddm_reject_code_invalid_value_date);

    System.out.print("totalRecordCount ---> " + totalRecordCount);

    if (fileInfo.getUploadedBy().equals(session_userName))
    {
        isOkToConfirm = true;
    }

    if (totalRecordCount > 0)
    {
        totalPageCount = (int) Math.ceil((Double.parseDouble(String.valueOf(totalRecordCount))) / DDM_Constants.noPageRecords);

        System.out.print("totalPageCount ---> " + totalPageCount);

        colResult = DAOFactory.getOWDetailsDAO().getOWDetails(fileID, fileBDate, batchNo, reqPageNo, DDM_Constants.noPageRecords);
        colIWDesBr999 = DAOFactory.getOWDetailsDAO().getIWDetailsWithDesBr999(fileID, fileBDate, DDM_Constants.status_all);

        totalTransactionAmount = DAOFactory.getOWDetailsDAO().getTotalTransactionAmount(fileID, fileBDate, batchNo, DDM_Constants.status_all, DDM_Constants.status_yes);

        String statusNotIn = "'" + DDM_Constants.slip_file_status_error + "','" + DDM_Constants.slip_file_status_rejected_insufficient_fund + "','" + DDM_Constants.slip_file_status_ddm_manager_rejected + "','" + DDM_Constants.slip_file_status_timeout + "','" + DDM_Constants.slip_file_status_upload_rejected_cocu_supervisor + "'";

        colDupFile = DAOFactory.getFileInfoDAO().getFileDetailsByCriteria(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), fileInfo.getFileType(), DDM_Constants.status_all, statusNotIn, DDM_Constants.status_all, fileInfo.getNooftransactionexpected(), totalTransactionAmount, fromDate, webBusinessDate);

        if (colDupFile != null && colDupFile.size() > 0)
        {
            int dfCount = 0;

            for (FileInfo fi : colDupFile)
            {
                if (!fi.getFileId().equals(fileID))
                {
                    dfCount++;
                }
            }

            if (dfCount > 0)
            {
                duplicatesAvailable = true;
            }
        }

        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| File Id - " + fileID + ", File Business Date - " + fileBDate + ", Batch No. - " + batchNo + ", Page No. - " + reqPageNo + " | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| File Id - " + fileID + ", File Business Date - " + fileBDate + ", Batch No. - " + batchNo + " | Total Record Count - 0 | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }

    int confirmedTrCount = -1;
    int confirmedTrCount_Rejected = -1;

    if (hdnConfirmRequest.equals("1"))
    {
        //String cDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate).substring(2);
        String cDate = fileBDate.replaceAll("-", "").substring(2);

        if (fileInfo.getFileType() != null && (fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type) || fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type)))
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_02, session_userName);
        }
        else
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_01, session_userName);
        }

        if (confirmedTrCount > 0)
        {
            //String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
            String businessDate = fileBDate.replaceAll("-", "");

            if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsIW(DDM_Constants.default_bank_code, DDM_Constants.status_all, fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    System.out.println("colCBfileDetails.size() ---> " + colCBfileDetails.size());

                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_uploader_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }

            confirmStatus = true;
            hdnAlreadyConfirmed = "1";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Success, Confirmed Valid Transaction Count - " + confirmedTrCount + ", Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            confirmStatus = true;
            hdnAlreadyConfirmed = "0";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Unsuccess, Couldn't Confirmed Any Valid Transaction, Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

    if (hdnConfirmRequest.equals("2"))
    {
        //String cDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate).substring(2);
        String cDate = fileBDate.replaceAll("-", "").substring(2);

        if (fileInfo.getFileType() != null && (fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type) || fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type)))
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_02, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_02, DDM_Constants.ddm_reject_code_invalid_pb_account, afvd, session_userName);
        }
        else
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_01, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_01, DDM_Constants.ddm_reject_code_invalid_pb_account, afvd, session_userName);
        }

        if ((confirmedTrCount + confirmedTrCount_Rejected) > 0)
        {
            //String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
            String businessDate = fileBDate.replaceAll("-", "");

            if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsIW(DDM_Constants.default_bank_code, DDM_Constants.status_all, fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_uploader_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }

            confirmStatus = true;
            hdnAlreadyConfirmed = "1";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Success, Confirmed Valid Transaction Count - " + confirmedTrCount + ", Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            confirmStatus = true;
            hdnAlreadyConfirmed = "0";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Unsuccess, Couldn't Confirmed Any Valid Transaction, Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

    if (hdnConfirmRequest.equals("3"))
    {
        //String cDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate).substring(2);
        String cDate = fileBDate.replaceAll("-", "").substring(2);

        if (fileInfo.getFileType() != null && (fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type) || fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type)))
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_02, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_02, DDM_Constants.ddm_reject_code_invalid_value_date, afvd, session_userName);
        }
        else
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_01, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_01, DDM_Constants.ddm_reject_code_invalid_value_date, afvd, session_userName);
        }

        if ((confirmedTrCount + confirmedTrCount_Rejected) > 0)
        {
            //String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
            String businessDate = fileBDate.replaceAll("-", "");

            if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsIW(DDM_Constants.default_bank_code, DDM_Constants.status_all, fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_uploader_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }

            confirmStatus = true;
            hdnAlreadyConfirmed = "1";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Success, Confirmed Valid Transaction Count - " + confirmedTrCount + ", Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            confirmStatus = true;
            hdnAlreadyConfirmed = "0";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Unsuccess, Couldn't Confirmed Any Valid Transaction, Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

    if (hdnConfirmRequest.equals("4"))
    {
        //String cDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate).substring(2);
        String cDate = fileBDate.replaceAll("-", "").substring(2);

        if (fileInfo.getFileType() != null && (fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type) || fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type)))
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_02, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_02, DDM_Constants.ddm_reject_code_invalid_pb_account, afvd, session_userName);
            confirmedTrCount_Rejected = confirmedTrCount_Rejected + DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_02, DDM_Constants.ddm_reject_code_invalid_value_date, afvd, session_userName);
            confirmedTrCount_Rejected = confirmedTrCount_Rejected + DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_02, DDM_Constants.ddm_reject_code_invalid_pb_account_and_value_date, afvd, session_userName);
        }
        else
        {
            confirmedTrCount = DAOFactory.getSlipsTransactionDAO().updateTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_00, DDM_Constants.ddm_transaction_status_01, session_userName);
            confirmedTrCount_Rejected = DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_01, DDM_Constants.ddm_reject_code_invalid_pb_account, afvd, session_userName);
            confirmedTrCount_Rejected = confirmedTrCount_Rejected + DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_01, DDM_Constants.ddm_reject_code_invalid_value_date, afvd, session_userName);
            confirmedTrCount_Rejected = confirmedTrCount_Rejected + DAOFactory.getSlipsTransactionDAO().updateRejectedTransactionStatusByUploader(fileID, cDate, DDM_Constants.ddm_transaction_status_01, DDM_Constants.ddm_reject_code_invalid_pb_account_and_value_date, afvd, session_userName);
        }

        if ((confirmedTrCount + confirmedTrCount_Rejected) > 0)
        {
            //String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
            String businessDate = fileBDate.replaceAll("-", "");

            if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsIW(DDM_Constants.default_bank_code, DDM_Constants.status_all, fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else if (fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_non_core_return_file_Type))
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_fund_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }
            else
            {
                DAOFactory.getFileInfoDAO().updateFileStatus(fileID, businessDate, DDM_Constants.slip_file_status_uploader_confirmed, null, session_userName);

                Collection<CustomBatch> colCBfileDetails = DAOFactory.getCustomBatchDAO().getBatchDetailsOW(DDM_Constants.default_bank_code, fileInfo.getOwBranch(), fileInfo.getCoCuID(), DDM_Constants.status_all, fileID, fileBDate, fileBDate);

                if (colCBfileDetails != null && colCBfileDetails.size() == 1)
                {
                    CustomBatch cbFileDetail = colCBfileDetails.iterator().next();

                    DAOFactory.getFileInfoDAO().updateCreditDebitTotalsAndUploadConfirmation(fileID, businessDate, cbFileDetail.getItemCountCredit(), cbFileDetail.getAmountCredit(), cbFileDetail.getItemCountDebit(), cbFileDetail.getAmountDebit(), totalTransactionAmount, session_userName);
                }
            }

            confirmStatus = true;
            hdnAlreadyConfirmed = "1";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Success, Confirmed Valid Transaction Count - " + confirmedTrCount + ", Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            confirmStatus = true;
            hdnAlreadyConfirmed = "0";
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id - " + fileID + ", Date - " + cDate + " |Confirmed Status - Unsuccess, Couldn't Confirmed Any Valid Transaction, Confirmed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

    if (hdnConfirmRequest.equals("5"))
    {        
        System.out.println("hdnConfirmRequest ---> " + hdnConfirmRequest);
        System.out.println("fileID - " + fileID + ", fileBDate - " + fileBDate);
        
        String fBussinessDate = fileBDate.replaceAll("-", "");
        
        System.out.println("fBussinessDate ---> " + fBussinessDate);
        
        if (DAOFactory.getFileInfoDAO().isFileCurrentlyProcessing(fileID, fBussinessDate))
        {
            System.out.println("isFileCurrentlyProcessing ---> is ture (fileID - " + fileID + ", fBussinessDate - " + fBussinessDate);
            
            if (DAOFactory.getSlipsTransactionDAO().deleteSlipsTransactions(fileID, fBussinessDate.substring(2)))
            {
                System.out.println("deleteSlipsTransactions ---> is ture (fileID - " + fileID + ", fBussinessDate - " + fBussinessDate);
                
                if (DAOFactory.getCustomBatchDAO().deleteSlipsBatch(fileID))
                {
                    System.out.println("deleteSlipsBatch ---> is ture (fileID - " + fileID + ", fBussinessDate - " + fBussinessDate);
                    
                    if (DAOFactory.getFileInfoDAO().deleteSlipsFile(fileID, fBussinessDate))
                    {
                        System.out.println("deleteSlipsFile ---> is ture (fileID - " + fileID + ", fBussinessDate - " + fBussinessDate);
                        
                        confirmStatus = true;
                        hdnAlreadyConfirmed = "1";
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_confirm_on_uploaded_ddm_transactions, "| SLIPS File Id : " + fileID + ", Date : " + fileBDate + " | Reject and Remove Uploaded File Status - Success, Done By - " + session_userName + " (" + session_userTypeDesc + ") |"));

                        System.out.println("Previous Slips Data and SLIPS File Successfily Deleted ------> " + fileID + ", " + fileBDate);
                    }
                }
            }
        }
    }

%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - View & Confirm Uploaded SLIPS Data</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>

        <script language="javascript" type="text/JavaScript">

            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2                 )
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

            function resetDates()
            {
            var from_elementId = 'txtFromBusinessDate';
            var to_elementId = 'txtToBusinessDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";
            }

            function isInitReq(status) {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";

            }

            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else
            {
            document.getElementById('hdnSearchReq').value = "0";
            }
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

            if(document.getElementById('clickSearch')!= null)
            {
            document.getElementById('clickSearch').style.display='block';
            }

            }

            function setReqPageNoForCombo2()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo2').value;
            document.frmPageNavi.action="ViewDetailsAndConfirm.jsp";
            document.frmPageNavi.submit();
            }

            function setReqPageNoForCombo()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo').value;
            document.frmPageNavi.action="ViewDetailsAndConfirm.jsp";
            document.frmPageNavi.submit();
            }

            function setReqPageNo(no)
            {
            document.getElementById('hdnReqPageNo').value = no;

            document.frmPageNavi.action="ViewDetailsAndConfirm.jsp";
            document.frmPageNavi.submit();				
            }


            function doSubmit(val)
            { 
            if(val==1)
            {
            document.getElementById('hdnConfirmRequest').value = "1";
            }
            if(val==2)
            {
            document.getElementById('hdnConfirmRequest').value = "2";
            }
            if(val==3)
            {
            document.getElementById('hdnConfirmRequest').value = "3";
            }
            if(val==4)
            {
            document.getElementById('hdnConfirmRequest').value = "4";
            }
            if(val==5)
            {
            document.getElementById('hdnConfirmRequest').value = "5";
            }

            document.frmConfirmTransactions.action="ViewDetailsAndConfirm.jsp";
            document.frmConfirmTransactions.submit();

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
                                                                                        <td align="left" valign="top" class="ddm_header_text">View &amp; Confirm SLIPS Transactions <span class="ddm_header_small_text">(Confirm Uploaded SLIPS Data)</span></td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td><table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%
                                                                                                                if (totalRecordCount == 0)
                                                                                                                {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="ddm_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%   }
                                                                                                            else if (colResult.size() > DDM_Constants.maxWebRecords)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="ddm_error">Sorry! Details view prevented due to too many records. (Max Viewable Records Count - <%=DDM_Constants.maxWebRecords%> , Current Records Count - <%=colResult.size()%>, This can be lead to memory overflow in your machine.)</div></td>
                                                                                                            </tr>
                                                                                                            <%}
                                                                                                            else
                                                                                                            {
                                                                                                            %>

                                                                                                            <%
                                                                                                                if (hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5"))
                                                                                                                {
                                                                                                                    if (confirmStatus)
                                                                                                                    {
                                                                                                                        if (hdnConfirmRequest.equals("5"))
                                                                                                                        {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_Display_Success_msg">You have successfully reject and remove the uploaded SLIPS data file and following transaction details!</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_Display_Success_msg">You have successfully confirmed the following transactions!</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td align="center" class="ddm_Display_Error_msg">Error occurred while confirming the transactions!</td>
                                                                                                            </tr>

                                                                                                            <%
                                                                                                                    }
                                                                                                                }
                                                                                                            %>

                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_header_text"></td>
                                                                                                            </tr>

                                                                                                            <%
                                                                                                                if (duplicatesAvailable)
                                                                                                                {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="ddm_header_text"><table border="0" cellspacing="0" cellpadding="1" bgcolor="#F8EFFA" class="ddm_table_boder">
                                                                                                                        <tr>
                                                                                                                            <td colspan="3"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#EFB4BC" class="ddm_table_boder_light">
                                                                                                                                    <tr>
                                                                                                                                        <td align="left" class="ddm_Display_Error_msg">
                                                                                                                                            <table border="0" cellspacing="0" cellpadding="2">
                                                                                                                                                <tr>
                                                                                                                                                    <td>&nbsp;</td>
                                                                                                                                                    <td><img src="<%=request.getContextPath()%>/images/warning2.png" width="48"
                                                                                                                                                             height="48" border="0" align="middle" ></td>
                                                                                                                                                    <td>&nbsp;&nbsp;</td>
                                                                                                                                                    <td valign="middle" ><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                            <tr>
                                                                                                                                                                <td height="10"></td>
                                                                                                                                                            </tr>
                                                                                                                                                            <tr>
                                                                                                                                                                <td class="ddm_Display_Error_msg"><h1>WARNING!</h1></td>
                                                                                                                                                            </tr>
                                                                                                                                                        </table>                                                                                                                    </td>
                                                                                                                                                    <td valign="middle" >&nbsp;</td>
                                                                                                                                                    <td align="center" valign="bottom" ><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                            <tr>
                                                                                                                                                                <td width="100" align="center" class="ddm_Display_Error_msg">&nbsp;</td>
                                                                                                                                                                <td align="center" class="ddm_Display_Error_msg"><h2>Duplicate SLIPS File Data Found    For Last 14 Days.</h2></td>
                                                                                                                                                            </tr>
                                                                                                                                                        </table></td>
                                                                                                                                                </tr>
                                                                                                                                            </table></td>
                                                                                                                                    </tr>
                                                                                                                                    <tr>
                                                                                                                                        <td height="5"></td>
                                                                                                                                    </tr>
                                                                                                                                </table></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td>&nbsp;&nbsp;</td>
                                                                                                                            <td>

                                                                                                                                <table border="0" cellpadding="3" cellspacing="1"  bgcolor="#FFFFFF" class="ddm_table_boder_light" >
                                                                                                                                    <tr>
                                                                                                                                        <td  class="ddm_tbl_header_text"></td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">File Id</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Business<br/>Date</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Session</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Corporate<br/>Customer</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Orginator<br/>Account No.</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Total<br/>Transactions</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Total<br/>Amount</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Status</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Uploaded<br/>By</td>
                                                                                                                                        <td align="center" bgcolor="#D7BBE1" class="ddm_tbl_header_text_horizontal">Uploaded<br/>Time</td>
                                                                                                                                    </tr>
                                                                                                                                    <%
                                                                                                                                        int rowNum = 0;

                                                                                                                                        for (FileInfo fi : colDupFile)
                                                                                                                                        {
                                                                                                                                            if (!fi.getFileId().equals(fileID))
                                                                                                                                            {
                                                                                                                                                rowNum++;

                                                                                                                                    %>
                                                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                        <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                                        <td nowrap class="ddm_common_text"><%=fi.getFileId()%></td>
                                                                                                                                        <td align="center" nowrap class="ddm_common_text"><%=fi.getBusinessDate()%></td>
                                                                                                                                        <td align="center" class="ddm_common_text"><%=fi.getSession()%></td>
                                                                                                                                        <td nowrap class="ddm_common_text"><%=fi.getCoCuID()%> - <%=fi.getCoCuName()%></td>
                                                                                                                                        <td nowrap class="ddm_common_text" title="<%=fi.getOriginatorAccName()%>"><%=fi.getOriginatorAccNo()%></td>
                                                                                                                                        <td align="right" class="ddm_common_text"><%=fi.getNooftransactionexpected()%></td>                                                                                                                                  

                                                                                                                                        <td align="right" class="ddm_common_text"><%=new DecimalFormat("###,##0.00").format((new Long(fi.getTotalAmountExpected()).doubleValue()) / 100)%></td>
                                                                                                                                        <td class="ddm_common_text"><%=fi.getStatusDesc()%></td>
                                                                                                                                        <td class="ddm_common_text"><%=fi.getUploadedBy()%></td>
                                                                                                                                        <td align="center" class="ddm_common_text"><%=fi.getUploadedTime()%></td>
                                                                                                                                    </tr>
                                                                                                                                    <%
                                                                                                                                            }

                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                </table>                                                                                                                    </td>
                                                                                                                            <td>&nbsp;&nbsp;</td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="10"></td>
                                                                                                                            <td></td>
                                                                                                                            <td></td>
                                                                                                                        </tr>
                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                            <tr><td height="10">&nbsp;</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }
                                                                                                            %>


                                                                                                            <tr>
                                                                                                                <td align="center"><div id="resultdata">







                                                                                                                        <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="right">
                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="ddm_table_boder_print"><form name="frmPageNavi" id="frmPageNavi" method="post" target="_self">
                                                                                                                                            <tr bgcolor="#DFE0E1">
                                                                                                                                                <td align="right" class="ddm_tbl_footer_text">
                                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><table border="0" cellspacing="0" cellpadding="3">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td width="5" nowrap class="ddm_common_text_bold">&nbsp;</td>
                                                                                                                                                                        <td nowrap class="ddm_common_text_bold_large">B. Date :</td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getBusinessDate()%></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold_large">Session :</td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getSession()%></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold_large"><span class="ddm_common_text_bold_large" title="Corporate Customer ID">CoCu :</span></td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getCoCuID() != null ? fileInfo.getCoCuID() : "N/A"%></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold_large">File :</td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getFileId()%></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold"><span class="ddm_common_text_bold_large" title="Total Number of Transactions">Total Tr. :</span></td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getNooftransactionexpected()%></td><td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold"><span class="ddm_common_text_bold_large" title="Number of Accepted Transactions">Acc. Tr. :</span></td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getNoOfTransaction()%></td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold"><span class="ddm_common_text_bold_large" title="Number Of Rejected Transactions">Rej. Tr. :</span></td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=fileInfo.getNooftransactionrejected()%> <% if (fileInfo.getNooftransactionrejected() > 0)
                                                                                                                                                                            {%><span class="ddm_link" title="Click To View The Rejected Transcation Details">(<a href="javascript:void(0)" class="ddm_link" onClick="javascript:window.open('ViewRejectDetails.jsp?fileId=<%=fileID%>&bDate=<%=fileBDate%>', 'ViewRejectTr', 'width=960,height=650,location=0,status=0,manubar=0,resizable=1,scrollbars=1,toolbar=0')"> View </a>)</span><% }%></td>

                                                                                                                                                                        <%
                                                                                                                                                                            if ((fileInfo.getFileType() != null && fileInfo.getFileType().equalsIgnoreCase(DDM_Constants.ddm_iwd_file_Type)) && (colIWDesBr999 != null && colIWDesBr999.size() > 0))
                                                                                                                                                                            {
                                                                                                                                                                        %>

                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                      <td nowrap class="ddm_common_text_bold"><span class="ddm_common_text_bold_large" title="Inward Transactions with Destination Branch 999">IW Des. Br. 999 Tr. :</span></td>
                                                                                                                                                                        <td class="ddm_common_text_large"><%=colIWDesBr999.size()%> (<span class="ddm_link" title="Click To View The Details of Inward Transactions with Destination Branch 999"><a href="javascript:void(0)" class="ddm_link" onClick="javascript:window.open('ViewIWDesBr999.jsp?fileId=<%=fileID%>&bDate=<%=fileBDate%>', 'ViewIWDesBr999', 'width=960,height=650,location=0,status=0,manubar=0,resizable=1,scrollbars=1,toolbar=0')"> View </a></span>)</td>
                                                                                                                                                                        <%
                                                                                                                                                                            }
                                                                                                                                                                        %>

                                                                                                                                                                        <td width="20" class="ddm_common_text_large">&nbsp;</td>
                                                                                                                                                                    </tr>
                                                                                                                                                                </table></td>
                                                                                                                                                            <td align="right"><table border="0" cellspacing="0" cellpadding="2">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td class="ddm_common_text"><input type="hidden" id="hdnFileName" name="hdnFileName" value="<%=fileID%>" />
                                                                                                                                                                            <input type="hidden" id="hdnFileBDate" name="hdnFileBDate" value="<%=fileBDate%>" />

                                                                                                                                                                            <input type="hidden" id="hdnBatchNo" name="hdnBatchNo" value="<%=batchNo%>" />   

                                                                                                                                                                            <input type="hidden" id="hdnCoCuID" name="hdnCoCuID" value="<%=cocuID%>" /> 

                                                                                                                                                                            <input type="hidden" id="hdnOrgAccNo" name="hdnOrgAccNo" value="<%=orgAccNo%>" /> 
                                                                                                                                                                            <input type="hidden" id="hdnAFVD" name="hdnAFVD" value="<%=afvd%>" /> 

<!-- input type="hidden" id="hdnConfirmRequest" name="hdnConfirmRequest" value="<%=hdnConfirmRequest%>" /-->         
                                                                                                                                                                            <input type="hidden" id="hdnAlreadyConfirmed" name="hdnAlreadyConfirmed" value="<%=hdnAlreadyConfirmed%>" />                                                                 
                                                                                                                                                                            <input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" />                                                                                                                        </td>
                                                                                                                                                                        <td align="right" valign="middle" class="ddm_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                                        <td width="15"></td>
                                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                                            <%
                                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                                {
                                                                                                                                                                            %>
                                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16" title="First Page" /> 													<%                                                                                                                        }
                                                                                                                                                                            else
                                                                                                                                                                            {
                                                                                                                                                                            %>
                                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                                            <%
                                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                                {
                                                                                                                                                                            %>
                                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                                                            else
                                                                                                                                                                            {
                                                                                                                                                                            %>

                                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                                                        <td width="2"></td>
                                                                                                                                                                        <td><select class="ddm_field_border_number" name="cmbPageNo" id="cmbPageNo" onChange="setReqPageNoForCombo()">
                                                                                                                                                                                <%
                                                                                                                                                                                    for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                                                                    {
                                                                                                                                                                                %>
                                                                                                                                                                                <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                                <%
                                                                                                                                                                                    }
                                                                                                                                                                                %>
                                                                                                                                                                            </select></td>
                                                                                                                                                                        <td width="2"></td>
                                                                                                                                                                        <td>
                                                                                                                                                                            <%
                                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                                {
                                                                                                                                                                            %>
                                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                                                            <%}
                                                                                                                                                                            else
                                                                                                                                                                            {%>
                                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)" /><%}%> </td>
                                                                                                                                                                        <td>
                                                                                                                                                                            <%
                                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                                {
                                                                                                                                                                            %>
                                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                                            else
                                                                                                                                                                            {%>
                                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                                                        <td width="5"></td>
                                                                                                                                                                    </tr>
                                                                                                                                                                </table></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table>
                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </form>
                                                                                                                                    </table>                                                                                                                                                                                                                    </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="center" height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="center"><table  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                                                        <tr>
                                                                                                                                            <td align="right" class="ddm_tbl_header_text_horizontal"></td>
                                                                                                                                            <!--td align="center" bgcolor="#A4B7CA" class="ddm_tbl_header_text">Out.<br/>Bk-Br</td-->
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                                                Bank-Branch</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                                                Account No.</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Originator<br/>
                                                                                                                                                Account Name</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal">Destination<br/>
                                                                                                                                                Bank-Branch</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Destination<br/>
                                                                                                                                                Account No.</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Destination<br/>
                                                                                                                                                Account Name</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >TC</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >RC</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Value<br/>
                                                                                                                                                Date</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Cur.<br/>
                                                                                                                                                Code</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Amount</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Part.</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Ref.</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Validation<br/>Status</td>
                                                                                                                                            <td align="center" class="ddm_tbl_header_text_horizontal" >Reject<br/>Codes</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            int rowNum = 0 + ((reqPageNo - 1) * DDM_Constants.noPageRecords);
                                                                                                                                            //int itemCountCredit = 0;
                                                                                                                                            //int itemCountDebit = 0;

                                                                                                                                            long totalAmount = 0;
                                                                                                                                            //long totalAmountDebit = 0;

                                                                                                                                            for (OWDetails owdetails : colResult)
                                                                                                                                            {
                                                                                                                                                rowNum++;

                                                                                                                                                //itemCountCredit += owdetails.getItemCountCredit();
                                                                                                                                                //itemCountDebit += owdetails.getItemCountDebit();
                                                                                                                                                if (owdetails.getAmount() > 0)
                                                                                                                                                {
                                                                                                                                                    totalAmount += owdetails.getAmount();
                                                                                                                                                }
                                                                                                                                                //totalAmountCredit += owdetails.getAmountCredit();
                                                                                                                                        %>
                                                                                                                                                                                                        <!--form action="" id="frmRemarks_<%=rowNum%>" name="frmRemarks_<%=rowNum%>" method="post" target="_self"-->
                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" class="ddm_common_text" ><%=rowNum%>.</td>
                                                                                                                                              <!--td align="center"  class="ddm_common_text"><%=owdetails.getOwBank()%>-<%=owdetails.getOwBranch()%></td-->
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getOrgAcNoDec()%></td>
                                                                                                                                            <td  class="ddm_common_text"><%=owdetails.getOrgAcNameDec()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getDesAcNo()%></td>
                                                                                                                                            <td  class="ddm_common_text"><%=owdetails.getDesAcNameDec()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getTc()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getRc()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getValueDate()%></td>
                                                                                                                                            <td align="center"  class="ddm_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                                                            <td align="right"  class="ddm_common_text"><%=new DecimalFormat("###,##0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                                                            <td  class="ddm_common_text"><%=owdetails.getParticulars()%></td>
                                                                                                                                          <td  class="ddm_common_text"><%=owdetails.getReference()%></td>



                                                                                                                                          <td  class="ddm_common_text"><%=owdetails.getStatusDesc() != null ? owdetails.getStatusDesc() : "N/A"%></td>
                                                                                                                                          <td align="center" nowrap  class="ddm_common_text"><%=owdetails.getRJCodes() != null ? owdetails.getRJCodes().equals("00") ? "-" : owdetails.getRJCodes() : "-"%></td>
                                                                                                                                        </tr>
                                                                                                                                        <!--/form-->
                                                                                                                                        <%
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                        <tr  class="ddm_common_text">
                                                                                                                                            <td height="20" colspan="10" align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal" ></td>
                                                                                                                                            <!--td align="center" bgcolor="#B4C4D3" class="ddm_common_text">&nbsp;</td-->
                                                                                                                                            <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">Total</td>
                                                                                                                                            <td align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text"><%=new DecimalFormat("###,##0.00").format((new Long(totalAmount).doubleValue()) / 100)%></td>
                                                                                                                                            <td colspan="4" align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr  class="ddm_common_text">
                                                                                                                                            <td height="20" colspan="10" align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal" ></td>
                                                                                                                                            <td align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">Grand Total</td>
                                                                                                                                            <td align="right" bgcolor="#B4C4D3" class="ddm_tbl_header_text"><%=new DecimalFormat("###,##0.00").format((new Long(totalTransactionAmount).doubleValue()) / 100)%></td>
                                                                                                                                            <td colspan="4" align="center" bgcolor="#B4C4D3" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right">
                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="ddm_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td align="right" class="ddm_tbl_footer_text">
                                                                                                                                                <table border="0" cellspacing="0" cellpadding="2">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right" valign="middle" class="ddm_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                        <td width="15"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16"  /> 													<%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>

                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                                        <td width="2"></td>
                                                                                                                                                        <td><select class="ddm_field_border_number" name="cmbPageNo2" id="cmbPageNo2" onChange="setReqPageNoForCombo2()">
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                                                    {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                            </select></td>
                                                                                                                                                        <td width="2"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                                            <%}
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)"/><%}%> </td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                    </table>

                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>



                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }
                                                                                                            %>
                                                                                                            <tr><td height="10"></td>
                                                                                                            </tr>
                                                                                                            <tr><td align="center"><form name="frmConfirmTransactions" id="frmConfirmTransactions"  method="post" >
                                                                                                                        <input type="hidden" id="hdnFileName" name="hdnFileName" value="<%=fileID%>" />
                                                                                                                        <input type="hidden" id="hdnFileBDate" name="hdnFileBDate" value="<%=fileBDate%>" />
                                                                                                                        <input type="hidden" id="hdnBatchNo" name="hdnBatchNo" value="<%=batchNo%>" />         

                                                                                                                        <input type="hidden" id="hdnCoCuID" name="hdnCoCuID" value="<%=cocuID%>" /> 

                                                                                                                        <input type="hidden" id="hdnOrgAccNo" name="hdnOrgAccNo" value="<%=orgAccNo%>" />  

                                                                                                                        <input type="hidden" id="hdnConfirmRequest" name="hdnConfirmRequest" value="<%=hdnConfirmRequest%>" />  
                                                                                                                        <input type="hidden" id="hdnAFVD" name="hdnAFVD" value="<%=afvd%>" />                                                                        
                                                                                                                        <input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" />                                                                                                                        
                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
                                                                                                                                if (isOkToConfirm)
                                                                                                                                {
                                                                                                                            %>  
                                                                                                                            <tr>
                                                                                                                                <td align="center"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>

                                                                                                                                                <input type="button" name="btnConfirm1" id="btnConfirm1" value="Confirm (Only Valid)" class="ddm_custom_button_large" onClick="doSubmit(1)" <%=((invalidOther != 0) || (afvd.equals(DDM_Constants.status_all) && (invalidValueDates > 0)) || (invalidOther > (invalidPBAccounts + invalidValueDates)) || validTrCountForConfirmation == 0 || hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5") || hdnAlreadyConfirmed.equals("1")) ? "disabled" : ""%>  ></td>

                                                                                                                                            <%
                                                                                                                                                if ((!(invalidOther > (invalidPBAccounts + invalidValueDates))) && ((invalidPBAccounts > 0) && (!(invalidValueDates > 0))))
                                                                                                                                                {

                                                                                                                                            %>

                                                                                                                                            <td width="15">&nbsp;</td>
                                                                                                                                            <td><input type="button" name="btnConfirm2" id="btnConfirm2" value="Confirm (Valid + Invalid PB Accounts)" class="ddm_custom_button_large" onClick="doSubmit(2)" <%=(hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5") || hdnAlreadyConfirmed.equals("1")) ? "disabled" : ""%>  ></td>
                                                                                                                                                <%
                                                                                                                                                    }

                                                                                                                                                    if ((!(invalidOther > (invalidPBAccounts + invalidValueDates))) && (!afvd.equals(DDM_Constants.status_all)) && ((invalidValueDates > 0) && (!(invalidPBAccounts > 0))))
                                                                                                                                                    {
                                                                                                                                                %>

                                                                                                                                            <td width="15">&nbsp;</td>
                                                                                                                                            <td><input type="button" name="btnConfirm3" id="btnConfirm3" value="Confirm (Valid + Invalid Value Dates)" class="ddm_custom_button_large" onClick="doSubmit(3)" <%=(hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5") || hdnAlreadyConfirmed.equals("1")) ? "disabled" : ""%>  ></td>
                                                                                                                                                <%
                                                                                                                                                    }

                                                                                                                                                    if ((!(invalidOther > (invalidPBAccounts + invalidValueDates))) && (!afvd.equals(DDM_Constants.status_all)) && ((invalidPBAccounts > 0) && (invalidValueDates > 0)))
                                                                                                                                                    {
                                                                                                                                                %>           

                                                                                                                                            <td width="15">&nbsp;</td>
                                                                                                                                            <td><input type="button" name="btnConfirm4" id="btnConfirm4" value="Confirm (Valid + Invalid PB Accounts and Value Dates)" class="ddm_custom_button_large" onClick="doSubmit(4)" <%=(hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5") || hdnAlreadyConfirmed.equals("1")) ? "disabled" : ""%>  ></td>

                                                                                                                                            <%
                                                                                                                                                }
                                                                                                                                            %>

                                                                                                                                            <td width="15">&nbsp;</td>
                                                                                                                                            <td><input type="button" name="btnConfirm4" id="btnConfirm4" value="Reject and Remove Uploaded File" class="ddm_custom_button_large" onClick="doSubmit(5)" <%=(hdnConfirmRequest.equals("1") || hdnConfirmRequest.equals("2") || hdnConfirmRequest.equals("3") || hdnConfirmRequest.equals("4") || hdnConfirmRequest.equals("5") || hdnAlreadyConfirmed.equals("1")) ? "disabled" : ""%>  ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>

                                                                                                                            <%
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td align="center" class="ddm_Display_Error_msg">Only the person who uploaded the slips data file can confirm and continue with the process!</td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>

                                                                                                                        </table>








                                                                                                                    </form></td></tr>


                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table></td>
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
        <span  ></span>
    </body>
    <script language="javascript" type="text/JavaScript">
        if (!document.layers)
        {

        document.write('<div id="GotoDown" style="position:absolute">');
        document.write('<layer id="GotoDown">');
        document.write('<a href="javascript:void(0)" onClick="gotoDown()"><img src="<%=request.getContextPath()%>/images/down.png" border="0" width="40" height="40" title="Go To Bottom" class="gradualshine" onMouseOver="slowhigh(this)" onMouseOut="slowlow(this)" /></a>');
        document.write('</layer>');
        document.write('</div>');

        document.write('<div id="GotoTop" style="position:absolute">');
        document.write('<layer id="GotoTop">');
        document.write('<a href="javascript:void(0)" onClick="gotoTop()"><img src="<%=request.getContextPath()%>/images/up.png" border="0" width="40" height="40" title="Go To Top" class="gradualshine" onMouseOver="slowhigh(this)" onMouseOut="slowlow(this)" /></a>');
        document.write('</layer>');
        document.write('</div>');


        }

    </script>

    <script language="javascript">floatItem("GotoDown", 40, 40, "right", 2, "top", 125);</script>
    <script language="javascript">floatItem("GotoTop", 40, 40, "right", 2, "bottom", 25);</script>
</html>
<%
        }

    }
%>
