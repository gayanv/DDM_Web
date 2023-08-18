/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.user;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class UserUtil
{

    private UserUtil()
    {
    }

    static Collection<User> makeUserIdObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<User> result = new java.util.ArrayList();

        while (rs.next())
        {
            User user = new User(rs.getString("UserId"));

            result.add(user);
        }

        return result;
    }

    static Collection<User> makeUserId_LevelObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<User> result = new java.util.ArrayList();

        while (rs.next())
        {
            User user = new User();

            user.setUserId(rs.getString("UserId"));
            user.setUserLevelId(rs.getString("UserLevel"));

            result.add(user);
        }

        return result;
    }

    static Collection<User> makeUserObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<User> result = new java.util.ArrayList();

        while (rs.next())
        {
            User user = new User();

            user.setUserId(rs.getString("UserId"));

            user.setUserLevelId(rs.getString("UserLevelId"));
            user.setUserLevelDesc(rs.getString("UserLevelDesc"));

            user.setUserLevelIdModify(rs.getString("UserLevelId_Modify"));
            user.setUserLevelDescModify(rs.getString("UserLevelDesc_Modify"));

            user.setBankCode(rs.getString("BankCode"));
            user.setBankFullName(rs.getString("BankFullName"));
            user.setBankShortName(rs.getString("BankShortName"));

            user.setBankCodeModify(rs.getString("BankCode_Modify"));
            user.setBankFullNameModify(rs.getString("BankFullName_Modify"));
            user.setBankShortNameModify(rs.getString("BankShortName_Modify"));

            user.setBranchCode(rs.getString("BranchCode"));
            user.setBranchName(rs.getString("BranchName"));

            user.setBranchCodeModify(rs.getString("BranchCode_Modify"));
            user.setBranchNameModify(rs.getString("BranchName_Modify"));

            user.setCoCuId(rs.getString("MerchantID"));
            user.setCoCuName(rs.getString("MerchantName"));

            user.setCoCuIdModify(rs.getString("MerchantID_Modify"));
            user.setCoCuNameModify(rs.getString("CoCuName_Modify"));

            user.setNIC(rs.getString("NIC"));
            user.setNICModify(rs.getString("NIC_Modify"));

            user.setEmpId(rs.getString("EmpId"));
            user.setEmpIdModify(rs.getString("EmpId_Modify"));

            user.setName(rs.getString("Name"));
            user.setNameModify(rs.getString("Name_Modify"));

            user.setDesignation(rs.getString("Designation"));
            user.setDesignationModify(rs.getString("Designation_Modify"));

            user.setEmail(rs.getString("Email"));
            user.setEmailModify(rs.getString("Email_Modify"));

            user.setContactNo(rs.getString("ContactNo"));
            user.setContactNoModify(rs.getString("ContactNo_Modify"));

            user.setTokenSerial(rs.getString("TokenSerial"));
            user.setTokenSerialModify(rs.getString("TokenSerial_Modify"));

            user.setStatus(rs.getString("Status"));
            user.setStatusModify(rs.getString("Status_Modify"));

            user.setRemarks(rs.getString("Remarks"));
            user.setRemarksModify(rs.getString("Remarks_Modify"));

            if (rs.getTimestamp("LastPasswordResetDate") != null)
            {
                user.setLastPasswordResetDate(DateFormatter.doFormat(rs.getTimestamp("LastPasswordResetDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setIsInitialPassword(rs.getString("IsInitialPassword"));
            user.setUnSccessfulLoggingAttempts(rs.getInt("UnSuccessfulLoggingAttempts"));

            if (rs.getTimestamp("LastLoggingAttempt") != null)
            {
                user.setLastLoggingAttempt(DateFormatter.doFormat(rs.getTimestamp("LastLoggingAttempt").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastSuccessfulLogin") != null)
            {
                user.setLastSuccessfulLogin(DateFormatter.doFormat(rs.getTimestamp("LastSuccessfulLogin").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastSuccessfulVisit") != null)
            {
                user.setLastSuccessfulVisit(DateFormatter.doFormat(rs.getTimestamp("LastSuccessfulVisit").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                user.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                user.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                user.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                user.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setTimeDiff(rs.getLong("timeDifference"));
            user.setMinPwdValidDays(rs.getInt("MinPwdValidDays"));

            result.add(user);
        }

        return result;
    }

    static User makeUserObject(ResultSet rs) throws SQLException
    {
        User user = null;

        if (rs == null)
        {
            System.out.println("WARNING : Null resultset parameter.");
            return user;
        }

        if (rs.isBeforeFirst())
        {
            rs.next();

            user = new User();

            user.setUserId(rs.getString("UserId"));

            user.setUserLevelId(rs.getString("UserLevelId"));
            user.setUserLevelDesc(rs.getString("UserLevelDesc"));

            user.setUserLevelIdModify(rs.getString("UserLevelId_Modify"));
            user.setUserLevelDescModify(rs.getString("UserLevelDesc_Modify"));

            user.setBankCode(rs.getString("BankCode"));
            user.setBankFullName(rs.getString("BankFullName"));
            user.setBankShortName(rs.getString("BankShortName"));

            user.setBankCodeModify(rs.getString("BankCode_Modify"));
            user.setBankFullNameModify(rs.getString("BankFullName_Modify"));
            user.setBankShortNameModify(rs.getString("BankShortName_Modify"));

            user.setBranchCode(rs.getString("BranchCode"));
            user.setBranchName(rs.getString("BranchName"));

            user.setBranchCodeModify(rs.getString("BranchCode_Modify"));
            user.setBranchNameModify(rs.getString("BranchName_Modify"));

            user.setCoCuId(rs.getString("MerchantID"));
            user.setCoCuName(rs.getString("MerchantName"));

            user.setCoCuIdModify(rs.getString("MerchantID_Modify"));
            user.setCoCuNameModify(rs.getString("CoCuName_Modify"));

            user.setNIC(rs.getString("NIC"));
            user.setNICModify(rs.getString("NIC_Modify"));

            user.setEmpId(rs.getString("EmpId"));
            user.setEmpIdModify(rs.getString("EmpId_Modify"));

            user.setName(rs.getString("Name"));
            user.setNameModify(rs.getString("Name_Modify"));

            user.setDesignation(rs.getString("Designation"));
            user.setDesignationModify(rs.getString("Designation_Modify"));

            user.setEmail(rs.getString("Email"));
            user.setEmailModify(rs.getString("Email_Modify"));

            user.setContactNo(rs.getString("ContactNo"));
            user.setContactNoModify(rs.getString("ContactNo_Modify"));

            user.setTokenSerial(rs.getString("TokenSerial"));
            user.setTokenSerialModify(rs.getString("TokenSerial_Modify"));

            user.setStatus(rs.getString("Status"));
            user.setStatusModify(rs.getString("Status_Modify"));

            user.setRemarks(rs.getString("Remarks"));
            user.setRemarksModify(rs.getString("Remarks_Modify"));

            if (rs.getTimestamp("LastPasswordResetDate") != null)
            {
                user.setLastPasswordResetDate(DateFormatter.doFormat(rs.getTimestamp("LastPasswordResetDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setIsInitialPassword(rs.getString("IsInitialPassword"));
            user.setUnSccessfulLoggingAttempts(rs.getInt("UnSuccessfulLoggingAttempts"));

            if (rs.getTimestamp("LastLoggingAttempt") != null)
            {
                user.setLastLoggingAttempt(DateFormatter.doFormat(rs.getTimestamp("LastLoggingAttempt").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastSuccessfulLogin") != null)
            {
                user.setLastSuccessfulLogin(DateFormatter.doFormat(rs.getTimestamp("LastSuccessfulLogin").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastSuccessfulVisit") != null)
            {
                user.setLastSuccessfulVisit(DateFormatter.doFormat(rs.getTimestamp("LastSuccessfulVisit").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                user.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                user.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                user.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                user.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setTimeDiff(rs.getLong("timeDifference"));

            user.setMinPwdValidDays(rs.getInt("MinPwdValidDays"));
        }

        return user;
    }

}
