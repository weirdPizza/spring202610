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
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
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
        {{info}}
        <img v-for="item in fileList" :src="item.filePath" :alt="item.fileName">
        <div>
            <button @click="fnPayment">구매하기</button>
            <button @click="fnRemove">제품 삭제</button>
        </div>
    </div>
</body>
</html>

<script>
    IMP.init("imp15853290");
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId : "${sessionId}",
                productId : "${productId}",
                info : {},
                fileList: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    productId : self.productId
                };
                $.ajax({
                    url: "http://localhost:8080/product/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.fileList = data.fileList;
                    }
                });
            },
            fnRemove : function() {
                let self = this;
                let param = {
                    productId : self.productId
                };
                $.ajax({
                    url: "http://localhost:8080/product/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        location.href="list.do";
                    }
                });
            },
            fnPayment : function() {
                let self = this;
                IMP.request_pay(
                {
                    channelKey: "channel-key-427fef34-d4cd-4a01-bc25-d5ae400bd936",
                    pay_method: "card",
                    merchant_uid: "payment-"+new Date().toLocaleString(), // 주문 고유 번호
                    name: self.info.productName,
                    amount: 1,
                    // 아래는 세션에 있는 정보
                    buyer_email: "gildong@gmail.com",
                    buyer_name: "홍길동",
                    buyer_tel: "010-4242-4242",
                    buyer_addr: "서울특별시 강남구 신사동",
                    buyer_postcode: "01181",
                },
                function (response) {
                    // 결제 종료 시 호출되는 콜백 함수
                    // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
                    // 결제 결과를 처리하는 로직을 작성합니다.
                    console.log(response);
                    if(response.success){
                        //alert("결제되었습니다!");
                        // 필요한 정보 db에 저장하는 로직 추가
                        self.fnPayDb(response.paid_amount, response.merchant_uid);
                    } else {
                        alert(response.error_msg);
                    }
                },
                );

            },
            fnPayDb : function(price, merchant_uid) {
                let self = this;
                let param = {
                    sessionId : self.sessionId,
                    productId : self.productId,
                    orderPrice : price,
                    merchantUid : merchant_uid      
                };
                $.ajax({
                    url: "http://localhost:8080/product/add-payment.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("구매 완료!");
                        
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