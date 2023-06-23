
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"  %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequest" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.ddmrequeststatus.DDMRequestStatus" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.merchant.Merchant" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
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

        if (session_userType.equals(DDM_Constants.user_type_ddm_administrator) || session_userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
        {
            if (DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Unauthorized access to page - 'LankaPay Direct Debit Mandate Exchange System - DDM Request Inquiry' | Accessed By - " + session_userName + " (" + session_userTypeDesc + ") |")))
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
            }
            else
            {
                response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp?fpDDM_Requests_Inquiry");
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
    String isSearchReq = null;
    String acquiringBankCode = null;
    String issuingBankCode = null;
    String issuingBranchCode = null;
    String acquiringBranchCode = null;
    String selMerchant = null;
    String selRequestStatus = null;
    String fromRequestDate = null;
    String toRequestDate = null;
    boolean initialRequest = false;
    int noOfItems = 0;

    Collection<Bank> colIssuingBank = null;
    Collection<Bank> colAcquiringBank = null;
    Collection<Branch> colIssuingBranch = null;
    Collection<Branch> colAcquiringBranch = null;
    Collection<Merchant> colMerchant = null;
    Collection<DDMRequestStatus> colStatus = null;

    Collection<DDMRequest> colDDMRequestDetails = null;

    isSearchReq = (String) request.getParameter("hdnIsSearch");

    colIssuingBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colAcquiringBank = DAOFactory.getBankDAO().getBankNotInStatus(DDM_Constants.status_pending);
    colMerchant = DAOFactory.getMerchantDAO().getMerchantNotInStatusBasicDetails(DDM_Constants.status_pending, DDM_Constants.status_all, DDM_Constants.status_all);
    colStatus = DAOFactory.getDDMRequestStatusDAO().getDDMRequestStatusAll();

    if (isSearchReq == null)
    {
        initialRequest = true;
        isSearchReq = "0";
        issuingBankCode = DDM_Constants.status_all;
        issuingBranchCode = DDM_Constants.status_all;
        acquiringBankCode = DDM_Constants.status_all;
        acquiringBranchCode = DDM_Constants.status_all;
        selMerchant = DDM_Constants.status_all;
        selRequestStatus = DDM_Constants.status_all;
        fromRequestDate = webBusinessDate;
        toRequestDate = currentDate;
    }
    else
    {       
        issuingBankCode = (String) request.getParameter("cmbIssuingBank");

        if (issuingBankCode == null)
        {
            issuingBankCode = DDM_Constants.status_all;
        }

        if (!issuingBankCode.equals(DDM_Constants.status_all))
        {
            colIssuingBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(issuingBankCode, DDM_Constants.status_pending);
        }

        acquiringBankCode = (String) request.getParameter("cmbAcquiringBank");

        if (acquiringBankCode == null)
        {
            acquiringBankCode = DDM_Constants.status_all;
        }

        if (!acquiringBankCode.equals(DDM_Constants.status_all))
        {
            colAcquiringBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(acquiringBankCode, DDM_Constants.status_pending);
        }

        issuingBranchCode = (String) request.getParameter("cmbIssuingBranch");
        acquiringBranchCode = (String) request.getParameter("cmbAcquiringBranch");
        selMerchant = (String) request.getParameter("cmbMerchant");
        selRequestStatus = (String) request.getParameter("cmbReqStatus");
        fromRequestDate = (String) request.getParameter("txtFromRequestDate");
        toRequestDate = (String) request.getParameter("txtToRequestDate");
        
        if (issuingBranchCode == null)
        {
            issuingBranchCode = DDM_Constants.status_all;
        }

        if (acquiringBranchCode == null)
        {
            acquiringBranchCode = DDM_Constants.status_all;
        }

        if (selMerchant == null)
        {
            selMerchant = DDM_Constants.status_all;
        }

        if (selRequestStatus == null)
        {
            selRequestStatus = DDM_Constants.status_all;
        }

        if (fromRequestDate == null)
        {
            fromRequestDate = DAOFactory.getBCMCalendarDAO().getPreviousBusinessDate(currentDate, 365);
        }
        if (toRequestDate == null)
        {
            toRequestDate = currentDate;
        }       
        

        if (isSearchReq.equals("0"))
        {
            initialRequest = true;
        }
        else if (isSearchReq.equals("1"))
        {
            initialRequest = false;

            colDDMRequestDetails = DAOFactory.getDDMRequestDAO().getDDARequestDetails(selMerchant, issuingBankCode, issuingBranchCode, acquiringBankCode, acquiringBranchCode, selRequestStatus, fromRequestDate, toRequestDate);

            String strReqStatDes = "All";

            if (!selRequestStatus.equals(DDM_Constants.status_all))
            {
                strReqStatDes = DAOFactory.getDDMRequestStatusDAO().getDDMRequestStatus(selRequestStatus).getDescription();

                if (strReqStatDes == null)
                {
                    strReqStatDes = "N/A";
                }
            }

            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_lankapay_user_ddm_request_inquiry_search, "| Search Criteria - (Issuing Bank : " + issuingBankCode + ", Issuing Branch : " + issuingBranchCode + ", Acquiring Bank : " + acquiringBankCode + ", Acquiring Branch : " + acquiringBranchCode + ", Merchant : " + selMerchant + ", Status : " + strReqStatDes + ", DDM Request Date : From - " + fromRequestDate + "  To - " + toRequestDate + ") | Result Count - " + (colDDMRequestDetails != null ? colDDMRequestDetails.size() : "0") + " | Searched By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }


%>
<html>
    <head>
        <title>LankaPay Direct Debit Mandate Exchange System - DDM Request Inquiry</title>
        <link rel="shortcut icon" type="image/png" href="<%=request.getContextPath()%>/images/favicon.png">
        <link href="<%=request.getContextPath()%>/css/animbg4.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/autocomplete.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/itemfloat.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>
        <script language="JavaScript" type="text/javascript">

            function submitForApproval()
            {

                var itemCount = document.getElementById('hdnNoOfItems').value;
                var batchIdCollection = "";
                //var batchIdCollection_over10ChbFrom1Cat = "";
                var batchIdCollectionRejected = "";

                var hdnRemarks = "";
                var hdnRemarksRejected = "";

                var noOfselectedItems = 0;

                for (var i = 1; i <= itemCount; i++)
                {
                    var chbElement = 'ddaID_' + i;
                    var chbElement_R = 'ddaID_R_' + i;

                    var txtaRemarks = 'txtaApprovalRemarks_' + i;

                    var val_txtaRemarks = document.getElementById(txtaRemarks).value;

                    val_txtaRemarks = val_txtaRemarks.replace("~", "-");
                    val_txtaRemarks = val_txtaRemarks.replace("|", "/");

                    if (document.getElementById(chbElement).checked)
                    {
                        noOfselectedItems++;
                        batchIdCollection = batchIdCollection + document.getElementById(chbElement).value + "|";
                        hdnRemarks = hdnRemarks + document.getElementById(chbElement).value + "|" + val_txtaRemarks + "~";
                    }

                    if (document.getElementById(chbElement_R).checked)
                    {
                        if (isempty(document.getElementById(txtaRemarks).value))
                        {
                            alert("Please fill the remarks describing the reason to reject the DDM Request! [Row No. " + i + "]");
                            return false;
                        }

                        noOfselectedItems++;
                        batchIdCollectionRejected = batchIdCollectionRejected + document.getElementById(chbElement_R).value + "|";
                        hdnRemarksRejected = hdnRemarksRejected + document.getElementById(chbElement_R).value + "|" + val_txtaRemarks + "~";
                    }
                }

                if (noOfselectedItems > 0)
                {
                    var decision = confirm("Do You Really Want To Proceed With This DDM Request(s) Approval!");

                    if (!decision)
                    {
                        return false;
                    } else
                    {
                        document.getElementById('hdnApprovedCBRIDs').value = batchIdCollection;
                        document.getElementById('hdnRejectedCBRIDs').value = batchIdCollectionRejected;

                        document.getElementById('hdnRemarks').value = hdnRemarks;
                        document.getElementById('hdnRemarksRejected').value = hdnRemarksRejected;

                        //alert("hdnApprovedCBRIDs ---> "  + document.getElementById('hdnApprovedCBRIDs').value);
                        //alert("hdnRejectedCBRIDs ---> "  + document.getElementById('hdnRejectedCBRIDs').value);
                        //alert("hdnApprovedCBRIDs_Over10Chb ---> "  + document.getElementById('hdnApprovedCBRIDs_Over10Chb').value);

                        document.frmApproveDDMR.submit();
                    }


                } else
                {
                    alert('Please select at least one Request to Approve!');
                }

            }

            function clearResultData()
            {
                if (document.getElementById('resultdata') != null)
                {
                    document.getElementById('resultdata').style.display = 'none';
                }

                if (document.getElementById('noresultbanner') != null)
                {
                    document.getElementById('noresultbanner').style.display = 'none';
                }

                if (document.getElementById('clickSearch1') != null)
                {
                    document.getElementById('clickSearch1').style.display = 'block';
                }

                if (document.getElementById('clickSearch2') != null)
                {
                    document.getElementById('clickSearch2').style.display = 'block';
                }

                //showTotalItems(0);
            }

            function select_deselect_all(val)
            {
                var itemCount = document.getElementById('hdnNoOfItems').value;

                if (val == 0)
                {
                    if (document.getElementById('ddaID_All').checked)
                    {
                        document.getElementById('ddaID_All_R').checked = false;

                        for (var i = 1; i <= itemCount; i++)
                        {
                            var chbElement = 'ddaID_' + i;
                            var chbElement_R = 'ddaID_R_' + i;
                            document.getElementById(chbElement).checked = true;
                            document.getElementById(chbElement_R).checked = false;
                        }
                    } else
                    {
                        for (var i = 1; i <= itemCount; i++)
                        {
                            var chbElement = 'ddaID_' + i;
                            document.getElementById(chbElement).checked = false;
                        }
                    }
                } else if (val == 1)
                {
                    if (document.getElementById('ddaID_All_R').checked)
                    {
                        document.getElementById('ddaID_All').checked = false;

                        for (var i = 1; i <= itemCount; i++)
                        {
                            var chbElement = 'ddaID_' + i;
                            var chbElement_R = 'ddaID_R_' + i;
                            document.getElementById(chbElement).checked = false;
                            document.getElementById(chbElement_R).checked = true;
                        }
                    } else
                    {
                        for (var i = 1; i <= itemCount; i++)
                        {
                            var chbElement_R = 'ddaID_R_' + i;
                            document.getElementById(chbElement_R).checked = false;
                        }
                    }
                }


            }

            function setValidCheckBoxType(val1, val2)
            {
                var chbElement = 'ddaID_' + val2;
                var chbElement_R = 'ddaID_R_' + val2;

                if (val1 == 0)
                {
                    if (document.getElementById(chbElement).checked)
                    {
                        document.getElementById(chbElement_R).checked = false;
                        document.getElementById('ddaID_All_R').checked = false;
                    } else
                    {
                        document.getElementById('ddaID_All').checked = false;
                    }
                } else if (val1 == 1)
                {
                    if (document.getElementById(chbElement_R).checked)
                    {
                        document.getElementById(chbElement).checked = false;
                        document.getElementById('ddaID_All').checked = false;
                    } else
                    {
                        document.getElementById('ddaID_All_R').checked = false;
                    }
                }
            }


            function isSearchRequest(status)
            {
                if (status)
                {
                    document.getElementById('hdnIsSearch').value = "1";
                } else
                {
                    document.getElementById('hdnIsSearch').value = "0";
                }

            }

            function resetDates()
            {
                var jFromDate = "<%=webBusinessDate%>";
                var jToDate = "<%=webBusinessDate%>";

                var from_elementId = 'txtFromRequestDate';
                var to_elementId = 'txtToRequestDate';

                document.getElementById(from_elementId).value = jFromDate;
                document.getElementById(to_elementId).value = jToDate;
            }



            function doSubmit()
            {
                document.frmInquiryDDMR_AsLankaPay.action = "inqddm.jsp";
                document.frmInquiryDDMR_AsLankaPay.submit();
            }


            function validate()
            {

                if (document.getElementById('hdnTabId').value == "1")
                {
                    if (isempty(document.getElementById('txtBatchNo').value))
                    {
                        alert('Please enter a valid Batch No.');
                        return false;
                    } else
                    {
                        return true;
                    }
                }

            }

            function isempty(Value)
            {
                if (Value.length < 1)
                {
                    return true;
                } else
                {
                    var str = Value;

                    while (str.indexOf(" ") != -1)
                    {
                        str = str.replace(" ", "");
                    }

                    if (str.length < 1)
                    {
                        return true;
                    } else
                    {
                        return false;
                    }
                }
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



        </script>

    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="showClock(3)">

        <div class="bg"></div>
        <div class="bg bg2"></div>
        <div class="bg bg3"></div>

        <table width="100%" height="100%" style="min-width:900;min-height:600" align="center" border="0" cellpadding="0" cellspacing="0" >
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

                                                                                        <%
                                                                                            String userTypeDescription = "Issuing Bank";

                                                                                        %>
                                                                                        <td align="left" valign="top" class="ddm_header_text">DDM Request Inquiry</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><form name="frmInquiryDDMR_AsLankaPay" id="frmInquiryDDMR_AsLankaPay" method="post" >
                                                                                                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="4">
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Issuing  Bank :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                                  try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbIssuingBank" id="cmbIssuingBank" class="ddm_field_border"  onChange="isSearchRequest(false);doSubmit();"  >
                                                                                                                                        <%                                                                                                                                            if (issuingBankCode == null || issuingBankCode.equals(DDM_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colIssuingBank != null && colIssuingBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bank : colIssuingBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(issuingBankCode != null && bank.getBankCode().equals(issuingBankCode)) ? "selected" : ""%> ><%=bank.getBankCode()%> - <%=bank.getBankFullName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No bank details available.</span>

                                                                                                                                    <% }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Acquiring Bank :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text" ><%                                                                                                                        try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbAcquiringBank" class="ddm_field_border" id="cmbAcquiringBank" onChange="isSearchRequest(false);doSubmit();"  >
                                                                                                                                        <%                                                                                                                                if (acquiringBankCode == null || acquiringBankCode.equals(DDM_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=DDM_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colAcquiringBank != null && colAcquiringBank.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Bank bank : colAcquiringBank)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(acquiringBankCode != null && bank.getBankCode().equals(acquiringBankCode)) ? "selected" : ""%> ><%=bank.getBankCode()%> - <%=bank.getBankFullName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No bank details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>

                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Merchant :</td>
                                                                                                                                <td align="left" valign="top" class="ddm_tbl_common_text"><%                                                                                                                        try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbMerchant" id="cmbMerchant" class="ddm_field_border"  onChange="clearResultData()" >
                                                                                                                                        <%                                                                                                                                if (selMerchant == null || selMerchant.equals(DDM_Constants.status_all))
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
                                                                                                                                            if (colMerchant != null && colMerchant.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Merchant merchant : colMerchant)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=merchant.getMerchantID()%>" <%=(selMerchant != null && merchant.getMerchantID().equals(selMerchant)) ? "selected" : ""%> ><%=merchant.getMerchantID()%> - <%=merchant.getMerchantName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No merchant details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Issuing  Branch :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                      try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbIssuingBranch" class="ddm_field_border" id="cmbIssuingBranch" onChange="clearResultData()" >
                                                                                                                                        <%                                                                                                                                if (issuingBranchCode == null || issuingBranchCode.equals(DDM_Constants.status_all))
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
                                                                                                                                            if (colIssuingBranch != null && colIssuingBranch.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Branch serviceBranch : colIssuingBranch)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=serviceBranch.getBranchCode()%>" <%=(issuingBranchCode != null && serviceBranch.getBranchCode().equals(issuingBranchCode)) ? "selected" : ""%> ><%=serviceBranch.getBranchCode()%> - <%=serviceBranch.getBranchName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                      }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No branch details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Acquiring Branch :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                        try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbAcquiringBranch" class="ddm_field_border" id="cmbAcquiringBranch" onChange="clearResultData()" >
                                                                                                                                        <%                                                                                                                                if (acquiringBranchCode == null || acquiringBranchCode.equals(DDM_Constants.status_all))
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
                                                                                                                                            if (colAcquiringBranch != null && colAcquiringBranch.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Branch branch : colAcquiringBranch)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(acquiringBranchCode != null && branch.getBranchCode().equals(acquiringBranchCode)) ? "selected" : ""%> ><%=branch.getBranchCode()%> - <%=branch.getBranchName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No branch details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %>                                                                                                                            </td>

                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Status :</td>
                                                                                                                                <td align="left" valign="middle" class="ddm_tbl_common_text"><%                                                                                                                        try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbReqStatus" id="cmbReqStatus" class="ddm_field_border"  onChange="clearResultData()" >
                                                                                                                                        <%                                                                                                                                if (selRequestStatus == null || selRequestStatus.equals(DDM_Constants.status_all))
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
                                                                                                                                            if (colStatus != null && colStatus.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (DDMRequestStatus reqStat : colStatus)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=reqStat.getStatusId()%>" <%=(selRequestStatus != null && reqStat.getStatusId().equals(selRequestStatus)) ? "selected" : ""%> ><%=reqStat.getDescription()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="ddm_error">No status details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_header_text">Request Date :                                                                                                                        </td>
                                                                                                                                <td align="right" valign="middle" class="ddm_tbl_common_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromRequestDate" id="txtFromRequestDate" type="text" onFocus="this.blur()" class="tcal" size="8" value="<%=(fromRequestDate == null || fromRequestDate.equals("0") || fromRequestDate.equals(DDM_Constants.status_all)) ? "" : fromRequestDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToRequestDate" id="txtToRequestDate" type="text" onFocus="this.blur()" class="tcal" size="8" value="<%=(toRequestDate == null || toRequestDate.equals("0") || toRequestDate.equals(DDM_Constants.status_all)) ? "" : toRequestDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="&nbsp;&nbsp; Reset Dates &nbsp;&nbsp;" type="button" onClick="resetDates()" class="ddm_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                                <td colspan="4" align="right" valign="middle" class="ddm_tbl_footer_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <div id="clickSearch1" class="ddm_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="&nbsp;&nbsp; Search &nbsp;&nbsp;" type="button" onClick="isSearchRequest(true);doSubmit();"  class="ddm_custom_button"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table>

                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="25" align="center" valign="top">
                                                                                                            <input type="hidden" name="hdnIsSearch" id="hdnIsSearch" value="<%=isSearchReq%>" /></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top">
                                                                                                            <div id="resultdata">
                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                    <%
                                                                                                                        if (colDDMRequestDetails != null && colDDMRequestDetails.size() > 0)
                                                                                                                        {
                                                                                                                            noOfItems = colDDMRequestDetails.size();


                                                                                                                    %>
                                                                                                                    <tr>
                                                                                                                        <td align="center">




                                                                                                                            <table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" class="ddm_table_boder">
                                                                                                                                <tr><td>





                                                                                                                                        <table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                                            <tr>
                                                                                                                                                <td class="ddm_tbl_header_text_horizontal_small"></td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Req.<br/>
                                                                                                                                                    Time</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Merchant</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Bank</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Branch</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Account No.</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Issuing<br/>
                                                                                                                                                    Account Name</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                                    Bank</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                                    Branch</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                                    Account No.</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Acquiring<br/>
                                                                                                                                                    Account Name</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Max<br/>
                                                                                                                                                    Limit</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Start<br/>
                                                                                                                                                    Date</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">End<br/>
                                                                                                                                                    Date</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Frequency</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Purpose</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Reference</td>
                                                                                                                                                <td align="center" class="ddm_tbl_header_text_horizontal_small">Status</td>
                                                                                                                                            </tr>
                                                                                                                                            <%                                                                                                                                    int rowNum = 0;

                                                                                                                                                double maxLimit = 0;
                                                                                                                                                double grandTotalMaxLimit = 0;

                                                                                                                                                for (DDMRequest ddmr : colDDMRequestDetails)
                                                                                                                                                {
                                                                                                                                                    rowNum++;

                                                                                                                                                    String strMaxLimit = ddmr.getMaxLimit();

                                                                                                                                                    try
                                                                                                                                                    {
                                                                                                                                                        maxLimit = Double.parseDouble(strMaxLimit);
                                                                                                                                                    }
                                                                                                                                                    catch (Exception ex)
                                                                                                                                                    {
                                                                                                                                                        maxLimit = 0;
                                                                                                                                                    }

                                                                                                                                                    grandTotalMaxLimit = grandTotalMaxLimit + maxLimit;

                                                                                                                                            %>
                                                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E8E8EA" : "#F9F9F9"%>"   onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                                <td align="right" class="ddm_common_text"><%=rowNum%>.</td>
                                                                                                                                                <td align="center" nowrap class="ddm_common_text"><%=ddmr.getCreatedDate()%></td>
                                                                                                                                                <td nowrap class="ddm_common_text"><%=ddmr.getMerchantID()%> - <%=ddmr.getMerchantName()%></td>

                                                                                                                                                <td nowrap class="ddm_common_text" title="<%=ddmr.getIssuningBankCode()%> - <%=ddmr.getIssuningBankName()%>"><%=ddmr.getIssuningBankCode()%> - <%=ddmr.getIssuningBankShortName()%></td>
                                                                                                                                                <td nowrap class="ddm_common_text" title="<%=ddmr.getIssuningBranch()%> - <%=ddmr.getIssuningBranchName()%>"><%=ddmr.getIssuningBranch()%> - <%=ddmr.getIssuningBranchName().length() > 10 ? (ddmr.getIssuningBranchName().substring(0, 8) + "..") : ddmr.getIssuningBranchName()%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getIssuningAccountNumber()%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getIssuningAccountName()%></td>                                                                                                                                 
                                                                                                                                                <td nowrap class="ddm_common_text" title="<%=ddmr.getAcquiringBankCode()%> - <%=ddmr.getAcquiringBankName()%>"><%=ddmr.getAcquiringBankCode()%> - <%=ddmr.getAcquiringBankShortName()%></td>
                                                                                                                                                <td nowrap class="ddm_common_text" title="<%=ddmr.getAcquiringBranch()%> - <%=ddmr.getAcquiringBranchName()%>"><%=ddmr.getAcquiringBranch()%> - <%=ddmr.getAcquiringBranchName().length() > 10 ? (ddmr.getAcquiringBranchName().substring(0, 8) + "..") : ddmr.getAcquiringBranchName()%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getAcquiringAccountNumber()%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getAcquiringAccountName()%></td>
                                                                                                                                                <td class="ddm_common_text" align="right" ><%=strMaxLimit%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getStartDate()%></td>
                                                                                                                                                <td class="ddm_common_text"><%=ddmr.getEndDate()%></td>
                                                                                                                                                <%
                                                                                                                                                    String strFrequency = "";

                                                                                                                                                    if (ddmr.getFrequency() != null)
                                                                                                                                                    {
                                                                                                                                                        if (ddmr.getFrequency().equals(DDM_Constants.ddm_request_frequency_daily))
                                                                                                                                                        {
                                                                                                                                                            strFrequency = "Daily";
                                                                                                                                                        }
                                                                                                                                                        else if (ddmr.getFrequency().equals(DDM_Constants.ddm_request_frequency_weekly))
                                                                                                                                                        {
                                                                                                                                                            strFrequency = "Weekly";
                                                                                                                                                        }
                                                                                                                                                        else if (ddmr.getFrequency().equals(DDM_Constants.ddm_request_frequency_monthly))
                                                                                                                                                        {
                                                                                                                                                            strFrequency = "Monthly";
                                                                                                                                                        }
                                                                                                                                                        else if (ddmr.getFrequency().equals(DDM_Constants.ddm_request_frequency_yearly))
                                                                                                                                                        {
                                                                                                                                                            strFrequency = "Yearly";
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            strFrequency = "n/a";
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        strFrequency = "n/a";
                                                                                                                                                    }
                                                                                                                                                %>

                                                                                                                                                <td class="ddm_common_text" align="center" ><%=strFrequency%></td>
                                                                                                                                                <td nowrap class="ddm_common_text"><%=(ddmr.getPurpose() != null) ? ddmr.getPurpose() : ""%></td>
                                                                                                                                                <td class="ddm_common_text"><%=(ddmr.getReference() != null) ? ddmr.getReference() : ""%></td>

                                                                                                                                                <td class="ddm_common_text"><%=(ddmr.getStatusDesc() != null) ? ddmr.getStatusDesc() : ""%></td>
                                                                                                                                            </tr>
                                                                                                                                            <%

                                                                                                                                                }
                                                                                                                                            %>
                                                                                                                                            <tr>
                                                                                                                                                <td class="ddm_tbl_footer_text"><input type="hidden" name="hdnNoOfItems" id="hdnNoOfItems" value="<%=noOfItems%>"/></td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text"></td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">Grand Total</td>
                                                                                                                                                <td align="right" class="ddm_tbl_footer_text"><%=new DecimalFormat("###,##0.00").format(grandTotalMaxLimit)%></td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="left" class="ddm_tbl_footer_text"> </td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                                <td align="center" class="ddm_tbl_footer_text">&nbsp;</td>
                                                                                                                                            </tr>
                                                                                                                                        </table>



                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>                                                                                          </td>
                                                                                                                    </tr>

                                                                                                                    <tr>
                                                                                                                        <td height="15">&nbsp;</td>
                                                                                                                    </tr>




                                                                                                                    <%

                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        if (!initialRequest)
                                                                                                                        {
                                                                                                                    %>
                                                                                                                    <tr>
                                                                                                                        <td align="center" class="ddm_common_text_bold_large"> No records available! </td>
                                                                                                                    </tr>
                                                                                                                    <%            }
                                                                                                                        }
                                                                                                                    %>
                                                                                                                </table>
                                                                                                            </div>


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