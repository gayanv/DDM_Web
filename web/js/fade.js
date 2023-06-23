var baseopacity=50;
var imgobj;

function slowhigh(which2)
{
	if(imgobj != null)
	{
		instantset(baseopacity);
	}
	
	imgobj=which2;
	browserdetect=which2.filters? "ie" : typeof which2.style.MozOpacity=="string"? "mozilla" : "";
	cleartimer();
	instantset(baseopacity);
	highlighting = setInterval("gradualfadehigh(imgobj)",50);
}

function slowlow(which2)
{
	cleartimer();	
	highlighting = setInterval("gradualfadelow(imgobj)",40);
	//instantset(baseopacity);
}

function instantset(degree)
{
	if (browserdetect=="mozilla")
	{
		imgobj.style.MozOpacity=degree/100;
	}
	else if (browserdetect=="ie")
	{
		imgobj.filters.alpha.opacity=degree;
	}
	else if (browserdetect=="safari")
	{
		imgobj.style.opacity=degree/100;
	}
	else if (browserdetect=="")
	{
		imgobj.style.opacity=degree/100;
	//alert("Here ......");
	}
}

function cleartimer()
{
	if (window.highlighting)
	{ 
		clearInterval(highlighting);
	}
}

function gradualfadehigh(cur2)
{	
	if (browserdetect=="mozilla" && cur2.style.MozOpacity<1)
	{
		cur2.style.MozOpacity=Math.min(parseFloat(cur2.style.MozOpacity)+0.1, 0.99);
	}
	else if (browserdetect=="safari" && cur2.style.opacity<1)
	{
		cur2.style.opacity=Math.min(parseFloat(cur2.style.opacity)+0.1, 0.99);
	}
	else if (browserdetect=="ie" && cur2.filters.alpha.opacity<100)
	{
		cur2.filters.alpha.opacity+=10;
	}
	else if(browserdetect=="" && cur2.style.opacity<1)
	{
		cur2.style.opacity=Math.min(parseFloat(cur2.style.opacity)+0.1, 0.99);
	}
	else if (window.highlighting)
	{
		clearInterval(highlighting);
	}
}

function gradualfadelow(cur2)
{	
	if (browserdetect=="mozilla" && cur2.style.MozOpacity > 0.5)
	{
		cur2.style.MozOpacity=Math.min(parseFloat(cur2.style.MozOpacity)-0.1, 0.99);
	}
	else if (browserdetect=="safari" && cur2.style.opacity > 0.5)
	{
		cur2.style.opacity=Math.min(parseFloat(cur2.style.opacity)-0.1, 0.99);
	}
	else if (browserdetect=="ie" && cur2.filters.alpha.opacity > 50)
	{
		cur2.filters.alpha.opacity-=10;
	}
	else if(browserdetect=="" && cur2.style.opacity > 0.5)
	{
		cur2.style.opacity=Math.min(parseFloat(cur2.style.opacity)-0.1, 0.99);
	}
	else if (window.highlighting)
	{
		clearInterval(highlighting);
	}
}
