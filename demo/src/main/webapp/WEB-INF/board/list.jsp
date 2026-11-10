<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        #app{
            width: 800px;
            margin: 40px auto;
        }
        table {
            width: 750px;
        }
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }

        a{
            text-decoration: none;
            color: black;
        }
        a:hover{
            text-decoration: underline;
        }

        .cnt{
            font-size: 12px;
            color:coral;
            margin-left: 8px;
        }

        #paging {
            text-align: center;
        }
        #paging a{
            margin-right: 8px;
            text-decoration: none;
        }
        #paging .active{
            font-weight: bold;
        }

        .table{
            margin-bottom: 8px;
            width: 80px;
            text-align: center;
        }
        .search{
            text-align: center;
        }
        .search input{
            height: 24px;
            width: 240px;
        }

    </style>
</head>
<body>
    <div id="app">
        <h3>{{sessionName}}님 환영합니다!</h3>
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="search">
            검색어 : <input type="text" @keyup.enter="fnList" v-model="keyword" placeholder="검색어를 입력해주세요.">
            <button @click="fnList">검색</button>
        </div>
        <select class="table" v-model="pageSize" @change="fnList">
            <option value="">::전체::</option>
            <!-- 전체 처리 필요 -->
            <option value="5">5개씩</option>
            <option value="10">10개씩</option>
            <option value="20">20개씩</option>
            <option value="50">50개씩</option>
        <select>
        <table>
            <tr>
                <!-- <th>선택</th> -->
                <th><input type="checkbox" @click="fnSelectItem" v-model="checked" value="true"></th>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
            <tr v-for="item in list">
                <!-- <td><input type="radio" name="board" v-model="selectItem" :value="item.boardNo"></td> -->
                <td><input type="checkbox" @change="fnSelect" name="board" v-model="selectItemList" :value="item.boardNo"></td>
                <td>{{item.boardNo}}</td>
                <td><a href="javascript:;" @click="fnView(item.boardNo)">{{item.title}}</a>
                    <span class="cnt">[{{item.cnt}}]</span>
                </td>
                <td>{{item.userId}}</td>
                <td>{{item.cDateTime}}</td>
            </tr>
        </table>
        <div id="paging">
            <a href="javascript:;" v-if="currentPage != 1" @click="currentPage--; fnList();">◀</a>
            <a @click="currentPage = item; fnList();" :class="{active : currentPage == item}" href="javascript:;" v-for="item in idx">{{item}}</a>
            <a href="javascript:;" v-if="currentPage != idx" @click="currentPage++; fnList();">▶</a>
            <!-- 마지막 페이지가(idx) 아닐 때 보여야 함. -->
        </div>
        <!-- <button @click="fnRemove">삭제</button> -->
        <a href="add.do"><button>글쓰기</button></a>
        <!-- 만약 /add.do 슬래시 넣고 싶다면 board/add.do까지 작성해줘야 함 -->
        <button @click="fnRemoveAll">삭제</button>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId : "${sessionId}",
                sessionRole : "${sessionRole}",
                sessionName : "${sessionName}",

                list:[],
                selectItem : "", // 라디오 버튼으로 삭제할 때
                selectItemList: [], // 체크박스로 삭제할 때
                //allSelectFlg : false,
                checked : false,
                
                idx : 1, // 페이징 개수(최대 페이지 수)
                pageSize : 5, // 한페이지에 출력할 개수
                currentPage : 1, // 현재 페이지

                keyword : "" // 검색어
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {
                    limit : self.pageSize,
                    offset: self.pageSize * (self.currentPage-1),
                    
                    keyword: self.keyword
                };
                $.ajax({
                    url: "http://localhost:8080/board/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.idx = Math.ceil(data.count/self.pageSize);
                    }
                });
            },
            fnRemove : function(){
                let self = this;
                if(self.selectItem == ""){
                    alert("삭제할 게시물을 선택하세요.");
                    return;
                }
                if(!confirm("정말 삭제하시겠습니까?")){
                    return;
                }

                let param = {boardNo : self.selectItem};
                $.ajax({
                    url: "http://localhost:8080/board/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        self.fnList();
                        self.selectItem="";
                    }
                });
            },
            fnRemoveAll : function(){
                let self = this;
                console.log(self.selectItemList);
                if(self.selectItemList.length == 0){
                    alert("삭제할 게시물을 선택하세요.");
                    return;
                }
                if(!confirm("정말 삭제하시겠습니까?")){
                    return;
                }

                let param = {selectItemList : JSON.stringify(self.selectItemList)}; 
                // 이 함수적용 안하면 리스트 맨 앞 원소 하나만 보내게 되어서 Json형태의 뭐시기로 바꿔야 온전한 리스트 형태로 감.
                $.ajax({
                    url: "http://localhost:8080/board/remove-all.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        self.fnList();
                        self.selectItemList=[];
                        self.checked = false; // 여기서 checked flase로 초기화
                    }
                });
            },
            fnSelectItem : function(){ 
                // 이 함수가 실행되는 순서가 checked의 value에 true가 들어가는 것보다 먼저임.
                // 그래서 밑에 if(!self.checked)조건을 검사할 때 checked는 false에서 true로 넘어가려는 상태.
                // 즉, 아직 false 상태임!! 그래서 이 코드가 작동하는 것.
                let self = this;
                // for(let i=0; i<self.list.length; i++){
                //     self.selectItemList.push(self.list[i].boardNo);
                // }
                // self.allSelectFlg= !self.selectFlg;
                self.selectItemList = []; // 값이 중복해서 들어가지 않게 초기화해야.
                if(!self.checked){ // false상태에서 true가 되어 전체 선택됨. 근데 선택하면 true가 되는데..
                    self.list.forEach(map => {
                        self.selectItemList.push(map.boardNo);
                    });
                }
            },
            fnSelect : function(){
                let self = this;
                self.checked = self.list.length == self.selectItemList.length;
            },
            fnView : function(boardNo){
                let self = this;
                pageChange("view.do", {boardNo : boardNo});
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>