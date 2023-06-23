//PROGRAM-ID.		calendar.js
//AUTHOR.			Bajaj
//COMPANY.		    BCS INFORMATION SYSTEMS PTE LTD (SINGAPORE).
//DATE-WRITTEN.	    2001
//*******************************************************************************
//		Copyright(c) 2000-2001 BCS Information Systems Pte Ltd
//			        ALL RIGHTS RESERVED
//*******************************************************************************
//This software is the confidential and proprietary information of BCSIS Pte Ltd.
//("Confidential Information").
//You shall not disclose such Confidential Information and shall use it only in
//accordance with the terms of the license agreement you entered into with BCSIS.
//*******************************************************************************
//AMENDMENT HISTORY.
//===================
//  1.  PROGRAMMER   : <Name of changer>
//      DATE         : <Date of change>
//      PPCR         : <Problem Control Log number if any>
//      DESCRIPTION  : <Description of the changes>
//
//  2.  PROGRAMMER   : <Name of changer>
//      DATE         : <Date of change>
//      PPCR         : <Problem Control Log number if any>
//      DESCRIPTION  : <Description of the changes>
//******************************************************************************
//		ABSTRACT ( PROGRAM DESCRIPTION )
//		================================
//Generate a calendar
//******************************************************************************


// Begin of color definition by ZhaoJun
var gcHeadWeekday = "#333333";
var gcHeadWeekend = "#990033";
var ftHead = "<B><font face='Arial, Helvetica, sans-serif' size='2'>";

var gcDateWeekday = "#006699";
var gcDateWeekend = "#990033";
var ftDate = "face='Verdana, Arial, Helvetica, sans-serif' size='2'";

var gcBottom = "#6699CC";
var gcBottomText = "#FFFFFF";
var gcBottomToggle = "#000000";
var ftBottom = "<font face='Verdana, Arial, Helvetica, sans-serif' size='2'>";

//var gcGray = "#808080";       //ZhaoJun
var gcGray = "#FFFFFF";
//var gcToggle = "#ffff00";     //ZhaoJun
var gcToggle = "#0099CC";       //#336699";
//var gcBG = "#cccccc";         //ZhaoJun
var gcBG = "#99CCFF";

// End of color definition by ZhaoJun

var gdCtrl = new Object();
var goSelectTag = new Array();
var iWant = 'n';
var shouldGtr = 'n';
var dateGot = new Date();
var iFirstDate = new Object();



//var gdCurDate = new Date();
var gdCurDate = new Date(currentServerDate);
var giYear = gdCurDate.getFullYear();
var giMonth = gdCurDate.getMonth()+1;
var giDay = gdCurDate.getDate();

function fSetDate(iYear, iMonth, iDay,iWant){
  VicPopCal.style.visibility = "hidden";
    if (iMonth == 1 || iMonth == 2 || iMonth == 3 || iMonth == 4 || iMonth == 5 || iMonth == 6 || iMonth == 7 || iMonth == 8 || iMonth == 9){
        iMonth= '0'+iMonth;
    }
    if (iDay == 1 || iDay == 2 || iDay == 3 || iDay == 4 || iDay == 5 || iDay == 6 || iDay == 7 || iDay == 8 || iDay == 9){
        iDay = '0'+iDay
    }

    //gdCtrl.value = iDay+"/"+iMonth+"/"+iYear;
    // gdCtrl.value = iYear + "/" + iMonth + "/" + iDay;

    if (iFirstDate.value != "" || iFirstDate.value != null){
        dateGot = new Date(iFirstDate.value);
    }
    var datePassed = new Date(iYear + "/" + iMonth + "/" + iDay);
    if (datePassed <= dateGot && (shouldGtr == 'y' || shouldGtr =='Y')){
        alert('Enter the Date Greater than\n'+dateGot);
    } else {
    if (iWant == 'Y' || iWant == 'y'){
        if (datePassed > gdCurDate){
            gdCtrl.value = iYear + "/" + iMonth + "/" + iDay;
        } else {
            alert('Enter the Date Later than the Current Date\n\t'+iYear+'/'+iMonth+'/'+iDay);
        }
    } else {
        gdCtrl.value = iYear + "/" + iMonth + "/" + iDay;
    }
  }
  for (i in goSelectTag)
    goSelectTag[i].style.visibility = "visible";
  goSelectTag.length = 0;
}


function fSetSelected(aCell){
  var iOffset = 0;
  var iYear = parseInt(tbSelYear.value);
  var iMonth = parseInt(tbSelMonth.value);

  self.event.cancelBubble = true;
  aCell.bgColor = gcBG;
  with (aCell.children["cellText"]){
    var iDay = parseInt(innerText);
//  if (color==gcGray)      //ZhaoJun
    if (color.toLowerCase() == gcGray.toLowerCase())
        iOffset = (Victor<10)?-1:1;
    iMonth += iOffset;
    if (iMonth<1) {
        iYear--;
        iMonth = 12;
    }else if (iMonth>12){
        iYear++;
        iMonth = 1;
    }
  }
  fSetDate(iYear, iMonth, iDay, iWant);
}

