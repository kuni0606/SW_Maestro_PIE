<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Piece in everything - Main</title>
	<link rel="shortcut icon" type="image/png" href="image/logo.png"/>
    <!--jQuery-->
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script type="text/javascript"
            src="https://cdnjs.cloudflare.com/ajax/libs/jquery.simpleWeather/3.0.2/jquery.simpleWeather.min.js"></script>
    <meta name="description" content="Blueprint: Slide and Push Menus"/>
    <meta name="keywords" content="sliding menu, pushing menu, navigation, responsive, menu, css, jquery"/>
    <meta name="author" content="Codrops"/>
    <link rel="shortcut icon" href="../favicon.ico">
    <link rel="stylesheet" type="text/css" href="css/default.css"/>
    <link rel="stylesheet" type="text/css" href="css/component.css"/>
    <script src="js/modernizr.custom.js"></script>
    <link href="http://fonts.googleapis.com/css?family=Montserrat:400,700,inherit,400" rel="stylesheet" type="text/css">
    <!--Bootstrap-->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"
          integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
            integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS"
            crossorigin="anonymous"></script>
    <!--News Feed-->
    <script>    
    ////////////////////////////////////////////////////////
    <% // 쿠키값 가져오기
    Cookie[] cookies = request.getCookies() ;
    
    String username = null;
    
    if(cookies != null){
         
        for(int i=0; i < cookies.length; i++){
            Cookie c = cookies[i] ;
             
            if( c.getName().equals("user_name") ){
            	username = URLDecoder.decode(c.getValue(), "UTF-8");
            }
        }
    } 
    %>
 
    var userName = '<%= username %>';
    
    function getCookie(cName) {
        cName = cName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        if(start != -1){
            start += cName.length;
            var end = cookieData.indexOf(';', start);
            if(end == -1)end = cookieData.length;
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }
    
    var tempId = getCookie('user_id');
    var userId = "";
    
    for(var b=0; b<tempId.length; b++){
    	if(!(tempId[b] == '\"')){
    		userId += tempId[b];
    	}
    }

///////////////////////////////////////////////////////////////////
    
        var loadFlag = false;

        $(function () {
            setInterval("newsPrint()", 5000);
        });
        var newsDataArr = [];
        var newsPanID;
        (function ($) {
            $.fn.FeedEk = function (opt) {
                var def = $.extend({
                    MaxCount: 10,
                    ShowDesc: true,
                    ShowPubDate: true,
                    DescCharacterLimit: 0,
                    TitleLinkTarget: "_blank",
                    DateFormat: "",
                    DateFormatLang:"en"
                }, opt);

                var id = $(this).attr("id");
                newsPanID = id;

                if (def.FeedUrl == undefined) return;
                //$("#" + id).append('<img src="loader.gif" />');


                var YQLstr = 'SELECT channel.item FROM feednormalizer WHERE output="rss_2.0" AND url ="' + def.FeedUrl + '" LIMIT ' + def.MaxCount;

                $.ajax({
                    async: false,
                    url: "https://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent(YQLstr) + "&format=json&diagnostics=false&callback=?",
                    dataType: "json",
                    success: function (data) {
                       // $("#" + id).empty();
                        if (!(data.query.results.rss instanceof Array)) {
                            data.query.results.rss = [data.query.results.rss];
                        }
                        var obj = data.query.results.rss;

                        for(var e = 0; e < obj.length; e++) {
                            var itm = obj[e];
                            var s = "";
                            var dt;
                            s += '<li><div class="itemTitle"><a href="' + itm.channel.item.link + '" target="' + def.TitleLinkTarget + '" >' + itm.channel.item.title + '</a></div>';

                            if (def.ShowPubDate){
                                dt = new Date(itm.channel.item.pubDate);
                                s += '<div class="itemDate">';
                                if ($.trim(def.DateFormat).length > 0) {
                                    try {
                                        moment.lang(def.DateFormatLang);
                                        s += moment(dt).format(def.DateFormat);
                                    }
                                    catch (e){s += dt.toLocaleDateString();}
                                }
                                else {
                                    s += dt.toLocaleDateString();
                                }
                                s += '</div>';
                            }
                            if (def.ShowDesc) {
                                s += '<div class="itemContent">';
                                if (def.DescCharacterLimit > 0 && itm.channel.item.description.length > def.DescCharacterLimit) {
                                    s += itm.channel.item.description.substring(0, def.DescCharacterLimit) + '...';
                                }
                                else {
                                    s += itm.channel.item.description;
                                }
                                s += '</div>';
                            }
                            newsDataArr.push(s);
                        }

                        if(loadFlag) {
                            $("#" + newsPanID).append('<ul class="feedEkList">' + newsDataArr[0] + '</ul>');
                            loadFlag = false;
                            cnt += 1;
                        }
                       //$("#" + newsPanID).empty();

                      //  $("#" + newsPanID).append('<ul class="feedEkList">' + newsDataArr[0] + '</ul>');

                    }
                });
            };
        })(jQuery);

    </script>


    <!--Scroll library-->
    <link rel="stylesheet" href="./css/jquery.mCustomScrollbar.css"/>
    <script src="./js/jquery.mCustomScrollbar.concat.min.js"></script>
    <!--------------------------------------------Calendar------------------------------------------------->
    <!--to do list-->
    
    <link rel="stylesheet" href='./widget/Calendar/todos.css'/><!--
    <!--FullCalendar-->
    <link href='./widget/Calendar/fullcalendar.css' rel='stylesheet'/>
    <link href='./widget/Calendar/fullcalendar.print.css' rel='stylesheet' media='print'/>
    <script src='./widget/Calendar/moment.min.js'></script>
    <script src='./widget/Calendar/fullcalendar.min.js'></script>
    
    <script>
    /* window.onclose = function()
    {
    	postData();
        $.get("http://210.118.74.117:8100/PIE/log_out_unload",{
        	
        },function(data){
        	
        });
    } */
    
        /* $(function() {
            window.onunload = function () {
                postData();
                if(event.clientX < 0 && event.clientY < 0) {
            		$.get("http://210.118.74.117:8100/PIE/log_out_unload",{
                    	
                    },function(data){
                    	
                    });	
            	}
            };
        }); */
        
        /* $(function() {
            window.onunload = function () {
					$.get("http://210.118.74.117:8100/PIE/log_out_unload",{
                    	
                    },function(data){
                    	
                    });
            };
        }); */
        
       
    </script>
    <!--News CSS-->
    <style>
	    .ui-dialog-titlebar-close {
		  background: url("http://code.jquery.com/ui/1.10.3/themes/smoothness/images/ui-icons_888888_256x240.png") repeat scroll -93px -128px rgba(0, 0, 0, 0);
		  border: medium none;
		}
		.ui-dialog-titlebar-close:hover {
		  background: url("http://code.jquery.com/ui/1.10.3/themes/smoothness/images/ui-icons_222222_256x240.png") repeat scroll -93px -128px rgba(0, 0, 0, 0);
		}
        .feedEkList {
            list-style: none outside none;
            background-color: #FFFFFF;
            padding: 10px 6px;
            color: #3E3E3E;
        }

        /*width: 100%; height:100%*/
        .feedEkList li:last-child {
            border-bottom: none;
        }

        .itemTitle a {
            font-weight: bold;
            color: #4EBAFF !important;
            text-decoration: none
        }

        .itemTitle a:hover {
            text-decoration: underline
        }


    </style>
    <style>
        /* sohee's style */
        .sh_parent {
            overflow: auto;

        }

        .sh_child {
            display: inline-block;
            overflow-y: hidden;
        }
    </style>
    <script>
        var cnt = 0;
        function goNews() {

            $('#divRss').FeedEk({
                FeedUrl: 'https://news.google.co.kr/news?cf=all&hl=ko&pz=1&ned=kr&output=rss',
                /*MaxCount: 1,*/
                ShowPubDate: false,
                ShowDesc: true
            });
        }

        function newsPrint() {
            $("#" + newsPanID).empty();
            $("#" + newsPanID).append('<ul class="feedEkList">' + newsDataArr[cnt++] + '</ul>');

            if(cnt == 10) {
                cnt = 0;
                newsDataArr = [];
                goNews();
            }

        }
    </script>
    <script>
        /* This is adding scroll */
        function addScroll() {
            $('.sh_parent').mCustomScrollbar({
                /* theme:"rounded-dark"*/
                axis: "yx",
                theme: "minimal-dark"
            });
        }

    </script>
    <script>
        /*FullCalendar*/
        $(document).ready(function () {
            $('#dialog-form').fullCalendar({
                header: {
                    left: 'prev, next',
                    center: 'title',
                    right: 'today'
                },
                editable: true,
                selectable: true,
                selectHelper: true,
                dayClick: function (date, jsEvent, view) {
                    AfterClick(date.format());
                    $("#dialog-form").dialog('close');
                },
                events: fullCalendar_list
            });
          
        });
    </script>
    <!-----------------------------------------------/Calendar------------------------------------------------>
    <style>
        html, body {
            width: 100%;
            height: 100%;
        }

        textarea {
            font-size: 15px;
            border: none;
            overflow: auto;
            outline: none;

            -webkit-box-shadow: none;
            -moz-box-shadow: none;
            box-shadow: none;
        }

        li {
            cursor: pointer;
            padding-left: 7px;
        }

        .btn {
            margin-top: -4px;
        }

        .widget_headline {
            margin-top: 2px;
            margin-left: 5px;
            float: left;
        }

        .widget_deleteBtn {
            float: right;
        }

        textarea {
            border-radius: 5px;
        }

        .widget_item {
            padding-left: 13px;
            padding-top: 5px;
            padding-bottom: 5px;
            font-size: 17px;
        }

        .div_Container {
            position: absolute;
            background-color: white;
            padding: 0.5em;
            border-radius: 5px;
            box-shadow: 1px 2px 10px gray;
        }

        .div_Container:hover {
            box-shadow: 0px 0px 20px 0px #3366CC;
        }

        .gallery_img_group {
            border-radius: 5px;
            box-shadow: 1px 2px 10px gray;
        }

        .gallery_img_group:hover {
            box-shadow: 0px 0px 20px 0px #3366CC;
        }

        .dropmenu_img {
            width: 20px;
            height: 20px;
            margin-top: -2px;
        }
        .search_bar_li:hover{
        background-color:#EEEEEE;
        }
        .opcity_img:hover{
        cursor:pointer;
        opacity:0.75;
        }
        
        #slideshow { 
    position: relative; 
}

