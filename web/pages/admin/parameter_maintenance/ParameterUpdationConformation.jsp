
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.reportmap.ReportMapDAO"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../../error.jsp" %>
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

        if (!(session_userType.equals(DDM_Constants.user_type_ddm_manager) || session_userType.equals(DDM_Constants.user_type_ddm_supervisor) || session_userType.equals(DDM_Constants.user_type_ddm_administrator)))
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - Set System Parameter Values' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fp=Set_System_Parameter_Values");
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

    ReportMapDAO reportMapDAO = DAOFactory.getReportMapDAO();
    ParameterDAO parameterDAO = DAOFactory.getParameterDAO();
%>
<%
    String colSize = null;
    String changedParamIds = null;
    String msg = null;

    colSize = request.getParameter("hdncolSize");
    changedParamIds = (String) request.getParameter("hdnNewParamIds");

    String[] arrayParamIds = null;
    //Collection<Parameter> col_parameter = null;
    ParameterDAO dao_para = null;
    boolean result = true;

    arrayParamIds = changedParamIds.split(":");

    if (arrayParamIds != null)
    {
        //col_parameter = new ArrayList();

        for (int i = 0; i < arrayParamIds.length; i++)
        {
            String id = arrayParamIds[i];
            String paramid = request.getParameter("hdnParamId_" + id);
            String paramDesc = request.getParameter("hdnParamDesc_" + id);
            String paramType = request.getParameter("hdnParamType_" + id);
            String currentValue = request.getParameter("hdnCurrentParamValue_" + id);
            String paramValue = null;

            if (paramType.equals(DDM_Constants.param_type_pwd))
            {
                paramValue = request.getParameter("txtPwd_" + id);
            }
            else if (paramType.equals(DDM_Constants.param_type_day))
            {
                paramValue = request.getParameter("txtParamValue_" + id);
                paramValue = paramValue.replaceAll("-", "");
            }
            else if (paramType.equals(DDM_Constants.param_type_time))
            {
                paramValue = request.getParameter("cmbHH_" + id) + request.getParameter("cmbMM_" + id);
                //SessionTimeOverlapValidation.validateSessionTime(paramValue);
            }
            else if (paramType.equals(DDM_Constants.param_type_other))
            {
                paramValue = request.getParameter("txtParamValue_" + id);
                String sessionParm;
                sessionParm = request.getParameter("noofsessions");
                String parmName = "txtParamValue_" + id;
            }

            if (((paramValue != null && paramValue.length() > 0) && currentValue != null) && !currentValue.equalsIgnoreCase(paramValue))
            {
                if (dao_para == null)
                {
                    dao_para = DAOFactory.getParameterDAO();
                }

                Parameter p = new Parameter();
                p.setName(paramid);
                p.setDescription(paramDesc);
                p.setType(paramType);
                p.setValue(paramValue);
                p.setCurrentValue(currentValue);
                p.setModifiedBy(session_userName);

                if (dao_para.update(p))
                {
                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_parameter_maintenance_set_param_value, "| Parameter ID - " + paramid + ", Parameter Value - (New : " + paramValue + ", Old : " + currentValue + ")| Process Status - Success | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }
                else
                {
                    result = false;
                    DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_admin_parameter_maintenance_set_param_value, "| Parameter ID - " + paramid + ", Parameter Value - (New : " + paramValue + ", Old : " + currentValue + ")| Process Status - Unsuccess (" + p.getUpdateStatusMsg() + ") | Modified By - " + session_userName + " (" + session_userTypeDesc + ") |"));
                }

            }
            //col_parameter.add(p);
        }
    }

%>
<%    ParameterDAO paraDAO = DAOFactory.getParameterDAO();
    Map<String, Parameter> para = paraDAO.getAllSessionParams();
%>


