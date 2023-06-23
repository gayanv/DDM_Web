/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportsubtype;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportSubTypeDAO
{
    /**
     * 
     * @param reportTypeID
     * @return 
     */
    public ReportSubType getReportType(String reportTypeID);

    /**
     * 
     * @return 
     */
    public Collection<ReportSubType> getReportTypes();
    
    /**
     * 
     * @param category
     * @param refParty
     * @return 
     */
    public Collection<ReportSubType> getReportTypes(String category, String refParty);
}
