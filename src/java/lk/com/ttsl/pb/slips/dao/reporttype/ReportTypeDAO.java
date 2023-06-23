/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reporttype;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportTypeDAO
{
    /**
     * 
     * @param reportTypeID
     * @return 
     */
    public ReportType getReportType(String reportTypeID);

    /**
     * 
     * @return 
     */
    public Collection<ReportType> getReportTypes();
    
    /**
     * 
     * @param category
     * @param refParty
     * @return 
     */
    public Collection<ReportType> getReportTypes(String category, String refParty);
}
