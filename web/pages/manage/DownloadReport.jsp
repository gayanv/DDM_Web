
<%@page import="java.util.*,java.sql.*,java.io.File" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="java.util.Collection,java.util.Date" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.Parameter" errorPage="../../error.jsp"%>
<%@page import="java.io.FileInputStream" errorPage="../../error.jsp"%>
<%@page import="java.io.BufferedInputStream"  errorPage="../../error.jsp"%>
<%@page import="java.io.File"  errorPage="../../error.jsp"%>
<%@page import="java.io.IOException" errorPage="../../error.jsp"%>
<%@page import="java.io.*" errorPage="../../error.jsp"%>
<%@page import="java.util.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter"  errorPage="../../error.jsp"%>
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
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");


%>

<%
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>

<%
    String reportName = (String) request.getParameter("hdnFileId");
    String reportPath = (String) request.getParameter("hdnFilePath");

    File reportFile = null;
    BufferedInputStream bufIn = null;
    ServletOutputStream servOut = null;
    int reportSize = -1;

    reportFile = new File(reportPath);

    if (reportFile.exists())
    {
        reportSize = (int) reportFile.length();

        try
        {
            servOut = response.getOutputStream();

            //set response headers
            response.setContentType("text/plain");

            if (reportFile.getName().endsWith(DDM_Constants.report_type_owd_bk1_report_name_suffix_full))
            {
                response.addHeader("Content-Disposition", "attachment; filename=" + reportFile.getName().replaceAll(DDM_Constants.report_type_owd_bk1_report_name_suffix_full, DDM_Constants.report_type_owd_bk1_report_name_original_suffix));
            }
            else
            {
                response.addHeader("Content-Disposition", "attachment; filename=" + reportFile.getName());
            }
            
            response.setContentLength(reportSize);

            FileInputStream input = new FileInputStream(reportFile);
            bufIn = new BufferedInputStream(input);
            int readBytes = 0;

            //read from the file; write to the ServletOutputStream
            while ((readBytes = bufIn.read()) != -1)
            {
                servOut.write(readBytes);
            }

            if (DAOFactory.getReportDAO().updateDownloadDetails(reportName, session_userName))
            {

                System.out.println("Report file - " + reportName + "  username - " + session_userName + ",  download status updatation is successful.");
            }
            else
            {
                System.out.println("Report file - " + reportName + "  username - " + session_userName + ",  download status updatation is unsuccessful.");
            }

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_reports_download_reports, "| File Id - " + reportFile.getName() + ", Download Status. - Successful , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));

        
        
        }
        catch (IOException e)
        {
            System.out.println(e.getMessage());
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_reports_download_reports, "| File Id - " + reportFile.getName() + ", Download Status. - Unsuccessful (" + e.getMessage() + ") , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            //throw new ServletException();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
        finally
        {
            if (servOut != null)
            {
                servOut.close();
            }
            if (bufIn != null)
            {
                bufIn.close();
            }
        }
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_reports_download_reports, "| File Id - " + reportFile.getName() + ", Download Status. - Unsuccessful (File Not Available) , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        response.sendRedirect(request.getContextPath() + "/error.jsp");
    }
%>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>LankaPay Direct Debit Mandate Exchange System - Download Validation Summary</title>
    </head>
    <body>
    </body>
</html>
<%
    }
%>
