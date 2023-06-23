
<%@page import="lk.com.ttsl.pb.slips.services.utils.RandomOTPGenerator"%>
<%@page language="java" import="java.sql.*,java.util.*,java.io.*" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.User" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.services.jsmenu.JS_MenuCreator"%>
<%@page import="lk.com.ttsl.pb.slips.services.email.SendHTMLEmail" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="error.jsp"%>

<%
    String ip = null;

    String isAuhenticated = null;
    String userName = null;
    String password = null;
    String branchId = null;
    String branchName = null;
    String cocuId = null;
    String cocuName = null;
    String userType = null;
    String userTypeDesc = null;
    String menuId = null;
    String menuName = null;
    String bankName = null;
    String bankCode = null;

    try
    {
        DAOFactory.getUserDAO().updateExpriedUserStatus();
        DAOFactory.getUserDAO().deactivateLongTimeInactiveUsers();
        DAOFactory.getUserDAO().autoUnlockLockedUsers();
        SendHTMLEmail.getInstance();

        String jsPath = request.getSession().getServletContext().getRealPath(DDM_Constants.directory_separator_web) + DDM_Constants.directory_separator + "js" + DDM_Constants.directory_separator;
        //String jsPath = request.getServletContext().getRealPath(DDM_Constants.directory_separator_web) + DDM_Constants.directory_separator + "js" + DDM_Constants.directory_separator;
        System.out.println("jsPath Main ---> " + jsPath);

        JS_MenuCreator.CreateAllMenus(jsPath);

        ip = request.getHeader("x-forwarded-for");

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getRemoteAddr();
        }

        System.out.println("Remote IP Address - " + ip);
    }
    catch (Exception e)
    {
        System.out.println("Warning: Error occured while reading remote IP address! - " + e.getMessage());
    }

    isAuhenticated = (String) session.getAttribute("session_isAuthenticated");

    if (isAuhenticated == null || isAuhenticated.equals("null"))
    {
        userName = (String) request.getParameter("txtUserName");

        if (userName == null)
        {
            session.invalidate();
            //response.sendRedirect("pages/login.jsp?msg=u");
            response.sendRedirect("pages/login.jsp");
        }
        else if (userName.equals("null") || (userName != null && userName.trim().length() < 1))
        {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
        }
        else
        {
            password = (String) request.getParameter("txtPassword");

            if (password == null || password.equals("null") || (password != null && password.trim().length() < 1))
            {
                //session.invalidate();
                //session.setAttribute("session_isinitlogin", DDM_Constants.status_no);
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
            }
            else
            {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + "| Remote IP - " + ip + " | Status - New Login Attempt. |"));

                boolean isAuth = DAOFactory.getUserDAO().isAuthorized(new User(userName, password), "'" + DDM_Constants.status_active + "','" + DDM_Constants.status_expired + "'");

                System.out.println(" isAuth value - " + isAuth + " for the user - " + userName);

                if (isAuth)
                {
                    boolean bool = DAOFactory.getUserDAO().setUserLoggingAttempts(userName, DDM_Constants.status_success);

                    System.out.println(" setUserLoggingAttempts ---> " + bool);

                    if (DAOFactory.getUserDAO().isInitialLogin(userName, DDM_Constants.status_active))
                    {
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Success and Prompt Initial Password Change. |"));

                        User user = DAOFactory.getUserDAO().getUserDetails(userName, DDM_Constants.status_all);
                        userTypeDesc = user.getUserLevelDesc();

                        session.setAttribute("session_userName", userName);
                        session.setAttribute("session_userType", userType);
                        session.setAttribute("session_userTypeDesc", userTypeDesc);
                        session.setAttribute("session_isAuthenticated", DDM_Constants.is_authorized_yes);
                        session.setAttribute("session_isInitLogin", DDM_Constants.status_yes);

                        response.sendRedirect("pages/user/initPwdChange.jsp");
                    }
                    else
                    {
                        System.out.println("inside else of isInitialLogin  ---> ");

                        User user = DAOFactory.getUserDAO().getUserDetails(userName, DDM_Constants.status_all);

                        if (user.getStatus().equals(DDM_Constants.status_expired))
                        {
                            //DAOFactory.getUserDAO().setUserStatus(userName, DDM_Constants.status_expired, false);
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_account_expired, "| Username - " + userName + " | Status - Account Expired and Directed to Expired Password Reset Page." + " |"));

                            userTypeDesc = user.getUserLevelDesc();

                            session.setAttribute("session_userName", userName);
                            session.setAttribute("session_userTypeDesc", userTypeDesc);
                            session.setAttribute("session_isAuthenticated", DDM_Constants.is_authorized_yes);
                            session.setAttribute("session_isInitLogin", DDM_Constants.status_yes);
                            session.setAttribute("session_curPwd", password);
                            response.sendRedirect(request.getContextPath() + "/pages/user/expPwdChange.jsp");
                        }
                        else
                        {
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + " (" + user.getUserLevelDesc() + ") | Status - Login Success |"));

                            branchId = user.getBranchCode();
                            branchName = user.getBranchName();
                            cocuId = user.getCoCuId();
                            cocuName = user.getCoCuName();
                            userType = user.getUserLevelId();
                            userTypeDesc = user.getUserLevelDesc();
                            bankName = user.getBankFullName();
                            bankCode = user.getBankCode();

                            System.out.println("inside else of user.getStatus().equals(DDM_Constants.status_expired) ---> ");

                            System.out.println("userType ---> " + userType);

                            if (userType.equals(DDM_Constants.user_type_ddm_administrator))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_admin;
                                menuName = DDM_Constants.js_menu_name_for_ddm_admin;
                            }
                            if (userType.equals(DDM_Constants.user_type_ddm_operator))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_operator;
                                menuName = DDM_Constants.js_menu_name_for_ddm_operator;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_helpdesk;
                                menuName = DDM_Constants.js_menu_name_for_ddm_helpdesk;
                            }
                            else if (userType.equals(DDM_Constants.user_type_bank_user))
                            {
                                menuId = DDM_Constants.js_menu_id_for_bank_operator;
                                menuName = DDM_Constants.js_menu_name_for_bank_operator;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_supervisor))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_supervisor;
                                menuName = DDM_Constants.js_menu_name_for_ddm_supervisor;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_manager))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_manager;
                                menuName = DDM_Constants.js_menu_name_for_ddm_manager;
                            }
                            else if (userType.equals(DDM_Constants.user_type_bank_manager))
                            {
                                menuId = DDM_Constants.js_menu_id_for_bank_admin;
                                menuName = DDM_Constants.js_menu_name_for_bank_admin;
                            }
                            else if (userType.equals(DDM_Constants.user_type_merchant_su))
                            {
                                menuId = DDM_Constants.js_menu_id_for_corporate_customer_su;
                                menuName = DDM_Constants.js_menu_name_for_corporate_customer_su;
                            }
                            else if (userType.equals(DDM_Constants.user_type_merchant_op))
                            {
                                menuId = DDM_Constants.js_menu_id_for_corporate_customer_op;
                                menuName = DDM_Constants.js_menu_name_for_corporate_customer_op;
                            }

                            session.setAttribute("session_userName", userName);
                            session.setAttribute("session_userType", userType);
                            session.setAttribute("session_userTypeDesc", userTypeDesc);
                            session.setAttribute("session_isAuthenticated", DDM_Constants.is_authorized_yes);
                            session.setAttribute("session_branchId", branchId);
                            session.setAttribute("session_branchName", branchName);
                            session.setAttribute("session_cocuId", cocuId);
                            session.setAttribute("session_cocuName", cocuName);
                            session.setAttribute("session_menuId", menuId);
                            session.setAttribute("session_menuName", menuName);
                            session.setAttribute("session_bankName", bankName);
                            session.setAttribute("session_bankCode", bankCode);

                            int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(userName);
                            session.setAttribute("session_pwdvalidityperiod", pwdValidityPeriod);

                            System.out.println("Start sending email 111 ---> ");

                            SendHTMLEmail objSendHTMLEmail = new SendHTMLEmail();

                            System.out.println("objSendHTMLEmail.sendOTP user.getUserId() ---> " + user.getUserId());
                            System.out.println("objSendHTMLEmail.sendOTP user.getName() ---> " + user.getName());
                            System.out.println("objSendHTMLEmail.sendOTP user.getEmail() ---> " + user.getEmail());

                            if (objSendHTMLEmail.sendOTP(user.getUserId(), user.getName(), user.getEmail()))
                            {
                                String strOTP_Prefix = objSendHTMLEmail.getMsg();
                                session.setAttribute("session_OTP_Prefix", strOTP_Prefix);
                                response.sendRedirect("pages/otp.jsp");
                            }
                            else
                            {
                                response.sendRedirect("pages/error.jsp?msg=em");

                                // Without sending email.....
//                                String strOTP_Prefix = objSendHTMLEmail.getMsg();
//                                session.setAttribute("session_OTP_Prefix", strOTP_Prefix);
//                                response.sendRedirect("pages/otp.jsp");
                            }
                        }
                    }
                }
                else
                {
                    User user = DAOFactory.getUserDAO().getUserDetails(userName, DDM_Constants.status_all);

                    if (user != null)
                    {
                        if (user.getStatus().equals(DDM_Constants.status_active))
                        {
                            boolean bool = DAOFactory.getUserDAO().setUserLoggingAttempts(userName, DDM_Constants.status_fail);
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Unsuccess, Invalid Username or Password. |"));
                            //session.invalidate();
                            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
                        }
                        else if (user.getStatus().equals(DDM_Constants.status_pending))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Username - " + userName + " | Status - Login Unsuccess, User Access Denied Due To Pending User Account. |"));
                            session.setAttribute("session_userName", userName);
                            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
                        }
                        else if (user.getStatus().equals(DDM_Constants.status_deactive))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_access_denied, "| Username - " + userName + " | Status - Login Unsuccess, User Access Denied Due To Inactive User Account. |"));
                            session.setAttribute("session_userName", userName);
                            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
                        }
                        else if (user.getStatus().equals(DDM_Constants.status_locked))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_account_locked, "| Username - " + userName + " | Status - Login Unsuccess, User Account Locked. |"));
                            //session.invalidate();
                            response.sendRedirect(request.getContextPath() + "/pages/userAccountLocked.jsp");
                        }
                        else if (user.getStatus().equals(DDM_Constants.status_expired))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_account_expired, "| Username - " + userName + " | Status - Login Unsuccess, User Account Expired. |"));
                            //session.invalidate();                            
                            response.sendRedirect(request.getContextPath() + "/pages/userAccountExpired.jsp");
                        }
                    }
                    else
                    {
                        DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Unsuccess, Invalid Username. |"));
                        //session.invalidate();
                        response.sendRedirect("pages/login.jsp?msg=up");
                    }
                }
            }
        }
    }
    else
    {
        if (isAuhenticated.equals(DDM_Constants.is_authorized_yes))
        {
            userName = (String) session.getAttribute("session_userName");

            if (userName == null || userName.equals("null"))
            {
                userName = (String) request.getParameter("uName");

                System.out.println(" uName ---> " + userName);

                if (userName == null || userName.equals("null"))
                {
                    session.invalidate();
                    response.sendRedirect("pages/logout.jsp");
                }
                else
                {
                    String strOTP = (String) session.getAttribute("session_OTP");

                    System.out.println(" strOTP ---> " + strOTP);

                    if (strOTP == null || strOTP.equals("null"))
                    {
                        User user = DAOFactory.getUserDAO().getUserDetails(userName, DDM_Constants.status_all);

                        SendHTMLEmail objSendHTMLEmail = new SendHTMLEmail();

                        if (objSendHTMLEmail.sendOTP(user.getUserId(), user.getName(), user.getEmail()))
                        {
                            String strOTP_Prefix = objSendHTMLEmail.getMsg();

                            session.setAttribute("session_userName", userName);
                            session.setAttribute("session_OTP_Prefix", strOTP_Prefix);
                            response.sendRedirect(request.getContextPath() + "/pages/otp.jsp");
                        }
                        else
                        {
                            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=em");
                        }
                    }
                    else
                    {
                        //System.out.println(" strOTP ---> " + strOTP);

                        if (DAOFactory.getUserDAO().isValidOTP(userName, strOTP))
                        {
                            User user = DAOFactory.getUserDAO().getUserDetails(userName, DDM_Constants.status_all);
                            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_login_info, "| Username - " + userName + " (" + user.getUserLevelDesc() + ") | Status - Login Success |"));

                            branchId = user.getBranchCode();
                            branchName = user.getBranchName();
                            cocuId = user.getCoCuId();
                            cocuName = user.getCoCuName();
                            userType = user.getUserLevelId();
                            userTypeDesc = user.getUserLevelDesc();
                            bankName = user.getBankFullName();
                            bankCode = user.getBankCode();

                            if (userType.equals(DDM_Constants.user_type_ddm_administrator))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_admin;
                                menuName = DDM_Constants.js_menu_name_for_ddm_admin;
                            }
                            if (userType.equals(DDM_Constants.user_type_ddm_operator))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_operator;
                                menuName = DDM_Constants.js_menu_name_for_ddm_operator;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_helpdesk_user))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_helpdesk;
                                menuName = DDM_Constants.js_menu_name_for_ddm_helpdesk;
                            }
                            else if (userType.equals(DDM_Constants.user_type_bank_user))
                            {
                                menuId = DDM_Constants.js_menu_id_for_bank_operator;
                                menuName = DDM_Constants.js_menu_name_for_bank_operator;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_supervisor))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_supervisor;
                                menuName = DDM_Constants.js_menu_name_for_ddm_supervisor;
                            }
                            else if (userType.equals(DDM_Constants.user_type_ddm_manager))
                            {
                                menuId = DDM_Constants.js_menu_id_for_ddm_manager;
                                menuName = DDM_Constants.js_menu_name_for_ddm_manager;
                            }
                            else if (userType.equals(DDM_Constants.user_type_bank_manager))
                            {
                                menuId = DDM_Constants.js_menu_id_for_bank_admin;
                                menuName = DDM_Constants.js_menu_name_for_bank_admin;
                            }
                            else if (userType.equals(DDM_Constants.user_type_merchant_su))
                            {
                                menuId = DDM_Constants.js_menu_id_for_corporate_customer_su;
                                menuName = DDM_Constants.js_menu_name_for_corporate_customer_su;
                            }
                            else if (userType.equals(DDM_Constants.user_type_merchant_op))
                            {
                                menuId = DDM_Constants.js_menu_id_for_corporate_customer_op;
                                menuName = DDM_Constants.js_menu_name_for_corporate_customer_op;
                            }

                            session.setAttribute("session_userName", userName);
                            session.setAttribute("session_userType", userType);
                            session.setAttribute("session_userTypeDesc", userTypeDesc);
                            session.setAttribute("session_isAuthenticated", DDM_Constants.is_authorized_yes);
                            session.setAttribute("session_branchId", branchId);
                            session.setAttribute("session_branchName", branchName);
                            session.setAttribute("session_cocuId", cocuId);
                            session.setAttribute("session_cocuName", cocuName);
                            session.setAttribute("session_menuId", menuId);
                            session.setAttribute("session_menuName", menuName);
                            session.setAttribute("session_bankName", bankName);
                            session.setAttribute("session_bankCode", bankCode);

                            int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(userName);
                            session.setAttribute("session_pwdvalidityperiod", pwdValidityPeriod);

                            String strIsOTPCorrect = (String) session.getAttribute("session_isOTPCorrect");

                            if (strIsOTPCorrect != null && strIsOTPCorrect.equals(DDM_Constants.is_authorized_yes))
                            {
                                response.sendRedirect(request.getContextPath() + "/pages/homepage.jsp");
                            }
                            else
                            {
                                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=op");
                            }
                        }
                        else
                        {
                            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=op");
                        }
                    }
                }
            }
            else
            {
                String strIsOTPCorrect = (String) session.getAttribute("session_isOTPCorrect");

                if (strIsOTPCorrect != null && strIsOTPCorrect.equals(DDM_Constants.is_authorized_yes))
                {
                    response.sendRedirect(request.getContextPath() + "/pages/homepage.jsp");
                }
                else
                {
                    response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=op");
                }
            }
        }
        else
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
        }
    }
%>
