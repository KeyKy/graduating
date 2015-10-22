function drawObj(el){
	var j_canvas = document.getElementById(el);
	var strokeSequence = '';
	var point = {};
	point.notFirst = false;
	
	var context = j_canvas.getContext('2d');
	
	var clickX = new Array();
    var clickY = new Array();
    var clickDrag = new Array();
    var paint;
	
	j_canvas.onmousedown = function(e){
		var mousePos = getMousePos(this, e);

		paint = true;
		addClick(mousePos.x, mousePos.y);
		blackdraw();
	}
	j_canvas.onmousemove = function(e){
		var mousePos = getMousePos(this, e);
		if(paint){
			addClick(mousePos.x, mousePos.y, true);
			blackdraw();
		}
	}
	j_canvas.onmouseleave = function(e){
		if (paint == true) {
			strokeSequence = strokeSequence + '#';
		}
		paint = false;
	}
	j_canvas.onmouseup = function(e){
		if(paint == true){
			strokeSequence = strokeSequence + '#';
		}
		paint = false;
	}
	
	function getMousePos(canvas, evt){
		var rect = canvas.getBoundingClientRect();
		return{
			x: evt.clientX - rect.left,
			y: evt.clientY - rect.top
		};
	}
	function addClick(x, y, dragging) {
                clickX.push(x);
                clickY.push(y);
                clickDrag.push(dragging);
			}
	function blackdraw() {
                context.strokeStyle = "#000000";
                context.lineJoin = "round";
                context.lineWidth = 1;

                while (clickX.length > 0) {
                    point.bx = point.x;
                    point.by = point.y;
                    point.x = clickX.pop();
                    point.y = clickY.pop();
                    point.drag = clickDrag.pop();
                    context.beginPath();
                    if (point.drag && point.notFirst) {
                        context.moveTo(point.bx, point.by);
                    } else {
                        point.notFirst = true;
                        context.moveTo(point.x - 1, point.y);
                    }
                    context.lineTo(point.x, point.y);
                    context.closePath();
                    context.stroke();
					
					strokeSequence += point.x;
					strokeSequence += ',';
					strokeSequence += point.y;
					strokeSequence += ',';
                }
            }
	function destroyClickedElement(event) {
            document.body.removeChild(event.target);
        }
	this.clear = function(){
		j_canvas.width = j_canvas.width;
		strokeSequence = '';
	}
	this.save = function(){
		var model_User_Fid = document.getElementById('Model_User_Fid').value;
		
		//save sketch image
		var lnk = document.createElement('a');
		lnk.href = j_canvas.toDataURL();
		lnk.download = model_User_Fid.toString() + '.png';
		if(document.createEvent){
			e = document.createEvent("MouseEvents");
			e.initMouseEvent("click", true, true, window,
                         0, 0, 0, 0, 0, false, false, false,
                         false, 0, null);
			lnk.dispatchEvent(e);
		}else if(lnk.fireEvent){
			lnk.fireEvent("onclick");
		}
		
		//save stroke sequence
		var textFileAsBlob = new Blob([strokeSequence], { type: 'text/plain' });
		var fileNameToSaveAs = model_User_Fid.toString() + '.txt';
		var downloadLink = document.createElement("a");
		downloadLink.download = fileNameToSaveAs;
		downloadLink.innerHTML = "Download File";
		if (window.webkitURL != null) {
			downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
		}
		else {
			downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
			downloadLink.onclick = destroyClickedElement;
			downloadLink.style.display = "none";
			document.body.appendChild(downloadLink);
		}
		downloadLink.click();
	}
}




