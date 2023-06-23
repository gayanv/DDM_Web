/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.requeststatus;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface RequestStatusDAO
{
    public RequestStatus getFileStatus(String id);
    
    public Collection<RequestStatus> getFileStatusDetails();
}