function Point(iX, iY){
    this.x = iX;
    this.y = iY;
}

function fBuildCal(iYear, iMonth) {
  var aMonth=new Array();
  for(i=1;i<7;i++)
    aMonth[i]=new Array(i);

  var dCalDate=new Date(iYear, iMonth-1, 1);
  var iDayOfFirst=dCalDate.getDay();
  var iDaysInMonth=new Date(iYear, iMonth, 0).getDate();
  var iOffsetLast=new Date(iYear, iMonth-1, 0).getDate()-iDayOfFirst+1;
  var iDate = 1;
  var iNext = 1;

  for (d = 0; d < 7; d++)
    aMonth[1][d] = (d<iDayOfFirst)?-(iOffsetLast+d):iDate++;
  for (w = 2; w < 7; w++)
    for (d = 0; d < 7; d++)
        aMonth[w][d] = (iDate<=iDaysInMonth)?iDate++:-(iNext++);
  return aMonth;
}

function fDrawCal(iYear, iMonth, iCellHeight, sDateTextSize) {
  var WeekDay = new Array("SUN","MON","TUE","WED","THU","FRI","SAT");
  //  var styleTD = " bgcolor='"+gcBG+"' bordercolor='"+gcBG+"' valign='middle' align='center' height='"+iCellHeight+"' style='font:bold arial "+sDateTextSize+";"; //ZhaoJun
  var styleTD = " bgcolor='"+gcBG+"' bordercolor='"+gcBG+"' valign='middle' align='center' style='";
  with (document) {
    write("<tr>");
    for(i=0; i<7; i++){
            //      write("<td "+styleTD+"color:#990099' >" + WeekDay[i] + "</td>");    //ZhaoJun
        write("<td "+styleTD+"color:" + (((i==0)||(i==6))?gcHeadWeekend:gcHeadWeekday) + "' >" + ftHead + WeekDay[i] + "</td>");
    }
    write("</tr>");

    for (w = 1; w < 7; w++) {
        write("<tr>");
        for (d = 0; d < 7; d++) {
            write("<td id=calCell "+styleTD+"cursor:hand;' onMouseOver='this.bgColor=gcToggle' onMouseOut='this.bgColor=gcBG' onclick='fSetSelected(this)'>");
            //write("<font id=cellText Victor='Liming Weng'> </font>");     //ZhaoJun
            write("<font id=cellText " + ftDate + " Victor='Liming Weng'> </font>");
            write("</td>")
        }
        write("</tr>");
    }
  }
}

function fUpdateCal(iYear, iMonth) {
    myMonth = fBuildCal(iYear, iMonth);
    var i = 0;
    for (w = 0; w < 6; w++)
        for (d = 0; d < 7; d++)
            with (cellText[(7*w)+d]) {
                Victor = i++;
                if (myMonth[w+1][d]<0) {
                    color = gcGray;
                    innerText = -myMonth[w+1][d];
                }else{
                    //color = ((d==0)||(d==6))?"red":"black";       //ZhaoJun
                    color = ((d==0)||(d==6))? gcDateWeekend:gcDateWeekday;
                    innerText = myMonth[w+1][d];
                }
            }
}

function fSetYearMon(iYear, iMon){
   tbSelMonth.options[iMon-1].selected = true;
   for (i = 0; i < tbSelYear.length; i++)
        if (tbSelYear.options[i].value == iYear)
        tbSelYear.options[i].selected = true;
    fUpdateCal(iYear, iMon);
}

function fPrevMonth(){
  var iMon = tbSelMonth.value;
  var iYear = tbSelYear.value;

  if (--iMon<1) {
      iMon = 12;
      iYear--;
  }

  fSetYearMon(iYear, iMon);
}

function fNextMonth(){
  var iMon = tbSelMonth.value;
  var iYear = tbSelYear.value;

  if (++iMon>12) {
      iMon = 1;
      iYear++;
  }

  fSetYearMon(iYear, iMon);
}

function fToggleTags(){
  with (document.all.tags("SELECT")){
    for (i=0; i<length; i++)
        if ((item(i).Victor!="Won")&&fTagInBound(item(i))){
            item(i).style.visibility = "hidden";
            goSelectTag[goSelectTag.length] = item(i);
        }
  }
}

function fTagInBound(aTag){
  with (VicPopCal.style){
    var l = parseInt(left);
    var t = parseInt(top);
    var r = l+parseInt(width);
    var b = t+parseInt(height);
    var ptLT = fGetXY(aTag);
    return !((ptLT.x>r)||(ptLT.x+aTag.offsetWidth<l)||(ptLT.y>b)||(ptLT.y+aTag.offsetHeight<t));
  }
}

function fGetXY(aTag){
  var oTmp = aTag;
  var pt = new Point(0,0);
  do {
    pt.x += oTmp.offsetLeft;
    pt.y += oTmp.offsetTop;
    oTmp = oTmp.offsetParent;
  } while(oTmp.tagName!="BODY");
  return pt;
}

