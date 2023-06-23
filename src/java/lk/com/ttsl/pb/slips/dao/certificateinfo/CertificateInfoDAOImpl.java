/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificateinfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;


/**
 *
 * @author Dinesh
 */
public class CertificateInfoDAOImpl implements CertificateInfoDAO
{

    static String msg;

    public String getMsg()
    {
        return msg;
    }

    public Collection<CertificateInfo> getCertDetails(String bankCode, String validity)
    {
        Collection<CertificateInfo> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_validity = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            //DAOFactory.getCertificateInfoDAO().
            sbQuery.append("SELECT cer.userid, cer.bankcode, bk.FullName, cer.certificateserial, "
                    + "cer.validfrom, cer.validto, cer.tokenserial, cer.IsValid, cer.IsExpired, cer.deviceid, "
                    + "DATEDIFF(str_to_date(validto,'%Y/%m/%d %H:%i:%s'), now()) as DaysToExpire FROM ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " cer, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk ");
            sbQuery.append("WHERE cer.bankcode = bk.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and cer.bankcode = ? ");
                vt.add(val_bankCode);
            }

            if (!validity.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and cer.IsValid = ? ");
                vt.add(val_validity);
            }

            sbQuery.append("ORDER BY bankcode, userid");

            //System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                }
                
                if (val_item == val_validity)
                {
                    pstm.setString(i, validity);
                }

                i++;
            }

            rs = pstm.executeQuery();

            col = CertificateInfoUtil.makeCertificateObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (Exception e)
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

    public CertificateInfo getCertificateDetails(String userID)
    {
        CertificateInfo cert = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userID == null)
        {
            System.out.println("WARNING : Null userID parameter.");
            return cert;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cer.userid, cer.bankcode, bk.FullName, cer.certificateserial, "
                    + "cer.validfrom, cer.validto, cer.tokenserial, cer.IsValid, cer.IsExpired, cer.deviceid, "
                    + "DATEDIFF(str_to_date(validto,'%Y/%m/%d %H:%i:%s'), now()) as DaysToExpire FROM ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " cer, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk ");
            sbQuery.append("WHERE cer.userid = ? ");

            //System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userID);

            rs = pstm.executeQuery();

            cert = CertificateInfoUtil.makeCertificateObject(rs);

            if (cert == null)
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (Exception e)
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

        return cert;
    }

    public boolean updateCertDetails(CertificateInfo cert)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("UPDATE ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " ");
            sbQuery.append("set IsValid = ?, IsExpired = ? where userid = ?");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cert.getStrIsValid());
            psmt.setString(2, cert.getStrIsExpired());
            psmt.setString(3, cert.getUserID());

            //System.out.println("updateCertDetails:-----> " + sbQuery.toString());
            count = psmt.executeUpdate();
            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean updateCertificateValidity(CertificateInfo cert)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " ");
            sbQuery.append("set IsValid = ?, IsExpired = ?, DaysToExpire = ? ");
            sbQuery.append("where userid = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cert.isIsValid() ? "Y" : "N");
            psmt.setString(2, cert.isIsExpired() ? "Y" : "N");
            psmt.setInt(3, cert.getNoOfDaysToExpire());
            psmt.setString(4, cert.getUserID());

            //System.out.println("updateCertDetails:-----> " + sbQuery.toString());
            count = psmt.executeUpdate();
            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

}
