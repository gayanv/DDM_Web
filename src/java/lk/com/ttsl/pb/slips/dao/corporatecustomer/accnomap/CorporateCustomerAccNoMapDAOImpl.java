/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class CorporateCustomerAccNoMapDAOImpl implements CorporateCustomerAccNoMapDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public Collection<CorporateCustomerAccNoMap> getCorporateCustomerAccounts(String ccID, String status)
    {
        Collection<CorporateCustomerAccNoMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (ccID == null)
        {
            System.out.println("WARNING : Null ccID parameter.");
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

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ccanm.CoCuID, ccanm.AccNo, ai.AccountHolderName, "
                    + "CONCAT(ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4) as  AccAddress, "
                    + "ai.AccountSubType, ai.BranchCode as AccBranch, "
                    + "ai.AccountStatus, acst.StatusDesc as AccStatusDesc, ccanm.Status as AccNoMapStatus, "
                    + "ccanm.Status_Modify as AccNoMapStatusModify, ccanm.CreatedBy as AccNoMapCreatedBy, "
                    + "ccanm.CreatedDate as AccNoMapCreatedDate, ccanm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "ccanm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "ccanm.ModifiedBy as AccNoMapModifiedBy, ccanm.ModifiedDate as AccNoMapModifiedDate, "
                    + "ccanm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "ccanm.ModificationAuthDate as AccNoMapModificationAuthDate FROM ");

            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ccanm, ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acst ");

            sbQuery.append("WHERE ccanm.AccNo  = ai.AccountNo ");
            sbQuery.append("AND ai.AccountStatus  = acst.Status ");
            
            sbQuery.append("AND ccanm.CoCuID = ? ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ccanm.Status = ? ");
            }

            sbQuery.append("ORDER BY ccanm.AccNo ");

            System.out.println("sbQuery(getCorporateCustomerNotInStatus)----> " + sbQuery);
            
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, ccID);

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(2, status);
            }

            rs = pstm.executeQuery();

            col = CorporateCustomerAccNoMapUtil.makeCorporateCustomerAccountMapObjectCollection(rs);

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
    public boolean addCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (ccanm.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID()  parameter.");
            return false;
        }

        if (ccanm.getAccNo() == null)
        {
            System.out.println("WARNING : Null getAccNo() parameter.");
            return false;
        }

        if (ccanm.getStatus() == null)
        {
            System.out.println("WARNING : Null getStatus() parameter.");
            return false;
        }

        if (ccanm.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy() parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ");
            sbQuery.append("(CoCuID,AccNo,Status,Status_Modify,"
                    + "CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now(),?,now())");

            //System.out.println("addCorporateCustomerAccNoMap(sbQuery)=========>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, ccanm.getCoCuID().trim());
            psmt.setString(2, ccanm.getAccNo().trim());
            psmt.setString(3, ccanm.getStatus().trim());
            psmt.setString(4, ccanm.getStatus().trim());
            psmt.setString(5, ccanm.getModifiedBy().trim());
            psmt.setString(6, ccanm.getModifiedBy().trim());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
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
    public boolean modifyCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm)
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean doAuthorizedCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (ccanm.getCoCuID() == null)
        {
            System.out.println("WARNING : Null getCoCuID()  parameter.");
            return false;
        }

        if (ccanm.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ");
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
            psmt.setString(3, ccanm.getAuthorizedBy());
            psmt.setString(4, ccanm.getAuthorizedBy());
            psmt.setString(5, ccanm.getCoCuID());

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
        catch (SQLException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (ClassNotFoundException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (NumberFormatException ex)
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
    public boolean doAuthorizeModifiedCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm)
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
