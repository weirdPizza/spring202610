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
    <script src="https://cdn.jsdelivr.net/npm/apexcharts@8.8.1/dist/apexcharts.min.js"></script>
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
        <div id="chart"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                productNameList : [],
                sumPriceList: [],
                total: 0
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnTemp : function(){
                let self = this;
                $.ajax({
                    url: "/chart3.dox",
                    dataType: "json",
                    type: "POST",
                    data: "",
                    success: function (data) {
                        console.log(data);
                        self.total = data.total.total;
                        for(let i=0; i<data.list.length; i++){
                            self.productNameList.push(data.list[i].productName) ;
                            self.sumPriceList.push(Math.round((parseInt(data.list[i].sumPrice)/self.total)*100));
                        }

                        // console.log(self.productNameList);
                        // console.log(self.sumPriceList);
                        // console.log(self.total);
                        self.fnChart();
                    }
                });
            },
            fnChart : function () {
                let self = this;
                console.log(self.productNameList);
                var options = {
                    series: self.sumPriceList,
                    chart: {
                        width: 1000,
                        type: 'donut',
                    },
                    labels: self.productNameList,
                    title: {
                        text: 'Revenue by Region ($M)',
                        align: 'center',
                    },
                    legend: {
                        show: false,
                    },
                    plotOptions: {
                        pie: {
                        dataLabels: {
                            external: {
                            show: true,
                            },
                        },
                        },
                    },
                    responsive: [
                        {
                        breakpoint: 480,
                        options: {
                            chart: {
                            width: 320,
                            },
                        },
                        },
                    ],
                    }
                var chart = new ApexCharts(document.querySelector('#chart'), options)
                chart.render()
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnTemp();
            
            
        }
    });

    app.mount('#app');
</script>