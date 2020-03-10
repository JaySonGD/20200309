if ( WEBGL.isWebGLAvailable() === false ) {

    document.body.appendChild( WEBGL.getWebGLErrorMessage() );
}  

/*--------------------------变量定义--------------------------------*/
// html容器
var container;
// 表示3D模型控件的宽度大小占比,113是APP部分卡片控件右边界距离屏幕左边的距离
var screen1 = 75;  // 主页占比
var screen2 = 100;	//局部占比
var widthOfModelPercent=screen1;
//	记录3D渲染相关
var camera=false, scene=null, renderer=null, controls=null, sceneBk=null, cameraBk=null;
// 记录模型mesh
var meshUser=null, meshDefault=null;
var windowHeight = window.innerHeight, windowWidth = window.innerWidth;
// 创建meshPhone材质
var textureLoader = new THREE.TextureLoader();
var decalSpecular = textureLoader.load( 'models/texture/2.png' );
var materialUserDefault = new THREE.MeshPhongMaterial( {
    specular: 0xF9FEFE,
    shininess: 20,
	bumpMap: decalSpecular,
	bumpScale: 10,  
    opacity:1,
    // 渲染数据深度缓存
    needsUpdate:true,
    // // 深度缓存数据，影响模型是否镂空
    depthWrite:true,
    // 阴影设置
    clipShadows: true,
    // 模型可见设置
    visible: true,
} );

// 记录用户模型uuid或者标准模型uuid，用于确认点击哪个模型
var clickuuidUser=null;
// 记录当前点击的位置坐标
var clickx=null, clicky=null, clickz=null;
var isScale=false;
// 状态符 0:主界面，1：局部对比，2：
var status = 0;
// 记录局部查看的是哪个部位
var scale_label = ["down", "normal", "up"];
var scale_index=0;
var partChoose="";
// 模型放大倍数
var size = 40;
// 模型放置时的初始位置设置
var position = new THREE.Vector3();
var modelOffsetX=null, 
	modelOffsetY=null, 
	modelOffsetZ=null;

var pointsOfScene = [];

var modelOffsetXDefault=0;
var modelOffsetYDefault=0;
var modelOffsetZDefault=0;
var boundingbox_yDefault=0;

var boundingbox_y = 0;
// 优化 由于不会变，所以放到全局上
var skyBoxGeometry = new THREE.BoxGeometry(35, 30, 30);
var texture = new THREE.TextureLoader().load("models/texture/circle4.png");
var clearTexture = new THREE.TextureLoader().load("models/texture/clear.png");
// 优化边缘锯齿
texture.wrapS = 1001;
texture.wrapT = 1001;
var skyBoxMaterial = [
	new THREE.MeshBasicMaterial({map: clearTexture}),
	new THREE.MeshBasicMaterial({map: clearTexture}),
	new THREE.MeshBasicMaterial({map: texture}),
	new THREE.MeshBasicMaterial({map: clearTexture}),
	new THREE.MeshBasicMaterial({map: clearTexture}),
	new THREE.MeshBasicMaterial({map: clearTexture}),	
];
var skyBox = new THREE.Mesh(skyBoxGeometry, new THREE.MeshFaceMaterial(skyBoxMaterial));

// 记录模型存放位置
var uriUser={}, uriDefault={};
var isFirstD=true, isFirstU=true;
var arr = []
// 以下用于记录各个部位的X和Y方向上的边界值，以及旋转角度，中心点
/*------------------------------功能逻辑----------------------*/
// 渲染模型初始化及加载
init();
animate();

// test("models/test/4.json", 0);
// test("models/default/00.json", 2);
// function test(url, modelType){		
// 	$.ajax({
// 		url:url,
// 		async:false,
// 		dataType:"json",
// 		success:function(data){
// 			if(modelType == 0){
// 		  		isFirstU = true;
// 					// log(data);
// 				parseData(data['uriUser'], false);
// 				resetAll(false)
// 			}else if(modelType == 2){
// 				uriDefault["id"] = data["id"];
// 				uriDefault["ply"] = data["ply"];
// 				resetAll(true)

// 			}
// 		}
// 	});
// }


var yStart=0, yEnd=0;
$(document).on("touchstart", function onclickStart(event){
	event.preventDefault();
	yStart = event.touches[0].clientY;	
	log("[debug onclickStart()]yStart: "+  yStart);
});

var i = 0;
var j = 0;

// 模拟app操作
$('#reset').on("touchstart ",function(e){	
	appToH5("{\"reset\":\"1\"}");
	if(i==0){
		appToH5("{\"part\":\"bust\"}");
	}else if(i ==1){
		appToH5("{\"part\":\"waist\"}");
	}else if(i == 2){
		appToH5("{\"part\":\"hipline\"}");
	}else if(i==3){
		appToH5("{\"part\":\"leftThigh\"}");
	}else if(i==4){
		appToH5("{\"part\":\"leftLeg\"}");
	}else if(i==5){
		appToH5("{\"part\":\"rightThigh\"}");
	}else if(i ==6){
		appToH5("{\"part\":\"rightLeg\"}");
	}else if(i ==7){
		appToH5("{\"part\":\"rightLowerArm\"}");
	}else if(i == 8){
		appToH5("{\"part\":\"rightUpperArm\"}");
	}else if(i == 9){
		appToH5("{\"part\":\"leftUpperArm\"}");
	}else if(i == 10){
		appToH5("{\"part\":\"leftLowerArm\"}");
	}
	i+=1;
})