#slideshow div { 
    position: absolute;
}
    </style>
    <style>
        /*----- Accordion -----*/
        .accordion, .accordion * {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }

        .accordion {
            overflow: hidden;
            box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.25);
            border-radius: 3px;
            background: #f7f7f7;
        }

        /*----- Section Titles -----*/
        .accordion-section-title {
            width: 100%;
            padding: 7px;
            display: inline-block;
            border-bottom: 1px solid #1a1a1a;
            background: #333;
            transition: all linear 0.15s;
            /* Type */
            font-size: 1.200em;
            text-shadow: 0px 1px 0px #1a1a1a;
            color: #fff;
        }

        .accordion-section-title.active, .accordion-section-title:hover {
            background: #4c4c4c;
            /* Type */
            text-decoration: none;
        }

        .accordion-section:last-child .accordion-section-title {
            border-bottom: none;
        }

        /*----- Section Content -----*/
        .accordion-section-content {
            padding: 15px;
            display: none;
        }

    </style>
    <script>
        onload = function on_load() {
            $.get("http://210.118.74.117:8100/PIE/get_back_ground", function (data) {
                if (data.msg == 'Success') {
                    var b_body_c = document.getElementById('body');
                    b_body_c.style.background = "url(" + data.back_ground_path + ")";
                    b_body_c.style.backgroundRepeat = "no-repeat";
                    b_body_c.style.backgroundSize = "cover";
                }
            });
            $.get("http://210.118.74.117:8100/PIE/get_picture_list",
                    function (data) {
                        if (data.msg == 'Success') {
                            gallery_idx = data.pictureList.length;
                        }
                        else {
                            //alert(data.msg);
                        }
                    });

            //get
            $.get("http://210.118.74.117:8100/PIE/get_widget_list", function (data) {
                click_Browser(data.lastSearchBar);
                var tempData = data.widgetList;

                for (var i = 0; i < tempData.length; i++) {
                    widget_height = parseInt((tempData[i].ySize * $(window).height()) / 100);
                    get_Widget(tempData[i].widgetId, tempData[i].w_Code, tempData[i].widgetType);
                    widgetData[tempData[i].widgetId] = {
                        "w_Code": tempData[i].w_Code,
                        "widgetType": tempData[i].widgetType,
                        "xPos": (tempData[i].xPos),
                        "yPos": (tempData[i].yPos),
                        "xSize": (tempData[i].xSize),
                        "ySize": (tempData[i].ySize)
                    };
                    /* if (tempData[i].widgetType == 3) {
                        var iframeElement = document.getElementById(iframe_inner_c);
                        iframeElement.onload = frameLoaded(iframe_inner_c);
                    } */
                    div_c.style.left = ((widgetData[div_c.id].xPos * $(window).width()) / 100) + 'px';
                    div_c.style.top = ((widgetData[div_c.id].yPos * $(window).height()) / 100) + 'px';
                    div_c.style.width = ((widgetData[div_c.id].xSize * $(window).width()) / 100) + 'px';
                    div_c.style.height = ((widgetData[div_c.id].ySize * $(window).height()) / 100) + 'px';


                }
            });
            var main_user_id = document.getElementById('main_user_id');
            while(main_user_id.hasChildNodes()){
            	main_user_id.removeChild(main_user_id.firstChild);
        	}
			main_user_id.appendChild(document.createTextNode(userName+' 님, 환영합니다.'));
			main_user_id.style.color="white";
			main_user_id.style.marginTop="12px";
			main_user_id.style.fontWeight="bold";
        }
    </script>
    <script>
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(function (position) {
                loadWeather(position.coords.latitude + ',' + position.coords.longitude);
            });
        } else {
            //alert("날씨 위젯을 띄울 수 없습니다.");
        }
        $(document).ready(function () {
            setInterval(getWeather, 10000);
        });
        function loadWeather(location, woeid) {
            $.simpleWeather({
                location: location,
                woeid: woeid,
                unit: 'c',
                success: function (weather) {
                    temp = weather.temp + '&deg;';
                    wcode = '<img class="weathericon" src="image/weathericons/' + weather.code + '.svg" style="width:100%;padding-top:10%;">';
                    wind = '<p>' + weather.wind.speed + '</p><p>' + weather.units.speed + '</p>';
                    humidity = weather.humidity + '%';
                    thumbnail1 = '<img class="weathericon" src="' + weather.forecast[1].thumbnail + '" style="width:50%;">';
                    day1 = weather.forecast[1].day;
                    thumbnail2 = '<img class="weathericon" src="' + weather.forecast[2].thumbnail + '" style="width:50%;">';
                    day2 = weather.forecast[2].day;
                    thumbnail3 = '<img class="weathericon" src="' + weather.forecast[3].thumbnail + '" style="width:50%;">';
                    day3 = weather.forecast[3].day;

                    
                    $(".temperature").html(temp);
                    $(".climate_bg").html(wcode);
                    $(".windspeed").html(wind);
                    $(".humidity").text(humidity);
                    $(".t_nail_1").html(thumbnail1);
                    $(".t_nail_2").html(thumbnail2);
                    $(".t_nail_3").html(thumbnail3);
                    $(".day1").html(day1);
                    $(".day2").html(day2);
                    $(".day3").html(day3);
                },

                error: function (error) {
                    $(".error").html('<p>' + error + '</p>');
                }
            });
        }
    </script>
    <script>

    </script>
    <script>
        var widgetData = {};
        var quickData = {};
        var quickData_length = 0;

        var widget_height;
        
        var gallery_idx=0;

        var div_c_c;
        var div_c;
        var div_1;
        var div_2;
        var div_3;
        var div_4;
        var table;
        var tbody;
        var tr;
        var td;

        var div_w;
        var p_temperature;
        var p_high;
        var p_low;
        var p_humidity;
        var climate_div;
        var w_img_1;
        var w_img_2;

        var google_mail = {};
        var google_chk = 0;
        var naver_mail = {};
        var naver_chk = 0;
        var email_msg;
        var g_chk = 0;
        var n_chk = 0;


        var iframe_inner_c;
        var iframe_inner_width;
        var iframe_inner_height;

        var google_e_id = null;
        var naver_e_id = null;

        var window_width = ($(window).width()) / 2 - 100;
        var window_height = ($(window).height()) / 2 - 200;

        function get_Widget(w_name, w_code, w_type) {
            div_c = document.createElement('div');
            div_c.id = w_name;
            div_c.className = "div_Container"; //------------------------------------------sohee's style
            table = document.createElement('table');
            table.style.width = "100%";
            table.style.height = "30px";
            table.style.marginTop="-2px";
            tbody = document.createElement('tbody');
            tr = document.createElement('tr');
            tr.style.width = "100%";
            td = document.createElement('td');
            td.style.width = "100%";
            div_1 = document.createElement('div');
            div_1.style.width = "100%";
            div_1.style.marginBottom = "6px";
            div_1.style.display = "table";
            div_2 = document.createElement('div');
            div_2.style.display = "table-cell";
            div_2.style.width = "20%";
            div_2.className = "widget_headline";
            var w_icon = document.createElement('img');
            w_icon.style.width = "20px";
            w_icon.style.height = "20px";
            switch (w_type) {
                case 1:
                    w_icon.src = "image/widget_Icon/news_c_icon.png";
                    break;
                case 2:
                    w_icon.src = "image/widget_Icon/mail_c_icon.png";
                    break;
                case 3:
                    w_icon.src = "image/widget_Icon/web_c_icon.png";
                    break;
                case 4:
                    w_icon.src = "image/widget_Icon/calendar_c_icon.png";
                    break;
                case 5:
                    w_icon.src = "image/widget_Icon/gallery_c_icon.png";
                    break;
                case 6:
                    w_icon.src = "image/widget_Icon/note_c_icon.png";
                    break;
                case 7:
                    w_icon.src = "image/widget_Icon/weather_c_icon.png";
                    break;
                case 8:
                    w_icon.src = "image/widget_Icon/quick_icon.png";
                    break;
            }
            div_2.appendChild(w_icon);
            div_1.appendChild(div_2);
            div_3 = document.createElement('div');
            div_3.style.display = "table-cell";
            div_3.style.width = "60%";

            if (w_type == 3) {
                var input_text = document.createElement('input');
                input_text.id = w_code + '_src';
                input_text.type = "text";
                input_text.style.width = "100%";
                input_text.placeholder = "http:// 를 꼭 붙여주세요!";
                input_text.value = "http://";
                div_3.appendChild(input_text);
                /*var input_img = document.createElement('img');
                 input_img.src = "image/go.png";
                 input_img.style.width = "20px";
                 input_img.style.height = "20px";
                 input_img.onclick = goto_URL;
                 div_3.appendChild(input_img);*/
            }

            div_1.appendChild(div_3);
            div_4 = document.createElement('div');
            div_4.style.display = "table-cell";
            div_4.style.width = "20%";
            switch (w_type) {
                case 1:
                    break;
                case 2:
                    var mail_btn = document.createElement('img');
                    mail_btn.src="image/plus_icon_w.png"
                    mail_btn.className="opcity_img";
                    mail_btn.style.width = "20px";
                    mail_btn.style.height = "20px";
                    mail_btn.style.float = "right";
                    mail_btn.onclick = function () {
                        mail_input_reset();
                        var dialog;

                        dialog = $("#email-dialog-form").dialog({
                            autoOpen: false,
                            width: 300,
                            height: 320,
                            modal: true,
                            buttons: {
                                "등록": function () {
                                    var radio = $(':radio[name="optradio"]:checked');
                                    var e_id = $("#email_id");
                                    var e_pw = $("#email_password");
									var google_r = document.getElementById('google_r');
									var naver_r = document.getElementById('naver_r');
                                    if (radio.val() == null) {
                                        alert("이메일을 선택하세요.");
                                    } else if (e_id.val() == '') {
                                        alert("아이디를 입력하세요.");
                                        e_id.focus();
                                    } else if (e_pw.val() == '') {
                                        alert("비밀번호를 입력하세요.");
                                        e_pw.focus();
                                    } else {
                                    	//서버에 타입이랑 아이디 비번 넘겨줌
                                        //ajax로 바꿈.
                                        $.ajax({
                                            type: 'POST',
                                            url: 'http://210.118.74.117:8100/PIE/add_email_info',
                                            data: {
                                                email_type: radio.val(),
                                                email_id: e_id.val(),
                                                email_pw: e_pw.val()
                                            },
                                            async: false,
                                            success: function (data) {
                                                if (data.msg == "Success") {
                                                    alert("등록이 완료되었습니다.");
                                                    if (radio.val() == 1) {
                                                        var temp_sub;
                                                        for (var k = 0; k < e_id.val().length; k++) {
                                                            if (e_id.val()[k] == '@') {
                                                                temp_sub = k;
                                                            }
                                                        }
                                                        document.getElementById('google_id').lastChild.nodeValue = (e_id.val()).substring(0, temp_sub);
                                                        g_chk = 0;
                                                    } else if (radio.val() == 2) {
                                                        document.getElementById('naver_id').lastChild.nodeValue = e_id.val();
                                                        n_chk = 0;
                                                    }
                                                    e_id.val("");
                                                    e_pw.val("");
                                                    google_r.checked=false;
                                                    naver_r.checked=false;
                                                    dialog.dialog("close");
                                                } else {
                                                    alert(data.msg);
                                                    alert("등록이 실패했습니다.");
                                                }
                                            }
                                        });
                                    }
                                },
                                "취소": function () {
                                    dialog.dialog("close");
                                }
                            },
                            close: function () {
                                dialog.dialog("close");
                            }
                        });

                        dialog.dialog('open');
                    };
                    div_4.appendChild(mail_btn);
                    break;
                case 3:
                    break;
                case 4:
                    var cal_img = document.createElement('img');
                    cal_img.id = "dialog_trigger";
                    cal_img.src = "./widget/Calendar/calendar_img.png";
                    cal_img.className="opcity_img";
                    cal_img.style.float = "right";
                    cal_img.style.width = "25px";
                    cal_img.style.height = "25px";
                    cal_img.onclick = function () {
                        var dialog;
                        dialog = $("#dialog-form").dialog({
                            autoOpen: false,
                            width: 1000,
                            modal: true
                        });
                      //all_list_data를 업데이트 해줘야 FullCalendar에서 업데이트 된 목록을 확인할 수 있다
                        getData();
                        dialog.dialog('open');
                        
                        $('#dialog-form').fullCalendar('prev');
                        $('#dialog-form').fullCalendar('next');
                    };
                    div_4.appendChild(cal_img);
                    break;
                case 5:
                	var gallery_plus_img = document.createElement('img');
                    gallery_plus_img.src = "image/plus_icon_w.png";
                    gallery_plus_img.className="opcity_img";
                    gallery_plus_img.style.width = "20px";
                    gallery_plus_img.style.height = "20px";
                    gallery_plus_img.onclick = function () {
                        $.get("http://210.118.74.117:8100/PIE/get_picture_list",
                                function (data) {
                                    if (data.msg == 'Success') {
                                        /*alert(data.pictureList.length);

                                         if( data.pictureList.length != 0 ){
                                         for(var m=0; m<data.pictureList.length; m++){
                                         alert(data.pictureList[m].code + " : " + data.pictureList[m].path);
                                         }
                                         }*/

                                        //이미지 넣자~
                                        for (var i = 1; i <= data.pictureList.length; i++) {
                                            $("#gallery_img_" + i).attr("src", data.pictureList[i - 1].path);
                                            $("#gallery_img_" + i).attr("name", data.pictureList[i - 1].code);
                                        }
                                    }
                                    else {
                                    }
                                });
                        var dialog;

                        dialog = $("#gallery-dialog-form").dialog({
                            autoOpen: false,
                            width: 700,
                            height: 520,
                            modal: true,
                            buttons: {
                                "저장": function () {
                                	location.reload();
                                },
                                "취소": function () {
                                    dialog.dialog("close");
                                }
                            },
                            close: function () {
                                dialog.dialog("close");
                            }
                        });
                        dialog.dialog('open');
                    };
                    gallery_plus_img.style.float = "right";
                    div_4.appendChild(gallery_plus_img);
                    break;
                case 6:
                    break;
                case 7:
                    break;
                case 8:
                    var mark_btn = document.createElement('img');
                    mark_btn.src="image/plus_icon_w.png";
                    mark_btn.className="opcity_img";
                    mark_btn.style.width = "20px";
                    mark_btn.style.height = "20px";
                    mark_btn.style.float = "right";
                    mark_btn.onclick = function () {
                        mark_input_reset();
                        var dialog;

                        dialog = $("#bookmark-dialog-form").dialog({
                            autoOpen: false,
                            width: 300,
                            height: 320,
                            modal: true,
                            buttons: {
                                "등록": function () {
                                    var q_title = $("#mark_title");
                                    var q_url = $("#mark_url");

                                    if (q_title.val() == "") {
                                        alert("Title을 입력하세요.");
                                        q_title.focus();
                                    } else if (q_url.val() == "") {
                                        alert("Url을 입력하세요.");
                                        q_url.focus();
                                    } else {
                                        $.post("http://210.118.74.117:8100/PIE/save_book_mark", {
                                            bookmark_title: q_title.val(),
                                            bookmark_url: q_url.val()
                                        }, function (data) {
                                            if (data.msg == 'Success') {
                                                var temp_code = data.code;

                                                var mark_cont = document.createElement('div');
                                                mark_cont.id = temp_code + '_div';
                                                mark_cont.style.width = "100%";
                                                mark_cont.style.display = "table";
                                                var quick_atag = document.createElement('a');
                                                quick_atag.id = temp_code;
                                                quick_atag.style.marginBottom = "5px";
                                                quick_atag.style.marginTop = "5px";
                                                quick_atag.style.fontSize = "15px";
                                                quick_atag.style.display = "table-cell";
                                                quick_atag.style.width = "80%";
                                                quick_atag.appendChild(document.createTextNode(' >  ' + q_title.val()));
                                                quick_atag.href = q_url.val();
                                                mark_cont.appendChild(quick_atag);
                                                var q_delete_btn = document.createElement('img');
                                                q_delete_btn.style.width = "20px";
                                                q_delete_btn.style.height = "20px";
                                                q_delete_btn.src = "image/close_widget.png";
                                                q_delete_btn.style.display = "table-cell";
                                                q_delete_btn.style.float = "right";
                                                mark_cont.appendChild(q_delete_btn);
                                                q_delete_btn.onclick = function () {
                                                    var del_div = $(this).parent().attr('id');
                                                    var q_code = del_div.substring(0, del_div.length - 4);
                                                    document.getElementById('w_quick').removeChild(document.getElementById(del_div));
                                                    $.post("http://210.118.74.117:8100/PIE/delete_book_mark", {
                                                        bookmark_code: temp_code
                                                    }, function (data) {
                                                        if (data.msg == 'Success') {
                                                            alert("삭제 되었습니다.");
                                                        } else {
                                                            alert(data.msg);
                                                        }
                                                    });
                                                };
                                                document.getElementById('w_quick').appendChild(mark_cont);
                                                dialog.dialog("close");
                                            }
                                        });
                                    }
                                },
                                "취소": function () {
                                    dialog.dialog("close");
                                }
                            },
                            close: function () {
                                dialog.dialog("close");
                            }
                        });
                        dialog.dialog('open');
                    };
                    div_4.appendChild(mark_btn);
                    break;
            }
            div_1.appendChild(div_4);
            td.appendChild(div_1);
            tr.appendChild(td);
            tbody.appendChild(tr);
            table.appendChild(tbody);
            div_c.appendChild(table);

            var dd = document.createElement('div');
            dd.style.wdith = "100%";
            dd.style.height = widget_height - 40 + 'px';
            var dd_2 = document.createElement('div');
            dd_2.style.width = "100%";
            dd_2.style.height = "100%";
            switch (w_type) {
                case 1:
                    dd_2.className = "sh_parent";
                    var news_div = document.createElement('div');
                    news_div.className = "sh_child";
                    news_div.id = "divRss";
                    dd_2.appendChild(news_div);
                    break;
                case 2:
                    var email_div = document.createElement('div');
                    email_div.id=w_code;
                    email_div.className = "accordion";
                    email_div.style.zIndex="101";
                    email_div.style.position="relative";
                    var e_div_google = document.createElement('div');
                    e_div_google.className = "accordion-section";
                    var e_atag_g = document.createElement('a');
                    e_atag_g.id = "google_id";
                    e_atag_g.className = "accordion-section-title";
                    e_atag_g.href = "#accordion-2";
                    var google_email_img = document.createElement('img');
                    google_email_img.src = "image/search_icon/google.png";
                    google_email_img.style.width = "25px";
                    google_email_img.style.height = "25px";
                    google_email_img.style.marginRight = "15px";
                    e_atag_g.appendChild(google_email_img);
                    $.ajax({
                        type: 'GET',
                        url: 'http://210.118.74.117:8100/PIE/get_email_id',
                        data: {
                            email_type: 1
                        },
                        async: false,
                        success: function (data) {
                            if (data.msg == "Success") {
                                var temp_sub;
                                for (var k = 0; k < data.email_id.length; k++) {
                                    if (data.email_id[k] == '@') {
                                        temp_sub = k;
                                    }
                                }
                                google_e_id = (data.email_id).substring(0, temp_sub);
                            }
                        }
                    });
                    if (google_e_id == null) {
                        e_atag_g.appendChild(document.createTextNode("Google"));
                    } else {
                        e_atag_g.appendChild(document.createTextNode(google_e_id));
                    }
                    e_div_google.appendChild(e_atag_g);
                    var e_div_google_c = document.createElement('div');
                    e_div_google_c.id = "accordion-2";
                    e_div_google_c.className = "accordion-section-content";
                    var e_table_1 = document.createElement('table');
                    e_table_1.style.width = "100%";
                    var e_tbody_1 = document.createElement('tbody');
                    e_tbody_1.id = "g_tbody";
                    e_atag_g.onclick = function (e) {
                        function close_accordion_section() {
                            $('.accordion .accordion-section-title').removeClass('active');
                            $('.accordion .accordion-section-content').slideUp(300).removeClass('open');
                        }

                        var currentAttrValue = $(this).attr('href');

                        if ($(e.target).is('.active')) {
                            close_accordion_section();
                        } else {
                            close_accordion_section();
                            $(this).addClass('active');
                            $('.accordion ' + currentAttrValue).slideDown(300).addClass('open');
                        }
                        e.preventDefault();

                        if (g_chk == 0) {
                            $.ajax({
                                type: 'GET',
                                url: 'http://210.118.74.117:8100/PIE/get_email_list',
                                data: {
                                    email_type: 1
                                },
                                async: false,
                                success: function (data) {
                                    if (data.msg == "Success") {
                                        google_mail = data.email_list;
                                        g_chk = 1;
                                    } else {
                                        alert(data.msg);
                                    }
                                }
                            });
                            if (google_mail.length == 0) {
                                google_chk = 0;
                            }
                            else if (google_mail.length != 0) {
                                google_chk = google_mail.length;
                                if (google_chk > 10) {
                                    google_chk = 10;
                                }
                            }
                            for (var i = 0; i < google_chk; i++) {
                                var e_tr_1 = document.createElement('tr');
                                e_tr_1.style.width = "100%";
                                for (var j = 0; j < 3; j++) {
                                    var e_td_1 = document.createElement('td');
                                    e_td_1.style.overflow = "auto";
                                    if (j == 0) {
                                        e_td_1.style.width = "20%";
                                        var temp_g;
                                        for (var g = 0; g < (google_mail[i].sender_address).length; g++) {
                                            if ((google_mail[i].sender_address)[g] == '@') {
                                                temp_g = g;
                                            }
                                        }
                                        e_td_1.appendChild(document.createTextNode((google_mail[i].sender_address).substring(0, temp_g)));
                                        e_tr_1.appendChild(e_td_1);
                                    } else if (j == 1) {
                                        e_td_1.style.width = "70%";
                                        var e_a_1 = document.createElement('a');
                                        e_a_1.href = "http://mail.google.com";
                                        var title_txt = document.createTextNode(google_mail[i].title);
                                        e_a_1.appendChild(title_txt);
                                        if (google_mail[i].flag == false) {
                                            e_a_1.style.fontWeight = "bold";
                                        }
                                        e_td_1.appendChild(e_a_1);
                                        e_tr_1.appendChild(e_td_1);
                                    } else if (j == 2) {
                                        e_td_1.style.width = "10%";
                                        if (google_mail[i].flag == true) {
                                            var read_mail_img = document.createElement('img');
                                            read_mail_img.style.float = "right";
                                            read_mail_img.style.width = "20px";
                                            read_mail_img.style.height = "20px";
                                            read_mail_img.style.opacity = "0.6";
                                            read_mail_img.src = "image/read_mail.png";
                                            e_td_1.appendChild(read_mail_img);
                                        } else if (google_mail[i].flag == false) {
                                            var not_read_mail_img = document.createElement('img');
                                            not_read_mail_img.style.float = "right";
                                            not_read_mail_img.style.width = "20px";
                                            not_read_mail_img.style.height = "20px";
                                            not_read_mail_img.src = "image/not_read_mail.png";
                                            e_td_1.appendChild(not_read_mail_img);
                                        }
                                        e_tr_1.appendChild(e_td_1);
                                    }
                                }
                                document.getElementById("g_tbody").appendChild(e_tr_1);
                            }
                        }
                    };

                    e_table_1.appendChild(e_tbody_1);
                    e_div_google_c.appendChild(e_table_1);
                    e_div_google.appendChild(e_div_google_c);
                    email_div.appendChild(e_div_google);
                    var e_div_naver = document.createElement('div');
                    e_div_naver.className = "accordion-section";
                    var e_atag_n = document.createElement('a');
                    e_atag_n.id = "naver_id";
                    e_atag_n.className = "accordion-section-title";
                    e_atag_n.href = "#accordion-1";
                    var naver_email_img = document.createElement('img');
                    naver_email_img.src = "image/search_icon/naver.png";
                    naver_email_img.style.width = "25px";
                    naver_email_img.style.height = "25px";
                    naver_email_img.style.marginRight = "15px";
                    e_atag_n.appendChild(naver_email_img);
                    $.ajax({
                        type: 'GET',
                        url: 'http://210.118.74.117:8100/PIE/get_email_id',
                        data: {
                            email_type: 2
                        },
                        async: false,
                        success: function (data) {
                            if (data.msg == "Success") {
                                naver_e_id = data.email_id;
                            }
                        }
                    });
                    if (naver_e_id == null) {
                        e_atag_n.appendChild(document.createTextNode("Naver"));
                    } else {
                        e_atag_n.appendChild(document.createTextNode(naver_e_id));
                    }

                    e_div_naver.appendChild(e_atag_n);
                    var e_div_naver_c = document.createElement('div');
                    e_div_naver_c.id = "accordion-1";
                    e_div_naver_c.className = "accordion-section-content";
                    var e_table = document.createElement('table');
                    e_table.style.width = "100%";
                    var e_tbody = document.createElement('tbody');
                    e_tbody.id = "n_tbody";
                    e_atag_n.onclick = function (e) {
                        function close_accordion_section() {
                            $('.accordion .accordion-section-title').removeClass('active');
                            $('.accordion .accordion-section-content').slideUp(300).removeClass('open');
                        }

                        var currentAttrValue = $(this).attr('href');

                        if ($(e.target).is('.active')) {
                            close_accordion_section();
                        } else {
                            close_accordion_section();
                            $(this).addClass('active');
                            $('.accordion ' + currentAttrValue).slideDown(300).addClass('open');
                        }
                        e.preventDefault();

                        if (n_chk == 0) {
                            $.ajax({
                                type: 'GET',
                                url: 'http://210.118.74.117:8100/PIE/get_email_list',
                                data: {
                                    email_type: 2
                                },
                                async: false,
                                success: function (data) {
                                    if (data.msg == "Success") {
                                        naver_mail = data.email_list;
                                        n_chk = 1;
                                    } else {
                                        alert(data.msg);
                                    }
                                }
                            });
                            if (naver_mail.length == 0) {
                                naver_chk = 0;
                            }
                            else if (naver_mail.length != 0) {
                                naver_chk = naver_mail.length;
                                if (naver_chk > 10) {
                                    naver_chk = 10;
                                }
                            }
                            for (var i = 0; i < naver_chk; i++) {
                                var e_tr = document.createElement('tr');
                                e_tr.style.width = "100%";
                                for (var j = 0; j < 3; j++) {
                                    var e_td = document.createElement('td');
                                    e_td.style.overflow = "auto";
                                    if (j == 0) {
                                        e_td.style.width = "20%";
                                        var temp_n;
                                        for (var n = 0; n < (naver_mail[i].sender_address).length; n++) {
                                            if ((naver_mail[i].sender_address)[n] == '@') {
                                                temp_n = n;
                                            }
                                        }
                                        e_td.appendChild(document.createTextNode((naver_mail[i].sender_address).substring(0, temp_n)));
                                        e_tr.appendChild(e_td);
                                    } else if (j == 1) {
                                        e_td.style.width = "70%";
                                        var e_a = document.createElement('a');
                                        e_a.href = "http://mail.naver.com";
                                        var title_txt_1 = document.createTextNode(naver_mail[i].title);
                                        e_a.appendChild(title_txt_1);
                                        if (naver_mail[i].flag == false) {
                                            e_a.style.fontWeight = "bold";
                                        }
                                        e_td.appendChild(e_a);
                                        e_tr.appendChild(e_td);
                                    } else if (j == 2) {
                                        e_td.style.width = "10%";
                                        if (naver_mail[i].flag == true) {
                                            var read_mail_img_1 = document.createElement('img');
                                            read_mail_img_1.style.float = "right";
                                            read_mail_img_1.style.width = "20px";
                                            read_mail_img_1.style.height = "20px";
                                            read_mail_img_1.style.opacity = "0.6";
                                            read_mail_img_1.src = "image/read_mail.png";
                                            e_td.appendChild(read_mail_img_1);
                                        } else if (naver_mail[i].flag == false) {
                                            var not_read_mail_img_1 = document.createElement('img');
                                            not_read_mail_img_1.style.float = "right";
                                            not_read_mail_img_1.style.width = "20px";
                                            not_read_mail_img_1.style.height = "20px";
                                            not_read_mail_img_1.src = "image/not_read_mail.png";
                                            e_td.appendChild(not_read_mail_img_1);
                                        }
                                        e_tr.appendChild(e_td);
                                    }
                                }
                                document.getElementById("n_tbody").appendChild(e_tr);
                            }
                        }
                    };

                    e_table.appendChild(e_tbody);
                    e_div_naver_c.appendChild(e_table);
                    e_div_naver.appendChild(e_div_naver_c);
                    email_div.appendChild(e_div_naver);
                    dd_2.appendChild(email_div);
                    break;
                case 3:
                    dd.style.height = widget_height - 50 + 'px';
                    dd_2.className = "sh_parent";
                    var iframe = document.createElement('iframe');
                    iframe.className = "sh_child";
                    iframe.style.width = "1150px";
                    iframe.style.height = "1300px";
                    iframe.id = w_code;
                    iframe_inner_c = w_code;
                    iframe.scrolling = "yes";
                    iframe.frameBorder = "0";

                    input_text.onkeydown = function (event) {
                        if (event.keyCode == 13) {
                            $.post("http://210.118.74.117:8100/PIE/update_widget_content", {
                                widgetType: 3,
                                w_Code: iframe.id,
                                url: input_text.value
                            }, function (data) {

                            });
                            iframe.src = input_text.value;
                        }
                    };
                    dd_2.appendChild(iframe);
                    break;
                case 4:
                    dd_2.className = "sh_parent";
                    var cal_div = document.createElement('div');
                    cal_div.id = "todoapp";
                    var cal_header = document.createElement('header');
                    var cal_h1 = document.createElement('h1');
                    cal_h1.id = "todayDate";

                    date = $.datepicker.formatDate('yy-mm-dd', new Date());
                    var date_txt = document.createTextNode(date);
                    cal_h1.appendChild(date_txt);
                    all_data_list[date] = [];

                    cal_header.appendChild(cal_h1);
                    var cal_input_text = document.createElement('input');
                    cal_input_text.id = "new-todo";
                    cal_input_text.onkeydown = function (event) {
                        if (event.keyCode == 13) {
                            var newTodoVal = $('#new-todo').val();
                            var temp_list = {};
                            var check_var = true;
                            $todoList = $('#todo-list');
                            if (all_data_list[date] != undefined) {
                                for (var i = 0; i < all_data_list[date].length; i++) {
                                    if (all_data_list[date][i].task == newTodoVal) {
                                        check_var = false;
                                    }
                                }
                            }
                          //이미 존재하는 리스트인지 판단 후, 목록화
                            if (check_var == false) {
                                alert("이미 존재하는 리스트입니다.");
                            } else {
                                var todos = $todoList.html();
                                todos += "" +
                                        "<li>" +
                                        "<div class='view'>" +
                                        "<input class='toggle' type='checkbox'>" +
                                        "<label data=''>" + newTodoVal + "</label>" +
                                        "<a class='destroy'></a>" +
                                        "</div>" +
                                        "</li>";

                                $(this).val('');
                                $todoList.html(todos);
                                runBind();
                                $('#main').show();

                                temp_list["task"] = newTodoVal;
                                temp_list["check"] = true;

                                if (all_data_list[date] == undefined) {
                                    all_data_list[date] = [];
                                    all_data_list[date].push(temp_list);
                                } else {
                                    all_data_list[date].push(temp_list);
                                }
                                temp_list = {};
                            }
                        }
                    }; // end if
                    cal_input_text.focusout = function () {
                        postData();
                    };
                    cal_input_text.type = "text";
                    cal_input_text.placeholder = "What needs to be done?";
                    cal_header.appendChild(cal_input_text);
                    cal_div.appendChild(cal_header);
                    var cal_section = document.createElement('section');
                    cal_section.id = "main";
                    var cal_ul = document.createElement('ul');
                    cal_ul.id = "todo-list";
                    cal_section.appendChild(cal_ul);
                    cal_div.appendChild(cal_section);
                    dd_2.appendChild(cal_div);
                    break;
                case 5:
                	var gallery_c = document.createElement('div');
                    gallery_c.style.width = "100%";
                    gallery_c.style.height = "100%";
                    //gallery_c.style.borderRadius="6px";
                    gallery_c.id="slideshow";
                    if (gallery_idx != 0) {
                        $.get("http://210.118.74.117:8100/PIE/get_picture_list",
                                function (data) {
                                    if (data.msg == 'Success') {
                                        for (var g = 0; g < data.pictureList.length; g++) {
                                        	var temp_div = document.createElement('div');
                                        	temp_div.style.width="100%";
                                        	temp_div.style.height="100%";
                                        	//temp_div.style.borderRadius="6px";
                                        	var gall_img = document.createElement('img');
                                        	gall_img.src=data.pictureList[g].path;
                                        	gall_img.style.borderRadius="6px";
                                        	gall_img.style.width="100%";
                                        	gall_img.style.height="100%";
                                        	temp_div.appendChild(gall_img);
                                        	gallery_c.appendChild(temp_div);
                                        }
                                    }
                                });
                    }
                    dd_2.appendChild(gallery_c);
                    break;
                case 6:
                    var textarea = document.createElement('textarea');
                    textarea.id = w_code;
                    textarea.focusout = function () {
                        $.post("http://210.118.74.117:8100/PIE/update_widget_content", {
                            widgetType: 6,
                            w_Code: textarea.id,
                            content: textarea.value,
                            title: "title"
                        }, function (data) {

                        });
                    };
                    textarea.style.resize = "none";
                    textarea.style.padding = "5px";
                    textarea.style.width = "100%";
                    textarea.style.height = "100%";
                    dd_2.appendChild(textarea);
                    break;
                case 7:
                    div_w = document.createElement('div');
                    div_w.style.width = "100%";
                    div_w.style.height = "100%";
                    var w_table = document.createElement('table');
                    w_table.style.width = "100%";
                    w_table.style.height = "68%";
                    w_table.style.marginBottom="2%";
                    var w_tbody = document.createElement('tbody');
                    var w_tr = document.createElement('tr');
                    w_tr.style.width = "100%";
                    var w_td = document.createElement('td');
                    w_td.style.width = "49%";
                    var w_div_1 = document.createElement('div');
                    w_div_1.style.borderRadius="10px";
                    w_div_1.style.background= "linear-gradient( 45deg, #1E90FF, #00CED1 )";
                    w_div_1.style.width = "100%";
                    w_div_1.style.height="100%";
                    w_div_1.style.verticalAlign="middle";
                    var temperature_div = document.createElement('div');
                    temperature_div.style.verticalAlign = "middle";
                    p_temperature = document.createElement('p');
                    p_temperature.style.paddingTop="50%";
                    p_temperature.style.paddingLeft="10px";
                    p_temperature.className = "temperature";
                    p_temperature.style.fontSize = "500%";
                    p_temperature.style.textAlign = "center";
                    p_temperature.style.margin = "0px";
                    temperature_div.appendChild(p_temperature);
                    w_div_1.appendChild(temperature_div);
                    w_td.appendChild(w_div_1);
                    w_tr.appendChild(w_td);
                    var w_td_1_1 = document.createElement('td');
                    w_td_1_1.style.width="2%";
                    w_tr.appendChild(w_td_1_1);
                    var w_td_1 = document.createElement('td');
                    w_td_1.style.width = "49%";
                    climate_div = document.createElement('div');
                    climate_div.style.wdith="100%";
                    climate_div.style.height="100%";
                    climate_div.style.borderRadius="10px";
                    climate_div.style.background= "linear-gradient( 45deg, #1E90FF, #00CED1 )";
                    climate_div.style.textAlign = "center";
                    climate_div.className = "climate_bg";
                    w_td_1.appendChild(climate_div);
                    w_tr.appendChild(w_td_1);
                    w_tbody.appendChild(w_tr);
                    w_table.appendChild(w_tbody);
                    div_w.appendChild(w_table);
                    var w_table_2 = document.createElement('table');
                    w_table_2.style.width = "100%";
                    w_table_2.style.height = "30%";
                    w_table_2.style.background= "linear-gradient( 45deg, #1E90FF, #00CED1 )";
                    w_table_2.style.borderRadius="10px";
                    var w_tbody_2 = document.createElement('tbody');
                    var w_tr_2 = document.createElement('tr');
                    w_tr_2.style.width = "100%";
                    var w_td_2_1 = document.createElement('td');
                    w_td_2_1.style.width = "33%";
                    var forecast_1_div = document.createElement('div');
                    forecast_1_div.style.textAlign = "center";
                    forecast_1_div.className = "t_nail_1";
                    w_td_2_1.appendChild(forecast_1_div);
                    var forecast_1_1_div = document.createElement('div');
                    forecast_1_1_div.style.textAlign = "center";
                    forecast_1_1_div.className = "day1";
                    w_td_2_1.appendChild(forecast_1_1_div);
                    w_tr_2.appendChild(w_td_2_1);

                    var w_td_2_2 = document.createElement('td');
                    w_td_2_2.style.width = "33%";
                    var forecast_2_div = document.createElement('div');
                    forecast_2_div.style.textAlign = "center";
                    forecast_2_div.className = "t_nail_2";
                    w_td_2_2.appendChild(forecast_2_div);
                    var forecast_2_1_div = document.createElement('div');
                    forecast_2_1_div.style.textAlign = "center";
                    forecast_2_1_div.className = "day2";
                    w_td_2_2.appendChild(forecast_2_1_div);
                    w_tr_2.appendChild(w_td_2_2);

                    var w_td_2_3 = document.createElement('td');
                    w_td_2_3.style.width = "33%";
                    var forecast_3_div = document.createElement('div');
                    forecast_3_div.style.textAlign = "center";
                    forecast_3_div.className = "t_nail_3";
                    w_td_2_3.appendChild(forecast_3_div);
                    var forecast_3_1_div = document.createElement('div');
                    forecast_3_1_div.style.textAlign = "center";
                    forecast_3_1_div.className = "day3";
                    w_td_2_3.appendChild(forecast_3_1_div);
                    w_tr_2.appendChild(w_td_2_3);
                    w_tbody_2.appendChild(w_tr_2);
                    w_table_2.appendChild(w_tbody_2);
                    div_w.appendChild(w_table_2);
                    dd_2.appendChild(div_w);
                    break;
                case 8:
                    dd_2.className = "sh_parent";
                    var w_quick = document.createElement('div');
                    w_quick.className = "sh_child";
                    w_quick.id = "w_quick";
                    w_quick.style.width = "100%";
                    w_quick.style.height = "100%";
                    //디비에서 등록한 사이트가 있는지 확인
                    //alert(quickData_length);
                    $.ajax({
                        type: "GET",
                        url: "http://210.118.74.117:8100/PIE/get_book_mark",
                        async: false,
                        success: function (data) {
                            if (data.msg == "Success") {
                                var q_tempData = data.bookmarkList;
                                //alert(data.msg);
                                quickData_length = q_tempData.length;
                                for (var i = 0; i < q_tempData.length; i++) {
                                    quickData[q_tempData[i].code] = {
                                        "code": q_tempData[i].code,
                                        "title": q_tempData[i].title,
                                        "url": q_tempData[i].url
                                    };
                                }
                                for (var key in quickData) {
                                    //alert(quickData[key].code + " : " + quickData[key].title + " : " + quickData[key].url);
                                    var mark_cont = document.createElement('div');
                                    mark_cont.id = quickData[key].code + '_div';
                                    mark_cont.style.width = "100%";
                                    mark_cont.style.display = "table";
                                    var quick_atag = document.createElement('a');
                                    quick_atag.style.fontWeight="bold";
                                    quick_atag.id = quickData[key].code;
                                    quick_atag.style.marginBottom = "5px";
                                    quick_atag.style.marginTop = "5px";
                                    quick_atag.style.fontSize = "15px";
                                    quick_atag.style.display = "table-cell";
                                    quick_atag.style.width = "80%";
                                    quick_atag.appendChild(document.createTextNode(' >  ' + quickData[key].title));
                                    quick_atag.href = quickData[key].url;
                                    mark_cont.appendChild(quick_atag);
                                    var q_delete_btn = document.createElement('img');
                                    q_delete_btn.style.width = "20px";
                                    q_delete_btn.style.height = "20px";
                                    q_delete_btn.src = "image/close_widget.png";
                                    q_delete_btn.style.display = "table-cell";
                                    q_delete_btn.style.float = "right";
                                    mark_cont.appendChild(q_delete_btn);
                                    q_delete_btn.onclick = function () {
                                        var del_div = $(this).parent().attr('id');
                                        var q_code = del_div.substring(0, del_div.length - 4);
                                        document.getElementById('w_quick').removeChild(document.getElementById(del_div));
                                        $.post("http://210.118.74.117:8100/PIE/delete_book_mark", {
                                            bookmark_code: q_code
                                        }, function (data) {
                                            if (data.msg == 'Success') {
                                                alert("삭제 되었습니다.");
                                            } else {
                                                alert(data.msg);
                                            }
                                        });
                                    };
                                    w_quick.appendChild(mark_cont);
                                }
                            }
                            else if (data.msg = "NoBookMark") {
                            }
                            else {
                                alert(data.msg);
                            }
                        }
                    });
                    dd_2.appendChild(w_quick);
                    break;
            }
            dd.appendChild(dd_2);
            div_c.appendChild(dd);
            document.getElementById('body').appendChild(div_c);
            if (w_type == 1) {
           	    loadFlag = true;
                goNews();
            }
            else if (w_type == 3) {
                $.post("http://210.118.74.117:8100/PIE/get_widget_content", {
                    widgetType: 3,
                    w_Code: iframe.id
                }, function (data) {
                    if (data.url == undefined) {
                        iframe.src = "";
                        input_text.value = "http://";
                    } else {
                        iframe.src = data.url;
                        input_text.value = data.url;
                    }
                });
            }else if(w_type==5){
            	slideShow();
            }else if (w_type == 4) {
                getData();
                runBind();
                taskList(date);
            }else if (w_type == 6) {
                $.post("http://210.118.74.117:8100/PIE/get_widget_content", {
                    widgetType: 6,
                    w_Code: textarea.id
                }, function (data) {
                    if (data.content == undefined) {
                        textarea.value = "";
                        textarea.placeholder = "새로운 내용을 입력하세요.";
                    } else {
                        textarea.value = data.content;
                    }
                });
            }
            addScroll(); //------------------ sohee's scroll script
        }

        function goto_Content() {
            var t_id = $(this).parent().parent().parent().parent().parent().parent().parent().attr('id');
            var t_id_code = widgetData[t_id].w_Code;
            var content = document.getElementById(t_id_code).value;
            $.post("http://210.118.74.117:8100/PIE/update_widget_content", {
                widgetType: 6,
                w_Code: t_id_code,
                content: content,
                title: "title"
            }, function (data) {

            });
            alert("저장되었습니다.");
        }
        function goto_URL() {
            var f_id = $(this).parent().parent().parent().parent().parent().parent().parent().attr('id');
            var f_id_code = widgetData[f_id].w_Code;
            var url = document.getElementById(f_id_code + '_src').value;
            var f_contents = document.getElementById(f_id_code);
            f_contents.src = url;
            $.post("http://210.118.74.117:8100/PIE/update_widget_content", {
                widgetType: 3,
                w_Code: f_id_code,
                url: url
            }, function (data) {

            });
        }
    </script>
    <script type="text/javascript">
  //데이터베이스에서 사용자가 지정한 브라우저의 번호를 가져와서 searchNum에 넣어야한다.
        var searchNum = 0;

        var all_data_list = {};
        var fullCalendar_list = [];

        var toggleStatus;
        var EnterKey = 13;
        var date = $.datepicker.formatDate('yy-mm-dd', new Date());

        var back_img = null;

        function postData() {
            $.ajax({
                type: 'POST',
                url: "http://210.118.74.117:8100/PIE/update_schedule",
                data: {
                    schedule_list: JSON.stringify(all_data_list)
                },
                async: false
            });
        }
        function getData() {
            var temp;
            var returnData = [];
            var allData = {};
            fullCalendar_list = []; //초기화
            $.ajax({
                type: "GET",
                url: "http://210.118.74.117:8100/PIE/get_schedule_list",
                async: false,
                success: function (data) {
                    if (data.msg == 'Success') {
                        temp = data.scheduleList;
                    }
                }
            });

            if (temp != undefined) {
                returnData = temp;

                for (var i = 0; i < returnData.length; i++) {
                    var fullCalendar_obj = {};
                    var day = returnData[i].date;
                    var tempArr = [];
                    var tempObj = {};

                    fullCalendar_obj['title'] = returnData[i].task;
                    fullCalendar_obj['start'] = day;
                    fullCalendar_list.push(fullCalendar_obj);

                    tempObj['task'] = returnData[i].task;
                    tempObj['check'] = returnData[i].check;
                    tempArr.push(tempObj);
                    if (allData[day] == undefined) {
                        allData[day] = tempArr;
                    } else {
                        allData[day].push(tempObj);
                    }
                }

            }
            all_data_list = allData;
            $('#dialog-form').fullCalendar('removeEvents');
            $('#dialog-form').fullCalendar('addEventSource', fullCalendar_list);

        }

        /*FullCalendar에서 날짜 클릭 후*/
        function AfterClick(_date) {
            date = _date;
            document.getElementById('todayDate').firstChild.nodeValue = date;
          //본래 task list 삭제하고 클릭한 날짜의 task list 출력
            $('#todo-list li').each(function () {
                $(this).remove();
            });
            taskList(date);
        }

        $.fn.isBound = function (type, fn) {
            var data = this.data('events')[type];

            if (data === undefined || data.length === 0) {
                return false;
            }

            return (-1 !== $.inArray(fn, data));
        };

        function runBind() {

            $('.destroy').on('click', function (e) {
                var labelText = $(this).closest('li').find('label').text(); //ì§ìì¼ íë task

                $currentListItem = $(this).closest('li');
                $currentListItem.remove();

                if (all_data_list[date] != undefined) {
                    all_data_list[date] = all_data_list[date].filter(function (el) {
                        return el.task !== labelText;
                    });
                    postData(); //서버로 데이터 저장
                    getData();
                }
            });

            $('.toggle').on('click', function (e) {
                var $currentListItemLabel = $(this).closest('li').find('label');
                var $input = $(this).closest('li').find('input');
                var labelText = $(this).closest('li').find('label').text(); // to do listì textë¥¼ ê°ì ¸ì´
                /*var targetData = date_todo_list[date].filter(function(v) {
                 return v[labelText];
                 });
                 var target = targetData[0];*/
                /*
                 * Do this or add css and remove JS dynamic css.
                 */
                if ($currentListItemLabel.attr('data') == 'done') {
                    $currentListItemLabel.attr('data', '');
                    $currentListItemLabel.css('text-decoration', 'none')
                    //$input.attr('checked', 'false');

                    for (var i = 0; i < all_data_list[date].length; i++) {

                        if (all_data_list[date][i].task == labelText) {
                            all_data_list[date][i].check = true;
                        }
                    }
                }
                else {
                    $currentListItemLabel.attr('data', 'done');
                    $currentListItemLabel.css('text-decoration', 'line-through');
                    //$input.attr('checked', 'true');

                    for (var i = 0; i < all_data_list[date].length; i++) {
                        if (all_data_list[date][i].task == labelText) {
                            all_data_list[date][i].check = false;
                        }
                    }
                }

            });
        }

      //매개변수로 해당 날짜를 입력 받아서 저장된 task list를 출력
        function taskList(where) {
            $todoList = $('#todo-list');
            var todos = $todoList.html();

            for (var i in all_data_list) {
                if (i == where) {
                    for (var i = 0; i < all_data_list[where].length; i++) {
                        var newTodoVal = all_data_list[where][i].task;
                        if (all_data_list[where][i].check == 'true') {
                            todos += "" +
                                    "<li>" +
                                    "<div class='view'>" +
                                    "<input class='toggle' type='checkbox'>" +
                                    "<label data=''>" + newTodoVal + "</label>" +
                                    "<a class='destroy'></a>" +
                                    "</div>" +
                                    "</li>";
                        } else {
                            todos += "" +
                                    "<li>" +
                                    "<div class='view'>" +
                                    "<input class='toggle' type='checkbox' checked='true'>" +
                                    "<label data='done' style='text-decoration: line-through;'>" + newTodoVal + "</label>" +
                                    "<a class='destroy'></a>" +
                                    "</div>" +
                                    "</li>";
                        }

                    }
                }
            }
            $todoList.html(todos);
            runBind();
            $('#main').show();
        }

        function searchURL() {
            var search_Content = document.getElementById("search_bar").value;
            document.getElementById("search_bar").value = "";

            if (searchNum == 1)
                window.location = 'https://www.google.co.kr/webhp?search=dddddd&gws_rd=cr,ssl&ei=_fs9VueKJcq_0gSUvqCwCA#newwindow=1&q=' + search_Content;
            else if (searchNum == 2)
                window.location = 'http://search.naver.com/search.naver?query=' + search_Content;
            else if (searchNum == 3)
                window.location = 'http://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&sq=&o=&q=' + search_Content;
            else if (searchNum == 4)
                window.location = 'https://www.bing.com/search?q=' + search_Content + '&go=%EC%A0%9C%EC%B6%9C&qs=n&form=QBRE&pq=' + search_Content + '&sc=8-4&sp=-1&sk=&cvid=96A16D8248204D5583CEB8CFE8077BC9';
            return false;
        }

        function click_Browser(b_num) {
            var aa;
            $.get("http://210.118.74.117:8100/PIE/last_search_bar", {
                last_search_bar: b_num
            }, function (data) {

            });
            searchNum = b_num;
            if (searchNum == 1)
                aa = 'Google';
            else if (searchNum == 2)
                aa = 'Naver';
            else if (searchNum == 3)
                aa = 'Daum';
            else if (searchNum == 4)
                aa = 'Bing';
            var b_state = document.getElementById("search_bar");
            b_state.placeholder = "Search for " + aa + " ...";
        }
        function to_Editor() {
            location.href = "http://210.118.74.117:8100/PIE/edit_page";
        }
        function log_out() {
        	location.href = "http://210.118.74.117:8100/PIE/logout";
            //$.get("http://210.118.74.117:8100/PIE/log_out");
            //location.href = "LoginForm.html";
        }
        function mail_click(type) {
            var emailid_input = document.getElementById('email_id');
            var emailpw_input = document.getElementById('email_password');
            if (type == 1) {
                emailid_input.value = null;
                emailpw_input.value = null;
                emailid_input.placeholder = "ID@gmail.com";
            } else if (type == 2) {
                emailid_input.value = null;
                emailpw_input.value = null;
                emailid_input.placeholder = "Insert only ID, not @naver.com";
            }
        }
        function mail_input_reset() {
            var emailid_input = document.getElementById('email_id');
            var emailpw_input = document.getElementById('email_password');
            emailid_input.value = null;
            emailpw_input.value = null;
        }
        function mark_input_reset() {
            var mark_title_input = document.getElementById('mark_title');
            var mark_url_input = document.getElementById('mark_url');
            mark_title_input.value = null;
            mark_url_input.value = null;
        }

        //--------------------------------------galleryê´ë ¨ í¨ì---------------
        function gallery_img_click(img_id) {
        	var click_img = document.getElementById(img_id);
            if (click_img.src != "http://localhost:13913/PIE/image/blank_gallery.png") {

                $.post("http://210.118.74.117:8100/PIE/delete_picture", {
                            picture_code: click_img.name
                        },
                        function (data) {
                            if (data.msg == 'Success') {
                                alert("삭제했습니다.");
                                //$("#"+img_id).setAttribute("src","image/black_gallery.png");
                                for (var g = 1; g <= 10; g++) {
                                    $("#gallery_img_" + g).attr("src", "image/blank_gallery.png");
                                }
                                $.get("http://210.118.74.117:8100/PIE/get_picture_list",
                                        function (data) {
                                            if (data.msg == 'Success') {
                                                //이미지 넣자~
                                                for (var i = 1; i <= data.pictureList.length; i++) {
                                                    $("#gallery_img_" + i).attr("src", data.pictureList[i - 1].path);
                                                    $("#gallery_img_" + i).attr("name", data.pictureList[i - 1].code);
                                                }
                                            }
                                        });
                            }
                        })
            }else if(click_img.src == "http://localhost:13913/PIE/image/blank_gallery.png"){
            	alert("먼저 이미지를 등록하세요");
            }
        }
        //---------------------------------------------------------------------
        //--------------------------------------mainbackê´ë ¨ í¨ì---------------
		function uploadUserFile(){
        	var user_img = $("#choice_background_img").val();
        	if(user_img==""){
        		alert("사진을 선택하세요");
        	}else{
        		switch(user_img.substring(user_img.lastIndexOf('.')+1).toLowerCase()){
        		case 'gif': case 'jpg': case 'png': case 'bmp':
        			var fileSelect = document.getElementById("choice_background_img");
                    var files = fileSelect.files;

                    if (files.length == 0) {
                        alert("파일을 선택하세요.");
                    }
                    else {
                        var formData = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            var file = files[i];

                            formData.append('file', file, file.name);
                        }

                        $.ajax({
                            url: 'http://210.118.74.117:8100/PIE/upload_back_ground',
                            type: 'POST',
                            data: formData,
                            processData: false,
                            contentType: false,
                            async: false,
                            success: function (data) {
                                if (data.msg == 'Success') {
                                    location.reload();
                                }else{
                                	alert(data.msg);
                                }
                            }
                        });
                    }
        			
        			break;
        			default:
        				$("#choice_background_img").val('');
        			alert('Not an Image format');
        			break;
        		}
        	}
        }
        function inform(input_id){
        	alert("11");
        }
        function change_back_dialog() {
            var dialog;

            dialog = $("#mainback-dialog-form").dialog({
                /*position: ,*/
                autoOpen: false,
                width: 700,
                height: 520,
                modal: true,
                buttons: {
                    "선택": function () {
                    	if (back_img == null) {
                            alert("사진을 선택하세요.");
                        } else {
                        	var path = "";
                            var idx = 0;
                            
                            for(var i=0; i<back_img.src.length; i++){                        	
                            	if( idx == 4 ){
                            		path += back_img.src[i];
                            	}
                            	else{
                            		if( back_img.src[i] == "/" ){
                                		idx++;
                                	}
                            	}
                            }
                            $.get("http://210.118.74.117:8100/PIE/save_back_ground", {
                                back_ground_path: path // image/background/back_1.bmp
                            }, function (data) {
                                if (data.msg == 'Success') {
                                    var b_body = document.getElementById('body');
                                    b_body.style.backgroundImage = "url(" + path + ")";
                                    b_body.style.backgroundRepeat = "no-repeat";
                                    b_body.style.backgroundSize = "cover";
                                    dialog.dialog("close");
                                }
                            });
                            for (var i = 0; i < 10; i++) {
                                back_img.style.boxShadow = "1px 2px 10px gray";
                                back_img.style.border = "none";
                            }
                        }
                        
                        //alert(path);
                        
                    },
                    "취소": function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    dialog.dialog("close");
                }
            });
            dialog.dialog('open');
        }

        function back_img_click(back_img_id) {
            back_img = document.getElementById(back_img_id);
            for (var i = 0; i < 10; i++) {
                document.getElementById('back_img_' + (i + 1)).style.boxShadow = "1px 2px 10px gray";
                document.getElementById('back_img_' + (i + 1)).style.border = "none";
            }
            back_img.style.boxShadow = "0px 0px 20px 0px #3366CC";
            back_img.style.border = "3px solid #3366CC";
        }
        //---------------------------------------------------------------------
        function to_Send_bug() {
            var dialog;

            dialog = $("#bug-dialog-form").dialog({
                autoOpen: false,
                width: 600,
                height: 420,
                modal: true,
                buttons: {
                    "전송": function () {
                        var bug_title = $("#bug_title");
                        var bug_content = $("#bug_content");

                        if (bug_title.val() == "") {
                            alert("제목을 입력하세요.");
                            bug_title.focus();
                        } else if (bug_content.val() == "") {
                            alert("내용을 입력하세요.");
                            bug_content.focus();
                        } else {
                            $.post("http://210.118.74.117:8100/PIE/save_bug_report", {
                                bug_title: bug_title.val(),
                                bug_content: bug_content.val()
                            }, function (data) {
                                if (data.msg == 'Success') {
                                    alert("의견 주셔서 감사합니다.");
                                    dialog.dialog("close");
                                }
                                else {
                                    alert(data.msg);
                                }
                            });
                        }
                    },
                    "취소": function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    dialog.dialog("close");
                }
            });
            dialog.dialog('open');
        }

        function frameLoaded(iframe_inner_v) {
            var ddd = document.getElementById(iframe_inner_v);
            //alert(ddd.contentWindow.document.body.offsetWidth + 'px');
            //alert(ddd.contentWindow.document.body.offsetHeight + 'px');
        }
        function uploadFile() {
            var fileSelect = document.getElementById("file");
            var files = fileSelect.files;
            
            if (files.length == 0) {
                alert("파일을 선택하세요.");
            }
            else {
                var formData = new FormData();
                for (var i = 0; i < files.length; i++) {
                    var file = files[i];

                    formData.append('file', file, file.name);
                }

                $.ajax({
                    url: 'http://210.118.74.117:8100/PIE/upload_picture',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    async: false,
                    success: function (data) {
                        if (data.msg == 'Success') {
                            alert('업로드를 완료했습니다.');
                            $.get("http://210.118.74.117:8100/PIE/get_picture_list",
                                    function (data) {
                                        if (data.msg == 'Success') {
                                           //이미지 넣자~

                                            for (var i = 1; i <= data.pictureList.length; i++) {
                                                $("#gallery_img_" + i).attr("src", data.pictureList[i-1].path);
                                                $("#gallery_img_" + i).attr("name", data.pictureList[i-1].code);
                                            }
                                        }
                                    });
                        }
                    }
                });
            }
        }
        function slideShow(){
        	$("#slideshow > div:gt(0)").hide();

        	setInterval(function() { 
        	  $('#slideshow > div:first')
        	    .fadeOut(1000)
        	    .next()
        	    .fadeIn(1000)
        	    .end()
        	    .appendTo('#slideshow');
        	},  5000);
        }
        function secure_chk(){
        	alert("구글 계정 등록을 위해 보안등급을 낮춰주세요. 해당 링크로 이동합니다.");
        	window.open('https://accounts.google.com/ServiceLogin?service=accountsettings&passive=1209600&osid=1&continue=https://www.google.com/settings/security/lesssecureapps&followup=https://www.google.com/settings/security/lesssecureapps&emr=1&mrp=security#identifier', '_blank');
        }
        function account_clicked(){
            var dialog;
            var dialog_change_pw;
            var dialog_withdrawal;
        	var user_name= document.getElementById('user_name');
        	user_name.style.fontWeight="bold";
        	while(user_name.hasChildNodes()){
        		user_name.removeChild(user_name.firstChild);
        	}
        	user_name.appendChild(document.createTextNode('Your ID : '+userId));
            var user_name_1= document.getElementById('user_name_1');
            user_name_1.style.fontWeight="bold";
            while(user_name_1.hasChildNodes()){
        		user_name_1.removeChild(user_name_1.firstChild);
        	}
        	user_name_1.appendChild(document.createTextNode('Your ID : '+userId));

            dialog = $("#account-dialog-form").dialog({
                autoOpen: false,
                width: 300,
                height: 150,
                modal: true,
                buttons: {
                    "확인": function () {
                        var radio = $(':radio[name="account_radio"]:checked');

                        if (radio.val() == null) {
                            alert("비밀번호 변경 또는 회원탈퇴를 선택해주세요.");
                        } else {
                            if(radio.val()==1){
                                dialog_change_pw = $("#changed-password-dialog-form").dialog({
                                    autoOpen: false,
                                    width: 300,
                                    height: 360,
                                    modal: true,
                                    buttons: {
                                        "확인": function () {
                                            //현재 비밀번호가 맞는지 확인하고 새로운 비밀번호 두개 같은지 확인하고 같으면 그걸로 변경
                                            var current_pw = document.getElementById('current_pw');
                                            var change_1 = document.getElementById('new_pw');
                                            var change_2 = document.getElementById('new_pw_chk');
                                           	
                                            if(current_pw.value==""){
                                            	alert("비밀번호를 입력하세요.");
                                            }else if(change_1.value==""){
                                            	alert("변경할 비밀번호를 입력하세요.");
                                            }else if(change_2.value==""){
                                            	alert("변경할 비밀번호를 한번 더 입력하세요.");
                                            }else if(change_1.value != change_2.value){
                                            	alert("변경할 비밀번호가 일치하지 않습니다.")
                                            }else{
                                            	$.post("http://210.118.74.117:8100/PIE/change_pw",{
                                            		current_pw : current_pw.value,
                                            		new_pw : change_1.value
                                            	}, function(data){
                                            		if(data.msg=='Success'){
                                            			alert("비밀번호가 변경되었습니다.");
                                            			dialog_change_pw.dialog("close");
                                            		}else{
                                            			alert(data.msg);
                                            		}
                                            	});
                                            }
                                            
                                        },
                                        "취소": function () {
                                            dialog_change_pw.dialog("close");
                                        }
                                    },
                                    close: function () {
                                        dialog_change_pw.dialog("close");
                                    }
                                });
                                dialog.dialog("close");
                                dialog_change_pw.dialog("open");
                            }else if(radio.val()==2){
                            	dialog_withdrawal = $("#exit-service-dialog-form").dialog({
                                    autoOpen: false,
                                    width: 300,
                                    height: 300,
                                    modal: true,
                                    buttons: {
                                        "확인": function () {
                                            //현재 비밀번호가 맞는지 확인하고 맞으면 회원정보 다 삭제
                                            var current_password = document.getElementById('current_pw_1');
                                            if(current_password.value==""){
                                            	alert("비밀번호를 입력하세요");
                                            }else{
                                            	$.post('http://210.118.74.117:8100/PIE/withdrawal',{
                                            		user_pw : current_password.value
                                            	},function(data){
                                            		if(data.msg=='Success'){
                                            			alert("회원탈퇴가 완료되었습니다. 이용해 주셔서 감사합니다.");
                                            			location.href="http://210.118.74.117:8100/PIE/logout";
                                            		}else{
                                            			alert(data.msg);
                                            		}
                                            	});
                                            	
                                            }
                                        },
                                        "취소": function () {
                                            dialog_withdrawal.dialog("close");
                                        }
                                    },
                                    close: function () {
                                        dialog_withdrawal.dialog("close");
                                    }
                                });
                                dialog.dialog("close");
                                dialog_withdrawal.dialog("open");
                            }
                        }
                    },
                    "취소": function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    dialog.dialog("close");
                }
            });
            dialog.dialog('open');
        }
    </script>
