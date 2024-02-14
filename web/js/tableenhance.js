var clickedRows = new Array();


function cOn(td){	
	
    if(document.getElementById||(document.all && !(document.getElementById))){
        td.style.backgroundColor="#FCE4E7";
    }
}
function cOut(td){
    if(document.getElementById||(document.all && !(document.getElementById))){
        td.style.backgroundColor="";
    }
}

function highlightTableRows(tableId) {
    var previousClass = null;    
    var table = document.getElementById(tableId);    
    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = tbody.getElementsByTagName("tr");

    // add event handlers so rows light up and are clickable
    for (i=0; i < (rows.length -1); i++) {

        rows[i].onmouseover = function() {

            previousClass=this.className;
            this.className ='over';
        };

        rows[i].onmouseout = function() {

            var isClickedRow = false;
            var rowIndexOnMouseOut = this.rowIndex;

            for(j=0; j < clickedRows.length; j++)
            {
                if(rowIndexOnMouseOut == clickedRows[j])
                {
                    isClickedRow = true;
                    break;
                }
            }

            if(isClickedRow)
            {
                this.className ='over';
            }
            else
            {
                if(rowIndexOnMouseOut%2==0)
                {
                    this.className ='even'
                }
                else if(rowIndexOnMouseOut%2==1)
                {
                    this.className ='odd'
                }
            }
            
        };

        /*
        rows[i].onclick = function() {
            var cell = this.getElementsByTagName("td")[0];
            if (cell.getElementsByTagName("a").length > 0) {
                var link = cell.getElementsByTagName("a")[0];
                if (link.onclick) {
                    call = link.getAttributeValue("onclick");
                    // this will not work for links with onclick handlers that return false
                    eval(call);
                } else {
                    location.href = link.getAttribute("href");
                }
                this.style.cursor="wait";
            }
        }
 */

        rows[i].onclick = function() {

            var isAlreadyCliked = false;
            var tempArray = new Array();
            var rowIndexOnClick = this.rowIndex;

            for(k=0; k < clickedRows.length; k++)
            {
                if(rowIndexOnClick == clickedRows[k])
                {
                    isAlreadyCliked = true;                    
                }
                else
                {
                    tempArray.push(clickedRows[k]);
                }
            }            

            if(isAlreadyCliked)
            {
                clickedRows = new Array();

                for(l=0; l < tempArray.length; l++)
                {
                    clickedRows.push(tempArray[l]);
                }

                if(rowIndexOnClick%2==0)
                {
                    this.className ='even'
                }
                else if(rowIndexOnClick%2==1)
                {
                    this.className ='odd'
                }
            }
            else
            {                
                clickedRows.push(rowIndexOnClick);
                this.className ='over'
            }

            document.getElementById('icSelected').innerHTML = clickedRows.length;

        };

    }
}
