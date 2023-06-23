// Title	: Custom Error Alert
// Date		: 11/02/2008
// Author	: dinesh_02337


function applyPreloadPage(preLoaderID)
{
		window.scroll(0,0);
		document.body.style.overflow = 'hidden';
		document.getElementById(preLoaderID).style.visibility='visible';	
	
}



function clearPreloadPage(preLoaderID) 
{ 

	if (document.getElementById)
	{
		document.getElementById(preLoaderID).style.visibility='hidden';
		document.body.style.overflow = 'scroll';
	}
	else
	{
		if (document.layers)
		{ 
			//NS4
			document.getElementById(preLoaderID).style.visibility='hidden';
			document.body.style.overflow = 'scroll';
		}
		else 
		{ 
			//IE4
			document.getElementById(preLoaderID).style.visibility='hidden';
			document.body.style.overflow = 'scroll';
		}
	}
	
}