// 补抓点击事件,如果点击位置在模型上则拾取点击坐标
$(document).on("click touchend",function onDocumentMouseDown( event ) {
    // event.preventDefault();
    var vector = new THREE.Vector3();//三维坐标对象
    if(event.changedTouches){
	    vector.set(
	        (   (event.changedTouches[0].clientX-windowWidth*(100-widthOfModelPercent)/100) / (windowWidth*widthOfModelPercent/100) )  * 2 - 1,
	          -(event.changedTouches[0].clientY / windowHeight) * 2 + 1,
	                                                                      0.5);
	    // 点击坐标转换成3D空间坐标
	    vector.unproject(camera);
	    // 创建raycaster
	    var raycaster = new THREE.Raycaster(camera.position, 
	    									vector.sub(camera.position).normalize());
	    // 获取raycaster直线和所有模型相交的数组集合
	    var intersects = raycaster.intersectObjects(scene.children);
	    // 得出点击的坐标
	    var selected;		
	    // 获取新的坐标值之前先进行初始化，因为如果点击的是模型外部的化，坐标值是获取不到的。
	    // 所以在获取不到模型外的坐标值时默认初始值。
	    clickx=-1000, clicky=-1000, clickz=-1000;
	    for (let index in intersects) {
	        if(intersects[index].object.uuid == clickuuidUser){
	            selected = intersects[index];
	            clickx=parseFloat(selected.point.x.toFixed(6));
	            clicky=parseFloat(selected.point.y.toFixed(6));
	            clickz=parseFloat(selected.point.z.toFixed(6));
	            log("[debug onDocumentMouseDown()]click(x,y,z): " + 
	            			"(" + clickx + "," + clicky + "," + clickz + ")");
	            break;
	        }
	    }// for
		if(status == 1){
			var varName = getVarName();
			var part = ""
	    	// 判断点击的部位
		    for(let index in varName){
				eval('minX='+varName[index]+'User_minX');
				eval('minY='+varName[index]+'User_minY');
				eval('maxX='+varName[index]+'User_maxX');
				eval('maxY='+varName[index]+'User_maxY');	    
				if( (clickx >= minX && clickx <= maxX) &&
					(clicky >= minY-2 && clicky <= maxY+2)  ){
					part = varName[index]
					break;
				}
			}
			if(part == partChoose){
				yEnd = event.changedTouches[0].clientY;
				log("[debug onDocumentMouseDown()]yEnd: "+  yEnd);
				if((yStart-yEnd) < -10){	// 下滑
					// partChoose是全局变量，记录当前处于哪个部位的局部查看，在checkPart()中被改变数值
					scale_index -= 1;
					if(scale_index < 0){
						scale_index = 0;
					}else if(partChoose != 'bust'){
						log("[debug onDocumentMouseDown()]checkPart: "+partChoose)
						log("[debug onDocumentMouseDown()]checkLocal: "+scale_label[scale_index]);
						// 红线标注选中的维度
						checkPart(partChoose, partChoose, scale_label[scale_index]);
						//数据交互
						buttonAction('', scale_label[scale_index]);			
					}
				}else if((yStart-yEnd) > 10){// 上滑
					scale_index += 1;
					if(scale_index > 2){
						scale_index = 2;
					}else if(partChoose != 'bust'){
						log("[debug onDocumentMouseDown()]checkPart: "+partChoose)
						log("[debug onDocumentMouseDown()]checkLocal: "+scale_label[scale_index]);
						// 红线标注选中的维度
						checkPart(partChoose, partChoose, scale_label[scale_index]);
						//数据交互
						buttonAction('', scale_label[scale_index]);
					}
				}	
			}// part == partChoose			
	    }// status
	}// if(event.changedTouches)    
});




function loadUserModel(){
	if(meshUser){
		checkPart("","","");
	}	
  	// 更新用户模型相关坐标数据
   	// console.time('loadModel user');
	if(isFirstU){
	    loadModule(0.7, true, true, false);
		updatePart(false);		
	    // 当更新了用户模型时，如果标准模型存在需要重新加载标准模型
	    isFirstU = false;		
	}else{
		scene.add(meshUser);
		meshUser.geometry.center();
	}
  	addCircle(true, boundingbox_y, modelOffsetY)	
  	// console.timeEnd("loadModel user");
}

