/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportmap;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

public class ReportMapDAOImpl implements ReportMapDAO
{

    static String msg;

    public String getMsg()
    {
        return msg;
    }

    /**
     *
     * @param srcBankCode
     * @param desBankCode
     * @param session
     * @param status
     * @return
     */
    public Collection<ReportMap> getReportMapDetails(String srcBankCode, String desBankCode, String session, String status)
    {

        Collection<ReportMap> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (srcBankCode == null)
        {
            System.out.println("WARNING : Null srcBankCode parameter.");
            return col;
        }

        if (desBankCode == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }

        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_srcBankCode = 1;
            int val_desBankCode = 2;
            int val_session = 3;
            int val_status = 4;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select rmp.SrcBank, sb.ShortName as S_ShortName, sb.FullName as S_FullName, rmp.SrcFileName, rmp.DesBank, db.ShortName as D_ShortName, db.FullName as D_FullName, rmp.DesFileName, rmp.RelevantSession, rmp.Status, rmp.ModifiedBy, rmp.ModifiedTime  from ");
            sbQuery.append(DDM_Constants.tbl_reportmap + " rmp, ");
            sbQuery.append(DDM_Constants.tbl_bank + " sb, ");
            sbQuery.append(DDM_Constants.tbl_bank + " db ");

            sbQuery.append("where rmp.SrcBank = sb.BankCode ");
            sbQuery.append("and rmp.DesBank = db.BankCode ");

            if (!srcBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rmp.SrcBank = ? ");
                vt.add(val_srcBankCode);
            }

            if (!desBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rmp.DesBank = ? ");
                vt.add(val_desBankCode);
            }

            if (!session.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rmp.RelevantSession = ? ");
                vt.add(val_session);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rmp.Status = ? ");
                vt.add(val_status);
            }


            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_srcBankCode)
                {
                    psmt.setString(i, srcBankCode);
                    i++;
                }

                if (val_item == val_desBankCode)
                {
                    psmt.setString(i, desBankCode);
                    i++;
                }

                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }

                if (val_item == val_status)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }


            rs = psmt.executeQuery();

            col = ReportMapUtil.makeReportMapObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public boolean addReportMap(ReportMap rmap)
    {
        boolean status = false;
        int ctr = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        if (rmap.getSrcBankCode() == null)
        {
            System.out.println("WARNING : Null srcBankCode parameter.");
            return status;
        }

        if (rmap.getSrcFileName() == null)
        {
            System.out.println("WARNING : Null srcFileName parameter.");
            return status;
        }

        if (rmap.getDesBankCode() == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return status;
        }

        if (rmap.getDesFileName() == null)
        {
            System.out.println("WARNING : Null desFileName parameter.");
            return status;
        }

        if (rmap.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }

        if (rmap.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return status;
        }

        if (rmap.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return status;
        }


        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("INSERT INTO ");
            sbQuery.append(DDM_Constants.tbl_reportmap);
            sbQuery.append("(SrcBank,SrcFileName,DesBank,DesFileName,RelevantSession,Status,ModifiedBy,ModifiedTime)");
            sbQuery.append("VALUES(?, ?, ?, ?, ?, ?, ?, now())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, rmap.getSrcBankCode());
            pstm.setString(2, rmap.getSrcFileName());
            pstm.setString(3, rmap.getDesBankCode());
            pstm.setString(4, rmap.getDesFileName());
            pstm.setString(5, rmap.getSession());
            pstm.setString(6, rmap.getStatus());
            pstm.setString(7, rmap.getModifiedBy());

            ctr = pstm.executeUpdate();

            if (ctr > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }


        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;

    }

    public boolean updateReportMap(ReportMap rmap)
    {

        boolean status = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (rmap.getSrcBankCode() == null)
        {
            System.out.println("WARNING : Null srcBankCode parameter.");
            return status;
        }

        if (rmap.getSrcFileName() == null)
        {
            System.out.println("WARNING : Null srcFileName parameter.");
            return status;
        }

        if (rmap.getDesBankCode() == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return status;
        }

        if (rmap.getDesFileName() == null)
        {
            System.out.println("WARNING : Null desFileName parameter.");
            return status;
        }

        if (rmap.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }

        if (rmap.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return status;
        }

        if (rmap.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_reportmap + " ");
            sbQuery.append("set Status = ?, ModifiedBy = ?, ModifiedTime = now() , DesFileName = ?");
            sbQuery.append("where SrcBank = ? ");
            sbQuery.append("and  SrcFileName = ? ");
            sbQuery.append("and  DesBank = ? ");
            sbQuery.append("and  DesFileName = ? ");
            sbQuery.append("and  RelevantSession = ? ");

            System.out.println("start query");

            pstm = con.prepareStatement(sbQuery.toString());


            pstm.setString(1, rmap.getStatus());
            pstm.setString(2, rmap.getModifiedBy());
            pstm.setString(3, rmap.getDesFileNameNew());
            pstm.setString(4, rmap.getSrcBankCode());
            pstm.setString(5, rmap.getSrcFileName());
            pstm.setString(6, rmap.getDesBankCode());
            pstm.setString(7, rmap.getDesFileName());
            pstm.setString(8, rmap.getSession());

            count = pstm.executeUpdate();
            
            //System.out.println(rmap.getDesFileName());
            System.out.println(rmap.getStatus());
            System.out.println(rmap.getModifiedBy());
            System.out.println(rmap.getSrcBankCode());
            System.out.println(rmap.getSrcFileName());
            System.out.println(rmap.getDesBankCode());
            System.out.println(rmap.getDesFileName());
            System.out.println(rmap.getSession());
            System.out.println("new "+rmap.getDesFileNameNew());

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                System.out.println("Cunt is 0");
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
    
       @Override
    public boolean insertReportMaps(String[] sessions,String user)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        
        String inString = "";
        
        for (int i = 0; i < sessions.length; i++)
        {
            if(sessions.length-1 > i){
                inString += "'"+sessions[i]+"'"+",";
            }else{
                inString += "'"+sessions[i]+"'";
            }
        }
        //System.out.println("In string "+inString);

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_reportmap + " ");
            sbQuery.append("set ");
            sbQuery.append("status = 'A' ,");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedTime = (select now()) ");
            sbQuery.append("where RelevantSession IN ("+inString+")");
            //System.out.println(""+sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());
            psmt.setString(1, user);
         
            

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
        catch (Exception ex)
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
    public boolean deactivateReportMaps(String[] sessions,String user)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        
        String inString = "";
        
        for (int i = 0; i < sessions.length; i++)
        {
            if(sessions.length-1 > i){
                inString += "'"+sessions[i]+"'"+",";
            }else{
                inString += "'"+sessions[i]+"'";
            }
        }
        //System.out.println("In string "+inString);

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_reportmap + " ");
            sbQuery.append("set ");
            sbQuery.append("status = 'D' ,");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedTime = (select now()) ");
            sbQuery.append("where RelevantSession IN ("+inString+")");
            //System.out.println(""+sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());
            psmt.setString(1, user);
         
            

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
        catch (Exception ex)
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
