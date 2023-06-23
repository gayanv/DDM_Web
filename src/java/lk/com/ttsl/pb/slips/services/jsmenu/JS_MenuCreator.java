/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.jsmenu;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.userlevelfunctionmap.UserLevelFunctionMap;
import lk.com.ttsl.pb.slips.services.utils.FileManager;

/**
 *
 * @author Dinesh
 */
public class JS_MenuCreator
{

    private static String is_AllJSMenusCreated;

    public static void main(String[] args)
    {
        JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_manager, "E:\\CITS\\bcm\\SLIPS_BCM_Web_v10.0\\web\\js\\");
    }

    public static boolean CreateMenu(String userLevel, String jsBasePath)
    {
        boolean status;

        String startSourceFileName = "";
        String jsMenuName = "";

        if (userLevel.equals(DDM_Constants.user_type_bank_manager))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_bank_admin;
            jsMenuName = DDM_Constants.js_menu_name_for_bank_admin;
        }
        else if (userLevel.equals(DDM_Constants.user_type_bank_user))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_bank_operator;
            jsMenuName = DDM_Constants.js_menu_name_for_bank_operator;
        }
        else if (userLevel.equals(DDM_Constants.user_type_merchant_su))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_corporate_customer_su;
            jsMenuName = DDM_Constants.js_menu_name_for_corporate_customer_su;
        }
        else if (userLevel.equals(DDM_Constants.user_type_merchant_op))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_corporate_customer_op;
            jsMenuName = DDM_Constants.js_menu_name_for_corporate_customer_op;
        }
        else if (userLevel.equals(DDM_Constants.user_type_ddm_administrator))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_ddm_admin;
            jsMenuName = DDM_Constants.js_menu_name_for_ddm_admin;
        }
        else if (userLevel.equals(DDM_Constants.user_type_ddm_operator))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_ddm_operator;
            jsMenuName = DDM_Constants.js_menu_name_for_ddm_operator;
        }
        else if (userLevel.equals(DDM_Constants.user_type_ddm_helpdesk_user))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_ddm_helpdesk;
            jsMenuName = DDM_Constants.js_menu_name_for_ddm_helpdesk;
        }
        else if (userLevel.equals(DDM_Constants.user_type_ddm_manager))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_ddm_manager;
            jsMenuName = DDM_Constants.js_menu_name_for_ddm_manager;
        }
        else if (userLevel.equals(DDM_Constants.user_type_ddm_supervisor))
        {
            startSourceFileName = DDM_Constants.js_menu_start_source_txt_for_ddm_supervisor;
            jsMenuName = DDM_Constants.js_menu_name_for_ddm_supervisor;
        }

        String strStart = new JS_MenuCreator().getCommonStart(jsBasePath + startSourceFileName);
        String strBody = new JS_MenuCreator().getBodyData(userLevel);
        String strEnd = new JS_MenuCreator().getCommonEnd(jsBasePath + DDM_Constants.js_menu_end_source_txt);

        String strFullData = strStart + strBody + strEnd;

        if (new FileManager().createFile(new File(jsBasePath + jsMenuName), strFullData, true))
        {
            status = true;
            System.out.println("js_menu creation is successful! ======> (" + jsBasePath + jsMenuName + ")");
        }
        else
        {
            status = false;
            System.out.println("js_menu creation is failed! ======> (" + jsBasePath + jsMenuName + ")");
        }

        return status;
    }

    public static boolean CreateAllMenus(String jsBasePath)
    {
        boolean status = true;

        if (is_AllJSMenusCreated == null)
        {
            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_bank_manager, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_bank_user, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_merchant_su, jsBasePath))
            {
                status = false;
            }
            
            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_merchant_op, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_administrator, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_operator, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_helpdesk_user, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_manager, jsBasePath))
            {
                status = false;
            }

            if (!JS_MenuCreator.CreateMenu(DDM_Constants.user_type_ddm_supervisor, jsBasePath))
            {
                status = false;
            }

            if (status)
            {
                is_AllJSMenusCreated = DDM_Constants.status_yes;
            }
        }
        else
        {
            status = true;
        }

        return status;
    }

    public String getCommonStart(String filename)
    {
        String content = null;
        File file = new File(filename); // For example, foo.txt
        FileReader reader = null;
        try
        {
            reader = new FileReader(file);
            char[] chars = new char[(int) file.length()];
            reader.read(chars);
            content = new String(chars);
            reader.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (reader != null)
            {
                try
                {
                    reader.close();
                }
                catch (IOException ex)
                {
                    ex.printStackTrace();
                }
            }
        }
        return content;
    }

    public String getBodyData(String usrLevel)
    {
        String bodyData = "\n\n";

        String strLevel1_PreviousName = "";
        String strLevel2_PreviousName = "";
        String strLevel3_PreviousName = "";
        String strLevel4_PreviousName = "";

        String strFunctionPath = "";

        JS_Menu jsMenu = null;
        Collection<MenuLevel1> colLv1 = null;
        Collection<MenuLevel2> colLv2 = null;
        Collection<MenuLevel3> colLv3 = null;
        Collection<MenuLevel4> colLv4 = null;
        MenuLevel1 ml_1 = null;
        MenuLevel2 ml_2 = null;
        MenuLevel3 ml_3 = null;
        MenuLevel4 ml_4 = null;

        Collection<UserLevelFunctionMap> colULFM = DAOFactory.getUserLevelFunctionMapDAO().getFunctionMapForMenuCreation(usrLevel, DDM_Constants.status_active);

        int i = 0;

        if (colULFM != null)
        {
            if (jsMenu == null)
            {
                jsMenu = new JS_Menu();
            }

            if (colLv1 == null)
            {
                colLv1 = new ArrayList<MenuLevel1>();
            }

            for (UserLevelFunctionMap ulfm : colULFM)
            {
                i++;

                if (ulfm != null)
                {
                    // ======================= Start Level 1 ========================
                    if (ulfm.getMenuLevel1() != null)
                    {
                        if (!strLevel1_PreviousName.equals(ulfm.getMenuLevel1()))
                        {
                            colLv2 = new ArrayList<MenuLevel2>();
                            ml_1 = new MenuLevel1();

                            ml_1.setItemName(ulfm.getMenuLevel1());
                            ml_1.setItemWidth(ulfm.getWidthMenuLevel1());
                            //ml_1.setItemURL("\"" + ulfm.getFunctionPath() + "\"");
                            colLv1.add(ml_1);
                        }
                        strLevel1_PreviousName = ulfm.getMenuLevel1();

                        // ======================= Start Level 2 ========================
                        if (ulfm.getMenuLevel2() != null)
                        {
                            if (!strLevel2_PreviousName.equals(ulfm.getMenuLevel2()))
                            {
                                colLv3 = new ArrayList<MenuLevel3>();
                                ml_2 = new MenuLevel2();

                                ml_2.setItemName(ulfm.getMenuLevel2());
                                ml_2.setItemWidth(ulfm.getWidthMenuLevel2());
                                //ml_2.setItemURL("\"" + ulfm.getFunctionPath() + "\"");
                                colLv2.add(ml_2);
                                ml_1.setColMenu2(colLv2);
                            }

                            strLevel2_PreviousName = ulfm.getMenuLevel2();

                            // ======================= Start Level 3 ========================
                            if (ulfm.getMenuLevel3() != null)
                            {
                                if (!strLevel3_PreviousName.equals(ulfm.getMenuLevel3()))
                                {
                                    colLv4 = new ArrayList<MenuLevel4>();
                                    ml_3 = new MenuLevel3();

                                    ml_3.setItemName(ulfm.getMenuLevel3());
                                    ml_3.setItemWidth(ulfm.getWidthMenuLevel3());
                                    //ml_2.setItemURL("\"" + ulfm.getFunctionPath() + "\"");
                                    colLv3.add(ml_3);
                                    ml_2.setColMenu3(colLv3);
                                }

                                strLevel3_PreviousName = ulfm.getMenuLevel3();

                                // ======================= Start Level 4 ========================
                                if (ulfm.getMenuLevel4() != null)
                                {
                                    if (!strLevel4_PreviousName.equals(ulfm.getMenuLevel4()))
                                    {
                                        ml_4 = new MenuLevel4();

                                        ml_4.setItemName(ulfm.getMenuLevel4());
                                        ml_4.setItemWidth(ulfm.getWidthMenuLevel4());
                                        ml_4.setItemURL(ulfm.getFunctionPath());
                                        colLv4.add(ml_4);
                                        ml_3.setColMenu4(colLv4);
                                    }

                                    strLevel4_PreviousName = ulfm.getMenuLevel4();

                                }
                                else
                                {
                                    ml_3.setItemURL(ulfm.getFunctionPath());
                                }
                                // ======================= End Level 4 ========================

                            }
                            else
                            {
                                ml_2.setItemURL(ulfm.getFunctionPath());
                            }
                            // ======================= End Level 3 ========================
                        }
                        else
                        {
                            ml_1.setItemURL(ulfm.getFunctionPath());
                        }

                        // ======================= End Level 2 ========================
                    }

                    // ======================= End Level 1 ========================
                }

            }

            jsMenu.setColMenu1(colLv1);

        }

        int level1 = 0;
        int level2 = -1;
        int level3 = -1;
        int level4 = -1;

        int level1MaxWidth = 0;
        int level2MaxWidth = 0;
        int level3MaxWidth = 0;
        int level4MaxWidth = 0;

        if (jsMenu != null && jsMenu.getColMenu1() != null)
        {
            for (MenuLevel1 m1 : jsMenu.getColMenu1())
            {
                level1++;
                level2 = -1;
                level3 = -1;
                level4 = -1;

                level2MaxWidth = 0;
                level3MaxWidth = 0;
                level4MaxWidth = 0;

//                System.out.println(level1 + ". L1_ItemName -> " + m1.getItemName());
//                System.out.println(level1 + ". L1_getItemWidth -> " + m1.getItemWidth());
//                System.out.println(level1 + ". L1_ItemURL -> " + (m1.getItemURL() != null ? m1.getItemURL() : ""));
                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_1_item_tag + level1 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + m1.getItemName() + DDM_Constants.js_menu_double_qoute_and_semicolon;
                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_1_item_width_tag + level1 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + m1.getItemWidth() + DDM_Constants.js_menu_double_qoute_and_semicolon;
                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_1_text_color_roll_tag + level1 + DDM_Constants.js_menu_level_1_text_color_roll_val;
                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_1_url_tag + level1 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (m1.getItemURL() != null ? m1.getItemURL() : "") + DDM_Constants.js_menu_double_qoute_and_semicolon;

                if (m1.getColMenu2() != null)
                {
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                    bodyData = bodyData + " /**********************************************************************************************\n"
                            + "     \n"
                            + "     Sub Menu Settings\n"
                            + "     \n"
                            + "     **********************************************************************************************/\n";

                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                    bodyData = bodyData + "//Sub Menu " + level1;

                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_border_color_tag + level1 + DDM_Constants.js_menu_level_2_3_4_border_color_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_items_padding_tag + level1 + DDM_Constants.js_menu_level_2_3_4_items_padding_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_xy_tag + level1 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + "-" + m1.getItemWidth() + ",3" + DDM_Constants.js_menu_double_qoute_and_semicolon;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                    String l2_width = "150";

                    for (MenuLevel2 m2 : m1.getColMenu2())
                    {
                        if (level2MaxWidth < m2.getItemWidth())
                        {

                            level2MaxWidth = m2.getItemWidth();
                        }

                        l2_width = "" + level2MaxWidth;
                    }

                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_width_tag + level1 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (l2_width != null ? l2_width : "150") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_animation_tag + level1 + DDM_Constants.js_menu_level_2_3_4_animation_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_transparency_tag + level1 + DDM_Constants.js_menu_level_2_3_4_transparency_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_horizontal_tag + level1 + DDM_Constants.js_menu_level_2_3_4_is_horizontal_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_tag + level1 + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_val;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                    for (MenuLevel2 m2 : m1.getColMenu2())
                    {
                        level2++;
                        level3 = -1;
                        level4 = -1;

                        level3MaxWidth = 0;
                        level4MaxWidth = 0;

//                        System.out.println("   " + level2 + ". L2_ItemName -> " + m2.getItemName());
//                        System.out.println("   " + level2 + ". L2_getItemWidth -> " + m2.getItemWidth());
//                        System.out.println("   " + level2 + ". L2_ItemURL -> " + (m2.getItemURL() != null ? m2.getItemURL() : "n/a"));
                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_icon_roll_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_icon_roll_val;
                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_item_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + m2.getItemName() + DDM_Constants.js_menu_double_qoute_and_semicolon;
                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_url_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (m2.getItemURL() != null ? m2.getItemURL() : "") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                        bodyData = bodyData + DDM_Constants.js_menu_new_line;

                        if (m2.getColMenu3() != null)
                        {
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;

                            bodyData = bodyData + "//Sub Menu " + level1 + DDM_Constants.js_menu_underscore + level2;

                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;

                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_border_color_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_border_color_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_items_padding_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_items_padding_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_xy_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + "5,-14" + DDM_Constants.js_menu_double_qoute_and_semicolon;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;

                            String l3_width = "150";

                            for (MenuLevel3 m3 : m2.getColMenu3())
                            {
                                if (level3MaxWidth < m3.getItemWidth())
                                {

                                    level3MaxWidth = m3.getItemWidth();
                                }

                                l3_width = "" + level3MaxWidth;
                            }

                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_width_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (l3_width != null ? l3_width : "150") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_animation_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_animation_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_transparency_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_transparency_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_horizontal_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_is_horizontal_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_val;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;
                            bodyData = bodyData + DDM_Constants.js_menu_new_line;

                            for (MenuLevel3 m3 : m2.getColMenu3())
                            {
                                level3++;
                                level4 = -1;

                                level4MaxWidth = 0;

//                                System.out.println("      " + level3 + ". L3_ItemName -> " + m3.getItemName());
//                                System.out.println("      " + level3 + ". L3_getItemWidth -> " + m3.getItemWidth());
//                                System.out.println("      " + level3 + ". L3_ItemURL -> " + (m3.getItemURL() != null ? m3.getItemURL() : "n/a"));
                                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_icon_roll_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_icon_roll_val;
                                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_item_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + m3.getItemName() + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_url_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (m3.getItemURL() != null ? m3.getItemURL() : "") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                bodyData = bodyData + DDM_Constants.js_menu_new_line;

                                if (m3.getColMenu4() != null)
                                {

                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                                    bodyData = bodyData + "//Sub Menu " + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3;

                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_border_color_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_border_color_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_items_padding_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_items_padding_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_xy_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + "5,-14" + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                                    String l4_width = "150";

                                    for (MenuLevel4 m4 : m3.getColMenu4())
                                    {
                                        if (level4MaxWidth < m4.getItemWidth())
                                        {

                                            level4MaxWidth = m4.getItemWidth();
                                        }

                                        l4_width = "" + level4MaxWidth;
                                    }

                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_width_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (l4_width != null ? l4_width : "150") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_animation_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_animation_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_transparency_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_transparency_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_horizontal_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_is_horizontal_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_level_2_3_4_is_divider_caps_val;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    bodyData = bodyData + DDM_Constants.js_menu_new_line;

                                    for (MenuLevel4 m4 : m3.getColMenu4())
                                    {
                                        level4++;
//                                        System.out.println("         " + level4 + ". L4_ItemName -> " + m4.getItemName());
//                                        System.out.println("         " + level4 + ". L4_getItemWidth -> " + m4.getItemWidth());
//                                        System.out.println("         " + level4 + ". L4_ItemURL -> " + (m4.getItemURL() != null ? m4.getItemURL() : "n/a"));

                                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_icon_roll_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_underscore + level4 + DDM_Constants.js_menu_level_2_3_4_icon_roll_val;
                                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_item_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_underscore + level4 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + m4.getItemName() + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                        bodyData = bodyData + DDM_Constants.js_menu_4_spaces + DDM_Constants.js_menu_level_2_3_4_url_tag + level1 + DDM_Constants.js_menu_underscore + level2 + DDM_Constants.js_menu_underscore + level3 + DDM_Constants.js_menu_underscore + level4 + DDM_Constants.js_menu_equal + DDM_Constants.js_menu_double_qoute + (m4.getItemURL() != null ? m4.getItemURL() : "") + DDM_Constants.js_menu_double_qoute_and_semicolon;
                                        bodyData = bodyData + DDM_Constants.js_menu_new_line;
                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

        level1++;
        bodyData = bodyData + DDM_Constants.js_menu_new_line;
        bodyData = bodyData + DDM_Constants.js_menu_level_1_item_tag + level1 + DDM_Constants.js_menu_level_1_item_val_user_profile;
        bodyData = bodyData + DDM_Constants.js_menu_new_line;
        bodyData = bodyData + DDM_Constants.js_menu_level_1_item_width_tag + level1 + DDM_Constants.js_menu_level_1_item_width_val_user_profile;
        bodyData = bodyData + DDM_Constants.js_menu_new_line;
        bodyData = bodyData + DDM_Constants.js_menu_level_1_text_color_roll_tag + level1 + DDM_Constants.js_menu_level_1_text_color_roll_val;
        bodyData = bodyData + DDM_Constants.js_menu_new_line;
        bodyData = bodyData + DDM_Constants.js_menu_level_1_url_tag + level1 + DDM_Constants.js_menu_level_1_url_val_user_profile;

        return bodyData;
    }

    public String getCommonEnd(String filename)
    {
        String content = null;
        File file = new File(filename); // For example, foo.txt
        FileReader reader = null;
        try
        {
            reader = new FileReader(file);
            char[] chars = new char[(int) file.length()];
            reader.read(chars);
            content = new String(chars);
            reader.close();
        }
        catch (IOException e)
        {
            System.out.println("Error_1 ---> " + e.getMessage());
        }
        finally
        {
            if (reader != null)
            {
                try
                {
                    reader.close();
                }
                catch (IOException e)
                {
                    //ex.printStackTrace();
                    System.out.println("Error_2 ---> " + e.getMessage());
                }
            }
        }
        return content;
    }

}
