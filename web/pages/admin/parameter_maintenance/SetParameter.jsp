<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../../error.jsp"  %>
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

        boolean isAccessOK = DAOFactory.getUserLevelFunctionMapDAO().isAccessOK(session_userType, DDM_Constants.directory_previous + request.getServletPath());

        if (!isAccessOK)
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

%>

<%
    ParameterDAO para_dao = DAOFactory.getParameterDAO();
    Collection<Parameter> col = para_dao.getAllParamterValues();
    List<Parameter> removeSess = new ArrayList();

    System.out.println(" col  ---> " + col.size());

    for (Parameter para : col)
    {
        if (para.getType().equals(DDM_Constants.param_type_time))
        {
            removeSess.add(para);
        }
    }

    System.out.println(" removeSess  ---> " + removeSess.size());

    if (removeSess != null && removeSess.size() > 0)
    {
        col.removeAll(removeSess);
    }

    Vector<String> vDateParams = null;
    String recordCounter_dayType = "";

    Vector<String> vDateParams_No = null;
    String recordCounter_dayType_No = "";

%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - Set Parameter Values</title>
<link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
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

            function validate()
            {
            var noOfItems = document.getElementById('hdncol_size').value;
            var completeNewParamValues = "";

            for(var i = 1; i <= noOfItems; i++)
            {
            var hdn_paramTypeName = 'hdnParamType_' + i;
            var hdn_paramTypeValue = document.getElementById(hdn_paramTypeName).value;

            if(hdn_paramTypeValue == '<%=DDM_Constants.param_type_pwd%>')
            {
            var paramValuePwd = document.getElementById('txtPwd_'+i).value;
            var paramValueRePwd = document.getElementById('txtRePwd_'+i).value;

            if(paramValuePwd != null && !isempty(paramValuePwd))
            {                           

            if(isempty(paramValueRePwd))
            {
            alert("Re-type Password Can not be empty!");
            return false;
            }
            else
            {
            if(paramValuePwd != paramValueRePwd)
            {
            alert("Password does not match with the Re-type Password!");

            document.getElementById('txtPwd_'+i).value="";
            document.getElementById('txtRePwd_'+i).value="";
            document.getElementById('txtPwd_'+i).focus();                                
            return false;
            }
            else
            {
            completeNewParamValues = completeNewParamValues + i + ":"
            }
            } 
            }
            }

            else if(hdn_paramTypeValue == '<%=DDM_Constants.param_type_day%>')
            {
            var paramValue = document.getElementById('txtParamValue_'+i).value;

            if(paramValue != null && !isempty(paramValue))
            {
            completeNewParamValues = completeNewParamValues + i + ":"
            }
            }

            else if(hdn_paramTypeValue == '<%=DDM_Constants.param_type_other%>')
            {
            var paramValue = document.getElementById('txtParamValue_'+i).value;
            var paramId = document.getElementById('hdnParamId_' + i).value;
//            var session = document.getElementById('hdnParamId_' + i).value;
//            var noOfess = null;
//            var sess = null;

            if(paramValue != null && !isempty(paramValue))
            {

            completeNewParamValues = completeNewParamValues + i + ":"
            }

            }
            else
            {
            alert('Invalid Parameter Type In row number -' + i +'.');
            return false;
            }
            }

            if(completeNewParamValues != null && !isempty(completeNewParamValues))
            {
            document.getElementById('hdnNewParamIds').value = completeNewParamValues;
            if(findChangedSessionPara()){
            document.frmSetParam.submit();
            }

            }
            else
            {
            alert('Sorry! There is no change to the parameters to update.');
            return false;
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



            function validateActiveSessions(noOfSessions)
            {
            if(noOfSessions != null && !noOfSessions.length <= 0 )
            {
            if(isNaN(noOfSessions))
            {
            alert("Number of Session should be a Number!");
            return false;
            }
            else
            {
            if(noOfSessions > 9)
            {
            alert("Number of Session should be less than or equal to 9!");
            return false;
            }
            if(noOfSessions < 2)
            {
            alert("Number of Session should be greater than 2!");
            return false;
            }
            if(noOfSessions >= 2 && noOfSessions <= 9)
            {
            return true ;
            }
            }
            }
            }


            function findChangedSessionPara(){

            var changedPara = document.getElementById('hdnNewParamIds').value;
            var changedParaArrIds = changedPara.split(":");
//            var activeSess = null;
//            var sessionInfo = null;
//            var flagSess = null;
            var pw = null;
            var status = true;


            if (changedParaArrIds != null)
            {

            var i;

            for (i = 0; i < changedParaArrIds.length - 1; i++){

            var id = changedParaArrIds[i]; 
            var paramId = document.getElementById('hdnParamId_' + id).value;
            var paramType = document.getElementById('hdnParamType_' + id).value;

            if(paramId == 'defaultPwd'){
            pw = document.getElementById('txtParamValue_'+id).value;
            }

            }         
            } else{
            status = true;  
            }
            

            
            

            if(pw != null){
            if(pw.length < 8){
            alert("Password must have more than 8 character");
            status = false;
            }
            }


            return status;
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
                                                                                        <td height="15"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><form name="frmSetParam" id="frmSetParam" action="ParameterUpdationConformation.jsp" method="post">
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <%

                                                                                                        try
                                                                                                        {

                                                                                                            if (col != null && col.size() == 0)
                                                                                                            {

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td align="center" class="ddm_header_small_text">No Records Available !</td>
                                                                                                    </tr>
                                                                                                    <%                                                                                                                              }
                                                                                                    else if (col != null && col.size() > 0)
                                                                                                    {

                                                                                                        System.out.println(" inside   ---> col.size() > 0");

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="1" cellpadding="3" class="ddm_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <th height="30" class="ddm_tbl_header_text_horizontal"></th>
                                                                                                                    <th align="center" class="ddm_tbl_header_text_horizontal">Parameter</th>
                                                                                                                    <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal">Current Value</th>
                                                                                                                    <th align="center" valign="middle" class="ddm_tbl_header_text_horizontal">New Value</th>
                                                                                                                </tr>
                                                                                                                <%                                                                                                                    int rowNum = 0;
                                                                                                                    int col_size = 0;

                                                                                                                    for (Parameter p : col)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                        System.out.println(" rowNum   --->" + rowNum);

                                                                                                                %>
                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                    <td align="left" class="ddm_common_text"><%=p.getDescription()%>

                                                                                                                        <input type="hidden" id="hdnParamId_<%=rowNum%>" name="hdnParamId_<%=rowNum%>" value="<%=p.getName()%>" />
                                                                                                                        <input type="hidden" id="hdnParamDesc_<%=rowNum%>" name="hdnParamDesc_<%=rowNum%>" value="<%=p.getDescription()%>" />
                                                                                                                    </td> 

                                                                                                                    <td class="ddm_common_text"><%
                                                                                                                        String formattedValue = null;

                                                                                                                        if (p.getType() != null && p.getValue() != null)
                                                                                                                        {
                                                                                                                            if (p.getType().equals(DDM_Constants.param_type_day))
                                                                                                                            {
                                                                                                                                formattedValue = DateFormatter.doFormat(DateFormatter.getTime(p.getValue(), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                            }
                                                                                                                            else if (p.getType().equals(DDM_Constants.param_type_pwd))
                                                                                                                            {
                                                                                                                                if (p.getDecrytedValue() != null)
                                                                                                                                {
                                                                                                                                    formattedValue = "";

                                                                                                                                    for (int i = 0; i < p.getDecrytedValue().length(); i++)
                                                                                                                                    {
                                                                                                                                        formattedValue = formattedValue + "*";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    formattedValue = "Not Available.";
                                                                                                                                }

                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                formattedValue = p.getValue();
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            formattedValue = "Not Available.";
                                                                                                                        }
                                                                                                                        %>
                                                                                                                        <%=formattedValue%>
                                                                                                                        <input type="hidden" id="hdnCurrentParamValue_<%=rowNum%>" name="hdnCurrentParamValue_<%=rowNum%>" value="<%=p.getValue()%>" /></td>
                                                                                                                    <td>


                                                                                                                        <%

                                                                                                                            if ((p.getType() != null) && (p.getType().equals(DDM_Constants.param_type_pwd)))
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <table cellpadding="1" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" class="ddm_common_text">Password</td>
                                                                                                                                <td></td>
                                                                                                                                <td align="center" class="ddm_common_text">Re-type Password</td>
                                                                                                                                <td></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><input name="txtPwd_<%=rowNum%>" type="password" class="ddm_field_border" id="txtPwd_<%=rowNum%>" size="22" maxlength="18" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input name="txtRePwd_<%=rowNum%>" type="password" class="ddm_field_border" id="txtRePwd_<%=rowNum%>" size="22" maxlength="20" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                        <%

                                                                                                                            }

                                                                                                                        %>

                                                                                                                        <%                                                                                                                            if ((p.getType() != null) && (p.getType().equalsIgnoreCase(DDM_Constants.param_type_day)))
                                                                                                                            {

                                                                                                                                if (vDateParams == null)
                                                                                                                                {
                                                                                                                                    vDateParams = new Vector();
                                                                                                                                }
                                                                                                                                String txtParamValueId = "txtParamValue_" + rowNum;
                                                                                                                                recordCounter_dayType = recordCounter_dayType + rowNum + "_";
                                                                                                                                vDateParams.add(txtParamValueId);
                                                                                                                        %>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">

                                                                                                                            <tr>

                                                                                                                                <td><input type="text" name="txtParamValue_<%=rowNum%>" id="txtParamValue_<%=rowNum%>" onFocus="this.blur()" class="tcal" size="9"/>                                                                                                                                </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}
                                                                                                                            if ((p.getType() != null) && (p.getType().equalsIgnoreCase(DDM_Constants.param_type_other)))
                                                                                                                            {
                                                                                                                                if (vDateParams_No == null)
                                                                                                                                {
                                                                                                                                    vDateParams_No = new Vector();
                                                                                                                                }
                                                                                                                                String txtParamValueId = "txtParamValue_" + rowNum;
                                                                                                                                recordCounter_dayType_No = recordCounter_dayType_No + rowNum + "_";
                                                                                                                                vDateParams_No.add(txtParamValueId);


                                                                                                                        %>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    

                                                                                                                                    <input type="text" name="txtParamValue_<%=rowNum%>" id="txtParamValue_<%=rowNum%>" class="ddm_field_border" size="14"/>


                                                                                                                                    
                                                                                                                                </td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%                                                                                                                                                                                     }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td height="35" colspan="4" align="right" valign="bottom" class="ddm_tbl_footer_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" id="hdncol_size" name="hdncol_size" value="<%=col != null ? col.size() : "0"%>" />
                                                                                                                                    <input type="hidden" name="hdnNewParamIds" id="hdnNewParamIds" >
                                                                                                                                </td>
                                                                                                                                <td><input name="btnSubmit" id="btnSubmit" type="button" value="&nbsp;&nbsp; Update &nbsp;&nbsp;" class="ddm_custom_button" onClick="javascript:validate();"/>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            }
                                                                                                        }
                                                                                                        catch (Exception e)
                                                                                                        {
                                                                                                            System.out.print(e.toString());
                                                                                                        }

                                                                                                    %>
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
<%        }
    }
%>
