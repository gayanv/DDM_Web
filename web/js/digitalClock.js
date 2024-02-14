// JavaScript Document

var object;
var serverTime;
//var strServerTime;

function clock(obj, type, val)
{
    
	
    if(type == 1)
    {
        object = obj;
        showClock1();
    }
    else if(type == 2)
    {
        object = obj;
        serverTime = val[0];       
        showClock2();
    }
    else if(type == 3)
    {
        object = obj;
        showClock3(val[0],val[1],val[2],val[3],val[4],val[5],val[6]);
    }
}


function showClock1()
{
    var clock1 = new Date();
    var hours1 = clock1.getHours();
    var minutes1 = clock1.getMinutes();
    var seconds1 = clock1.getSeconds();
	
	
    // for a nice disply we'll add a zero before the numbers between 0 and 9
    if (hours1<10)
    {
        hours1="0" + hours1;
    }
    if (minutes1<10)
    {
        minutes1="0" + minutes1;
    }
    if (seconds1<10)
    {
        seconds1="0" + seconds1;
    }
    //document.getElementById('showText').innerHTML=hours+":"+minutes+":"+seconds;
    object.innerHTML=hours1+":"+minutes1+":"+seconds1;

    t=setTimeout('showClock1()',500);
/* setTimeout() JavaScript method is used to call showClock() every 1000 milliseconds (that means exactly 1 second) */
}

function showClock2()
{
    var clock2 = new Date(serverTime);
    var hours2 = clock2.getHours();
    var minutes2 = clock2.getMinutes();
    var seconds2 = clock2.getSeconds();
	
    // for a nice disply we'll add a zero before the numbers between 0 and 9
    if (hours2<10)
    {
        hours2="0" + hours2;
    }
    if (minutes2<10)
    {
        minutes2="0" + minutes2;
    }
    if (seconds2<10)
    {
        seconds2="0" + seconds2;
    }
    //document.getElementById('showText').innerHTML=hours+":"+minutes+":"+seconds;
    object.innerHTML=hours2+":"+minutes2+":"+seconds2;
    serverTime = serverTime + 500;
    t=setTimeout('showClock2()',500);
/* setTimeout() JavaScript method is used to call showClock() every 1000 milliseconds (that means exactly 1 second) */
}

function showClock3(year, month, day, hour, minitue, second, milisecond)
{
    
    
    var clock3 = new Date();
    clock3.setYear(year);
    clock3.setMonth(month);
    clock3.setDate(day);
    clock3.setHours(hour);
    clock3.setMinutes(minitue);
    clock3.setSeconds(second);
    clock3.setMilliseconds(milisecond);
    serverTime = clock3.getTime();
    showClock2();
}

function isCutOffReached(cutOffTime)
{
    if(serverTime > cutOffTime)
    {
        return true;
    }
    else
    {
        return false;
    }

}