</head>
<body id="body" style="background-color: #EEEEEE;">
<header class="" id="header" role="banner">
    <nav class="navbar navbar-inverse">
        <table style="width:100%;">
            <tbody>
            <tr style="width:100%;">
                <td style="width:35%">
					<img src="image/logo_all.png" width="80" height="40" style="margin-left:10px; margin-top:3px">
                </td>
                <td style="width:30%">
                    <div style="width:100%; padding-top:7px;">
                        <div style="float:left; width:100%">
                            <form action="" autocomplete="on" method="get" onsubmit="return searchURL()">
                                <input id="search_bar" style="margin:auto;margin-top:-2px;width:100%;" type="text" class="form-control"
                                       placeholder="Search for Google...">
                            </form>
                        </div>
                        <div style="float:left; margin-left: -35px; margin-top:2px;" class="btn-group">
                            <button style="background: transparent; border:none;" type="button"
                                    class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false">
                                <span class="caret"></span>
                            </button>
                            <ul style="margin:0px;" class="dropdown-menu">
                                <li id="b_google" class="search_bar_li"
                                    style="cursor:pointer; padding-left:13px; padding-top:1px; padding-bottom: 5px;"
                                    onclick="click_Browser(1)"><img width="25" height="25"
                                                                    src="image/search_icon/google.png"/>&nbsp&nbsp&nbspGoogle
                                </li>
                                <li style="margin:0px;" role="separator" class="divider"></li>
                                <li id="b_naver" class="search_bar_li"
                                    style="cursor:pointer; padding-left:13px; padding-top:5px; padding-bottom: 5px;"
                                    onclick="click_Browser(2)"><img width="25" height="25"
                                                                    src="image/search_icon/naver.png"/>&nbsp&nbsp&nbspNaver
                                </li>
                                <li style="margin:0px;" role="separator" class="divider"></li>
                                <li id="b_daum" class="search_bar_li"
                                    style="cursor:pointer; padding-left:13px; padding-top:5px; padding-bottom: 5px;"
                                    onclick="click_Browser(3)"><img width="25" height="25"
                                                                    src="image/search_icon/daum.png"/>&nbsp&nbsp&nbspDaum
                                </li>
                                <li style="margin:0px;" role="separator" class="divider"></li>
                                <li id="b_bing" class="search_bar_li"
                                    style="cursor:pointer; padding-left:13px; padding-top:5px; padding-bottom: 1px;"
                                    onclick="click_Browser(4)"><img width="25" height="25"
                                                                    src="image/search_icon/bing.png"/>&nbsp&nbsp&nbspBing
                                </li>
                            </ul>
                        </div>
                    </div>
                </td>
                <td style="width:35%">
                    <img id="showRight" class="opcity_img" src="image/main_menu.png"
                         style="float:right; width:40px; height:40px; margin-top: 2px;margin-right: 7px;">
                         <p id="main_user_id" style="float:right; margin-right:10px;"></p>
                </td>
            </tr>
            </tbody>
        </table>
    </nav>
