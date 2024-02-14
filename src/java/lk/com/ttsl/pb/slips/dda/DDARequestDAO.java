/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dda;

/**
 *
 * @author TTSADMIN
 */
public interface DDARequestDAO {
    
    public String getMsg();

    public boolean addDDARequest(DDARequest ddaRequest);
}
