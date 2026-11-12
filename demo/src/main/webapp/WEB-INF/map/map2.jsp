<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>키워드로 장소검색하고 목록으로 표출하기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <!-- 장소 검색을 위해 &libraries=services 파라미터 필수 추가 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8c1d11928aeba70c96fbffbe408d66a3&libraries=services"></script>
    <style>
        /* 기존 테이블 스타일 */
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

        /* 카카오맵 장소검색 목록 스타일 */
        .map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
        .map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
        .map_wrap {position:relative;width:100%;height:500px;}
        #menu_wrap {position:absolute;top:0;left:0;bottom:0;width:250px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(255, 255, 255, 1);z-index: 1;font-size:12px;border-radius: 10px;}
        .bg_white {background:#fff;}
        #menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
        #menu_wrap .option{text-align: center;}
        #menu_wrap .option p {margin:10px 0;}  
        #menu_wrap .option button {margin-left:5px;}
        #placesList li {list-style: none;}
        #placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
        #placesList .item span {display: block;margin-top:4px;}
        #placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
        #placesList .item .info{padding:10px 0 10px 55px;}
        #placesList .info .gray {color:#8a8a8a;}
        #placesList .info .jibun {padding-left:26px;background:url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
        #placesList .info .tel {color:#009900;}
        #placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
        #placesList .item .marker_1 {background-position: 0 -10px;}
        #placesList .item .marker_2 {background-position: 0 -56px;}
        #placesList .item .marker_3 {background-position: 0 -102px}
        #placesList .item .marker_4 {background-position: 0 -148px;}
        #placesList .item .marker_5 {background-position: 0 -194px;}
        #placesList .item .marker_6 {background-position: 0 -240px;}
        #placesList .item .marker_7 {background-position: 0 -286px;}
        #placesList .item .marker_8 {background-position: 0 -332px;}
        #placesList .item .marker_9 {background-position: 0 -378px;}
        #placesList .item .marker_10 {background-position: 0 -423px;}
        #placesList .item .marker_11 {background-position: 0 -470px;}
        #placesList .item .marker_12 {background-position: 0 -516px;}
        #placesList .item .marker_13 {background-position: 0 -562px;}
        #placesList .item .marker_14 {background-position: 0 -608px;}
        #placesList .item .marker_15 {background-position: 0 -654px;}
        #pagination {margin:10px auto;text-align: center;}
        #pagination a {display:inline-block;margin-right:10px;}
        #pagination .on {font-weight: bold; cursor: default;color:#777;}
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="map_wrap">
            <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>

            <div id="menu_wrap" class="bg_white">
                <div class="option">
                    <div>
                        <form @submit.prevent="searchPlaces">
                            키워드 : <input type="text" v-model="keyword" id="keyword" size="15"> 
                            <button type="submit">검색하기</button> 
                        </form>
                    </div>
                </div>
                <hr>
                <ul id="placesList"></ul>
                <div id="pagination"></div>
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
                map: null,
                ps: null,
                infowindow: null,
                markers: [],
                keyword: '부평역'
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInit: function () {
                let self = this;

                var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
                    mapOption = {
                        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };  

                // 지도를 생성합니다    
                self.map = new kakao.maps.Map(mapContainer, mapOption); 

                // 장소 검색 객체를 생성합니다
                self.ps = new kakao.maps.services.Places();  

                // 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
                self.infowindow = new kakao.maps.InfoWindow({zIndex: 1});

                // 키워드로 장소를 검색합니다
                self.searchPlaces();
            },

            // 키워드 검색을 요청하는 함수입니다
            searchPlaces: function () {
                let self = this;

                if (!self.keyword.replace(/^\s+|\s+$/g, '')) {
                    alert('키워드를 입력해주세요!');
                    return false;
                }

                // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
                self.ps.keywordSearch(self.keyword, self.placesSearchCB); 
            },

            // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
            placesSearchCB: function (data, status, pagination) {
                let self = this;

                if (status === kakao.maps.services.Status.OK) {
                    // 정상적으로 검색이 완료됐으면 검색 목록과 마커를 표출합니다
                    self.displayPlaces(data);

                    // 페이지 번호를 표출합니다
                    self.displayPagination(pagination);

                } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                    alert('검색 결과가 존재하지 않습니다.');
                    return;

                } else if (status === kakao.maps.services.Status.ERROR) {
                    alert('검색 결과 중 오류가 발생했습니다.');
                    return;
                }
            },

            // 검색 결과 목록과 마커를 표출하는 함수입니다
            displayPlaces: function (places) {
                let self = this;

                var listEl = document.getElementById('placesList'), 
                    menuEl = document.getElementById('menu_wrap'),
                    fragment = document.createDocumentFragment(), 
                    bounds = new kakao.maps.LatLngBounds();
                
                // 검색 결과 목록에 추가된 항목들을 제거합니다
                self.removeAllChildNods(listEl);

                // 지도에 표시되고 있는 마커를 제거합니다
                self.removeMarker();
                
                for (var i = 0; i < places.length; i++) {
                    // 마커를 생성하고 지도에 표시합니다
                    var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                        marker = self.addMarker(placePosition, i), 
                        itemEl = self.getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해 LatLngBounds 객체에 좌표를 추가합니다
                    bounds.extend(placePosition);

                    // 마커와 검색결과 항목에 mouseover 했을때 인포윈도우에 장소명을 표시합니다
                    (function(marker, title) {
                        kakao.maps.event.addListener(marker, 'mouseover', function() {
                            self.displayInfowindow(marker, title);
                        });

                        kakao.maps.event.addListener(marker, 'mouseout', function() {
                            self.infowindow.close();
                        });

                        itemEl.onmouseover = function () {
                            self.displayInfowindow(marker, title);
                        };

                        itemEl.onmouseout = function () {
                            self.infowindow.close();
                        };
                    })(marker, places[i].place_name);

                    fragment.appendChild(itemEl);
                }

                // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
                listEl.appendChild(fragment);
                menuEl.scrollTop = 0;

                // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
                self.map.setBounds(bounds);
            },

            // 검색결과 항목을 Element로 반환하는 함수입니다
            getListItem: function(index, places) {
                var el = document.createElement('li'),
                    itemStr = '<span class="markerbg marker_' + (index + 1) + '"></span>' +
                              '<div class="info">' +
                              '   <h5>' + places.place_name + '</h5>';

                if (places.road_address_name) {
                    itemStr += '    <span>' + places.road_address_name + '</span>' +
                               '   <span class="jibun gray">' +  places.address_name  + '</span>';
                } else {
                    itemStr += '    <span>' +  places.address_name  + '</span>'; 
                }
                             
                itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                           '</div>';           

                el.innerHTML = itemStr;
                el.className = 'item';

                return el;
            },

            // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
            addMarker: function(position, idx) {
                let self = this;

                var imageSrc = 'https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
                    imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
                    imgOptions = {
                        spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
                        spriteOrigin : new kakao.maps.Point(0, (idx * 46) + 10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
                        offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
                    },
                    markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
                    marker = new kakao.maps.Marker({
                        position: position, // 마커의 위치
                        image: markerImage 
                    });

                marker.setMap(self.map); // 지도 위에 마커를 표출합니다
                self.markers.push(marker);  // 배열에 생성된 마커를 추가합니다

                return marker;
            },

            // 지도 위에 표시되고 있는 마커를 모두 제거합니다
            removeMarker: function() {
                let self = this;

                for (var i = 0; i < self.markers.length; i++) {
                    self.markers[i].setMap(null);
                }   
                self.markers = [];
            },

            // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
            displayPagination: function(pagination) {
                var paginationEl = document.getElementById('pagination'),
                    fragment = document.createDocumentFragment(),
                    i; 

                // 기존에 추가된 페이지번호를 삭제합니다
                while (paginationEl.hasChildNodes()) {
                    paginationEl.removeChild(paginationEl.lastChild);
                }

                for (i = 1; i <= pagination.last; i++) {
                    var el = document.createElement('a');
                    el.href = "#";
                    el.innerHTML = i;

                    if (i === pagination.current) {
                        el.className = 'on';
                    } else {
                        el.onclick = (function(i) {
                            return function(e) {
                                e.preventDefault(); // 페이지 상단 튕김 방지
                                pagination.gotoPage(i);
                            }
                        })(i);
                    }

                    fragment.appendChild(el);
                }
                paginationEl.appendChild(fragment);
            },

            // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
            // 인포윈도우에 장소명을 표시합니다
            displayInfowindow: function(marker, title) {
                let self = this;

                var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

                self.infowindow.setContent(content);
                self.infowindow.open(self.map, marker);
            },

            // 검색결과 목록의 자식 Element를 제거하는 함수입니다
            removeAllChildNods: function(el) {   
                while (el.hasChildNodes()) {
                    el.removeChild(el.lastChild);
                }
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnInit();
        }
    });

    app.mount('#app');
</script>