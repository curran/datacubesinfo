window.onload = init;

var canvas;
var processing;
var t = 0;
var touches;

function init(){ 
    canvas = document.getElementById("canvas");  
    processing = new Processing(canvas, draw);
    resize();
}
function resize(){
    var displayWidth = window.innerWidth;
    var displayHeight = window.innerHeight;
    processing.size(displayWidth,displayHeight);
}    

function draw(p){
    p.setup = function() { p.background(100,0,20); }
    p.draw = function(){
	if(touches != undefined){
	    var r = (Math.sin(t)/2.0+0.5)*255;
	    var g = (Math.sin(t*1.3)/2.0+0.5)*255;
	    var b = (Math.sin(t*1.4)/2.0+0.5)*255;
	    p.noStroke();
	    p.fill(r,g,b);
	    t += 0.1;
	    var i;
	    for(i=0;i < touches.length;i++)
		p.ellipse(touches[i].pageX,touches[i].pageY,30,30);
	}
    }
}
function touchStart(e){ touches = e.touches; }
function touchMove(e){ touches = e.touches; }
function touchEnd(e){ touches = undefined; }
function orientationChange(){
    resize();
}
