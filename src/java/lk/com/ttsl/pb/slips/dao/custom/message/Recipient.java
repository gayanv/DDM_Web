/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.message;

/**
 *
 * @author Dinesh
 */
public class Recipient
{

    public String getRecipientBankCode()
    {
        return recipientBankCode;
    }

    public void setRecipientBankCode(String recipientBankCode)
    {
        this.recipientBankCode = recipientBankCode;
    }

    public String getRecipientCode()
    {
        return recipientCode;
    }

    public void setRecipientCode(String recipientCode)
    {
        this.recipientCode = recipientCode;
    }

    public String getRecipientName()
    {
        return recipientName;
    }

    public void setRecipientName(String recipientName)
    {
        this.recipientName = recipientName;
    }

    public String getRecipientType()
    {
        return recipientType;
    }

    public void setRecipientType(String recipientType)
    {
        this.recipientType = recipientType;
    }    
    
    String recipientCode;
    String recipientName;    
    String recipientType;
    String recipientBankCode;
}
