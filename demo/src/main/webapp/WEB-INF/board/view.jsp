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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <h3>제목 : {{info.title}}</h3>
            <h3>작성자 : {{info.userId}} | 조회수 : {{info.cnt}}</h3>
            <hr>
            <h4>내용</h4>
            <img v-for="item in fileList" :src="item.filePath" :alt="item.fileName">
            <div v-html="info.contents"></div> 
            <!-- 문자취급 받던 html 속성을 실제로 적용해줌.-->
            <hr>
            <div v-if="sessionRole=='A' || sessionId == info.userId">
                <button @click="fnEdit">수정</button>
                <button @click="fnRemove">삭제</button>
            </div>
            <hr>
            <div v-for="(item,index) in cmtList">
                <span><strong>{{item.userId}}</strong></span>&nbsp;|&nbsp;
                <span v-if="index !== editIndex">{{item.contents}}</span>
                <input v-else type="text" v-model="editCmt">
                <button v-if="sessionId==item.userId" @click="fnEditComment(index)">수정</button>
                <button v-if="(sessionId==item.userId || sessionRole=='A') && index !== editIndex" @click="fnRemoveComment(item.commentNo)">삭제</button>
            </div>
            <div>
                댓글작성 : <input v-model="cmtContent" @keyup.enter="fnCmtAdd" style="width: 300px;">
                <button @click="fnCmtAdd">등록</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                boardNo : "${boardNo}",
                info: {},
                fileList : [],
                cmtList : [],

                cmtContent: "",
                
                sessionId : "${sessionId}",
                sessionRole : "${sessionRole}",

                editIndex:-1,
                editCmt:""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo,
                    option: "VIEW"
                };
                $.ajax({
                    url: "view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.fileList = data.fileList;
                        self.cmtList = data.cmtList;
                    }
                });
            },
            fnEdit : function(){
                let self = this;
                pageChange("edit.do", {boardNo : self.boardNo});
            },
            fnRemove : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo
                };

                if(!confirm("정말 삭제?")){
                    return;
                }
                $.ajax({
                    url: "remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(message);
                        if(data.result == "success"){
                            location.href="list.do";
                        }
                    }
                });
            },
            fnCmtAdd: function() {
                let self = this;
                let param = {
                    cmtContent : self.cmtContent,
                    boardNo : self.boardNo
                };
                $.ajax({
                    url: "add-comment.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.result == "success"){
                            self.fnInfo();
                            self.cmtContent = "";
                        }
                    }
                });
            },
            fnEditComment : function(index){
                let self = this;
                if(index != self.editIndex){
                    self.editIndex = index;
                    self.editCmt = self.cmtList[index].contents;
                    return;
                }
                let param = {
                    cotents : self.editCmt,
                    commentNo : self.cmtList[index].commentNo
                }
                $.ajax({
                    url: "edit-comment.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.result == "success"){
                            self.fnInfo();
                            // 초기화
                            self.editCmt = "";
                            self.editIndex = -1;
                        }
                    }
                });
            },
            fnRemoveComment : function(commentNo){
                let self = this;
                
                let param = {
                    commentNo
                }
                $.ajax({
                    url: "remove-comment.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.result == "success"){
                            self.fnInfo();
                        }
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnInfo();
        }
    });

    app.mount('#app');
</script>