</header>
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right" id="cbp-spmenu-s2">
    <h3>Option<img class="opcity_img" id="closeRight" src="image/close_slide.png" style="float:right; width:25px; height:25px;"></h3>
    <a href="javascript:void(0)" onclick="account_clicked()" id="account"><img src="image/main_Icon/account.png"
                                                   style="width:20px; height:20px; margin-right:12px;">My
        Account</a>
    <a href="javascript:void(0)" onclick="to_Editor()"><img src="image/main_Icon/editor.png"
                                                            style="width:20px; height:20px; margin-right:12px;">Editor
        Mode</a>
    <a href="javascript:void(0)" id="mainback" onclick="change_back_dialog()"><img src="image/main_Icon/back_img.png"
                                                                                   style="width:20px; height:20px; margin-right:12px;">Background</a>
    <a href="javascript:void(0)" onclick="to_Send_bug()" id="bug"><img src="image/main_Icon/bug.png"
                                                                       style="width:20px; height:20px; margin-right:12px;">Bug
        Report</a>
    <a href="javascript:void(0)" onclick="log_out()"><img src="image/main_Icon/logout.png"
                                                          style="width:20px; height:20px; margin-right:12px;">Log
        out</a>
</nav>
<!-- Classie - class helper functions by @desandro https://github.com/desandro/classie -->
<script src="js/classie.js"></script>
<script>
    var menuRight = document.getElementById('cbp-spmenu-s2'),
            showRight = document.getElementById('showRight'),
            closeRight = document.getElementById('closeRight'),
            body = document.body;

    showRight.onclick = function () {
        classie.toggle(this, 'active');
        classie.toggle(menuRight, 'cbp-spmenu-open');
        disableOther('showRight');
    };
    closeRight.onclick = function () {
        classie.toggle(this, 'active');
        classie.toggle(menuRight, 'cbp-spmenu-open');
        disableOther('showRight');
    }
    function disableOther(button) {
        if (button !== 'showRight') {
            classie.toggle(showRight, 'disabled');
        }
    }
