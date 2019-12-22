<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" /> 
		<title>前端该死的作业</title>
		<style>
    body {margin:0;padding:0;font-size:16px;background: #CDCDCD;}
header {height:50px;background:#333;background:rgba(47,47,47,0.98);}
section{margin:0 auto;}
label{float:left;width:100px;line-height:50px;color:#DDD;font-size:24px;cursor:pointer;font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;}
header input{float:right;width:60%;height:24px;margin-top:12px;text-indent:10px;border-radius:5px;box-shadow: 0 1px 0 rgba(255,255,255,0.24), 0 1px 6px rgba(0,0,0,0.45) inset;border:none}
input:focus{outline-width:0}
h2{position:relative;}
span{position:absolute;top:2px;right:5px;display:inline-block;padding:0 5px;height:20px;border-radius:20px;background:#E6E6FA;line-height:22px;text-align:center;color:#666;font-size:14px;}
ol,ul{padding:0;list-style:none;}
li input{position:absolute;top:2px;left:10px;width:22px;height:22px;cursor:pointer;}
p{margin: 0;}
li p input{top:3px;left:40px;width:70%;height:20px;line-height:14px;text-indent:5px;font-size:14px;}
li{height:32px;line-height:32px;background: #fff;position:relative;margin-bottom: 10px;
	padding:0 45px;border-radius:3px;border-left: 5px solid #629A9C;box-shadow: 0 1px 2px rgba(0,0,0,0.07);}
ol li{cursor:move;}
ul li{border-left: 5px solid #999;opacity: 0.5;}
li a{position:absolute;top:2px;right:5px;display:inline-block;width:14px;height:12px;border-radius:14px;border:6px double #FFF;background:#CCC;line-height:14px;text-align:center;color:#FFF;font-weight:bold;font-size:14px;cursor:pointer;}
footer{color:#666;font-size:14px;text-align:center;}
footer a{color:#666;text-decoration:none;color:#999;}
@media screen and (max-device-width: 620px) {section{width:96%;padding:0 2%;}}
@media screen and (min-width: 620px) {section{width:600px;padding:0 10px;}}
</style>
	</head>
	<body>
		<header>
			<section>
				<form action="javascript:postaction()" id="form">
					<label for="title">ToDoList</label>
					<input type="text" id="title" name="title" placeholder="添加ToDo" required="required" autocomplete="off" />
				</form>
			</section>
		</header>
		<section>
			<h2 onclick="save()">任务列表 <span id="todocount"></span></h2>
			<ol id="todolist" class="demo-box">
			</ol>
		</section>
		<footer>
			<a href="javascript:clear();">clear</a>
		</footer>
		<script >
    function clear(){
	localStorage.clear();
	load();
}

function postaction(){
	var title = document.getElementById("title");
	if(title.value == "") {
		alert("内容不能为空");
	}else{
		var data=loadData();
		var todo={"title":title.value,"done":false};
		data.push(todo);
		saveData(data);
		var form=document.getElementById("form");
		form.reset();
		load();
	}
}

function loadData(){
	var collection=localStorage.getItem("todo");
	if(collection!=null){
		return JSON.parse(collection);
	}
	else return [];
}

function saveSort(){
	var todolist=document.getElementById("todolist");
	var donelist=document.getElementById("donelist");
	var ts=todolist.getElementsByTagName("p");
	var ds=donelist.getElementsByTagName("p");
	var data=[];
	for(i=0;i<ts.length; i++){
		var todo={"title":ts[i].innerHTML,"done":false};
		data.unshift(todo);
	}
	for(i=0;i<ds.length; i++){
		var todo={"title":ds[i].innerHTML,"done":true};
		data.unshift(todo);
	}
	saveData(data);
}

function saveData(data){
	localStorage.setItem("todo",JSON.stringify(data));
}

function remove(i){
	var data=loadData();
	var todo=data.splice(i,1)[0];
	saveData(data);
	load();
}

function update(i,field,value){
	var data = loadData();
	var todo = data.splice(i,1)[0];
	todo[field] = value;
	data.splice(i,0,todo);
	saveData(data);
	load();
}

function edit(i)
{
	load();
	var p = document.getElementById("p-"+i);
	p.innerHTML="<input id='input-"+i+"' value='"+title+"' />";
	var input = document.getElementById("input-"+i);
	input.setSelectionRange(0,input.value.length);
	input.focus();
	input.onblur =function(){
		if(input.value.length == 0){
			p.innerHTML = title;
			alert("内容不能为空");
		}
		else{
			update(i,"title",input.value);
		}
	};
}

function load(){
	var todolist=document.getElementById("todolist");
	var donelist=document.getElementById("donelist");
	var collection=localStorage.getItem("todo");
	if(collection!=null){
		var data=JSON.parse(collection);
		var todoCount=0;
		var doneCount=0;
		var todoString="";
		var doneString="";
		for (var i = data.length - 1; i >= 0; i--) {
			if(data[i].done){
				doneString+="<li draggable='true'><input type='checkbox' οnchange='update("+i+",\"done\",false)' checked='checked' />"
				+"<p id='p-"+i+"' οnclick='edit("+i+")'>"+data[i].title+"</p>"
				+"<a href='javascript:remove("+i+")'>-</a></li>";
				doneCount++;
			}
			else{
				todoString+="<li draggable='true'><input type='checkbox' οnchange='update("+i+",\"done\",true)' />"
				+"<p id='p-"+i+"' οnclick='edit("+i+")'>"+data[i].title+"</p>"
				+"<a href='javascript:remove("+i+")'>-</a></li>";
				todoCount++;
			}
		};
		todocount.innerHTML=todoCount;
		todolist.innerHTML=todoString;
		donecount.innerHTML=doneCount;
		donelist.innerHTML=doneString;
	}
	else{
		todocount.innerHTML=0;
		todolist.innerHTML="";
		donecount.innerHTML=0;
		donelist.innerHTML="";
	}

	var lis=todolist.querySelectorAll('ol li');
	[].forEach.call(lis, function(li) {
		li.addEventListener('dragstart', handleDragStart, false);
		li.addEventListener('dragover', handleDragOver, false);
		li.addEventListener('drop', handleDrop, false);

		onmouseout =function(){
			saveSort();
		};
	});		
}

window.onload=load;

window.addEventListener("storage",load,false);

var dragSrcEl = null;
function handleDragStart(e) {
  dragSrcEl = this;
  e.dataTransfer.effectAllowed = 'move';
  e.dataTransfer.setData('text/html', this.innerHTML);
}
function handleDragOver(e) {
  if (e.preventDefault) {
    e.preventDefault();
  }
  e.dataTransfer.dropEffect = 'move';
  return false;
}
function handleDrop(e) {
  if (e.stopPropagation) {
    e.stopPropagation(); 
  }
  if (dragSrcEl != this) {
    dragSrcEl.innerHTML = this.innerHTML;
    this.innerHTML = e.dataTransfer.getData('text/html');
  }
  return false;
}
</script>
	</body>
</html>