// Main: popCtrl is the widget beyond which you want this calendar to appear;
//       dateCtrl is the widget into which you want to put the selected date.
// i.e.: <input type="text" name="dc" style="text-align:center" readonly><INPUT type="button" value="V" onclick="fPopCalendar(dc,dc);return false">
function fPopCalendar(popCtrl,dateCtrl,iRequire, iValidate){
  gdCtrl = dateCtrl;
  iFirstDate = popCtrl;
  if (iRequire != null || iRequire != ""){
     iWant = iRequire;
  }
  if (iValidate != null || iValidate != ""){
     shouldGtr = iValidate;
  }
  fSetYearMon(giYear, giMonth);
  var point = fGetXY(popCtrl);
  with (VicPopCal.style) {
    left = point.x;
    top  = point.y+popCtrl.offsetHeight+1;
    width = VicPopCal.offsetWidth;
    height = VicPopCal.offsetHeight;
    fToggleTags(point);
    visibility = 'visible';
  }
  VicPopCal.focus();
}

function fHideCal(){
  var oE = window.event;
  if ((oE.clientX>0)&&(oE.clientY>0)&&(oE.clientX<document.body.clientWidth)&&(oE.clientY<document.body.clientHeight)) {
    var oTmp = document.elementFromPoint(oE.clientX,oE.clientY);
    while ((oTmp.tagName!="BODY") && (oTmp.id!="VicPopCal"))
        oTmp = oTmp.offsetParent;
    if (oTmp.id=="VicPopCal")
        return;
  }
  VicPopCal.style.visibility = 'hidden';
  for (i in goSelectTag)
    goSelectTag[i].style.visibility = "visible";
  goSelectTag.length = 0;
}

var gMonths = new Array("January","February","March","April","May","June","July","August","September","October","November","December");

with (document) {
//write("<Div id='VicPopCal' onblur='fHideCal()' onclick='focus()' style='POSITION:absolute;visibility:hidden;border:2px ridge;width:10;z-index:100;'>");   //ZhaoJun
write("<Div id='VicPopCal' onblur='fHideCal()' onclick='focus()' style='POSITION:absolute;visibility:hidden;border:0px ridge;width:10;z-index:100;'>");
//write("<table border='0' bgcolor='#6699cc'>");        //ZhaoJun
write("<table border='0' style='width:256' cellspacing='0' bgcolor='" + gcBG + "'>");
//write("<TR>");        //ZhaoJun
write("<TR style='height:36' bgcolor='" + gcBG + "'>");
write("<td valign='middle' align='center'><input type='button' name='PrevMonth' value='<' style='height:20;width:20;FONT:bold' onClick='fPrevMonth()' onblur='fHideCal()'>");
write("&nbsp;<select name='tbSelMonth' onChange='fUpdateCal(tbSelYear.value, tbSelMonth.value)' Victor='Won' onclick='self.event.cancelBubble=true' onblur='fHideCal()'>");
for (i=0; i<12; i++)
    write("<option value='"+(i+1)+"'>"+gMonths[i]+"</option>");
write("</SELECT>");
write("&nbsp;<SELECT name='tbSelYear' onChange='fUpdateCal(tbSelYear.value, tbSelMonth.value)' Victor='Won' onclick='self.event.cancelBubble=true' onblur='fHideCal()'>");
for(i=2000;i<2051;i++)
//  write("<OPTION value='"+i+"'>A.D. "+i+"</OPTION>");
    write("<OPTION value='"+i+"'>"+i+"</OPTION>");
write("</SELECT>");
write("&nbsp;<input type='button' name='PrevMonth' value='>' style='height:20;width:20;FONT:bold' onclick='fNextMonth()' onblur='fHideCal()'>");
write("</td>");
write("</TR><TR>");
write("<td align='center'>");
//write("<DIV style='background-color:teal'><table width='100%' border='0'>");      //ZhaoJun
write("<DIV style='background-color:"+gcBG+"'><table width='100%' border='1' cellspacing='0'>");
fDrawCal(giYear, giMonth, 20, '12');
write("</table></DIV>");
write("</td>");
//write("</TR><TR><TD align='center'>");        //ZhaoJun
write("</TR><TR bgcolor='" + gcBottom + "' style='height:36; color=" + gcBottomText + "'><TD align='center'>");
//write("<B style='cursor:hand' onclick='fSetDate(giYear,giMonth,giDay); self.event.cancelBubble=true' onMouseOver='this.style.color=gcToggle' onMouseOut='this.style.color=0'>Today:  "+gMonths[giMonth-1]+" "+giDay+", "+giYear+"</B>");      //ZhaoJun
write(ftBottom + "<B style='cursor:hand' onclick='fSetDate(giYear,giMonth,giDay); self.event.cancelBubble=true' onMouseOver='this.style.color=gcBottomToggle' onMouseOut='this.style.color=\""+gcBottomText+"\"'>Today:  "+gMonths[giMonth-1]+" "+giDay+", "+giYear+"</B>");
write("</TD></TR>");write("</TD></TR>");
write("</TABLE></Div>");
}