</script>
<div id="email-dialog-form" title="이메일 등록" style="display:none;">
    <div style="width:100%; display:table">
        <div style="display:table-cell; text-align: center" class="radio">
            <input type="radio" id="google_r" name="optradio" value="1" onclick="mail_click(1);" onchange="secure_chk()">구글
        </div>
        <div style="display:table-cell; text-align: center" class="radio">
            <input type="radio" id="naver_r" name="optradio" value="2" onclick="mail_click(2);">네이버
        </div>
    </div>
    <br>

    <div class="form-group">
        <label for="email_id">ID</label>
        <input id="email_id" type="text" class="form-control" placeholder="Insert Email">
    </div>
    <div class="form-group">
        <label for="email_password">PASSWORD</label>
        <input id="email_password" type="password" class="form-control"
               placeholder="Insert Password">
    </div>
</div>
<div id="dialog-form" title="Calendar" style="display:none;"></div>
<div id="gallery-dialog-form" title="사진 선택" style="display:none;">
    <div style="width:100%;">
        <img class="opcity_img" src="image/upload_Btn.png" width="60" height="30" id="upload_btn" style="float:right; margin-top:-3px;margin-left:5px;" onclick="uploadFile()">
        <input type="file" id="file" name="file" style="float:right;" multiple="multiple">
    </div>
    <table style="width:100%; height:90%; margin-top: 40px;">
        <tbody>
        <tr style="width:100%; height:50%;">
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_1" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_1')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_2" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_2')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_3" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="lery_img_click('gallery_img_3')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_4" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_4')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_5" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_5')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
        </tr>
        <tr style="width:100%; height:50%;">
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_6" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_6')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_7" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_7')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_8" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_8')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_9" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_9')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="gallery_img_10" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="gallery_img_click('gallery_img_10')" src="image/blank_gallery.png" title="삭제하시려면 클릭하세요">
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div id="mainback-dialog-form" title="이미지 선택" style="display:none;">
    <div style="width:100%;">
        <img class="opcity_img" src="image/upload_Btn.png" width="60" height="30" id="upload_btn" style="float:right; margin-top:-3px;margin-left:5px;" onclick="uploadUserFile()">
        <input type="file" id="choice_background_img" style="float:right;">
    </div>
    <table style="width:100%; height:90%; margin-top: 40px;">
        <tbody>
        <tr style="width:100%; height:50%;">
            <td style="width:20%; padding:5px;">
                <img id="back_img_1" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_1')" src="image/background/back_1.bmp">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_2" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_2')" src="image/background/back_2.bmp">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_3" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_3')" src="image/background/back_3.jpg">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_4" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_4')" src="image/background/back_4.jpg">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_5" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_5')" src="image/background/back_5.jpg">
            </td>
        </tr>
        <tr style="width:100%; height:50%;">
            <td style="width:20%; padding:5px;">
                <img id="back_img_6" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_6')" src="image/background/back_6.jpg">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_7" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_7')" src="image/background/back_7.jpg">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_8" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_8')" src="image/background/back_8.bmp">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_9" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_9')" src="image/background/back_9.bmp">
            </td>
            <td style="width:20%; padding:5px;">
                <img id="back_img_10" class="gallery_img_group" style="width:123px; height:160px;"
                     onclick="back_img_click('back_img_10')" src="image/background/back_10.bmp">
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div id="bookmark-dialog-form" title="Quick URL" style="display:none;">
    <div class="form-group">
        <label for="mark_title">Title</label>
        <input id="mark_title" type="text" class="form-control" placeholder="Insert Title">
    </div>
    <div class="form-group">
        <label for="mark_url">URL</label>
        <input id="mark_url" type="text" class="form-control"
               placeholder="Insert URL">
    </div>
