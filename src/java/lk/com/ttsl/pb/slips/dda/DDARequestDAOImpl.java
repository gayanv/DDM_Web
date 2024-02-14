/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dda;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author TTSADMIN
 */
public class DDARequestDAOImpl implements DDARequestDAO {

    private String msg = null;

    @Override
    public String getMsg() {
        return this.msg;
    }

    @Override
    public boolean addDDARequest(DDARequest ddaRequest) {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (ddaRequest.getDDAID() == null) {
            System.out.println("WARNING : Null getDDAID parameter.");
            return false;
        }

        if (ddaRequest.getMerchantID() == null) {
            System.out.println("WARNING : Null getMerchantID parameter.");
            return false;
        }

        if (ddaRequest.getIssuningBank() == null) {
            System.out.println("WARNING : Null getIssuningBank parameter.");
            return false;
        }

        if (ddaRequest.getIssuningBranch() == null) {
            System.out.println("WARNING : Null getIssuningBranch parameter.");
            return false;
        }

        if (ddaRequest.getIssuningAcNo() == null) {
            System.out.println("WARNING : Null getIssuningAcNo parameter.");
            return false;
        }

        if (ddaRequest.getIssuningAcName() == null) {
            System.out.println("WARNING : Null getIssuningAcName parameter.");
            return false;
        }

        if (ddaRequest.getStartDate() == null) {
            System.out.println("WARNING : Null getStartDate parameter.");
            return false;
        }

        if (ddaRequest.getEndDate() == null) {
            System.out.println("WARNING : Null getEndDate parameter.");
            return false;
        }

        if (ddaRequest.getMaxLimit() == null) {
            System.out.println("WARNING : Null getMaxLimit parameter.");
            return false;
        }

        if (ddaRequest.getFrequency() == null) {
            System.out.println("WARNING : Null getFrequency parameter.");
            return false;
        }

        if (ddaRequest.getPurpose() == null) {
            System.out.println("WARNING : Null getPurpose parameter.");
            return false;
        }
        if (ddaRequest.getRef() == null) {
            System.out.println("WARNING : Null getRef parameter.");
            return false;
        }
        if (ddaRequest.getStatus() == null) {
            System.out.println("WARNING : Null getStatus parameter.");
            return false;
        }
        if (ddaRequest.getAquiringBank() == null) {
            System.out.println("WARNING : Null getAquiringBank parameter.");
            return false;
        }
        if (ddaRequest.getAquiringBranch() == null) {
            System.out.println("WARNING : Null getAquiringBranch parameter.");
            return false;
        }
        if (ddaRequest.getAquiringAcNo() == null) {
            System.out.println("WARNING : Null getAquiringAcNo parameter.");
            return false;
        }
        if (ddaRequest.getAquiringAcName() == null) {
            System.out.println("WARNING : Null getAquiringAcName parameter.");
            return false;
        }
        if (ddaRequest.getCreatedBy() == null) {
            System.out.println("WARNING : Null getCreatedBy parameter.");
            return false;
        }

        try {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            final StringBuilder sqlQuery = new StringBuilder("INSERT INTO ")
                    .append(DDM_Constants.tbl_ddmrequest).append(" (")
                    .append("DDAID, MerchantID, ")
                    .append("IssuningBank, IssuningBranch, IssuningAcNo, IssuningAcName, ")
                    .append("StartDate, EndDate, MaxLimit, Frequency, Purpose, Ref, Status, ")
                    .append("AquiringBank, AquiringBranch, AquiringAcNo, AquiringAcName, ")
                    .append("CreatedBy, CreatedDate ")
                    .append(") ")
                    .append("VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now())");

            System.out.println("addDDARequest(sqlQuery)=========>" + sqlQuery.toString());

            psmt = con.prepareStatement(sqlQuery.toString());

            psmt.setString(1, ddaRequest.getDDAID().trim());
            psmt.setString(2, ddaRequest.getMerchantID().trim());
            psmt.setString(3, ddaRequest.getIssuningBank().trim());
            psmt.setString(4, ddaRequest.getIssuningBranch().trim());
            psmt.setString(5, ddaRequest.getIssuningAcNo().trim());
            psmt.setString(6, ddaRequest.getIssuningAcName().trim());
            psmt.setString(7, ddaRequest.getStartDate().trim());
            psmt.setString(8, ddaRequest.getEndDate().trim());
            psmt.setString(9, ddaRequest.getMaxLimit().trim());
            psmt.setString(10, ddaRequest.getFrequency().trim());
            psmt.setString(11, ddaRequest.getPurpose().trim());
            psmt.setString(12, ddaRequest.getRef().trim());
            psmt.setString(13, ddaRequest.getStatus().trim());
            psmt.setString(14, ddaRequest.getAquiringBank().trim());
            psmt.setString(15, ddaRequest.getAquiringBranch().trim());
            psmt.setString(16, ddaRequest.getAquiringAcNo().trim());
            psmt.setString(17, ddaRequest.getAquiringAcName().trim());
            psmt.setString(18, ddaRequest.getCreatedBy().trim());

            count = psmt.executeUpdate();

            if (count > 0) {
                System.out.println("### addDDARequest was Success ####");
                con.commit();
                status = true;
            } else {
                status = false;
                msg = DDM_Constants.msg_duplicate_records;
            }
        } catch (SQLException | ClassNotFoundException e) {
            msg = e.getMessage();
            System.out.println(e.toString());
        } finally {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

}
