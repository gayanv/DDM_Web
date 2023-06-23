/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.report;

import java.io.File;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportDAO
{

    /**
     *
     * @return
     */
    public String getMsg();

    /**
     *
     * @param reportName
     * @param okToDownload
     * @return
     */
    public File getFile(String reportName, String okToDownload);

    /**
     *
     * @param reportName
     * @param type
     * @param okToDownload
     * @return
     */
    public Report getReportDetails(String reportName, String type, String okToDownload);

    /**
     *
     * @param bankCode
     * @param branchCode
     * @param merchantID
     * @param type
     * @param category
     * @param status
     * @param fromBusinessDate
     * @param toBusinessDate
     * @return
     */
    public Collection<Report> getReportDetails(String bankCode, String branchCode, String merchantID, String type, String category, String status, String fromBusinessDate, String toBusinessDate);

    /**
     *
     * @param businessDate
     * @param session
     * @param bankCode
     * @param branchCode
     * @param cocu_id
     * @param reportName
     * @param reportPath
     * @param reportType
     * @param createdBy
     * @return
     */
    public boolean addReportDetails(String businessDate, String session, String bankCode, String branchCode, String cocu_id, String reportName, String reportPath, String reportType, String createdBy);

    /**
     *
     * @param reportName
     * @param downloadedBy
     * @return
     */
    public boolean updateDownloadDetails(String reportName, String downloadedBy);

//    /**
//     *
//     * @param businessDate
//     * @param session
//     * @param generatedBy
//     * @return
//     */
//    public String generateHOGL_Report(String businessDate, String session, String generatedBy);
    /**
     *
     * @param businessDate
     * @param session
     * @param reportType
     * @param reportName
     * @param generatedBy
     * @return
     */
    public String generateFT_Reports(String businessDate, String session, String reportType, String reportName, String generatedBy);

    /**
     *
     * @param businessDate
     * @param session
     * @param reportType
     * @param reportName
     * @param generatedBy
     * @return
     */
    public String generateCustomerSummary_Reports(String businessDate, String session, String reportType, String reportName, String generatedBy);

    /**
     *
     * @param businessDate
     * @param session
     * @param branch
     * @param reportType
     * @param reportName
     * @param generatedBy
     * @return
     */
    public String generateCustomerSummary_Branch_Reports(String businessDate, String session, String branch, String reportType, String reportName, String generatedBy);

    /**
     *
     * @param businessDate
     * @param session
     * @param branch
     * @param cocuid
     * @param reportType
     * @param reportName
     * @param generatedBy
     * @return
     */
    public String generateCustomerSummary_CoCu_Reports(String businessDate, String session, String branch, String cocuid, String reportType, String reportName, String generatedBy);

    /**
     *
     * @param businessDate
     * @param session
     * @param reportType
     * @param fileId
     * @param generatedBy
     * @return
     */
    public String generateInhouseBranchSummary(String businessDate, String session, String reportType, String fileId, String generatedBy);

    /**
     *
     * @param businessDate
     * @param session
     * @param reportType
     * @param fileId
     * @param generatedBy
     * @return
     */
    public String generateOutwardBranchSummary(String businessDate, String session, String reportType, String fileId, String generatedBy);

}
