/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.services.utils.RandomPasswordGenerator;

/**
 *
 * @author Dinesh
 */
public class UserDAOImpl implements UserDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public void setMsg(String message)
    {
        msg = message;
    }

    @Override
    public boolean changeUserPassword(User usr, String curPwd, boolean isInitial)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }

        if (!isInitial && curPwd == null)
        {
            System.out.println("WARNING : Null currentPassword parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            if (!isInitial)
            {
                if (DAOFactory.getUserDAO().isAuthorized(new User(usr.getUserId(), curPwd, DDM_Constants.status_all)))
                {
                    con = DBUtil.getInstance().getConnection();
                    con.setAutoCommit(false);

                    StringBuilder sbQuery = new StringBuilder();

                    sbQuery.append("update ");
                    sbQuery.append(DDM_Constants.tbl_user + " ");
                    sbQuery.append("set Password=MD5(?), Status = ?, LastPasswordResetDate=now(), IsInitialPassword = ? ");
                    sbQuery.append("where userId = ? ");
                    sbQuery.append("and Password = MD5(?) ");

                    //System.out.println(sbQuery.toString());
                    psmt = con.prepareStatement(sbQuery.toString());

                    psmt.setString(1, usr.getUserId() + usr.getPassword());
                    psmt.setString(2, DDM_Constants.status_active);
                    psmt.setString(3, DDM_Constants.status_no);
                    psmt.setString(4, usr.getUserId());
                    psmt.setString(5, usr.getUserId() + curPwd);

                    count = psmt.executeUpdate();

                    //System.out.println("count ---> " + count);
                    if (count > 0)
                    {
                        con.commit();
                        query_status = true;
                    }
                    else
                    {
                        msg = DDM_Constants.msg_error_while_processing;
                        con.rollback();
                    }

                    //System.out.println("msg ---> " + msg);
                }
                else
                {
                    msg = "Current Password Does not match!";
                }

            }
            else
            {
                con = DBUtil.getInstance().getConnection();
                con.setAutoCommit(false);

                StringBuilder sbQuery = new StringBuilder();

                sbQuery.append("update ");
                sbQuery.append(DDM_Constants.tbl_user + " ");
                sbQuery.append("set Password=MD5(?), LastPasswordResetDate=now(), IsInitialPassword = ? ");
                sbQuery.append("where userId = ? ");

                //System.out.println(sbQuery.toString());
                psmt = con.prepareStatement(sbQuery.toString());

                psmt.setString(1, usr.getUserId() + usr.getPassword());
                psmt.setString(2, DDM_Constants.status_no);
                psmt.setString(3, usr.getUserId());

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    query_status = true;
                }
                else
                {
                    msg = DDM_Constants.msg_error_while_processing;
                    con.rollback();
                }
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean resetUserPassword(User usr, boolean resetUnSuccessfulLoggingAttempts)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Password=MD5(?), LastPasswordResetDate=now(), IsInitialPassword = ? ");

            if (usr.getStatus() != null)
            {
                sbQuery.append(", Status = ? ");
            }

            if (resetUnSuccessfulLoggingAttempts == true)
            {
                sbQuery.append(", UnSuccessfulLoggingAttempts = 0 ");
            }

            sbQuery.append("where userId = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, usr.getUserId() + usr.getPassword());
            psmt.setString(2, DDM_Constants.status_yes);

            if (usr.getStatus() != null)
            {
                psmt.setString(3, usr.getStatus());
                psmt.setString(4, usr.getUserId());
            }
            else
            {
                psmt.setString(3, usr.getUserId());
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean isAuthorized(User usr)
    {
        boolean isAuthorized = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isAuthorized;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null password parameter.");
            return isAuthorized;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return isAuthorized;
        }

        try
        {
            int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(usr.getUserId());

            if (pwdValidityPeriod < 0)
            {
                DAOFactory.getUserDAO().setUserStatus(usr.getUserId(), DDM_Constants.status_expired, false);
                return isAuthorized;
            }

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAuthorized FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND Password = MD5(?) ");

            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usr.getUserId());
            pstm.setString(2, usr.getUserId() + usr.getPassword());

            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                pstm.setString(3, usr.getStatus());
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAuthorized");

                if (count > 0)
                {
                    isAuthorized = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAuthorized;
    }

    @Override
    public boolean isAuthorized(User usr, String statusIn)
    {
        boolean isAuthorized = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isAuthorized;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null password parameter.");
            return isAuthorized;
        }
        if (statusIn == null)
        {
            System.out.println("WARNING : Null statusIn parameter.");
            return isAuthorized;
        }

        try
        {
            int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(usr.getUserId());

            if (pwdValidityPeriod < 0)
            {
                DAOFactory.getUserDAO().setUserStatus(usr.getUserId(), DDM_Constants.status_expired, false);
                return isAuthorized;
            }

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAuthorized FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND Password = MD5(?) ");

            if (!statusIn.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Status in (").append(statusIn).append(") ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usr.getUserId());
            pstm.setString(2, usr.getUserId() + usr.getPassword());

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAuthorized");

                if (count > 0)
                {
                    isAuthorized = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAuthorized;
    }

    @Override
    public boolean isAuthorizedDualUser(User usr, String usrLevel, String curUser)
    {
        boolean isAuthorized = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isAuthorized;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null password parameter.");
            return isAuthorized;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return isAuthorized;
        }

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return isAuthorized;
        }

        if (curUser == null)
        {
            System.out.println("WARNING : Null curUser parameter.");
            return isAuthorized;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_userStatus = 1;
            int val_userLevel = 2;
            int val_curUser = 3;

            int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(usr.getUserId());

            if (pwdValidityPeriod < 0)
            {
                DAOFactory.getUserDAO().setUserStatus(usr.getUserId(), DDM_Constants.status_expired, false);
                return isAuthorized;
            }

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAuthorized FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND Password = MD5(?) ");

            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
                vt.add(val_userStatus);
            }

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND UserLevel = ? ");
                vt.add(val_userLevel);
            }

            if (!curUser.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND UserId != BINARY(?) ");
                vt.add(val_curUser);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usr.getUserId());
            pstm.setString(2, usr.getUserId() + usr.getPassword());

            int i = 3;

            for (int val_item : vt)
            {
                if (val_item == val_userStatus)
                {
                    pstm.setString(i, usr.getStatus());
                    i++;
                }

                if (val_item == val_userLevel)
                {
                    pstm.setString(i, usrLevel);
                    i++;
                }

                if (val_item == val_curUser)
                {
                    pstm.setString(i, curUser);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAuthorized");

                if (count > 0)
                {
                    isAuthorized = true;
                }
                else
                {
                    msg = DDM_Constants.msg_no_records;
                }
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAuthorized;
    }

    @Override
    public boolean isCurrentlyLoggedin(String userId, int sessionExpTimeInMinutes)
    {
        boolean isCurLoggedin = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            msg = DDM_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsCurLoggedin FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND IsCurrentlyLoggedIn = ? ");
            sbQuery.append("AND TIMESTAMPDIFF(MINUTE,LastSuccessfulVisit,now()) <= ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);
            pstm.setString(2, DDM_Constants.status_yes);
            pstm.setInt(3, sessionExpTimeInMinutes);

            //System.out.println("PropertyLoader.getInstance().getUserSessionTimeout() --> " + PropertyLoader.getInstance().getUserSessionTimeout());
            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsCurLoggedin");

                if (count > 0)
                {
                    isCurLoggedin = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isCurLoggedin;
    }

    @Override
    public boolean isAuthorizedForWeb(User usr, String remoteIP)
    {
        boolean isAuthorized = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String requestBranch = null;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isAuthorized;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null password parameter.");
            return isAuthorized;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return isAuthorized;
        }
        if (remoteIP == null)
        {
            System.out.println("WARNING : Null remoteIP parameter.");
            return isAuthorized;
        }
        else
        {
            String[] result = remoteIP.split(".");

            if (result != null && result.length == 4)
            {
                requestBranch = result[1] + result[2];
                //System.out.println("requestBranch --> " + requestBranch);
            }
            else
            {
                requestBranch = "n/a";
            }
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAuthorized FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND Password = MD5(?) ");

            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usr.getUserId());
            pstm.setString(2, usr.getUserId() + usr.getPassword());

            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                pstm.setString(3, usr.getStatus());
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAuthorized");

                if (count > 0)
                {
                    isAuthorized = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAuthorized;
    }

    @Override
    public boolean isInitialLogin(String userId, String status)
    {
        boolean isInitLogin = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            msg = DDM_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            msg = DDM_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsInitLogin FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND IsInitialPassword = ? ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);
            pstm.setString(2, DDM_Constants.status_yes);

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(3, status);
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsInitLogin");

                if (count > 0)
                {
                    isInitLogin = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isInitLogin;
    }

    @Override
    public Collection<User> getUserDetails(String status)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration;
        int iUserPwdExpireDuration;
        String strSystemUserPwdExpireDuration = null;
        String strUserPwdExpireDuration = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), usr.LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");
            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");

            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND usr.Status = ? ");
            }

            sbQuery.append("ORDER BY usr.UserId");

            pstm = con.prepareStatement(sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(4, status);
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public User getUserDetails(String userId, String status)
    {
        User user = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
        int iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
        String strSystemUserPwdExpireDuration = null;
        String strUserPwdExpireDuration = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return user;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return user;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");
            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");

            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");
            sbQuery.append("AND usr.UserId = BINARY(?) ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND usr.Status = ? ");
            }

            System.out.println("getUserDetails:SB Query ----> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);

            pstm.setString(4, userId);

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(5, status);
            }

            rs = pstm.executeQuery();

            user = UserUtil.makeUserObject(rs);

            if (user == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return user;
    }

    @Override
    public Collection<User> getUserList(String UserLevel)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
        int iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
        String strSystemUserPwdExpireDuration = null;
        String strUserPwdExpireDuration = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), usr.LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");
            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");

            if (!UserLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.UserLevel = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("getUserList(String UserLevel)===>" + sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (Exception e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);

            if (!UserLevel.equals(DDM_Constants.status_all))
            {

                pstm.setString(4, UserLevel);
            }

            System.out.println("param1===>" + DDM_Constants.param_id_user_system);
            System.out.println("param2===>" + iSystemUserPwdExpireDuration);
            System.out.println("param3===>" + iUserPwdExpireDuration);
            System.out.println("param4===>" + UserLevel);

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public Collection<User> getUserList(String bank, String userLevel, String status)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
        int iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
        String strSystemUserPwdExpireDuration = null;
        String strUserPwdExpireDuration = null;

        try
        {
            ArrayList<Integer> vt = new ArrayList();
            int val_bank = 1;
            int val_userLevel = 2;
            int val_status = 3;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), usr.LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");

            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.Bank = ? ");
                vt.add(val_bank);
            }

            if (!userLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.UserLevel = ? ");
                vt.add(val_userLevel);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.Status = ? ");
                vt.add(val_status);
            }

            //System.out.println("getUserList(sbQuery)===========>" + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);

            int i = 4;

            for (int val_item : vt)
            {
                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }
                if (val_item == val_userLevel)
                {
                    pstm.setString(i, userLevel);
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public int getPasswordValidityPeriod(String userId)
    {
        int validityPeriod = -1;  //100;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return validityPeriod;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select (? - DATEDIFF(now(), LastPasswordResetDate)) as NoDays, UserLevel FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            if (userId.equals(DDM_Constants.param_id_user_system))
            {
                //pstm.setInt(1, DDM_Constants.system_pwd_expire_duration);
                int iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;

                String strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

                if (strSystemUserPwdExpireDuration != null)
                {
                    try
                    {
                        iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                    }
                    catch (Exception e)
                    {
                        iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                    }
                }
                else
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }

                pstm.setInt(1, iSystemUserPwdExpireDuration);
            }
            else
            {
                //pstm.setInt(1, DDM_Constants.user_pwd_expire_duration);

                int iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;

                String strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

                if (strUserPwdExpireDuration != null)
                {
                    try
                    {
                        iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                    }
                    catch (Exception e)
                    {
                        iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                    }
                }
                else
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }

                pstm.setInt(1, iUserPwdExpireDuration);

            }

            pstm.setString(2, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                validityPeriod = rs.getInt("NoDays");
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return validityPeriod;
    }

    @Override
    public boolean setUserStatus(String userId, String status, boolean resetUnSuccessfulLoggingAttempts)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status = ? ");

            if (resetUnSuccessfulLoggingAttempts == true)
            {
                sbQuery.append(", UnSuccessfulLoggingAttempts = 0 ");
            }

            if (status.equals(DDM_Constants.status_deactive))
            {
                sbQuery.append(", TokenSerial = null ");
            }

            sbQuery.append("where userId = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, status);
            psmt.setString(2, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public Collection<User> getUsers(User usr, String statusNotIn)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserLevelId() == null)
        {
            System.out.println("WARNING : Null usr.getUserLevelId()  parameter.");
            return col;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null usr.getStatus() parameter.");
            return col;
        }

        if (usr.getBankCode() == null)
        {
            System.out.println("WARNING : Null usr.getBankCode() parameter.");
            return col;
        }

        if (usr.getBranchCode() == null)
        {
            System.out.println("WARNING : Null usr.getBranchCode() parameter.");
            return col;
        }

        if (usr.getCoCuId() == null)
        {
            System.out.println("WARNING : Null usr.getCoCuId()  parameter.");
            return col;
        }

        if (statusNotIn == null)
        {
            System.out.println("WARNING : Null statusNotIn parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_userLevel = 1;
            int val_userStatus = 2;
            int val_userBank = 3;
            int val_userBranch = 4;
            int val_userMerchant = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, usr.UserLevel FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " usr ");

            sbQuery.append("WHERE usr.UserId != ? ");

            if (!usr.getUserLevelId().equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.UserLevel = ? ");
                vt.add(val_userLevel);
            }
            if (!usr.getStatus().equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.Status = ? ");
                vt.add(val_userStatus);
            }
            if (!usr.getBankCode().equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND usr.Bank = ? ");
                vt.add(val_userBank);
            }
            if (!usr.getBranchCode().equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.Branch = ? ");
                vt.add(val_userBranch);
            }
            if (!usr.getCoCuId().equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.MerchantID = ? ");
                vt.add(val_userMerchant);
            }

            if (!statusNotIn.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and usr.Status not in (").append(statusNotIn).append(") ");
                //vt.add(val_statusNotIn);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("UserDAOImpl:getUsers(User usr, String statusNotIn)----> " + sbQuery.toString());
            pstm.setString(1, DDM_Constants.param_id_user_system);

            int i = 2;

            for (int val_item : vt)
            {
                if (val_item == val_userLevel)
                {
                    pstm.setString(i, usr.getUserLevelId());
                    i++;
                }
                if (val_item == val_userStatus)
                {
                    pstm.setString(i, usr.getStatus());
                    i++;
                }
                if (val_item == val_userBank)
                {
                    pstm.setString(i, usr.getBankCode());
                    i++;
                }
                if (val_item == val_userBranch)
                {
                    pstm.setString(i, usr.getBranchCode());
                    i++;
                }
                if (val_item == val_userMerchant)
                {
                    pstm.setString(i, usr.getBranchCode());
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserId_LevelObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean setUserLoggingAttempts(String userId, String status)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        User user = null;
        boolean query_status = false;
        int invalidPwdMaxWaitTime = 300;
        int maxUnsuccesfulLoginCount = 5;

        try
        {
            String strInvalidPwdMaxWaitTime = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_InvalidPwdMaxWaitTime);

            if (strInvalidPwdMaxWaitTime != null)
            {
                invalidPwdMaxWaitTime = Integer.parseInt(strInvalidPwdMaxWaitTime);
            }
            else
            {
                invalidPwdMaxWaitTime = 300;
            }
        }
        catch (NumberFormatException e)
        {
            invalidPwdMaxWaitTime = 300;
            System.out.println("Exception====>" + e.getMessage());
        }

        try
        {
            String strUnsuccesfulLoginCount = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UnsuccesfulLoginCount);

            if (strUnsuccesfulLoginCount != null)
            {
                maxUnsuccesfulLoginCount = Integer.parseInt(strUnsuccesfulLoginCount);
            }
            else
            {
                maxUnsuccesfulLoginCount = 5;
            }
        }
        catch (Exception e)
        {
            maxUnsuccesfulLoginCount = 5;
            System.out.println("Exception====>" + e.getMessage());
        }

        try
        {
            user = new UserDAOImpl().getUnSuccessfulLoggingAttemptsDetails(userId);

            if (user != null)
            {
                int unSuccessLoggingcount = user.getUnSccessfulLoggingAttempts();
                long timeDiff = user.getTimeDiff();
                int paramSetId = 0;

                //System.out.println("unSuccessLoggingcount ---> " + unSuccessLoggingcount);
                //System.out.println("timeDiff ---> " + timeDiff);
                con = DBUtil.getInstance().getConnection();
                con.setAutoCommit(false);

                StringBuilder sbQuery = new StringBuilder();

                sbQuery.append("update ");
                sbQuery.append(DDM_Constants.tbl_user + " ");

                if (status.equals(DDM_Constants.status_fail))
                {
                    if (timeDiff < invalidPwdMaxWaitTime)
                    {
                        if (unSuccessLoggingcount < (maxUnsuccesfulLoginCount - 1))
                        {
                            unSuccessLoggingcount++;
                            sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                            sbQuery.append("LastLoggingAttempt = now() ");
                            sbQuery.append("where userId = ? ");

                            paramSetId = 1;
                        }
                        else
                        {
                            unSuccessLoggingcount++;
                            sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                            sbQuery.append("Status = ?, ");
                            sbQuery.append("LastLoggingAttempt = now() ");
                            sbQuery.append("where userId = ? ");
                            paramSetId = 2;
                        }
                    }
                    else
                    {
                        unSuccessLoggingcount = 1;
                        sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                        sbQuery.append("LastLoggingAttempt = now() ");
                        sbQuery.append("where userId = ? ");
                        paramSetId = 3;
                    }

                    //System.out.println(sbQuery.toString());
                    psmt = con.prepareStatement(sbQuery.toString());

                    if (paramSetId == 1)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, userId);
                    }
                    else if (paramSetId == 2)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, DDM_Constants.status_locked);
                        psmt.setString(3, userId);
                    }
                    else if (paramSetId == 3)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, userId);
                    }
                }
                else
                {
                    unSuccessLoggingcount = 0;
                    sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                    sbQuery.append("LastLoggingAttempt = now(), LastSuccessfulLogin = now() ");
                    sbQuery.append("where userId = ? ");

                    //System.out.println(sbQuery.toString());
                    psmt = con.prepareStatement(sbQuery.toString());

                    psmt.setInt(1, unSuccessLoggingcount);
                    psmt.setString(2, userId);

                }

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    query_status = true;
                }
                else
                {
                    msg = DDM_Constants.msg_error_while_processing;
                    con.rollback();
                }
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public User getUnSuccessfulLoggingAttemptsDetails(String userId)
    {
        User user = null;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return user;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select UnSuccessfulLoggingAttempts, TIME_TO_SEC(TIMEDIFF(now(), LastLoggingAttempt)) as timeDifference FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");

            //System.out.println("sbQuery ---> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                user = new User(rs.getInt("UnSuccessfulLoggingAttempts"), rs.getLong("timeDifference"));

                //System.out.println("rs.getInt(UnSuccessfulLoggingAttempts) ---> " + rs.getInt("UnSuccessfulLoggingAttempts"));
                //System.out.println("rs.getLong(timeDifference) ---> " + rs.getLong("timeDifference"));
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return user;
    }

    @Override
    public boolean isOkToChangePassword(String userId, int iMinPwdResetDays)
    {
        boolean isOkToChangePassword = false;  //100;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isOkToChangePassword;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select DATEDIFF(now(), LastPasswordResetDate) as NoDays FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                if (rs.getInt("NoDays") >= iMinPwdResetDays)
                {
                    isOkToChangePassword = true;
                }
                else
                {
                    isOkToChangePassword = false;
                }
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
                isOkToChangePassword = false;
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isOkToChangePassword;
    }

    @Override
    public boolean updateUserVisitStat(String userId, String isCurrentlyLoggedIn)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (isCurrentlyLoggedIn == null)
        {
            System.out.println("WARNING : Null isCurrentlyLoggedIn parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set IsCurrentlyLoggedIn = ? , LastSuccessfulVisit = now() ");
            sbQuery.append("where userId = ? ");

            System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, isCurrentlyLoggedIn);
            psmt.setString(2, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean deactivateAllUsers(String bank)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status = ? ");
            sbQuery.append("where Bank = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_deactive);
            psmt.setString(2, bank);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean updateExpriedUserStatus()
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status = ? ");
            sbQuery.append("where UserId!= ? and Status = ? and ((SELECT ParamValue FROM parameter where ParamId = ?) - DATEDIFF(now(), LastPasswordResetDate)) < ? ");

            //System.out.println("updateExpriedUserStatus(sbQuery)=======>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_expired);
            psmt.setString(2, DDM_Constants.param_id_user_system);
            psmt.setString(3, DDM_Constants.status_active);
            psmt.setString(4, DDM_Constants.param_id_UserPwdExpireDuration);
            psmt.setInt(5, 0);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean autoUnlockLockedUsers()
    {
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status = ?, ");
            sbQuery.append("UnSuccessfulLoggingAttempts = 0 ");
            sbQuery.append("where Status = ? and ((TIME_TO_SEC(TIMEDIFF(now(), LastLoggingAttempt))) - (SELECT ParamValue FROM parameter where ParamId = ?)) > ? ");

            //System.out.println("autoUnlockLockedUsers(sbQuery)=======>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_locked);
            psmt.setString(3, DDM_Constants.param_id_userAccountAutoUnlockTime);
            psmt.setInt(4, 0);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean addUser(User usr)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }
        if (usr.getUserLevelId() == null)
        {
            System.out.println("WARNING : Null User Level parameter.");
            return false;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getBankCode() == null)
        {
            System.out.println("WARNING : Null Bank Code parameter.");
            return false;
        }

        if (usr.getNIC() == null)
        {
            System.out.println("WARNING : Null NIC parameter.");
            return false;
        }

        if (usr.getTokenSerial() == null)
        {
            System.out.println("WARNING : Null Token Serial parameter.");
            return false;
        }

        if (usr.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null Created By parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("(UserId,UserLevel,UserLevel_Modify,Bank,Bank_Modify,Branch,Branch_Modify,");

            if (usr.getCoCuId() != null && !usr.getCoCuId().equals(DDM_Constants.status_all))
            {
                sbQuery.append("MerchantID,MerchantID_Modify,");
            }

            sbQuery.append("NIC,NIC_Modify,EmpId,EmpId_Modify,"
                    + "Name,Name_Modify,Designation,Designation_Modify,Email,Email_Modify,"
                    + "ContactNo,ContactNo_Modify,Password,IsInitialPassword,TokenSerial,TokenSerial_Modify,"
                    + "Status,Status_Modify,Remarks,Remarks_Modify,LastPasswordResetDate,"
                    + "CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values ");
            sbQuery.append("(?,?,?,?,?,?,?,");

            if (usr.getCoCuId() != null && !usr.getCoCuId().equals(DDM_Constants.status_all))
            {
                sbQuery.append("?,?,");
            }

            sbQuery.append("?,?,?,?,?,?,?,?,?,?,?,?,MD5(?),?,?,?,?,?,?,?,NOW(),?,NOW(),?,NOW())");

            psmt = con.prepareStatement(sbQuery.toString());

            int minPwdLength = 8;

            try
            {
                minPwdLength = Integer.parseInt(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_minimum_pwd_length));
            }
            catch (NumberFormatException e)
            {

                minPwdLength = 8;
            }

            String defaultPassword = RandomPasswordGenerator.generatePassword(minPwdLength);

            if (defaultPassword == null)
            {
                defaultPassword = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_default_pwd);;
            }

            if (usr.getCoCuId() != null && !usr.getCoCuId().equals(DDM_Constants.status_all))
            {
                psmt.setString(1, usr.getUserId());
                psmt.setString(2, usr.getUserLevelId());
                psmt.setString(3, usr.getUserLevelId());
                psmt.setString(4, usr.getBankCode());
                psmt.setString(5, usr.getBankCode());
                psmt.setString(6, usr.getBranchCode());
                psmt.setString(7, usr.getBranchCode());
                psmt.setString(8, usr.getCoCuId());
                psmt.setString(9, usr.getCoCuId());
                psmt.setString(10, usr.getNIC() != null ? (!usr.getNIC().equals("")) ? usr.getNIC() : null : null);
                psmt.setString(11, usr.getNIC() != null ? (!usr.getNIC().equals("")) ? usr.getNIC() : null : null);
                psmt.setString(12, usr.getEmpId());
                psmt.setString(13, usr.getEmpId());
                psmt.setString(14, usr.getName());
                psmt.setString(15, usr.getName());
                psmt.setString(16, usr.getDesignation());
                psmt.setString(17, usr.getDesignation());
                psmt.setString(18, usr.getEmail());
                psmt.setString(19, usr.getEmail());
                psmt.setString(20, usr.getContactNo());
                psmt.setString(21, usr.getContactNo());
                psmt.setString(22, usr.getUserId() + usr.getPassword());
                psmt.setString(23, usr.getIsInitialPassword());
                psmt.setString(24, usr.getTokenSerial() != null ? (!usr.getTokenSerial().equals("")) ? usr.getTokenSerial() : null : null);
                psmt.setString(25, usr.getTokenSerial() != null ? (!usr.getTokenSerial().equals("")) ? usr.getTokenSerial() : null : null);
                psmt.setString(26, usr.getStatus());
                psmt.setString(27, usr.getStatus());
                psmt.setString(28, usr.getRemarks());
                psmt.setString(29, usr.getRemarks());
                psmt.setString(30, usr.getCreatedBy());
                psmt.setString(31, usr.getCreatedBy());
            }
            else
            {
                psmt.setString(1, usr.getUserId());
                psmt.setString(2, usr.getUserLevelId());
                psmt.setString(3, usr.getUserLevelId());
                psmt.setString(4, usr.getBankCode());
                psmt.setString(5, usr.getBankCode());
                psmt.setString(6, usr.getBranchCode());
                psmt.setString(7, usr.getBranchCode());
                psmt.setString(8, usr.getNIC() != null ? (!usr.getNIC().equals("")) ? usr.getNIC() : null : null);
                psmt.setString(9, usr.getNIC() != null ? (!usr.getNIC().equals("")) ? usr.getNIC() : null : null);
                psmt.setString(10, usr.getEmpId());
                psmt.setString(11, usr.getEmpId());
                psmt.setString(12, usr.getName());
                psmt.setString(13, usr.getName());
                psmt.setString(14, usr.getDesignation());
                psmt.setString(15, usr.getDesignation());
                psmt.setString(16, usr.getEmail());
                psmt.setString(17, usr.getEmail());
                psmt.setString(18, usr.getContactNo());
                psmt.setString(19, usr.getContactNo());
                psmt.setString(20, usr.getUserId() + usr.getPassword());
                psmt.setString(21, usr.getIsInitialPassword());
                psmt.setString(22, usr.getTokenSerial() != null ? (!usr.getTokenSerial().equals("")) ? usr.getTokenSerial() : null : null);
                psmt.setString(23, usr.getTokenSerial() != null ? (!usr.getTokenSerial().equals("")) ? usr.getTokenSerial() : null : null);
                psmt.setString(24, usr.getStatus());
                psmt.setString(25, usr.getStatus());
                psmt.setString(26, usr.getRemarks());
                psmt.setString(27, usr.getRemarks());
                psmt.setString(28, usr.getCreatedBy());
                psmt.setString(29, usr.getCreatedBy());
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;

                //String finalURL = commonURL;
                //finalURL = "<a href=\"" + finalURL + "\" title=\"Login To LankaSign RA Automation System\">Login To LankaSign RA Automation System</a>";
                // Send email with new default userId and password to registration applied user 
                //new SendHTMLEmail().sendEmailForNewRegRequest(usr.getEmail(), "Alert - LankaSign RA Automation System Login!", "Dear " + usr.getName() + ", <br/><br/> You have successfuly added to the <b> LankaPay Direct Debit Mandate Exchange System </b>.<br/>In order to view the status of the new '" + categoryDisplayName + "' registration request, please click on the below link,", "<br/><br/>" + finalURL + "<br/><br/>Use below default username and password for login to the system.<br/><br/><b>Username - <b>" + defaultUserId + "<br/><b>Password - <b>" + defaultPassword + " <br/><br/>Thank You!");
            }
            else
            {
                con.rollback();
                msg = DDM_Constants.msg_no_records_updated;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public Collection<User> getAuthPendingUsers(String createdUser, String sessionUserType)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration;
        int iUserPwdExpireDuration;
        String strSystemUserPwdExpireDuration;
        String strUserPwdExpireDuration;

        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        if (sessionUserType == null)
        {
            System.out.println("WARNING : Null sessionUserType parameter.");
            return col;
        }

        System.out.println("sessionUserType ======> " + sessionUserType);

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), usr.LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");

            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");

            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");

            sbQuery.append("AND usr.Status = ? ");
            sbQuery.append("AND usr.CreatedBy != ? ");

            if (!sessionUserType.equals(DDM_Constants.user_type_ddm_manager))
            {
                sbQuery.append("AND usr.UserLevel != ? ");
            }

            sbQuery.append("ORDER BY usr.UserId");

            //System.out.println("sbQuery(getAuthPendingUsers)=====>" + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);
            pstm.setString(4, DDM_Constants.status_pending);
            pstm.setString(5, createdUser);

            if (!sessionUserType.equals(DDM_Constants.user_type_ddm_manager))
            {
                pstm.setString(6, DDM_Constants.user_type_ddm_manager);
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean doAuthorizedNewUser(String userId, String authBy)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (authBy == null)
        {
            System.out.println("WARNING : Null authBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("AuthorizedDate = now() ");
            sbQuery.append("where UserId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_active);
            psmt.setString(3, authBy);
            psmt.setString(4, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (SQLException | ClassNotFoundException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    @Override
    public boolean setUserStatusManual(String userId, String status, boolean resetUnSuccessfulLoggingAttempts, String modifiedBy)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (modifiedBy == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = null ");

            if (resetUnSuccessfulLoggingAttempts == true)
            {
                sbQuery.append(", UnSuccessfulLoggingAttempts = 0 ");
            }

            if (status.equals(DDM_Constants.status_deactive))
            {
                sbQuery.append(", TokenSerial_Modify = null ");
            }

            sbQuery.append("where userId = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, status);
            psmt.setString(2, modifiedBy);
            psmt.setString(3, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean updateUser(User usr)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getDesignation() == null)
        {
            System.out.println("WARNING : Null Designation parameter.");
            return false;
        }

        if (usr.getName() == null)
        {
            System.out.println("WARNING : Null Name parameter.");
            return false;
        }

        if (usr.getEmail() == null)
        {
            System.out.println("WARNING : Null Email parameter.");
            return false;
        }

        if (usr.getContactNo() == null)
        {
            System.out.println("WARNING : Null Contact No. parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status_Modify = ?, ");
            sbQuery.append("Remarks_Modify = ?, ");
            sbQuery.append("Name_Modify = ?, ");
            sbQuery.append("Designation_Modify = ?, ");
            sbQuery.append("Email_Modify = ?, ");
            sbQuery.append("ContactNo_Modify = ?, ");
            sbQuery.append("EmpId_Modify = ?, ");
            sbQuery.append("NIC_Modify = ?, ");
            sbQuery.append("TokenSerial_Modify = ?, ");
            sbQuery.append("Bank_Modify = ?, ");
            sbQuery.append("Branch_Modify = ?, ");
            sbQuery.append("MerchantID_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = null ");

            if (usr.getUserLevelId() != null)
            {
                sbQuery.append(", UserLevel_Modify = ? ");
            }
            sbQuery.append(" where UserId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, usr.getStatus());
            psmt.setString(2, usr.getRemarks());
            psmt.setString(3, usr.getName());
            psmt.setString(4, usr.getDesignation());
            psmt.setString(5, usr.getEmail());
            psmt.setString(6, usr.getContactNo());
            psmt.setString(7, usr.getEmpId());
            psmt.setString(8, usr.getNIC());
            psmt.setString(9, usr.getTokenSerial());
            psmt.setString(10, usr.getBankCode());
            psmt.setString(11, usr.getBranchCode());
            psmt.setString(12, usr.getCoCuId());
            psmt.setString(13, usr.getModifiedBy());

            if (usr.getUserLevelId() != null)
            {
                psmt.setString(14, usr.getUserLevelId());
                psmt.setString(15, usr.getUserId());
            }
            else
            {
                psmt.setString(14, usr.getUserId());
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                con.rollback();
                msg = DDM_Constants.msg_no_records_updated;
            }

        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public Collection<User> getAuthPendingModifiedUser(String modifiedBy, String modifyType, String sessionUserType)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        int iSystemUserPwdExpireDuration;
        int iUserPwdExpireDuration;
        String strSystemUserPwdExpireDuration;
        String strUserPwdExpireDuration;

        if (modifiedBy == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return col;
        }
        if (modifyType == null)
        {
            System.out.println("WARNING : Null modifyType parameter.");
            return col;
        }
        if (sessionUserType == null)
        {
            System.out.println("WARNING : Null sessionUserType parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");

            sbQuery.append("usr.UserLevel_Modify as UserLevelId_Modify, ");
            sbQuery.append("usrlvlm.UserLevelDesc as UserLevelDesc_Modify, ");

            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bk.ShortName as BankShortName, ");
            sbQuery.append("bk.FullName as BankFullName, ");

            sbQuery.append("usr.Bank_Modify as BankCode_Modify, ");
            sbQuery.append("bkm.ShortName as BankShortName_Modify, ");
            sbQuery.append("bkm.FullName as BankFullName_Modify, ");

            sbQuery.append("usr.Branch as BranchCode, ");
            sbQuery.append("br.BranchName, ");

            sbQuery.append("usr.Branch_Modify as BranchCode_Modify, ");
            sbQuery.append("brm.BranchName as BranchName_Modify, ");

            sbQuery.append("usr.MerchantID, ");
            sbQuery.append("cocu.MerchantName, ");

            sbQuery.append("usr.MerchantID_Modify, ");
            sbQuery.append("cocum.MerchantName as CoCuName_Modify, ");

            sbQuery.append("usr.NIC, ");
            sbQuery.append("usr.NIC_Modify, ");
            sbQuery.append("usr.EmpId, ");
            sbQuery.append("usr.EmpId_Modify, ");
            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Name_Modify, ");

            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Designation_Modify, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.Email_Modify, ");
            sbQuery.append("usr.ContactNo, ");
            sbQuery.append("usr.ContactNo_Modify, ");

            sbQuery.append("usr.TokenSerial, ");
            sbQuery.append("usr.TokenSerial_Modify, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.Status_Modify, ");
            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.Remarks_Modify, ");

            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.LastPasswordResetDate, ");
            sbQuery.append("usr.LastLoggingAttempt, ");
            sbQuery.append("usr.LastSuccessfulLogin, ");
            sbQuery.append("usr.LastSuccessfulVisit, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");

            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.AuthorizedBy, ");
            sbQuery.append("usr.AuthorizedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModificationAuthBy, ");
            sbQuery.append("usr.ModificationAuthDate, ");

            sbQuery.append("TIME_TO_SEC(TIMEDIFF(now(), usr.LastLoggingAttempt)) as timeDifference, ");
            sbQuery.append("(IF(usr.UserId=?, ?, ?) - DATEDIFF(now(), usr.LastPasswordResetDate)) as MinPwdValidDays FROM ");

            sbQuery.append(DDM_Constants.tbl_user + " usr, ");

            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");

            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");

            sbQuery.append(DDM_Constants.tbl_merchant + " cocu, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cocum, ");

            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlevel, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " usrlvlm ");

            sbQuery.append("WHERE usr.Bank = bk.BankCode ");
            sbQuery.append("AND usr.Bank_Modify = bkm.BankCode ");

            sbQuery.append("AND usr.Branch = br.BranchCode ");
            sbQuery.append("AND usr.Bank = br.BankCode ");

            sbQuery.append("AND usr.Branch_Modify = brm.BranchCode ");
            sbQuery.append("AND usr.Bank_Modify = brm.BankCode ");

            sbQuery.append("AND IFNULL(usr.MerchantID, '" + DDM_Constants.default_coporate_customer_id + "') = cocu.MerchantID ");
            sbQuery.append("AND IFNULL(usr.MerchantID_Modify, '" + DDM_Constants.default_coporate_customer_id + "') = cocum.MerchantID ");

            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserLevel_Modify = usrlvlm.UserLevelId ");
            sbQuery.append("AND usr.ModificationAuthBy is null ");
            sbQuery.append("AND usr.ModifiedBy != ? ");
            sbQuery.append("AND usr.Status != ? ");

            if (!sessionUserType.equals(DDM_Constants.user_type_ddm_manager))
            {
                sbQuery.append("AND usr.UserLevel != ? ");
            }

            if (modifyType != null)
            {
                if (modifyType.equals(DDM_Constants.status_user_modify_details))
                {
                    sbQuery.append("and usr.Status = usr.Status_Modify ");
                }
                else if (modifyType.equals(DDM_Constants.status_user_modify_deactivate))
                {
                    sbQuery.append("and usr.Status != usr.Status_Modify ");
                    sbQuery.append("and usr.Status_Modify = '" + DDM_Constants.status_deactive + "' ");
                }
                else if (modifyType.equals(DDM_Constants.status_user_modify_activate))
                {
                    sbQuery.append("and usr.Status != usr.Status_Modify ");
                    sbQuery.append("and usr.Status_Modify = '" + DDM_Constants.status_active + "' ");
                }
            }

            sbQuery.append("ORDER BY usr.UserId");

            pstm = con.prepareStatement(sbQuery.toString());

            strSystemUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_SystemUserPwdExpireDuration);

            if (strSystemUserPwdExpireDuration != null)
            {
                try
                {
                    iSystemUserPwdExpireDuration = Integer.parseInt(strSystemUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
                }
            }
            else
            {
                iSystemUserPwdExpireDuration = DDM_Constants.system_pwd_expire_duration;
            }

            strUserPwdExpireDuration = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_UserPwdExpireDuration);

            if (strUserPwdExpireDuration != null)
            {
                try
                {
                    iUserPwdExpireDuration = Integer.parseInt(strUserPwdExpireDuration);
                }
                catch (NumberFormatException e)
                {
                    iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
                }
            }
            else
            {
                iUserPwdExpireDuration = DDM_Constants.user_pwd_expire_duration;
            }

            pstm.setString(1, DDM_Constants.param_id_user_system);
            pstm.setInt(2, iSystemUserPwdExpireDuration);
            pstm.setInt(3, iUserPwdExpireDuration);
            pstm.setString(4, modifiedBy);
            pstm.setString(5, DDM_Constants.status_pending);

            if (!sessionUserType.equals(DDM_Constants.user_type_ddm_manager))
            {
                pstm.setString(6, DDM_Constants.user_type_ddm_manager);
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean doAuthorizeModifiedUser(User usr)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }

        if (usr.getModificationAuthBy() == null)
        {
            System.out.println("WARNING : Null modificationAuthBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set ");

            if (usr.getStatusModify() != null)
            {
                if (usr.getStatusModify().equals(DDM_Constants.status_deactive))
                {
                    sbQuery.append("Status = Status_Modify, ");
                }
                else if (usr.getStatusModify().equals(DDM_Constants.status_active) && usr.getStatus().equals(DDM_Constants.status_expired))
                {
                    sbQuery.append("Status = Status_Modify, LastPasswordResetDate = now(), IsInitialPassword = '" + DDM_Constants.status_yes + "', ");
                }
                else
                {
                    sbQuery.append("Status = Status_Modify, ");
                }
            }
            else
            {
                sbQuery.append("UserLevel = UserLevel_Modify, ");
                sbQuery.append("Bank = Bank_Modify, ");
                sbQuery.append("Branch = Branch_Modify, ");
                sbQuery.append("MerchantID = MerchantID_Modify, ");
                sbQuery.append("NIC = NIC_Modify, ");
                sbQuery.append("EmpId = EmpId_Modify, ");
                sbQuery.append("Name = Name_Modify, ");
                sbQuery.append("Designation = Designation_Modify, ");
                sbQuery.append("Email = Email_Modify, ");
                sbQuery.append("ContactNo = ContactNo_Modify, ");
                sbQuery.append("TokenSerial = TokenSerial_Modify, ");
                sbQuery.append("Remarks = Remarks_Modify, ");
            }

            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where UserId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            //psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(1, usr.getModificationAuthBy());
            psmt.setString(2, usr.getUserId());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (SQLException | ClassNotFoundException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    @Override
    public boolean deactivateLongTimeInactiveUsers()
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set Status = ? ");
            sbQuery.append("where UserId!= ? and Status = ? and (DATEDIFF(now(), LastSuccessfulVisit) > (SELECT ParamValue FROM " + DDM_Constants.tbl_parameter + " where ParamId = ?)) ");

            System.out.println("deactivateLongTimeInactiveUsers(sbQuery)=======>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_deactive);
            psmt.setString(2, DDM_Constants.param_id_user_system);
            psmt.setString(3, DDM_Constants.status_expired);
            psmt.setString(4, DDM_Constants.param_id_InactiveUsersDeactivationDuration);

            count = psmt.executeUpdate();

            if (count >= 0)
            {
                System.out.println("deactivateLongTimeInactiveUsers(sbQuery)=======> successful");
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean updateOTP(String userId, String otp, int otpExpMinutes)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (otp == null)
        {
            System.out.println("WARNING : Null OTP parameter.");
            return false;
        }
        if (otpExpMinutes < 1)
        {
            System.out.println("WARNING : Null OTP parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("set OTP = ? , OTP_ExpireTime = date_add(now(),interval ? minute) ");
            sbQuery.append("where userId = ? ");

            System.out.println("updateOTP(sbQuery) ---> " + sbQuery.toString());
            System.out.println("UserId ---> " + userId);
            System.out.println("OTP ---> " + otp);
            System.out.println("otpExpMinutes ---> " + otpExpMinutes);

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, otp);
            psmt.setInt(2, otpExpMinutes);
            psmt.setString(3, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean isValidOTP(String userId, String otp)
    {
        boolean isValidOTP = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            msg = DDM_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        if (otp == null)
        {
            System.out.println("WARNING : Null OTP parameter.");
            msg = DDM_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsValidOTP FROM ");
            sbQuery.append(DDM_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND OTP = ? ");
            sbQuery.append("AND OTP_ExpireTime >= now() ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);
            pstm.setString(2, otp);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsValidOTP");

                if (count > 0)
                {
                    isValidOTP = true;
                }
                else
                {
                    msg = DDM_Constants.msg_invalid_or_expired_otp;
                }
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isValidOTP;
    }

}
