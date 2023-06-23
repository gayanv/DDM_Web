/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.confirmstatus;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ConfirmStatusDAO
{
    public ConfirmStatus getConfirmStatus(String id);
    
    public Collection<ConfirmStatus> getConfirmStatusDetails();
}
