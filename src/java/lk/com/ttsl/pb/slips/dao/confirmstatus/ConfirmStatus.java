/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.confirmstatus;

/**
 *
 * @author Dinesh
 */
public class ConfirmStatus
{

    private String ID;
    private String description;

    public ConfirmStatus()
    {
    }

    public ConfirmStatus(String ID, String description)
    {
        this.ID = ID;
        this.description = description;
    }

    public String getID()
    {
        return ID;
    }

    public void setID(String ID)
    {
        this.ID = ID;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }
}
