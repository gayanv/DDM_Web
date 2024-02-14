function cdd_menu399999(){//////////////////////////Start Menu Data/////////////////////////////////

    //**** NavStudio, (c) 2004, OpenCube Inc.,  -  www.opencube.com ****
    //Note: This data file may be manually customized outside of the visual interface.

    //Unique Menu Id
    this.uid = 399999;


/**********************************************************************************************
                               Icon Images
**********************************************************************************************/

    //In-line positioned icon images (flow with the item text)

    this.rel_icon_image0 = "spacer.gif";
    this.rel_icon_rollover0 = "spacer.gif";
    this.rel_icon_image_wh0 = "5,2";

    this.rel_icon_image1 = "yellow.gif";
    this.rel_icon_rollover1 = "red.gif";
    this.rel_icon_image_wh1 = "12,12";

    this.rel_icon_image2 = "redLow.gif";
    this.rel_icon_rollover2 = "redHigh.gif";
    this.rel_icon_image_wh2 = "22,12";

    this.rel_icon_image3 = "arrow_red_low.png";
    this.rel_icon_rollover3 = "arrow_red_high.png";
    this.rel_icon_image_wh3 = "22,12";


/**********************************************************************************************

                              Global - Menu Container Settings

**********************************************************************************************/


    this.menu_background_color = "#FCFCFC";
    this.menu_border_color = "";
    this.menu_border_width = "1";
    this.menu_padding = "1,4,1,4";
    this.menu_border_style = "solid";
    this.divider_caps = true;
    this.divider_width = 1;
    this.divider_height = 1;
    this.divider_background_color = "#6D7C9E";
    this.divider_border_style = "none";
    this.divider_border_width = 0;
    this.divider_border_color = "#6D7C9E";
    this.menu_is_horizontal = false;
    this.menu_width = "119";
    this.menu_xy = "-14,-19";
    this.menu_scroll_direction = 1;
    this.menu_scroll_reverse_on_hide = true;
    this.menu_scroll_delay = 0;
    this.menu_scroll_step = 4;
    this.menu_animation = "progid:DXImageTransform.Microsoft.none(duration=1)";
    //this.menu_z_index = 999




/**********************************************************************************************

                              Global - Menu Item Settings

**********************************************************************************************/

    this.icon_rel = 0;
    this.menu_items_background_color_roll = "#FCE4E7";
    this.menu_items_text_color = "#353C66";
    this.menu_items_text_decoration = "none";
    this.menu_items_font_family = "sans-serif";
    this.menu_items_font_size = "12px";
    this.menu_items_font_style = "normal";
    this.menu_items_font_weight = "normal";
    this.menu_items_text_align = "left";
    this.menu_items_padding = "2,5,2,5";
    this.menu_items_border_style = "solid";
    this.menu_items_border_width = "0";
    this.menu_items_width = "";
    this.menu_items_text_color_roll = "#FF9105";

/**********************************************************************************************

                              Main Menu Settings

**********************************************************************************************/

    this.menu_background_color_main = "";
    this.menu_border_width_main = "0";
    this.menu_border_color_main = "#EEEEEE";
    this.menu_padding_main = "1,0,1,10";
    this.menu_width_main = "";
    this.menu_is_horizontal_main = true;
    this.divider_width_main = 1;
    this.divider_height_main = 1;
    this.divider_caps_main = true;
    this.divider_background_color_main = "#ACB3CC";
    this.divider_border_width_main = "0";

    this.menu_items_background_color_main = "";
    this.menu_items_background_color_roll_main = "#E7EAF5";
    this.menu_items_font_size_main = "12px";
    /*this.menu_items_font_weight_main = "bold"*/
    this.menu_items_text_color_main = "#353C66";
    this.menu_items_text_color_roll_main = "#000000";    
    this.menu_items_text_decoration_main = "none";
    this.menu_items_text_decoration_roll_main = "none";
    this.menu_items_border_width_main = "0";
    this.menu_items_border_color_main = "#949CC7";
    this.menu_items_border_color_roll_main = "#949CC7";
    this.menu_items_width_main = "";

        
    this.item0 = "Re-Login";
    //this.item1 = "Exit";
		
    this.item_width0 = "66";
    //this.item_width1 = "40";

    this.item_text_color_roll0 = "#FF9105";
    //this.item_text_color_roll1 = "#FF9105";	
        
        
    this.url0 = "../index.jsp";
    //this.url1 = "javascript:window.close()";
		
        

    /**********************************************************************************************

                              Sub Menu Settings

**********************************************************************************************/


	
	
		
	

}

///////////////////////// END Menu Data /////////////////////////////////////////

//Document Level Settings

cdd__activate_onclick = false;
cdd__showhide_delay = 250;
cdd__url_target = "_self";
cdd__url_features = "resizable=1, scrollbars=1, titlebar=1, menubar=1, toolbar=1, location=1, status=1, directories=1, channelmode=0, fullscreen=0";
cdd__display_urls_in_status_bar = true;
cdd__default_cursor = "hand";

//NavStudio Code (Warning: Do Not Alter!)

if (window.showHelp){
    b_type = "ie";
    if (!window.attachEvent) b_type += "mac";
}
if (document.createElementNS) b_type = "dom";
if (navigator.userAgent.indexOf("afari")>-1) b_type = "safari";
if (window.opera) b_type = "opera";
qmap1 = "\<\script language=\"JavaScript\" vqptag='loader_sub' src=\"";
qmap2 = ".js\">\<\/script\>";
;
function iesf(){};
;

function vqp_error(val)
{
    alert(val);
}

if (b_type)
{
    document.write(qmap1+cdd__codebase+"pbrowser_"+b_type+qmap2);
    document.close();
}

