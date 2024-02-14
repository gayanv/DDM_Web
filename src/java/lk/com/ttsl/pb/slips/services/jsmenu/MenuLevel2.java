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
public class MenuLevel2
{

    private Collection<MenuLevel3> colMenu3;
    private String itemName;
    private int itemWidth;
    private String itemURL;

    public Collection<MenuLevel3> getColMenu3()
    {
        return colMenu3;
    }

    public void setColMenu3(Collection<MenuLevel3> colMenu3)
    {
        this.colMenu3 = colMenu3;
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
