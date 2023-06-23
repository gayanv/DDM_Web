/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequeststatus;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface DDMRequestStatusDAO
{
    /**
     * 
     * @return 
     */
    public String getMsg();
    
    /**
     * 
     * @param id
     * @return 
     */
    public DDMRequestStatus getDDMRequestStatus(String id);
    
    /**
     * 
     * @return 
     */
    public Collection<DDMRequestStatus> getDDMRequestStatusAll();
}