function loadDefaultModel(isDisplay){
	if(isDisplay && isFirstD){
		var ply;	
		ply = window.atob(uriDefault["ply"]);
		// uri获取模型ply数据
	    var loader = new THREE.PLYLoader();
		onLoad(loader.parse(ply));		
		isFirstD = false;
		addCircle(true, boundingbox_yDefault, modelOffsetYDefault)
	}else if (isDisplay && !isFirstD){
		scene.add(meshDefault)
		addCircle(true, boundingbox_yDefault, modelOffsetYDefault)
	}else if(!isDisplay && meshDefault){
		scene.remove(meshDefault)
		scene.dispose(meshDefault)
	}

    function onLoad( ply ) {
        // 模型大小设置
        ply.scale(size,size,size);
        // 更新模型顶点法线数据
        ply.computeVertexNormals();
		ply.computeBoundingBox();

        // 创建meshPhone材质
		var textureLoader = new THREE.TextureLoader();
		var decalSpecular = textureLoader.load( 'models/texture/2.png' );
        var material = new THREE.MeshPhongMaterial( {
            specular: 0xF9FEFE,
            shininess: 20,
			bumpMap: decalSpecular,
            opacity:1,
            needsUpdate:true,
            // // 深度缓存数据，影响模型是否镂空
            depthWrite:true,
            // 模型可见设置
            visible: true,
        } );

        // 创建mesh
        var mesh = new THREE.Mesh(ply, material);
        mesh.renderOrder=1;
        mesh.rotateX(Math.PI);
		modelOffsetXDefault = ply.boundingBox.getCenter().x
	    modelOffsetYDefault = ply.boundingBox.getCenter().y
	    modelOffsetZDefault = ply.boundingBox.getCenter().z
	    boundingbox_yDefault = ply.boundingBox.min.y
        mesh.geometry.center()
        
        log(mesh);
        // 保存创建的mesh信息
        scene.remove(meshDefault)
       	scene.dispose(meshDefault);
        meshDefault=mesh;
        scene.add( mesh );
    }// onLoad()	

}

function resetAll(loadDefault){
	setContainWdith(screen1);
	if(camera){
		setCmaeraAspect(screen1);
	}	
	partTarget("")
    log("[debug ()]reset");
	isScale = false; // 用于记录维度点击，每次进入局部之前需要设置该值为false，当iscale为true表示处于局部不需要修改视角
    if(!loadDefault){
    	loadDefaultModel(loadDefault);
	    loadUserModel();
	    status = 0;
    }else{
    	if(meshUser){
    		checkPart("","","");
	    	scene.remove(meshUser)
    		scene.dispose(meshUser)
    	}
		loadDefaultModel(loadDefault);
		status = -1;
    }
}


function parsePartData(partData, isTypical){
	if(!isTypical){
		// 获取各个部位坐标
		for(let key in partData){
			var isPart=false;
			var partValue={};
			if(	key == "bust"){
				isPart=true;
				partValue["normal"] = partData[key]["normal"]["location"];
			}else if(	key == "leftThigh" 	|| 	key == 	"leftUpperArm" 	||
						key == "rightThigh" ||	key	==	"rightUpperArm"	){
				isPart=true;
				partValue["up"] 		=	partData[key]["normal"]["location"];
				partValue["normal"]		=	partData[key]["down"]["location"];
				partValue["down"]		=	partData[key]["down1"]["location"];
			}else if(	key == "hipline"	||	key ==	"waist"		   	||
						key == "leftLeg"	||  key ==  "leftLowerArm"	||
						key == "rightLeg"	||	key ==	"rightLowerArm"	){
				isPart=true;
				partValue["up"] 		=	partData[key]["up"]["location"]	;
				partValue["normal"]		=	partData[key]["normal"]["location"]	;
				partValue["down"]		=	partData[key]["down"]["location"]	;
			}
			if(isPart){
				var part = partNameMap(key);
				// log("[debug parsePartData()]key=>part: "+ key + "=>" + part);
				uriUser[part] = partValue;
				// log("[debug parsePartData()] partValue: ");
				// log(partValue);
				log("[debug parsePartData()] uriUser part: ");
				log(uriUser[part]);				
			}
		}// for
	}
}

	
function parseData(data, isTypical){
	if(!isTypical){
		// 记录模型id
		uriUser["id"] = data["id"];
		log("[debug partData()]data[\"id\"]=>id: ", data["id"] + "=>" + uriUser["id"]);
		// 记录ply数据
		uriUser["ply"] = data["ply"];
		//解析各个部位数据
		uriUser["result"] = data;
		// uriUser["result"] = data["result"];
		parsePartData(uriUser["result"], false);
	}
}


function getDefaultData(url){
	$.ajax({
		url:url,
		async:false,
		dataType:"json",
		success:function(data){
			uriDefault["id"]  = data["id"];
			uriDefault["ply"] = data["ply"];
		}
	});
}

