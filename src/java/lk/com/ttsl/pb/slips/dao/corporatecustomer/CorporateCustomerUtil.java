/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMap;

/**
 *
 * @author Dinesh - ProntoIT
 */
class CorporateCustomerUtil
{

    private CorporateCustomerUtil()
    {
    }

    static CorporateCustomer makeCorporateCustomerObject(ResultSet rs) throws SQLException
    {

        String prev_CoCuID = "";
        CorporateCustomer cc = null;
        CorporateCustomerAccNoMap ccanm = null;

        if (rs != null && rs.isBeforeFirst())
        {
            Collection<CorporateCustomerAccNoMap> result2 = new java.util.ArrayList();

            while (rs.next())
            {
                if (prev_CoCuID.equals(rs.getString("CoCuID")))
                {
                    ccanm = new CorporateCustomerAccNoMap();

                    ccanm.setAccNo(rs.getString("AccNo"));
                    ccanm.setAccName(rs.getString("AccountHolderName"));
                    ccanm.setAccAddress(rs.getString("AccAddress"));
                    ccanm.setAccBranch(rs.getString("AccBranch"));
                    ccanm.setAccType(rs.getString("AccountSubType"));
                    //ccanm.setAccTypeDesc(rs.getString("SubAccDesc"));
                    ccanm.setAccStatus(rs.getString("AccountStatus"));
                    ccanm.setAccStatusDesc(rs.getString("AccStatusDesc"));
                    ccanm.setStatus(rs.getString("AccNoMapStatus"));
                    ccanm.setStatusModify(rs.getString("AccNoMapStatusModify"));

                    ccanm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

                    if (rs.getTimestamp("AccNoMapCreatedDate") != null)
                    {
                        ccanm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
                    }

                    ccanm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

                    if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
                    {
                        ccanm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
                    }

                    ccanm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

                    if (rs.getTimestamp("AccNoMapModifiedDate") != null)
                    {
                        ccanm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
                    }

                    ccanm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

                    if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
                    {
                        ccanm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
                    }

                    result2.add(ccanm);

                }
                else
                {
                    cc = new CorporateCustomer();

                    prev_CoCuID = rs.getString("CoCuID");

                    cc.setCoCuID(rs.getString("CoCuID"));
                    cc.setCoCuName(rs.getString("CoCuName"));
                    cc.setCoCuNameModify(rs.getString("CoCuName_Modify"));
                    cc.setCoCuBranch(rs.getString("Branch"));

                    cc.setCoCuAddress(rs.getString("CoCuAddress"));
                    cc.setCoCuAddressModify(rs.getString("CoCuAddress_Modify"));

                    cc.setPrimaryAccNo(rs.getString("PrimaryAccNo"));
                    cc.setPrimaryAccNoModify(rs.getString("PrimaryAccNo_Modify"));

                    ccanm = new CorporateCustomerAccNoMap();

                    ccanm.setAccNo(rs.getString("AccNo"));
                    ccanm.setAccName(rs.getString("AccountHolderName"));
                    ccanm.setAccAddress(rs.getString("AccAddress"));
                    ccanm.setAccBranch(rs.getString("AccBranch"));
                    ccanm.setAccType(rs.getString("AccountSubType"));
                    //ccanm.setAccTypeDesc(rs.getString("SubAccDesc"));
                    ccanm.setAccStatus(rs.getString("AccountStatus"));
                    ccanm.setAccStatusDesc(rs.getString("AccStatusDesc"));
                    ccanm.setStatus(rs.getString("AccNoMapStatus"));
                    ccanm.setStatusModify(rs.getString("AccNoMapStatusModify"));

                    ccanm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

                    if (rs.getTimestamp("AccNoMapCreatedDate") != null)
                    {
                        ccanm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
                    }

                    ccanm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

                    if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
                    {
                        ccanm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
                    }

                    ccanm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

                    if (rs.getTimestamp("AccNoMapModifiedDate") != null)
                    {
                        ccanm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
                    }

                    ccanm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

                    if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
                    {
                        ccanm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
                    }

                    result2.add(ccanm);
                    cc.setColAccNoMap(result2);

                    cc.setCoCuAddress(rs.getString("CoCuAddress"));
                    cc.setCoCuAddressModify(rs.getString("CoCuAddress_Modify"));

                    cc.setEmail(rs.getString("Email"));
                    cc.setEmailModify(rs.getString("Email_Modify"));

                    cc.setTelephone(rs.getString("Telephone"));
                    cc.setTelephoneModify(rs.getString("Telephone_Modify"));

                    cc.setExtension(rs.getString("Extension"));
                    cc.setExtensionModify(rs.getString("Extension_Modify"));

                    cc.setFax(rs.getString("Fax"));
                    cc.setFaxModify(rs.getString("Fax_Modify"));

                    cc.setIs_CUST1_Allowed(rs.getString("Is_CUST1_Allowed"));
                    cc.setIs_CUST1_AllowedModify(rs.getString("Is_CUST1_Allowed_Modify"));

                    cc.setIs_CUSTOUT_Allowed(rs.getString("Is_CUSTOUT_Allowed"));
                    cc.setIs_CUSTOUT_AllowedModify(rs.getString("Is_CUSTOUT_Allowed_Modify"));

                    cc.setIs_DSLIPS_Allowed(rs.getString("Is_DSLIPS_Allowed"));
                    cc.setIs_DSLIPS_AllowedModify(rs.getString("Is_DSLIPS_Allowed_Modify"));

                    cc.setIs_FSLIPS_Allowed(rs.getString("Is_FSLIPS_Allowed"));
                    cc.setIs_FSLIPS_AllowedModify(rs.getString("Is_FSLIPS_Allowed_Modify"));

                    cc.setStatus(rs.getString("CoCuStatus"));
                    cc.setStatusModify(rs.getString("CoCuStatusModify"));

                    cc.setCreatedBy(rs.getString("CreatedBy"));

                    if (rs.getTimestamp("CreatedDate") != null)
                    {
                        cc.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    cc.setAuthorizedBy(rs.getString("AuthorizedBy"));

                    if (rs.getTimestamp("AuthorizedDate") != null)
                    {
                        cc.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    cc.setModifiedBy(rs.getString("ModifiedBy"));

                    if (rs.getTimestamp("ModifiedDate") != null)
                    {
                        cc.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    cc.setModificationAuthBy(rs.getString("ModificationAuthBy"));

                    if (rs.getTimestamp("ModificationAuthDate") != null)
                    {
                        cc.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                }

            }

        }

        return cc;
    }

    static Collection<CorporateCustomer> makeCorporateCustomerObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CorporateCustomer> result = new java.util.ArrayList();
        Collection<CorporateCustomerAccNoMap> result2 = null;

        String prev_CoCuID = "";
        CorporateCustomer cc = null;
        CorporateCustomerAccNoMap ccanm = null;

        while (rs.next())
        {
            if (prev_CoCuID.equals(rs.getString("MerchantID")))
            {
                ccanm = new CorporateCustomerAccNoMap();

                ccanm.setAccNo(rs.getString("AccNo"));
                ccanm.setAccName(rs.getString("AccountHolderName"));
                ccanm.setAccAddress(rs.getString("AccAddress"));
                ccanm.setAccBranch(rs.getString("AccBranch"));
                ccanm.setAccType(rs.getString("AccountSubType"));
                //ccanm.setAccTypeDesc(rs.getString("SubAccDesc"));
                ccanm.setAccStatus(rs.getString("AccountStatus"));
                ccanm.setAccStatusDesc(rs.getString("AccStatusDesc"));
                ccanm.setStatus(rs.getString("AccNoMapStatus"));
                ccanm.setStatusModify(rs.getString("AccNoMapStatusModify"));

                ccanm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

                if (rs.getTimestamp("AccNoMapCreatedDate") != null)
                {
                    ccanm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
                }

                ccanm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

                if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
                {
                    ccanm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
                }

                ccanm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

                if (rs.getTimestamp("AccNoMapModifiedDate") != null)
                {
                    ccanm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
                }

                ccanm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

                if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
                {
                    ccanm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
                }

                result2.add(ccanm);

            }
            else
            {
                cc = new CorporateCustomer();

                prev_CoCuID = rs.getString("CoCuID");

                cc.setCoCuID(rs.getString("CoCuID"));
                cc.setCoCuName(rs.getString("CoCuName"));
                cc.setCoCuNameModify(rs.getString("CoCuName_Modify"));
                cc.setCoCuBranch(rs.getString("Branch"));

                cc.setPrimaryAccNo(rs.getString("PrimaryAccNo"));
                cc.setPrimaryAccNoModify(rs.getString("PrimaryAccNo_Modify"));

                ccanm = new CorporateCustomerAccNoMap();

                ccanm.setAccNo(rs.getString("AccNo"));
                ccanm.setAccName(rs.getString("AccountHolderName"));
                ccanm.setAccAddress(rs.getString("AccAddress"));
                ccanm.setAccBranch(rs.getString("AccBranch"));
                ccanm.setAccType(rs.getString("AccountSubType"));
                //ccanm.setAccTypeDesc(rs.getString("SubAccDesc"));
                ccanm.setAccStatus(rs.getString("AccountStatus"));
                ccanm.setAccStatusDesc(rs.getString("AccStatusDesc"));
                ccanm.setStatus(rs.getString("AccNoMapStatus"));
                ccanm.setStatusModify(rs.getString("AccNoMapStatusModify"));

                ccanm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

                if (rs.getTimestamp("AccNoMapCreatedDate") != null)
                {
                    ccanm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
                }

                ccanm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

                if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
                {
                    ccanm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
                }

                ccanm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

                if (rs.getTimestamp("AccNoMapModifiedDate") != null)
                {
                    ccanm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
                }

                ccanm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

                if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
                {
                    ccanm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
                }

                result2 = new java.util.ArrayList();
                result2.add(ccanm);

                cc.setColAccNoMap(result2);

                cc.setCoCuAddress(rs.getString("CoCuAddress"));
                cc.setCoCuAddressModify(rs.getString("CoCuAddress_Modify"));

                cc.setEmail(rs.getString("Email"));
                cc.setEmailModify(rs.getString("Email_Modify"));

                cc.setTelephone(rs.getString("Telephone"));
                cc.setTelephoneModify(rs.getString("Telephone_Modify"));

                cc.setExtension(rs.getString("Extension"));
                cc.setExtensionModify(rs.getString("Extension_Modify"));

                cc.setFax(rs.getString("Fax"));
                cc.setFaxModify(rs.getString("Fax_Modify"));

                cc.setIs_CUST1_Allowed(rs.getString("Is_CUST1_Allowed"));
                cc.setIs_CUST1_AllowedModify(rs.getString("Is_CUST1_Allowed_Modify"));

                cc.setIs_CUSTOUT_Allowed(rs.getString("Is_CUSTOUT_Allowed"));
                cc.setIs_CUSTOUT_AllowedModify(rs.getString("Is_CUSTOUT_Allowed_Modify"));

                cc.setIs_DSLIPS_Allowed(rs.getString("Is_DSLIPS_Allowed"));
                cc.setIs_DSLIPS_AllowedModify(rs.getString("Is_DSLIPS_Allowed_Modify"));

                cc.setIs_FSLIPS_Allowed(rs.getString("Is_FSLIPS_Allowed"));
                cc.setIs_FSLIPS_AllowedModify(rs.getString("Is_FSLIPS_Allowed_Modify"));

                cc.setStatus(rs.getString("CoCuStatus"));
                cc.setStatusModify(rs.getString("CoCuStatusModify"));

                cc.setCreatedBy(rs.getString("CreatedBy"));

                if (rs.getTimestamp("CreatedDate") != null)
                {
                    cc.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                cc.setAuthorizedBy(rs.getString("AuthorizedBy"));

                if (rs.getTimestamp("AuthorizedDate") != null)
                {
                    cc.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                cc.setModifiedBy(rs.getString("ModifiedBy"));

                if (rs.getTimestamp("ModifiedDate") != null)
                {
                    cc.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                cc.setModificationAuthBy(rs.getString("ModificationAuthBy"));

                if (rs.getTimestamp("ModificationAuthDate") != null)
                {
                    cc.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                result.add(cc);

            }

        }

        return result;
    }

    static Collection<CorporateCustomer> makeCorporateCustomerObjectsCollectionMinimal(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CorporateCustomer> result = new java.util.ArrayList();

        while (rs.next())
        {
            CorporateCustomer cc = new CorporateCustomer();

            cc.setCoCuID(rs.getString("CoCuID"));
            cc.setCoCuName(rs.getString("CoCuName"));
            cc.setCoCuBranch(rs.getString("Branch"));
            cc.setCoCuBranchName(rs.getString("BranchName"));
            cc.setPrimaryAccNo(rs.getString("PrimaryAccNo"));
            cc.setCoCuAddress(rs.getString("CoCuAddress"));
            cc.setEmail(rs.getString("Email"));
            cc.setTelephone(rs.getString("Telephone"));
            cc.setExtension(rs.getString("Extension"));
            cc.setFax(rs.getString("Fax"));
            cc.setIs_CUST1_Allowed(rs.getString("Is_CUST1_Allowed"));
            cc.setIs_CUSTOUT_Allowed(rs.getString("Is_CUSTOUT_Allowed"));
            cc.setIs_DSLIPS_Allowed(rs.getString("Is_DSLIPS_Allowed"));
            cc.setIs_FSLIPS_Allowed(rs.getString("Is_FSLIPS_Allowed"));
            cc.setStatus(rs.getString("Status"));

            cc.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                cc.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cc.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                cc.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cc.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                cc.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cc.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                cc.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(cc);

        }

        return result;
    }

}