<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Set Parameter Values (Confirmation)</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>



        <script language="javascript" type="text/JavaScript">

            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2        )
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
                                                                                        <td align="left" valign="top" class="ddm_header_text">Set Parameter Values</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                <%
                                                                                                    if (dao_para != null)
                                                                                                    {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center"><table border="0" cellspacing="1" cellpadding="3" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                            <tr>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">&nbsp;</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Parameter</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Current Value</td>
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">New Value</td>
                                                                                                                <!--   <td align="center" bgcolor="#FDCB99" class="ddm_tbl_header_text">New Status </td> -->
                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal">Update Status</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                int rowNum = 0;

                                                                                                                HashMap<String, Parameter> htSuccess = dao_para.getSuccessQuery2();

                                                                                                                for (Map.Entry<String, Parameter> entry : htSuccess.entrySet())
                                                                                                                {
                                                                                                                    String paramid = entry.getKey();
                                                                                                                    Parameter param = entry.getValue();

                                                                                                                    String curVal = null;
                                                                                                                    String newVal = null;

                                                                                                                    if (param.getType() != null && param.getType().equals(DDM_Constants.param_type_day))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                    }
                                                                                                                    else if (param.getType() != null && param.getType().equals(DDM_Constants.param_type_pwd))
                                                                                                                    {
                                                                                                                        if (param.getCurrentValue() != null)
                                                                                                                        {
                                                                                                                            int i = 0;
                                                                                                                            curVal = "";

                                                                                                                            while (i < param.getCurrentValue().length())
                                                                                                                            {
                                                                                                                                curVal = curVal + "*";
                                                                                                                                i++;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            curVal = "-";
                                                                                                                        }

                                                                                                                        if (param.getValue() != null)
                                                                                                                        {
                                                                                                                            int i = 0;
                                                                                                                            newVal = "";

                                                                                                                            while (i < param.getValue().length())
                                                                                                                            {
                                                                                                                                newVal = newVal + "*";
                                                                                                                                i++;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            newVal = "-";
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        curVal = param.getCurrentValue();
                                                                                                                        newVal = param.getValue();

                                                                                                                        if (param.getName().equals(DDM_Constants.param_id_no_of_sessions))
                                                                                                                        {
                                                                                                                            int preSessCount = Integer.parseInt(param.getCurrentValue());
                                                                                                                            String currSess = param.getValue();

                                                                                                                            if (currSess != null)
                                                                                                                            {
                                                                                                                                int currSessCount = Integer.parseInt(currSess);

                                                                                                                                if (currSessCount != preSessCount)
                                                                                                                                {
                                                                                                                                    if (preSessCount > currSessCount)
                                                                                                                                    {
                                                                                                                                        int updateSessCount = preSessCount - currSessCount;

                                                                                                                                        String[] updateSess = new String[updateSessCount];

                                                                                                                                        for (int j = 0; j < updateSessCount; j++)
                                                                                                                                        {
                                                                                                                                            updateSess[j] = String.valueOf((preSessCount) - j);

                                                                                                                                        }

                                                                                                                                        System.out.println("delete()");
                                                                                                                                        
                                                                                                                                        reportMapDAO.deactivateReportMaps(updateSess, session_userName);
                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        int insertSessCount = currSessCount - preSessCount;

                                                                                                                                        String[] insertSess = new String[insertSessCount];

                                                                                                                                        for (int j = 0; j < insertSessCount; j++)
                                                                                                                                        {
                                                                                                                                            insertSess[j] = String.valueOf((preSessCount + 1) + j);

                                                                                                                                        }

                                                                                                                                        System.out.println("insert()");
                                                                                                                                        
                                                                                                                                        reportMapDAO.insertReportMaps(insertSess, session_userName);                                                                                                                                        
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }

                                                                                                                        }
                                                                                                                    }

                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="left" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                <td class="ddm_common_text"><%=param.getDescription()%></td>
                                                                                                                <td class="ddm_common_text"><%=curVal%></td>
                                                                                                                <td class="ddm_common_text"><%=newVal%></td>
                                                                                                                <td class="ddm_Display_Success_msg">Success <span class="ddm_error">(Manager Level Authorization Is Mandatory!)</span></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }

                                                                                                                HashMap<String, Parameter> htError = dao_para.getFailQuery2();

                                                                                                                for (Map.Entry<String, Parameter> entry : htError.entrySet())
                                                                                                                {
                                                                                                                    String paramid = entry.getKey();
                                                                                                                    Parameter param = entry.getValue();

                                                                                                                    String curVal = null;
                                                                                                                    String newVal = null;

                                                                                                                    if (param.getType() != null && param.getType().equals(DDM_Constants.param_type_day))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                    }
                                                                                                                    else if (param.getType() != null && param.getType().equals(DDM_Constants.param_type_time))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), DDM_Constants.simple_date_format_hhmm), DDM_Constants.simple_date_format_hh_mm);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), DDM_Constants.simple_date_format_hhmm), DDM_Constants.simple_date_format_hh_mm);
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        curVal = param.getCurrentValue();
                                                                                                                        newVal = param.getValue();
                                                                                                                    }

                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="left" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                <td class="ddm_common_text"><%=param.getDescription()%></td>
                                                                                                                <td class="ddm_common_text"><%=curVal%></td>
                                                                                                                <td class="ddm_common_text"><%=newVal%></td>
                                                                                                                <td class="ddm_Display_Error_msg">Fail - <span class="ddm_error"><%=param.getUpdateStatusMsg()%></span></td>
                                                                                                            </tr>
                                                                                                            <%}


                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <%                      }
                                                                                                else
                                                                                                {%>
                                                                                                <tr>
                                                                                                    <td align="center" class="ddm_header_small_text"> Sorry! There is no change to the parameters to update. </td>
                                                                                                </tr>
                                                                                                <%                                                                                }
                                                                                                %>
                                                                                            </table>
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td height="25" colspan="2" align="left" class="ddm_header_small_text"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td colspan="2" align="left" class="ddm_header_small_text"><form action="SetParameter.jsp" name="frmBack" id="frmBack"  method="post" target="_self" >

                                                                                                            <input type="submit" name="btnView" id="btnView" value="  Back  " class="ddm_custom_button" >
                                                                                                        </form></td>
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


    </body>
</html>
<%
        }
    }
%>