//app调用js接口传入参数
// 备注：此接口中if的顺序是按照交互逻辑设计的，如果逻辑无改动，请勿修改
function appToH5(json){
   var msg = $.parseJSON( json );
   // 交互：重置操作，即返回初始界面
   if(msg.reset == 1){
   		resetAll(false);
   }
   if(msg.uriDefault != undefined){
   		if(msg.uriDefault == 1){// 女性模型
   			log(1)
   			if(uriDefault["id"] && uriDefault["id"] == '01'){
   				resetAll(true);
   			}else{
				loadDefaultModel(false);
   				isFirstD = true;
				getDefaultData('models/default/01.json')
				resetAll(true)   				
   			} 
   		}else if(msg.uriDefault == 0){// 男性模型
   			log(0)
   			if(uriDefault["id"] && uriDefault["id"] == '00'){
   				resetAll(true);
   			}else{
				loadDefaultModel(false);		
	   			isFirstD = true;
				getDefaultData('models/default/00.json')
				resetAll(true)   				
   			}
   		}
   }
   // 交互：更新加载的用户模型
   if(msg.uriUser && msg.uriUser["id"]){
   		if(msg.uriUser["id"] != uriUser["id"]){
	   		log("[debug appToH5()]update userModel: " + msg.uriUser["id"]); 	   	
		   	// 解析模型数据
		   	parseData(msg.uriUser, false);
		   	isFirstU = true;
		   	resetAll(false)   			
   		}else{
	   		log("[debug appToH5()]update userModel: " + msg.uriUser["id"]); 	   	
		   	resetAll(false)   			
   		}
  }
   // 交互：局部查看
   if(msg.part){
   		var part = partNameMap(msg.part);
   		log("[debug appToH5()]checkPart msg:"+part);
   		if(part == "leftThigh" 	|| 	part == 	"leftUpperArm" 	||
			part == "rightThigh" ||	part	==	"rightUpperArm"	){
	   		checkPart(part, part, "up");
	   		scale_index=2
   		}else{
   			checkPart(part, part, "normal");
   			scale_index=1
   		}	
   		status = 1;
   }
}

// 部位命名抓换，本脚本使用的部位变量和交互约定的部位值有差异，所以做个映射
function partNameMap(part){
	var partMap = {	"hip"			: 	"hipline"		,
					"hipline"		: 	"hip"			,
					"leftLowerArm"	: 	"leftForearm"	,
					"leftForearm"	: 	"leftLowerArm"	,
					"rightLowerArm" : 	"rightForearm"	,
					"rightForearm" 	: 	"rightLowerArm"	, 
					"leftShank"		: 	"leftLeg"		,
					"leftLeg"		: 	"leftShank"		,
					"rightShank" 	: 	"rightLeg" 		,
					"rightLeg"		: 	"rightShank"	,
					"leftUpperArm"  : 	"leftUpperArm" 	,
					"rightUpperArm" : 	"rightUpperArm"	,
					"bust"			: 	"bust"			,
					"leftThigh"		: 	"leftThigh"		,
					"rightThigh"	: 	"rightThigh"	,
					"waist"			: 	"waist"			,
					"hipLine"		: 	"hip"			,
					""				: 	""
				}
	return partMap[part];
}

// h5调用app接口传入参数
/*
 *---局部查看和局部对比时交互的11个部位--  |  -----当局部查看时还增加以下12个部位-----   
 *此列为part，scale两个参数共同的取值 		|  此列为scale额外的取值
 *参数 part/scale 部位类型：   			|  参数 scale  部位类型
 *左上臂：leftUpperArm 					|  左上臂下维度1：leftUpperArmDown1
 *右上臂：rightUpperArm 					|  左上臂下维度2：leftUpperArmDown2
 *左下臂：leftForearm 					|  右上臂下维度1：rightUpperArmDown1
 *右下臂：righForearm 					|  右上臂下维度2：rightUpperArmDown2
 *胸：bust 								|  左下臂上维度：leftForearmUp
 *臀：hipline							|  左下臂下维度：leftForearmDown
 *腰：waist 								|  右下臂上维度：rightForearmUp
 *左小腿：leftShank 						|  右下臂下维度：rightForearmDown
 *左大腿：leftThigh 						|  臀上维度：hipUp
 *右小腿：rightShank						|  臀下维度：hipDown
 *右大腿：rightThigh 					|  腰上维度：waistUp
 *                    					|  腰下维度：waistDown
 */
function buttonAction(part, scale) {
	// 获取浏览器useragent，判断是安卓端还是ios端
	var u = navigator.userAgent;
	var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
    if(isAndroid){ //android
    	if(part){//局部对比
			part = partNameMap(part);
		    log("[debug buttonAction()]check part:" + part);
	        window.android.h5ToApp("{" + "\"part\"" + ":" + part + "}");    		
    	}else if(scale){//局部查看
		    console	.log("[debug buttonAction()]check scale:" + scale);
	        window.android.h5ToApp("{" + "\"scale\"" + ":" + scale + "}");    		    		
    	}
    }else{//ios
    	if(part){//局部对比
		    part = partNameMap(part);
		    log("[debug buttonAction()]check part:" + part);
	        window.webkit.messageHandlers.h5ToApp.postMessage(
	        	{"part": part}
	        );
    	}else if(scale){//局部查看
		    log("[debug buttonAction()]check scale:" + scale);
		    window.webkit.messageHandlers.h5ToApp.postMessage(
	        	{"scale": scale}
	        );   	
		}

    }// else

}//buttonAction()