</div>
<div id="bug-dialog-form" title="Bug Report" style="display:none;">
    <div class="form-group">
        <label for="bug_title">Title</label>
        <input id="bug_title" type="text" class="form-control" placeholder="Insert Title">
    </div>
    <div class="form-group">
        <label for="bug_content">Content</label>
        <textarea id="bug_content" class="form-control"
                  placeholder="Insert Bug" style="resize: none; height:185px;"></textarea>
    </div>
</div>
<div id="account-dialog-form" title="My Account" style="display:none;">
    <div style="width:100%; display:table">
        <div style="display:table-cell; text-align: center" class="radio">
            <input type="radio" name="account_radio" value="1">비밀번호 변경
        </div>
        <div style="display:table-cell; text-align: center" class="radio">
            <input type="radio" name="account_radio" value="2">회원 탈퇴
        </div>
    </div>
</div>
<div id="changed-password-dialog-form" title="My Account - change password" style="display:none;">
    <p id="user_name"></p>
    <div class="form-group">
        <label for="current_pw">Password</label>
        <input id="current_pw" type="password" class="form-control" placeholder="Insert current password">
    </div>
    <div class="form-group">
        <label for="new_pw">New Password</label>
        <input id="new_pw" type="password" class="form-control"
               placeholder="Insert new password">
    </div>
    <div class="form-group">
        <input id="new_pw_chk" type="password" class="form-control"
               placeholder="Insert new password">
    </div>
</div>
<div id="exit-service-dialog-form" title="My Account - withdrawal" style="display:none;">
    <p id="user_name_1"></p>
    <div class="form-group">
        <label for="current_pw_1">Password</label>
        <input id="current_pw_1" type="password" class="form-control" placeholder="Insert current password">
    </div>
</div>
</body>
</html>