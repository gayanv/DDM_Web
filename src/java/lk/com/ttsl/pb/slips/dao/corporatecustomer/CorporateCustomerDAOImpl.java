/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMap;

/**
 *
 * @author Dinesh
 */
public class CorporateCustomerDAOImpl implements CorporateCustomerDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    /**
     *
     * @param branchCode
     * @param cocuId
     * @param status
     * @return
     */
    @Override
    public Collection<CorporateCustomer> findCoCu(String branchCode, String cocuId, String status)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return col;
        }
        if (cocuId == null)
        {
            System.out.println("WARNING : Null cocuId parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_branchCode = 1;
            int val_cocuid = 2;
            int val_status = 3;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select cc.MerchantID, cc.CoCuName, cc.Branch, br.BranchName, cc.PrimaryAccNo, "
                    + " cc.CoCuAddress, cc.Email, cc.Telephone, cc.Extension, cc.Fax, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUSTOUT_Allowed, cc.Is_DSLIPS_Allowed, cc.Is_FSLIPS_Allowed, "
                    + "cc.Status, cc.CreatedBy, cc.CreatedDate, cc.AuthorizedBy, cc.AuthorizedDate, "
                    + "cc.ModifiedBy, cc.ModifiedDate, cc.ModificationAuthBy, cc.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("WHERE cc.Branch = br.BranchCode ");
            sbQuery.append("AND br.BankCode = ? ");

            if (!branchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Branch = ? ");
                vt.add(val_branchCode);
            }

            if (!cocuId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.MerchantID like ? ");
                vt.add(val_cocuid);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Status = ? ");
                vt.add(val_status);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            //System.out.println("sbQuery ---> " + sbQuery.toString());
            int i = 1;

            pstm.setString(i, DDM_Constants.default_bank_code);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_branchCode)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == val_cocuid)
                {
                    pstm.setString(i, cocuId + "%");
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollectionMinimal(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public CorporateCustomer getCorporateCustomerDetails(String ccID)
    {
        CorporateCustomer cocu = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (ccID == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return cocu;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, "
                    + "ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");
            sbQuery.append("AND cc.MerchantID = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, ccID);

            rs = pstm.executeQuery();

            cocu = CorporateCustomerUtil.makeCorporateCustomerObject(rs);

            if (cocu == null)
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return cocu;
    }

    @Override
    public Collection<CorporateCustomer> getCorporateCustomer()
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");
            sbQuery.append("ORDER BY CoCuID ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {

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
    public Collection<CorporateCustomer> getCorporateCustomer(String status, String branch)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Status = ?  ");
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Branch = ?  ");
            }

            sbQuery.append("ORDER BY CoCuID ");

            //System.out.println("sbQuery(getCorporateCustomer)------> " + sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(i, status);
                i++;
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                pstm.setString(i, branch);
                i++;
            }

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public Collection<CorporateCustomer> getCorporateCustomerBasicDetails(String status, String branch)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select cc.MerchantID, cc.CoCuName, cc.Branch, br.BranchName, cc.PrimaryAccNo, "
                    + " cc.CoCuAddress, cc.Email, cc.Telephone, cc.Extension, cc.Fax, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUSTOUT_Allowed, cc.Is_DSLIPS_Allowed, cc.Is_FSLIPS_Allowed, "
                    + "cc.Status, cc.CreatedBy, cc.CreatedDate, cc.AuthorizedBy, cc.AuthorizedDate, "
                    + "cc.ModifiedBy, cc.ModifiedDate, cc.ModificationAuthBy, cc.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("WHERE cc.Branch = br.BranchCode ");
            sbQuery.append("AND br.BankCode = ? ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Status = ?  ");
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Branch = ?  ");
            }

            sbQuery.append("ORDER BY CoCuID ");

            System.out.println("sbQuery(getCorporateCustomerBasicDetails)------> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_bank_code);
            i++;

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(i, status);
                i++;
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                pstm.setString(i, branch);
                i++;
            }

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollectionMinimal(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public Collection<CorporateCustomer> getCorporateCustomerNotInStatus(String status, String branch)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");
            sbQuery.append("AND cc.Status NOT IN (?) ");

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Branch = ? ");
            }

            sbQuery.append("ORDER BY CoCuID ");

            //System.out.println("sbQuery(getCorporateCustomerNotInStatus)----> " + sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, status);

            if (!branch.equals(DDM_Constants.status_all))
            {
                pstm.setString(2, branch);
            }

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public Collection<CorporateCustomer> getCorporateCustomerNotInStatusBasicDetails(String status, String branch)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select cc.MerchantID, cc.CoCuName, cc.Branch, br.BranchName, cc.PrimaryAccNo, "
                    + " cc.CoCuAddress, cc.Email, cc.Telephone, cc.Extension, cc.Fax, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUSTOUT_Allowed, cc.Is_DSLIPS_Allowed, cc.Is_FSLIPS_Allowed, "
                    + "cc.Status, cc.CreatedBy, cc.CreatedDate, cc.AuthorizedBy, cc.AuthorizedDate, "
                    + "cc.ModifiedBy, cc.ModifiedDate, cc.ModificationAuthBy, cc.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("WHERE cc.Branch = br.BranchCode ");
            sbQuery.append("AND br.BankCode = ? ");
            sbQuery.append("AND cc.Status NOT IN (?) ");

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND cc.Branch = ? ");
            }

            sbQuery.append("ORDER BY CoCuID ");

            //System.out.println("sbQuery(getCorporateCustomerNotInStatus)----> " + sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_bank_code);
            i++;

            pstm.setString(i, status);
            i++;

            if (!branch.equals(DDM_Constants.status_all))
            {
                pstm.setString(i, branch);
            }

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollectionMinimal(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public Collection<CorporateCustomer> getAuthPendingCorporateCustomer(String createdUser)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");
            sbQuery.append("AND cc.Status = ?  ");
            sbQuery.append("AND cc.CreatedBy != ? ");
            sbQuery.append("ORDER BY CoCuID");

            //System.out.println("sbQuery(getAuthPendingCorporateCustomer) -----> " + sbQuery);
            //System.out.println("createdUser -----> " + createdUser);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, DDM_Constants.status_pending);
            pstm.setString(2, createdUser);

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public Collection<CorporateCustomer> getAuthPendingModifiedCorporateCustomer(String modifiedUser)
    {
        Collection<CorporateCustomer> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cc.MerchantID, cc.CoCuName, cc.CoCuName_Modify, cc.Branch, "
                    + "cc.CoCuAddress, cc.CoCuAddress_Modify, cc.Email, cc.Email_Modify, "
                    + "cc.Telephone, cc.Telephone_Modify, cc.Extension, cc.Extension_Modify, cc.Fax, cc.Fax_Modify, "
                    + "cc.PrimaryAccNo, cc.PrimaryAccNo_Modify, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.BranchCode as AccBranch, ai.AccountSubType, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate, "
                    + "cc.Is_CUST1_Allowed, cc.Is_CUST1_Allowed_Modify, cc.Is_CUSTOUT_Allowed, "
                    + "cc.Is_CUSTOUT_Allowed_Modify, cc.Is_DSLIPS_Allowed, cc.Is_DSLIPS_Allowed_Modify, "
                    + "cc.Is_FSLIPS_Allowed, cc.Is_FSLIPS_Allowed_Modify, cc.Status as CoCuStatus, "
                    + "cc.Status_Modify as CoCuStatusModify, cc.CreatedBy, cc.CreatedDate, "
                    + "cc.AuthorizedBy, cc.AuthorizedDate, cc.ModifiedBy, cc.ModifiedDate, "
                    + "cc.ModificationAuthBy, cc.ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " cc, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");
            //sbQuery.append(DDM_Constants.tbl_account_sub_type + " acstp ");
            sbQuery.append("WHERE cc.MerchantID  = ccanm.CoCuID ");
            sbQuery.append("AND ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            //sbQuery.append("AND ai.AccountSubType  = acstp.SubAccType ");

            sbQuery.append("AND cc.ModificationAuthBy is null ");
            sbQuery.append("AND cc.ModifiedBy != ? ");
            sbQuery.append("AND cc.Status != ? ");
            sbQuery.append("ORDER BY CoCuID");

            //System.out.println("getAuthPendingModifiedCorporateCustomer(sbQuery)=========>" + sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, modifiedUser);
            pstm.setString(2, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = CorporateCustomerUtil.makeCorporateCustomerObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
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
    public boolean addCorporateCustomer(CorporateCustomer cc)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (cc.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID  parameter.");
            return false;
        }

        if (cc.getCoCuName() == null)
        {
            System.out.println("WARNING : Null getCoCuName parameter.");
            return false;
        }

        if (cc.getPrimaryAccNo() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccNo parameter.");
            return false;
        }

        if (cc.getCoCuAddress() == null)
        {
            System.out.println("WARNING : Null getCoCuAddress() parameter.");
            return false;
        }

        if (cc.getEmail() == null)
        {
            System.out.println("WARNING : Null getEmail() parameter.");
            return false;
        }

        if (cc.getTelephone() == null)
        {
            System.out.println("WARNING : Null getTelephone() parameter.");
            return false;
        }

        if (cc.getIs_CUST1_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_CUST1_Allowed parameter.");
            return false;
        }

        if (cc.getIs_CUSTOUT_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_CUSTOUT_Allowed parameter.");
            return false;
        }

        if (cc.getIs_DSLIPS_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_DSLIPS_Allowed parameter.");
            return false;
        }

        if (cc.getIs_FSLIPS_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_FSLIPS_Allowed parameter.");
            return false;
        }

        if (cc.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("(CoCuID,CoCuName,CoCuName_Modify,Branch,PrimaryAccNo,PrimaryAccNo_Modify,"
                    + "CoCuAddress,CoCuAddress_Modify,Email,Email_Modify,Telephone,Telephone_Modify,"
                    + "Extension,Extension_Modify,Fax,Fax_Modify,"
                    + "Is_CUST1_Allowed,Is_CUST1_Allowed_Modify,"
                    + "Is_CUSTOUT_Allowed, Is_CUSTOUT_Allowed_Modify, Is_DSLIPS_Allowed, "
                    + "Is_DSLIPS_Allowed_Modify, Is_FSLIPS_Allowed, Is_FSLIPS_Allowed_Modify, "
                    + "Status, Status_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now(),?,now())");

            //System.out.println("addCorporateCustomer(sbQuery)=========>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cc.getCoCuID().trim());
            psmt.setString(2, cc.getCoCuName().trim());
            psmt.setString(3, cc.getCoCuName().trim());
            psmt.setString(4, cc.getPrimaryAccNo().trim().substring(0, 3));
            psmt.setString(5, cc.getPrimaryAccNo().trim());
            psmt.setString(6, cc.getPrimaryAccNo().trim());

            psmt.setString(7, cc.getCoCuAddress().trim());
            psmt.setString(8, cc.getCoCuAddress().trim());

            psmt.setString(9, cc.getEmail().trim());
            psmt.setString(10, cc.getEmail().trim());
            psmt.setString(11, cc.getTelephone().trim());
            psmt.setString(12, cc.getTelephone().trim());
            psmt.setString(13, cc.getExtension());
            psmt.setString(14, cc.getExtension());
            psmt.setString(15, cc.getFax());
            psmt.setString(16, cc.getFax());

            psmt.setString(17, cc.getIs_CUST1_Allowed().trim());
            psmt.setString(18, cc.getIs_CUST1_Allowed().trim());

            psmt.setString(19, cc.getIs_CUSTOUT_Allowed().trim());
            psmt.setString(20, cc.getIs_CUSTOUT_Allowed().trim());

            psmt.setString(21, cc.getIs_DSLIPS_Allowed().trim());
            psmt.setString(22, cc.getIs_DSLIPS_Allowed().trim());

            psmt.setString(23, cc.getIs_FSLIPS_Allowed().trim());
            psmt.setString(24, cc.getIs_FSLIPS_Allowed().trim());

            psmt.setString(25, DDM_Constants.status_pending);
            psmt.setString(26, DDM_Constants.status_pending);

            psmt.setString(27, cc.getModifiedBy().trim());
            psmt.setString(28, cc.getModifiedBy().trim());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                if (DAOFactory.getCorporateCustomerAccNoMapDAO().addCorporateCustomerAccNoMap(new CorporateCustomerAccNoMap(cc.getCoCuID().trim(), cc.getPrimaryAccNo().trim(), DDM_Constants.status_pending, cc.getModifiedBy().trim())))
                {
                    System.out.println("### addCorporateCustomerAccNoMap was Success ####");
                    con.commit();
                    status = true;
                }
                else
                {
                    System.out.println("### addCorporateCustomerAccNoMap was Failed ####");
                    status = true;
                    msg = "Adding records to Corporate Customer Acoount Map Failed.";
                }

            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_duplicate_records;
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

        return status;
    }

    @Override
    public boolean modifyCorporateCustomer(CorporateCustomer cc)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (cc.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID  parameter.");
            return false;
        }

        if (cc.getCoCuName() == null)
        {
            System.out.println("WARNING : Null getCoCuName parameter.");
            return false;
        }

        if (cc.getPrimaryAccNo() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccNo parameter.");
            return false;
        }

        if (cc.getIs_CUST1_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_CUST1_Allowed parameter.");
            return false;
        }

        if (cc.getIs_CUSTOUT_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_CUSTOUT_Allowed parameter.");
            return false;
        }

        if (cc.getIs_DSLIPS_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_DSLIPS_Allowed parameter.");
            return false;
        }

        if (cc.getIs_FSLIPS_Allowed() == null)
        {
            System.out.println("WARNING : Null getIs_FSLIPS_Allowed parameter.");
            return false;
        }

        if (cc.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("CoCuName_Modify = ?, ");
            sbQuery.append("CoCuAddress_Modify = ?, ");
            sbQuery.append("PrimaryAccNo_Modify = ?, ");
            sbQuery.append("Email_Modify = ?, ");
            sbQuery.append("Telephone_Modify = ?, ");
            sbQuery.append("Extension_Modify = ?, ");
            sbQuery.append("Fax_Modify = ?, ");
            sbQuery.append("Is_CUST1_Allowed_Modify = ?, ");
            sbQuery.append("Is_CUSTOUT_Allowed_Modify = ?, ");
            sbQuery.append("Is_DSLIPS_Allowed_Modify = ?, ");
            sbQuery.append("Is_FSLIPS_Allowed_Modify = ?, ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = now(), ");
            sbQuery.append("ModificationAuthBy = null, ");
            sbQuery.append("ModificationAuthDate = null ");
            sbQuery.append("where CoCuID = ? ");

            //System.out.println("modifyBank(sbQuery)=====>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cc.getCoCuName());
            psmt.setString(2, cc.getCoCuAddress());
            psmt.setString(3, cc.getPrimaryAccNo());
            psmt.setString(4, cc.getEmail());
            psmt.setString(5, cc.getTelephone());
            psmt.setString(6, cc.getExtension());
            psmt.setString(7, cc.getFax());
            psmt.setString(8, cc.getIs_CUST1_Allowed());
            psmt.setString(9, cc.getIs_CUSTOUT_Allowed());
            psmt.setString(10, cc.getIs_DSLIPS_Allowed());
            psmt.setString(11, cc.getIs_FSLIPS_Allowed());
            psmt.setString(12, cc.getStatus());
            psmt.setString(13, cc.getModifiedBy());
            psmt.setString(14, cc.getCoCuID());

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
    public boolean doAuthorizedCorporateCustomer(CorporateCustomer cc)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (cc.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID  parameter.");
            return false;
        }

        if (cc.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null authorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate = now(), ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where CoCuID = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_active);
            psmt.setString(3, cc.getAuthorizedBy());
            psmt.setString(4, cc.getAuthorizedBy());
            psmt.setString(5, cc.getCoCuID());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                if (DAOFactory.getCorporateCustomerAccNoMapDAO().doAuthorizedCorporateCustomerAccNoMap(new CorporateCustomerAccNoMap(cc.getCoCuID().trim(), cc.getAuthorizedBy().trim())))
                {
                    System.out.println("### doAuthorizedCorporateCustomerAccNoMap was Success ####");
                    con.commit();
                    status = true;
                }
                else
                {
                    System.out.println("### doAuthorizedCorporateCustomerAccNoMap was Failed ####");
                    status = true;
                    msg = "Authorized records of Corporate Customer Acoount Map Failed.";
                }
            }
            else
            {
                con.rollback();
            }

        }
        catch (SQLException | ClassNotFoundException | NumberFormatException ex)
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
    public boolean doAuthorizeModifiedCorporateCustomer(CorporateCustomer cc)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (cc.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID  parameter.");
            return false;
        }

        if (cc.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null authorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("CoCuName = CoCuName_Modify, ");
            sbQuery.append("CoCuAddress = CoCuAddress_Modify, ");
            sbQuery.append("PrimaryAccNo = PrimaryAccNo_Modify, ");
            sbQuery.append("Is_CUST1_Allowed = Is_CUST1_Allowed_Modify, ");
            sbQuery.append("Is_CUSTOUT_Allowed = Is_CUSTOUT_Allowed_Modify, ");
            sbQuery.append("Is_DSLIPS_Allowed = Is_DSLIPS_Allowed_Modify, ");
            sbQuery.append("Is_FSLIPS_Allowed = Is_FSLIPS_Allowed_Modify, ");
            sbQuery.append("Status = Status_Modify, ");

            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where CoCuID = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cc.getAuthorizedBy());
            psmt.setString(2, cc.getCoCuID());

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

}