/*--------------------------------------相关函数--------------------------*/
// 输出日志
function log(str){
	console.log(str)
}


/*模块所属：模型11个部位相关坐标全局变量的更新
 *调用接口：getVarName()
 *接口功能：返回11个部位的名字
 *接口参数：无
 *参数解释：
 *   备注：多个地方使用到
 */
function getVarName(){
	var varName =   [ 'rightUpperArm', 'leftUpperArm',     //右上臂，左上臂
                       'rightForearm',  'leftForearm',     //右下臂，左下臂
                         'rightThigh',    'leftThigh',     //右大腿，左大腿
                         'rightShank',    'leftShank',     //右小腿，左小腿
                                'hip',        'waist',     //臀，腰
                               'bust',                     //胸
                    ]
    return varName;
}

/*模块所属：模型11个部位相关坐标全局变量的更新
 *调用接口：updatePart(uri)
 *接口功能：更新部位坐标包括：计算模型部位角度偏差，中心点
 *接口参数：uri
 *参数解释：11个部位坐标数据存在的目录路径
 *    备注：无
 */
function updatePart(isTypical){
    var varName =  getVarName();
	//更新中心点，角度    
	for(let index in varName){
		// var partData = uriUser[varName[index]]	//partData = {up:[{"x":},{"y":},{"z"}], normal: down:}
		var part = varName[index];
		if(!isTypical){
			part = part+'User';
			log("[debug updatePart()] part point: " + part);
	        updatePoint(varName[index], part, false);// e.g.:hip, hipUser	
    		log("[debug updatePart()] part MinMax: " + part);
	        updateMinMax(varName[index], part, false)// e.g.: hip, hipUser
		}
	}

    // 更新部位中心点和部位角度
	function updatePoint(index, part, isTypical){//index: hip, leftShank, part:leftShankUser, leftThighUser, leftShankTypical...
        // 找出最大X值和最小X值的点
	    var normal;
	    if(!isTypical){
	    	// 获得部位数据
	    	normal = uriUser[index]["normal"];
	    }
	    var minX=1000, maxX=-1000,
		 	minY=1000, maxY=-1000,
     		minZ=1000, maxZ=-1000;
		for(let i in normal){
			point = normal[i];
			// log("[deubg updatePoint()]normal.point(x,y,z): " + "(" + point["x"] + "," + point["y"] + ","+  point["z"] + ")");
			if(point["x"] > maxX){
				maxX = parseFloat(point["x"].toFixed(6));
				maxY = parseFloat(point["y"].toFixed(6));
				maxZ = parseFloat(point["z"].toFixed(6));
				
			}
			if(point["x"] < minX){
				minX = parseFloat(point["x"].toFixed(6));
				minY = parseFloat(point["y"].toFixed(6));
				minZ = parseFloat(point["z"].toFixed(6));					
			}	
		}// for
        // 计算角度：最大点和最小点X方向Y方向的距离，求角度
        var right_angle1 = Math.abs(maxX-minX);
        var right_angle2 = Math.abs(maxY-minY);
        var angle = Math.atan(right_angle2/right_angle1);
        eval(part+'_midX= (maxX+minX)/2');//部位维度中心点
        eval(part+'_midY= (maxY+minY)/2');//部位维度中心点
        eval(part+'_midZ= (maxZ+minZ)/2');//部位维度中心点
        eval(part+'_angle = angle'); 
	}// updatePoint()

	// 更新部位边界
	function updateMinMax(index, part, isTypical){//part: leftShankTypical, leftThighUser, rightShankUser, rightThighTypical...
	    if(!isTypical){
	    	// 获得部位数据
    		data = uriUser[index];
	    }else{
	    	data = uriTypical[index];
	    }
	    var minX=1000, maxX=-1000,
		 	minY=1000, maxY=-1000,
     		minZ=1000, maxZ=-1000;	
		for(let scale in data){
			log("[debug updateMinMax()] scale:" + scale);
			for(let i in data[scale]){
				point = data[scale][i];
				// log("[deubg updateMinMax()point(x,y,z): " + "(" + point["x"] + "," + point["y"] + ","+  point["z"] + ")");
				var point = getPointXYZ(point["x"], point["y"], point["z"]);

				if(point["x"] > maxX){maxX = point["x"];} 
				if(point["x"] < minX){minX = point["x"];}
				if(point["y"] > maxY){maxY = point["y"];}
				if(point["y"] < minY){minY = point["y"];}	
			}// for
		}// fpr
		eval(part+'_minX=minX');
		eval(part+'_minY=minY');
		eval(part+'_maxX=maxX');
		eval(part+'_maxY=maxY');	
		log("[debug updateMinMax()]" + minX, minY, maxX, maxY);
        // log("[debug updatePart()] part MinMax: "+part);       		
	}// updateMinMax()
}//updatePart()

