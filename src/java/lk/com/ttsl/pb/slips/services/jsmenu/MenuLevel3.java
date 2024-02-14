/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.jsmenu;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class MenuLevel3
{

    private Collection<MenuLevel4> colMenu4;
    private String itemName;
    private int itemWidth;
    private String itemURL;

    public Collection<MenuLevel4> getColMenu4()
    {
        return colMenu4;
    }

    public void setColMenu4(Collection<MenuLevel4> colMenu4)
    {
        this.colMenu4 = colMenu4;
    }

    public String getItemName()
    {
        return itemName;
    }

    public void setItemName(String itemName)
    {
        this.itemName = itemName;
    }

    public int getItemWidth()
    {
        return itemWidth;
    }

    public void setItemWidth(int itemWidth)
    {
        this.itemWidth = itemWidth;
    }

    public String getItemURL()
    {
        return itemURL;
    }

    public void setItemURL(String itemURL)
    {
        this.itemURL = itemURL;
    }
    
    

}
