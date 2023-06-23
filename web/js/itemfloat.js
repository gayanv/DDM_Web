/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var floatingItems = new Array();
var ns = (navigator.appName.indexOf("Netscape") != -1);

window.onresize = function()
{
   window.location.reload();
}


function floatItem(itemId,itemWidth,itemHeight,hPos,hPosOffset,vPos,vPosOffset)
{    
    
    var d = document;
    
    floatingItems.push(ml(itemId));
    gotoTopDivPosition();

    function ml(id)
    {
        var el = d.getElementById?d.getElementById(id):d.all?d.all[id]:d.layers[id];

        if(d.layers)
        {
            el.style = el;
        }

        el.sP = function(x,y){
            this.style.left=x;
            this.style.top=y;
        };
        

        /**
         *  Horizontal alignment settings
         */

        if (hPos=="left")
        {
            el.x = hPosOffset;
        }
        else if(hPos=="right")
        {
            var body = document.body;
            var html = document.documentElement;            
            
            //el.x = ns ? (window.pageXOffset + window.innerWidth) - 15 : document.body.scrollLeft + document.body.clientWidth;
            //el.x = ns ? document.width : document.body.scrollWidth;
            el.x = Math.max(body.scrollWidth, body.offsetWidth, html.clientWidth, html.scrollWidth, html.offsetWidth);
            el.x -= (hPosOffset + itemWidth);
        }
        else if(hPos=="center")
        {
            //el.x = ns ? (window.pageXOffset + window.innerWidth)/2 : (document.body.scrollLeft + document.body.clientWidth)/2;
            el.x = ns ? document.width/2 : document.body.scrollWidth/2;
            el.x -= (hPosOffset + itemWidth)/2;
        }


        /**
         *  Vertical alignment settings
         */

        if (vPos=="top")
        {
            el.y = vPosOffset;
        }
        else if(vPos=="bottom")
        {
            el.y = ns ? (window.pageYOffset + window.innerHeight) - 5 : document.body.scrollTop + document.body.clientHeight;
            el.y -= (vPosOffset + itemHeight);
        }
        else if(vPos=="middle")
        {
            el.y = ns ? (window.pageYOffset + window.innerHeight)/2 : (document.body.scrollTop + document.body.clientHeight)/2;
            el.y -= (vPosOffset + itemHeight)/2;
        }

        el.w = itemWidth;
        el.h = itemHeight;
        el.hp = hPos;
        el.vp = vPos;
        el.hpo = hPosOffset;
        el.vpo = vPosOffset;       

        return el;
    }
    

/*
    window.gotoTopDivPosition = function()
    {

        var pY,pX;

        if (verticalpos=="top")
        {
            pY  = ns ? window.pageYOffset : document.body.scrollTop;
            ftlObj.y += (pY + startY - ftlObj.y)/8;
        }
        else if(verticalpos=="bottom"){
            pY = ns ? window.pageYOffset + window.innerHeight : document.body.scrollTop + document.body.clientHeight;
            ftlObj.y += (pY - startY - ftlObj.y)/8;
        }
        else if(verticalpos=="center")
        {
            pY = ns ? (window.pageYOffset + window.innerHeight)/2 : (document.body.scrollTop + document.body.clientHeight)/2;
            ftlObj.y += (pY - ftlObj.y)/8;
        }

        ftlObj.sP(ftlObj.x, ftlObj.y);

        setTimeout("gotoTopDivPosition()", 20);
    }

*/

}

function gotoTopDivPosition()
{

    for(i=0; i < floatingItems.length; i++)
    {
        var pY,pX;

        var ftlObj = floatingItems[i];

        if (ftlObj.vp=="top")
        {
            pY  = ns ? window.pageYOffset : document.body.scrollTop;
            ftlObj.y += ((pY + ftlObj.vpo)- ftlObj.y)/8;
        }
        else if(ftlObj.vp=="bottom"){
            pY = ns ? (window.pageYOffset + window.innerHeight) - 5 : document.body.scrollTop + document.body.clientHeight;
            ftlObj.y += ((pY - (ftlObj.vpo + ftlObj.h)) - ftlObj.y)/8;
        }
        else if(ftlObj.vp=="center")
        {
            pY = ns ? (window.pageYOffset + window.innerHeight)/2 : (document.body.scrollTop + document.body.clientHeight)/2;
            ftlObj.y += (pY - (ftlObj.vpo + ftlObj.h)/2)/8;
        }

        ftlObj.sP(ftlObj.x, ftlObj.y);
    }

    setTimeout("gotoTopDivPosition()", 20);
}


function gotoTop()
{
    var xos = ns ? window.pageXOffset : document.body.scrollLeft;
    window.scrollTo(xos,0);
}


function gotoDown()
{
    var body = document.body;
    var html = document.documentElement;
    
    //var dHeight = ns ? document.height : document.body.scrollHeight;
    var dHeight = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
    //var wHeight = ns ? window.innerHeight : document.body.clientHeight;
    var xos = ns ? window.pageXOffset : document.body.scrollLeft;   

    window.scrollTo(xos,dHeight);
}