/*模块所属：模型11个部位相关坐标全局变量的更新
 *调用接口：getPointXYZ(x,y,z)
 *接口功能：返回部位文件中某个点经过空间变化后的坐标值
 *接口参数：x,y,z
 *参数解释：点坐标
 *    备注：多个地方使用
 */
function getPointXYZ(x,y,z){
	var pointMaterial = new THREE.PointsMaterial({
		color: 0xFF0000,
		size: 0.5,
	});
	// 创建几何空间，并将点放置空间中
	var geom = new THREE.Geometry();
	var p1 = new THREE.Vector3(x*size, y*size, z*size);
	// var p1 = new THREE.Vector3(x, y, z);

	geom.vertices.push(p1);
	var points = new THREE.Points(geom, pointMaterial);
	// 点在3D空间的变化映射
	points.rotateX(Math.PI);
	points.position.x -= modelOffsetX;
	points.position.y += modelOffsetY;
	points.position.z += modelOffsetZ;
	// 取出空间的点
	p1 = points.geometry.vertices.pop();
	var pointX = parseFloat(( p1.x - modelOffsetX).toFixed(6)),
		pointY = parseFloat((-p1.y + modelOffsetY).toFixed(6)),
		pointZ = parseFloat((-p1.z + modelOffsetZ).toFixed(6)); 
	// log("[debug getPointMinMax()] point: " + 
				// "(" + pointX + "," + pointY + "," + pointZ + ")");
	return {"x":pointX, "y":pointY, "z":pointZ};
}

/*模块所属：局部查看
 *调用接口：checkPart(index, part, scale)
 *接口功能：局部查看某些部位各个维度信息，红圈标注
 *接口参数：index, part
 *参数解释:index是部位坐标数据检索值，part是查看的部位，如下是part的具体取值范围，scale是需要标红圈的局部维度，取值为up,normal,down
 *                     index/part取值     	 	部位名字
 * 					  "rightUpperArm"	 	 	右上臂
 *				 	   "leftUpperArm"			左上臂
 *                     "rightForearm"			右下臂
 *                      "leftForearm"			左下臂
 *                       "rightThigh"			右大腿
 *                        "leftThigh"			左大腿
 *                       "rightShank"			右小腿    
 *                        "leftShank"			左小腿
 *                            	"hip"			臀   
 *                            "waist"			腰
 *                             "bust"			胸
 *                
 *    备注：导入标准模型和用户模型后使用
 */
function checkPart(index, part, scale){  
    partChoose = part;
    log("[debug checkPart()]partChoose: " + partChoose);
    // 先删除已标注的部位红圈，如果有的话
    var len = pointsOfScene.length;
    for(var i=0;i<len;i++){
		var points = pointsOfScene.pop();
    	scene.remove(points);    	
    }
    if(part != ""  &&  scale != ""){
	    // 标注需要的部位维度红圈，该部位其余维度为灰色
	    drawPart(index,scale)	
	    // 标注需要的部位阴影
	    log("isScale: " + isScale)
	    if(isScale == false){
	    	setContainWdith(screen2);
	    	setCmaeraAspect(screen2);
	    	addCircle(false,"","")
		    // 调整局部视角
		    isScale = true;	   
    	    partTarget(part); 	
	    }
    }

	//局部查看：标注局部维度线圈颜色
	function drawPart(index, scale){
		// 获得局部维度数据
		var data = uriUser[index];
		
		//点材质定义
		for(let s in data){// 每个维度，up，normal，down
			var pointMaterial = new THREE.PointsMaterial({
				// color: 0xFF0000,
				size: 0.5,
			});
			var arr = []
			var geom = new THREE.Geometry();
			for(let i in data[s]){// 维度所有点
				point  = data[s][i];
				// log(point);
				// log("[deubg drawPart()] (x,y,z) = " + "(" + point["x"]*size + "," + point["y"]*size + ","+ point["z"]*size + ")");
				var p1 = new THREE.Vector3(point["x"]*size, point["y"]*size, point["z"]*size)
				// geom.vertices.push(p1);
				arr.push(p1)
			}
			var curve = new THREE.ClosedSplineCurve3(arr)
			geom.vertices = curve.getPoints(10000)
			// var points = new THREE.Line(geom, new THREE.LineBasicMaterial({color:0x0000ff, linewidth:8}))
			var points = new THREE.Points(geom, pointMaterial);
			log("[deubg drawPart()]scale s=>scale:" + s + "=>" + scale);
			// 修改points线圈的颜色
			if(s == scale){
				log("[deug drawPart()] s==scale? true")
				points.material.color = new THREE.Color(0xF55D5D);//红色偏暖
			}else{
				log("[deug drawPart()] s==scale? false")
				// points.material.color = new THREE.Color(0xF55D5D);//红色偏暖
				points.material.color = new THREE.Color(0xC8C7C5);//灰色偏白
			} 
			points.rotateX(Math.PI);   	
			points.position.x -= modelOffsetX;
			points.position.y += modelOffsetY;
			points.position.z += modelOffsetZ;
			scene.add(points);	
			pointsOfScene.push(points);
		}
	}//drawPart()
}

