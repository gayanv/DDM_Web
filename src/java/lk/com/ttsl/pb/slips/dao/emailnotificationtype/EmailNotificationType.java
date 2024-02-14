/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emailnotificationtype;

/**
 *
 * @author Dinesh
 */
public class EmailNotificationType
{

    private String ID;
    private String description;
    private String setBankOnly;

    public EmailNotificationType()
    {
    }

    public EmailNotificationType(String ID, String description, String setBankOnly)
    {
        this.ID = ID;
        this.description = description;
        this.setBankOnly = setBankOnly;
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

    public String getSetBankOnly()
    {
        return setBankOnly;
    }

    public void setSetBankOnly(String setBankOnly)
    {
        this.setBankOnly = setBankOnly;
    }

}
