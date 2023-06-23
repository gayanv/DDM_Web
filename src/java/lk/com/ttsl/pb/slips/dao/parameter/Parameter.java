/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.parameter;

/**
 *
 * @author Dinesh
 */
public class Parameter
{

    private String name;
    private String description;
    private String value;
    private String valueModify;
    private String decrytedValue;
    private String decrytedValueModify;
    private String currentValue;
    private String type;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;
    private String updateStatus;
    private String updateStatusMsg;

    public Parameter()
    {
    }

    public Parameter(String name, String modificationAuthBy)
    {
        this.name = name;
        this.modificationAuthBy = modificationAuthBy;
    }

    public Parameter(String name, String value, String modifiedBy)
    {
        this.name = name;
        this.value = value;
        this.modifiedBy = modifiedBy;
    }

    public Parameter(String name, String description, String value, String type, String modifiedBy)
    {
        this.name = name;
        this.description = description;
        this.value = value;
        this.type = type;
        this.modifiedBy = modifiedBy;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getValue()
    {
        return value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    public String getValueModify()
    {
        return valueModify;
    }

    public void setValueModify(String valueModify)
    {
        this.valueModify = valueModify;
    }

    public String getDecrytedValue()
    {
        return decrytedValue;
    }

    public void setDecrytedValue(String decrytedValue)
    {
        this.decrytedValue = decrytedValue;
    }

    public String getDecrytedValueModify()
    {
        return decrytedValueModify;
    }

    public void setDecrytedValueModify(String decrytedValueModify)
    {
        this.decrytedValueModify = decrytedValueModify;
    }

    public String getCurrentValue()
    {
        return currentValue;
    }

    public void setCurrentValue(String currentValue)
    {
        this.currentValue = currentValue;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

    public String getModificationAuthBy()
    {
        return modificationAuthBy;
    }

    public void setModificationAuthBy(String modificationAuthBy)
    {
        this.modificationAuthBy = modificationAuthBy;
    }

    public String getModificationAuthDate()
    {
        return modificationAuthDate;
    }

    public void setModificationAuthDate(String modificationAuthDate)
    {
        this.modificationAuthDate = modificationAuthDate;
    }

    public String getUpdateStatus()
    {
        return updateStatus;
    }

    public void setUpdateStatus(String updateStatus)
    {
        this.updateStatus = updateStatus;
    }

    public String getUpdateStatusMsg()
    {
        return updateStatusMsg;
    }

    public void setUpdateStatusMsg(String updateStatusMsg)
    {
        this.updateStatusMsg = updateStatusMsg;
    }

}