/*模块所属：3D渲染
 *调用接口：setRoomRender()
 *接口功能：3D空间光源，场景渲染
 *接口参数：无
 *参数解释：无
 *    备注：
 */
function setRoomRender(){
	renderer = new THREE.WebGLRenderer({ alpha:true, antialias: true });
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.localClippingEnabled = true;
    renderer.sortObjects = false;

    // 创建场景对象
    scene = new THREE.Scene();
    sceneBk = new THREE.Scene();

    // 相机创建，参数为可视角度，实际窗口的纵横比，近处裁面距离，远处裁面距离
    camera = new THREE.PerspectiveCamera( 50, (windowWidth*screen1/100)/ (windowHeight*100/100), 1, 1000 );

    // 影响模型远近
    var nz = 115
    // 相机位置
    camera.position.z = nz;
    camera.position.x =0;
    camera.position.y =	0;
    
    cameraBk = new THREE.PerspectiveCamera( 50, windowWidth*screen1/100/ windowHeight, 1, 1000 );
    // 相机位置
    cameraBk.position.z = nz;
    cameraBk.position.x =0;
    cameraBk.position.y =0;
    

    // 控制器
    controls = new THREE.OrbitControls( camera, renderer.domElement );
    // 相机距离焦点最近距离
    controls.minDistance = nz;
    // 禁止平移
    controls.enablePan = false;
    // 不开启缩放操作
    controls.enableZoom = false;
    // 限制左右旋转
    controls.minPolarAngle=Math.PI/2;
    controls.maxPolarAngle = Math.PI/2;

  	var hemiLight = new THREE.HemisphereLight(0xF9FEFE, 0x000000, 1);
	hemiLight.position.set(0, 100, 0); //这个也是默认位置
	scene.add(hemiLight);
 
	var spotLight = new THREE.SpotLight( 0xEFFFFF, 0.1	);
	spotLight.position.set( 0, -10, -10 );
	spotLight.position.multiplyScalar( 700 );
	scene.add( spotLight );
	spotLight.castShadow = true;
	spotLight.shadow.mapSize.width = 2048;
	spotLight.shadow.mapSize.height = 2048;
	spotLight.shadow.camera.near = 200;
	spotLight.shadow.camera.far = 1500;
	spotLight.shadow.camera.fov = 40;
	spotLight.shadow.bias = - 0.005;


    var spotLight = new THREE.SpotLight( 0xEFFFFF, 0.1);
	spotLight.position.set( 0, -10, 10 );
	spotLight.position.multiplyScalar( 700 );
	scene.add( spotLight );
	spotLight.castShadow = true;
	spotLight.shadow.mapSize.width = 2048;
	spotLight.shadow.mapSize.height = 2048;
	spotLight.shadow.camera.near = 200;
	spotLight.shadow.camera.far = 1500;
	spotLight.shadow.camera.fov = 40;
	spotLight.shadow.bias = - 0.005;

    var spotLight = new THREE.SpotLight( 0xEFFFFF, 0.1);
	spotLight.position.set( 0.5, 0, 1 );
	spotLight.position.multiplyScalar( 700 );
	scene.add( spotLight );
	spotLight.castShadow = true;
	spotLight.shadow.mapSize.width = 2048;
	spotLight.shadow.mapSize.height = 2048;
	spotLight.shadow.camera.near = 200;
	spotLight.shadow.camera.far = 1500;
	spotLight.shadow.camera.fov = 40;
	spotLight.shadow.bias = - 0.005;


	var spotLight = new THREE.SpotLight( 0xEFFFFF, 0.1);
	spotLight.position.set( 0.5, 0, -1 );
	spotLight.position.multiplyScalar( 700 );
	scene.add( spotLight );
	spotLight.castShadow = true;
	spotLight.shadow.mapSize.width = 2048;
	spotLight.shadow.mapSize.height = 2048;
	spotLight.shadow.camera.near = 200;
	spotLight.shadow.camera.far = 1500;
	spotLight.shadow.camera.fov = 40;
	spotLight.shadow.bias = - 0.005;
}//setModuleRender()


// isadd为true表示需要添加圈，添加圈会把现有的圈移除
// y_mergin是模型的下边界
// y_offset是模型居中的偏移量
function addCircle(isAdd, y_mergin, y_offset){
	sceneBk.remove(skyBox);
	sceneBk.dispose(skyBox);
	if(isAdd){
		// log("y_mergin: " + y_mergin)
		// log("y_offset: " + y_offset)
		// log("boundingbox_y: "+ (y_mergin-y_offset))
		// 15是正方体长的一半,这样正方体的俯视面与脚底面重合
		skyBox.position.y = (y_mergin-y_offset-15); 
		// log("添加图片")
		sceneBk.add(skyBox);	
	}else{
		sceneBk.remove(skyBox);
		sceneBk.dispose(skyBox);
	}

}

