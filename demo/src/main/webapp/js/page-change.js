function pageChange(url, param) {
    var target = "_self"; // 링크걸 때 현페이지 출력인가 팝업띄울것인가 나타내는 속성
    if(param == undefined) {
        return;
    } // url 내가 이동하고자 하는 페이지 주소 , param 맵형태. 내가 보내고자 하는 데이터
	// location.href = ~는 get으로 이동하는거임. post 이동이 안되니까 우린 이 pageChange 메소드를 쓰는거임.
	// 리턴도 map임!
    
    var form = document.createElement("form"); 
    form.name = "dataform";
    form.action = url;
    form.method = "post";
    form.target = target;

    for(var name in param){
        var item = name;
        var val = "";
        if(param[name] instanceof Object){
            val = JSON.stringify(param[name]);
        } else {
            val = param[name];
        } // 파람 json 형태로 바꿈
        
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = item;
        input.value = val;
        form.insertBefore(input, null);
    }

    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}