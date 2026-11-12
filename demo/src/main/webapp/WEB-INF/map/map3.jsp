<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리로 장소 검색하기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <!-- 1. &libraries=services 추가 필수 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8c1d11928aeba70c96fbffbe408d66a3&libraries=services"></script>
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
        <!-- 카테고리 선택 시 searchCategory 실행 -->
        <select v-model="category" @change="searchCategory">
            <option value="">:: 선택 ::</option>
            <option value="MT1">대형마트</option>
            <option value="CS2">편의점</option>
            <option value="PS3">어린이집, 유치원</option>
            <option value="SC4">학교</option>
            <option value="AC5">학원</option>
            <option value="PK6">주차장</option>
            <option value="OL7">주유소, 충전소</option>
            <option value="SW8">지하철역</option>
            <option value="BK9">은행</option>
            <option value="CT1">문화시설</option>
            <option value="AG2">중개업소</option>
            <option value="PO3">공공기관</option>
            <option value="AT4">관광명소</option>
            <option value="AD5">숙박</option>
            <option value="FD6">음식점</option>
            <option value="CE7">카페</option>
            <option value="HP8">병원</option>
            <option value="PM9">약국</option>
        </select>
        <div id="map" style="width:500px;height:400px;margin-top:10px;"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 다른 메서드에서도 공통으로 쓰기 위해 data에 등록
                category: "",
                map: null,
                ps: null,
                infowindow: null,
                markers: [] // 기존 마커를 지우기 위한 배열
            };
        },
        methods: {
            // 처음 페이지가 열릴 때 지도와 객체들을 한 번만 초기화
            fnInit: function () {
                let self = this;

                // 마커를 클릭하면 장소명을 표출할 인포윈도우 생성
                self.infowindow = new kakao.maps.InfoWindow({zIndex: 1});

                var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
                    mapOption = {
                        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };  

                // 지도를 생성합니다    
                self.map = new kakao.maps.Map(mapContainer, mapOption); 

                // 장소 검색 객체를 생성합니다
                self.ps = new kakao.maps.services.Places(self.map); 
            },

            // select 박스에서 카테고리를 변경했을 때 실행되는 함수
            searchCategory: function () {
                let self = this;

                // 열려있는 인포윈도우 닫기 및 기존 마커 제거
                self.infowindow.close();
                self.removeMarkers();

                // ':: 선택 ::' (빈 값)을 골랐을 때는 검색하지 않고 종료
                if (self.category === "") {
                    return;
                }

                // 선택한 카테고리로 장소를 검색합니다 (콜백에 self. 붙이기)
                self.ps.categorySearch(self.category, self.placesSearchCB, {useMapBounds: true}); 
            },

            // 카테고리 검색 완료 시 호출되는 콜백함수 입니다
            placesSearchCB: function (data, status, pagination) {
                let self = this;

                if (status === kakao.maps.services.Status.OK) {
                    for (var i = 0; i < data.length; i++) {
                        self.displayMarker(data[i]);    
                    }       
                }
            },

            // 지도에 마커를 표시하는 함수입니다
            displayMarker: function(place) {
                let self = this;

                // 마커를 생성하고 지도에 표시합니다
                var marker = new kakao.maps.Marker({
                    map: self.map,
                    position: new kakao.maps.LatLng(place.y, place.x) 
                });

                // 나중에 지울 수 있도록 배열에 마커 저장
                self.markers.push(marker);

                // 마커에 클릭이벤트를 등록합니다 (displayMarker 안에 있어야 함)
                kakao.maps.event.addListener(marker, 'click', function() {
                    // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
                    self.infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
                    self.infowindow.open(self.map, marker);
                });
            },

            // 지도에 표시된 기존 마커들을 모두 지우는 함수
            removeMarkers: function() {
                let self = this;
                for (var i = 0; i < self.markers.length; i++) {
                    self.markers[i].setMap(null);
                }
                self.markers = [];
            }
        },
        mounted() {
            // 처음 시작할 때 지도 초기화 실행
            let self = this;
            self.fnInit();
        }
    });

    app.mount('#app');
</script>