/*模块所属：3D渲染
 *调用接口：loadModule()
 *接口功能：模型加载
 *接口参数： uri：					plym模型路径
 *			opacity:0-1, 			透明度
 *			visible:boolean， 		可见与否
 *			clipShadows:boolean，   阴影与否
 *			isTypical:boolean，     是否导入的是标准模型
 *参数解释：无
 *    备注：
 */

 // 更新模型上述部位坐标变量中缺失的中心点及角度值
function loadModule(opacity, visible, clipShadows, isTypical) {
	var ply;	
   // 调试信息：查看加载的模型
    log("[debug loadModule()]modeluri user: " + uriUser["id"]);
	// log(uriUser["ply"])
	ply = window.atob(uriUser["ply"]);
	// ply = uriUser["ply"]
	// log(ply);

	// uri获取模型ply数据
    var loader = new THREE.PLYLoader();

	onLoad(loader.parse(ply));
    function onLoad( ply ) {
        // 模型大小设置
        ply.scale(size,size,size);
        // 更新模型顶点法线数据
        ply.computeVertexNormals();
		ply.computeBoundingBox();
        // 创建mesh
        var mesh = new THREE.Mesh(ply, materialUserDefault);
        mesh.renderOrder=1;
        mesh.rotateX(Math.PI);
		modelOffsetX = ply.boundingBox.getCenter().x
		modelOffsetY = ply.boundingBox.getCenter().y
		modelOffsetZ = ply.boundingBox.getCenter().z

		boundingbox_y = ply.boundingBox.min.y
        mesh.geometry.center()

        log(mesh);
        // 保存创建的mesh信息
        scene.remove(meshUser)
        scene.dispose(meshUser);
        meshUser=mesh;
        clickuuidUser = mesh.uuid;
        scene.add( mesh );
    }// onLoad()	
} // loadModule


/*模块所属：局部对比
 *调用接口：partTarget(part)
 *接口功能：依据局部查看的部位调整相机位置
 *接口参数：part
 *参数解释：
 *    备注：无
 */
function partTarget(part){
	if(part != ""){
	   	eval('var middleX ='+ part+'User_midX*size-modelOffsetX');
	   	eval('var middleY ='+ part+'User_midY*size-modelOffsetY');
	   	eval('var middleZ ='+ part+'User_midZ*size-modelOffsetZ');
	   	
	    controls.target = new THREE.Vector3(middleX,-middleY,middleZ);
	    var distance = 35
	    controls.minDistance= distance

	    camera.position.x =  middleX;
	    camera.position.y = -middleY;
		camera.position.z = distance;		

		cameraBk.position.x =  middleX;
	    cameraBk.position.y = -middleY;
		cameraBk.position.z = distance;		
		
	}else if(part == ""){
	    // 控制器
	    controls.target = new THREE.Vector3(0,0,0);	  
 	    // 相机位置
 	    var distance = 115
	    camera.position.z = distance;
	    camera.position.x =0;
	    camera.position.y =	0;
	    	
	    cameraBk.position.z = distance;
	    cameraBk.position.x =0;
	    cameraBk.position.y =0;
	}
}


function setContainWdith(width) {
	widthOfModelPercent = width;
	if(width == 75){
		renderer.setSize( windowWidth*widthOfModelPercent/100, windowHeight*100/100); 		
		container.style.width = `${windowWidth}px`;
		container.style.height = `${windowHeight*100/100}px`;
		renderer.domElement.style.marginLeft = `${100-75}%`;
		renderer.domElement.style.marginBottom= `${-12.5}%`;
	}
	else{
		renderer.setSize( windowWidth*widthOfModelPercent/100, windowHeight*100/100); 		
		container.style.width = `${windowWidth}px`;
		container.style.height = `${windowHeight*100/100}px`;
		renderer.domElement.style.marginLeft = `${100-widthOfModelPercent}%`;
		renderer.domElement.style.marginBottom= `${0}%`;
	}
}


function setCmaeraAspect(width){
	camera.aspect = windowWidth*width/100 / windowHeight;
	camera.updateProjectionMatrix();
	cameraBk.aspect = windowWidth*width/100 / windowHeight;
	cameraBk.updateProjectionMatrix();
}

// webgl控制器加载
function animate() {
    controls.update();
    renderer.autoClear = false;
    renderer.render(sceneBk, cameraBk)
    renderer.render(scene, camera)
    requestAnimationFrame( animate );
}

// 3D模型渲染初始化
function init() {
	container = document.createElement( 'div' );
	// bottom = document.createElement('div');
	// bottom.style.height = `${windowWidth*12.5/100}px`;
    setRoomRender();
    container.appendChild( renderer.domElement );
	document.body.appendChild( container );
	// document.body.appendChild(bottom)
	document.addEventListener("touchmove",function(e){
	  e.preventDefault();
	  e.stopPropagation();
	},false);
} // init