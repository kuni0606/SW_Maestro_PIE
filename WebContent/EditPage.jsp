<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Piece in everything - Edit</title>
<link rel="shortcut icon" type="image/png" href="image/logo.png"/>
    <!--jQuery-->
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
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

    <style>
        html, body {
            width: 100%;
            height: 100%;
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
            cursor: move;
        }

        .close_img {
            width: 30px;
            height: 30px;
            margin-top: -2px;
            cursor:pointer;
            opacity:0.75;
        }
        .opcity_img:hover{
        cursor:pointer;
        opacity:0.75;
        }
    </style>
    
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
            	
					$.get("http://210.118.74.117:8100/PIE/log_out_unload",{
                    	
                    },function(data){
                    	
                    });
            };
        }); */
    </script>
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
    
        var max_web = 0;
        var max_note = 0;
        onload = function on_load() {
            $.get("http://210.118.74.117:8100/PIE/get_back_ground", function (data) {
                if (data.msg == 'Success') {
                    var b_body_c = document.getElementById('body');
                    b_body_c.style.background = "url(" + data.back_ground_path + ")";
                    b_body_c.style.backgroundRepeat = "no-repeat";
                    b_body_c.style.backgroundSize = "cover";
                }
            });
            //get
            $.get("http://210.118.74.117:8100/PIE/get_widget_list", function (data) {
                var tempData = data.widgetList;
                widgetData = {};

                for (var i = 0; i < tempData.length; i++) {
                    if (tempData[i].widgetType == 3) {
                        if (max_web < tempData[i].widgetId.substring(3, tempData[i].widgetId.length)) {
                            max_web = tempData[i].widgetId.substring(3, tempData[i].widgetId.length);
                        }
                    } else if (tempData[i].widgetType == 6) {
                        if (max_note < tempData[i].widgetId.substring(4, tempData[i].widgetId.length)) {
                            max_note = tempData[i].widgetId.substring(4, tempData[i].widgetId.length);
                        }
                    }
                }
                web_num = max_web;
                note_num = max_note;

                for (var i = 0; i < tempData.length; i++) {
                    switch (tempData[i].widgetType) {
                        case 1:
                            news_chk = 1;
                            break;
                        case 2:
                            mail_chk = 1;
                            break;
                        case 4:
                            calendar_chk = 1;
                            break;
                        case 5:
                            gallery_chk = 1;
                            break;
                        case 7:
                            weather_chk = 1;
                            break;
                        case 8:
                            quick_chk = 1;
                            break;
                    }
                    get_Widget(tempData[i].widgetId, tempData[i].widgetType);
                    widgetData[tempData[i].widgetId] = {
                        "w_Code": tempData[i].w_Code,
                        "widgetType": tempData[i].widgetType,
                        "xPos": (tempData[i].xPos),
                        "yPos": (tempData[i].yPos),
                        "xSize": (tempData[i].xSize),
                        "ySize": (tempData[i].ySize)
                    }
                    div_c.style.left = ((widgetData[div_c.id].xPos * $(window).width()) / 100) + 'px';
                    div_c.style.top = ((widgetData[div_c.id].yPos * $(window).height()) / 100) + 'px';
                    div_c.style.width = ((widgetData[div_c.id].xSize * $(window).width()) / 100) + 'px';
                    div_c.style.height = ((widgetData[div_c.id].ySize * $(window).height()) / 100) + 'px';
                }
            });
        }
    </script>
    <script>
        var widgetData = new Object();

        var web_num = 0;
        var note_num = 0;
        var div_c;
        var div_1;
        var div_2;
        var div_3;
        var table;
        var tbody;
        var tr;
        var td;
        var img;

        var news_chk = 0;
        var mail_chk = 0;
        var calendar_chk = 0;
        var gallery_chk = 0;
        var weather_chk = 0;
        var quick_chk = 0;

        var w_type = -1;
        var clicked_el;

        var window_width = ($(window).width()) / 2 - 100;
        var window_height = ($(window).height()) / 2 - 200;

        function complete_Save() {
            var sendData = {};

            for (var key in widgetData) {
                sendData[key] = [];
                sendData[key].push(widgetData[key]);
            }
            $.post("http://210.118.74.117:8100/PIE/update_widget", {
                widget_list: JSON.stringify(sendData)
            }, function (result) {
            	//alert(result.msg);
            	
            	if( result.msg == "Success"){
            		location.href = "http://210.118.74.117:8100/PIE/main_page";	
            	}
            	
            });
        }

        function create_Widget(w_name, widgetType) {
            w_type = widgetType;

            switch (w_type) {
                case 1:
                    if (news_chk == 0) {
                        widget_form(w_name, w_type);
                        news_chk = 1;
                    } else if (news_chk == 1) {
                        alert("News 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
                case 2:
                    if (mail_chk == 0) {
                        widget_form(w_name, w_type);
                        mail_chk = 1;
                    } else if (mail_chk == 1) {
                        alert("E-mail 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
                case 3:
                    widget_form(w_name, w_type);
                    break;
                case 4:
                    if (calendar_chk == 0) {
                        widget_form(w_name, w_type);
                        calendar_chk = 1;
                    } else if (calendar_chk == 1) {
                        alert("Calendar 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
                case 5:
                    if (gallery_chk == 0) {
                        widget_form(w_name, w_type);
                        gallery_chk = 1;
                    } else if (gallery_chk == 1) {
                        alert("Gallery 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
                case 6:
                    widget_form(w_name, w_type);
                    break;
                case 7:
                    if (weather_chk == 0) {
                        widget_form(w_name, w_type);
                        weather_chk = 1;
                    } else if (weather_chk == 1) {
                        alert("Weather 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
                case 8:
                    if (quick_chk == 0) {
                        widget_form(w_name, w_type);
                        quick_chk = 1;
                    } else if (quick_chk == 1) {
                        alert("Quick URL 위젯은 하나만 생성할 수 있습니다.");
                    }
                    break;
            }
        }
        function widget_form(w_name, w_type) {
            div_c = document.createElement('div');
            switch (w_name) {
                case 'Web':
                    web_num++;
                    div_c.id = w_name + web_num;
                    break;
                case 'Note':
                    note_num++;
                    div_c.id = w_name + note_num;
                    break;
                default:
                    div_c.id = w_name;
            }
            div_c.className = "div_Container";
            div_c.style.left = window_width + 'px';
            div_c.style.top = window_height + 'px';
            switch (w_type) {
                case 1:
                    div_c.style.width = "220px";
                    div_c.style.height = "220px";
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 2:
                    div_c.style.width = "400px";
                    div_c.style.height = "136px";
                    div_c.style.minWidth = "400px";
                    div_c.style.minHeight = "136px";
                    break;
                case 3:
                    div_c.style.width = "320px";
                    div_c.style.height = "320px";
                    div_c.style.minWidth = "320px";
                    div_c.style.minHeight = "320px";
                    break;
                case 4:
                    div_c.style.width = "250px";
                    div_c.style.height = "250px";
                    div_c.style.minWidth = "200px";
                    div_c.style.minHeight = "250px";
                    break;
                case 5:
                    div_c.style.width = "220px";
                    div_c.style.height = "220px";
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 6:
                    div_c.style.width = "220px";
                    div_c.style.height = "220px";
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 7:
                    div_c.style.width = "250px";
                    div_c.style.height = "250px";
                    div_c.style.minWidth = "250px";
                    div_c.style.minHeight = "250px";
                    break;
                case 8:
                    div_c.style.width = "200px";
                    div_c.style.height = "200px";
                    div_c.style.minWidth = "130px";
                    div_c.style.minHeight = "130px";
                    break;
            }
            table = document.createElement('table');
            table.style.width = "100%";
            table.style.height = "100%";
            tbody = document.createElement('tbody');
            tr = document.createElement('tr');
            tr.style.width = "100%";
            td = document.createElement('td');
            td.style.width = "100%";
            div_1 = document.createElement('div');
            div_2 = document.createElement('div');
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
            div_3.className = "widget_deleteBtn";
            img = document.createElement('img');
            img.id = div_c.id + 'img';
            img.src = "image/close_widget.png";
            img.className = "close_img";

            div_3.appendChild(img);
            div_1.appendChild(div_3);
            td.appendChild(div_1);
            tr.appendChild(td);
            tbody.appendChild(tr);

            tr = document.createElement('tr');
            tr.style.width = "100%";
            tr.style.height = "100%";
            td = document.createElement('td');
            td.style.width = "100%";
            td.style.height = "100%";
            tr.appendChild(td);
            tbody.appendChild(tr);
            table.appendChild(tbody);
            div_c.appendChild(table);
            document.getElementById('body').appendChild(div_c);

            widgetData[div_c.id] = {
                w_Code: -1,
                widgetType: w_type,
                xPos: (100 * (div_c.style.left.substring(0, div_c.style.left.length - 2) / $(window).width())),
                yPos: (100 * (div_c.style.top.substring(0, div_c.style.top.length - 2)) / $(window).height()),
                xSize: (100 * (200) / $(window).width()),
                ySize: (100 * (200) / $(window).height())
            };

            $(function () {
                $("#" + div_c.id).draggable({
                    stop: function (event, ui) {
                        var c_widget = $(this).attr('id');
                        var offset = $(this).offset();
                        var windowHeight = $(window).height();
                        var windowWidth = $(window).width();
                        widgetData[c_widget] = {
                            "w_Code": widgetData[div_c.id].w_Code,
                            "widgetType": w_type,
                            "xPos": (100 * (offset.left / windowWidth)),
                            "yPos": (100 * (offset.top / windowHeight)),
                            "xSize": (100 * (ui.helper.width() / windowWidth)),
                            "ySize": (100 * (ui.helper.height() / windowHeight))
                        };
                    }
                });
                $("#" + div_c.id).resizable({
                    stop: function (event, ui) {
                        var c_widget = $(this).attr('id');
                        var aaa = $(this).attr('id');
                        var width = ui.size.width;
                        var height = ui.size.height;
                        var offset = $(this).offset();
                        var windowHeight = $(window).height();
                        var windowWidth = $(window).width();
                        widgetData[c_widget] = {
                            "w_Code": widgetData[div_c.id].w_Code,
                            "widgetType": w_type,
                            "xPos": (100 * (offset.left / windowWidth)),
                            "yPos": (100 * (offset.top / windowHeight)),
                            "xSize": (100 * (ui.helper.width() / windowWidth)),
                            "ySize": (100 * (ui.helper.height() / windowHeight))
                        };
                    }
                });
                $("#" + img.id).click(function () {
                	switch (w_type) {
                    case 1:
                        news_chk = 0;
                        break;
                    case 2:
                        mail_chk = 0;
                        break;
                    case 4:
                        calendar_chk = 0;
                        break;
                    case 5:
                        gallery_chk = 0;
                        break;
                    case 7:
                        weather_chk = 0;
                        break;
                    case 8:
                        quick_chk = 0;
                        break;
                }
                    var delete_w = $(this).parent().parent().parent().parent().parent().parent().parent().attr('id');
                    var temp_widgetData = {};

                    for (var property in widgetData) {
                        if (widgetData.hasOwnProperty(property)) {
                            if (property !== delete_w) {
                                temp_widgetData[property] = widgetData[property];
                            }
                        }
                    }
                    widgetData = temp_widgetData;
                    document.getElementById('body').removeChild(document.getElementById(delete_w));
                });
            });
        }

        function get_Widget(w_name, widgetType) {
            div_c = document.createElement('div');
            div_c.id = w_name;
            div_c.className = "div_Container";
            switch (widgetType) {
                case 1:
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 2:
                    div_c.style.minWidth = "400px";
                    div_c.style.minHeight = "136px";
                    break;
                case 3:
                    div_c.style.minWidth = "320px";
                    div_c.style.minHeight = "320px";
                    break;a
                case 4:
                    div_c.style.minWidth = "200px";
                    div_c.style.minHeight = "250px";
                    break;
                case 5:
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 6:
                    div_c.style.minHeight = "220px";
                    div_c.style.minWidth = "220px";
                    break;
                case 7:
                    div_c.style.minWidth = "250px";
                    div_c.style.minHeight = "250px";
                    break;
                case 8:
                    div_c.style.minWidth = "130px";
                    div_c.style.minHeight = "130px";
                    break;
            }
            table = document.createElement('table');
            table.style.width = "100%";
            table.style.height = "100%";
            tbody = document.createElement('tbody');
            tr = document.createElement('tr');
            tr.style.width = "100%";
            td = document.createElement('td');
            td.style.width = "100%";
            div_1 = document.createElement('div');
            div_2 = document.createElement('div');
            div_2.className = "widget_headline";
            var w_icon = document.createElement('img');
            w_icon.style.width = "20px";
            w_icon.style.height = "20px";
            switch (widgetType) {
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
            div_3.className = "widget_deleteBtn";
            img = document.createElement('img');
            img.id = div_c.id + 'img';
            img.src = "image/close_widget.png";
            img.className = "close_img";

            div_3.appendChild(img);
            div_1.appendChild(div_3);
            td.appendChild(div_1);
            tr.appendChild(td);
            tbody.appendChild(tr);

            tr = document.createElement('tr');
            tr.style.width = "100%";
            tr.style.height = "100%";
            td = document.createElement('td');
            td.style.width = "100%";
            td.style.height = "100%";
            tr.appendChild(td);
            tbody.appendChild(tr);
            table.appendChild(tbody);
            div_c.appendChild(table);
            document.getElementById('body').appendChild(div_c);

            $(function () {
                $("#" + div_c.id).draggable({
                    stop: function (event, ui) {
                        var c_widget = $(this).attr('id');
                        var offset = $(this).offset();
                        var windowHeight = $(window).height();
                        var windowWidth = $(window).width();
                        widgetData[c_widget] = {
                            "w_Code": widgetData[c_widget].w_Code,
                            "widgetType": widgetData[c_widget].widgetType,
                            "xPos": (100 * (offset.left / windowWidth)),
                            "yPos": (100 * (offset.top / windowHeight)),
                            "xSize": (100 * (ui.helper.width() / windowWidth)),
                            "ySize": (100 * (ui.helper.height() / windowHeight))
                        };
                    }
                });
                $("#" + div_c.id).resizable({
                    stop: function (event, ui) {
                        var c_widget = $(this).attr('id');
                        var width = ui.size.width;
                        var height = ui.size.height;
                        var offset = $(this).offset();
                        var windowHeight = $(window).height();
                        var windowWidth = $(window).width();
                        widgetData[c_widget] = {
                            "w_Code": widgetData[c_widget].w_Code,
                            "widgetType": widgetData[div_c.id].widgetType,
                            "xPos": (100 * (offset.left / windowWidth)),
                            "yPos": (100 * (offset.top / windowHeight)),
                            "xSize": (100 * (ui.helper.width() / windowWidth)),
                            "ySize": (100 * (ui.helper.height() / windowHeight))
                        };
                    }
                });
                $("#" + img.id).click(function () {
                    switch (widgetType) {
                        case 1:
                            news_chk = 0;
                            break;
                        case 2:
                            mail_chk = 0;
                            break;
                        case 4:
                            calendar_chk = 0;
                            break;
                        case 5:
                            gallery_chk = 0;
                            break;
                        case 7:
                            weather_chk = 0;
                            break;
                        case 8:
                            quick_chk = 0;
                            break;
                    }
                    var delete_w = $(this).parent().parent().parent().parent().parent().parent().parent().attr('id');
                    var temp_widgetData = {};

                    for (var property in widgetData) {
                        if (widgetData.hasOwnProperty(property)) {
                            if (property !== delete_w) {
                                temp_widgetData[property] = widgetData[property];
                            }
                        }
                    }
                    widgetData = temp_widgetData;
                    document.getElementById('body').removeChild(document.getElementById(delete_w));
                });
            });
        }

    </script>
</head>
<body id="body" style="background-color: #EEEEEE">

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
                            <form action="" autocomplete="on" method="get">
                                <input id="search_bar" style="margin:auto;margin-top:-2px;width:100%;" type="text" class="form-control"
                                       placeholder="Search for Google...">
                            </form>
                        </div>
                    </div>
                </td>
                <td style="width:35%">
                    <img class="opcity_img" id="showRight" src="image/settings.png"
                         style="float:right; width:40px; height:40px; margin-top: 2px;margin-right: 7px;">
                    <img class="opcity_img" style="margin-top: 2px; margin-right: 2px; float:right; width:80px; height:40px;"
                         src="image/save_Btn.png" onclick="complete_Save()">
                </td>
            </tr>
            </tbody>
        </table>
    </nav>
</header>
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right" id="cbp-spmenu-s2">
    <h3>Widget<img class="opcity_img" id="closeRight" src="image/close_slide.png" style="float:right; width:25px; height:25px;">
    </h3>
    <a href="javascript:void(0)" onclick="create_Widget('News',1)"><img src="image/widget_Icon/news_w_icon.png"
                                                                        style="width:20px; height:20px; margin-right:12px;">News</a>
    <a href="javascript:void(0)" onclick="create_Widget('E-mail',2)"><img src="image/widget_Icon/mail_w_icon.png"
                                                                          style="width:20px; height:20px; margin-right:12px;">E-mail</a>
    <a href="javascript:void(0)" onclick="create_Widget('Web',3)"><img src="image/widget_Icon/web_w_icon.png"
                                                                       style="width:20px; height:20px; margin-right:12px;">Web
        page</a>
    <a href="javascript:void(0)" onclick="create_Widget('Schedule',4)"><img src="image/widget_Icon/calendar_w_icon.png"
                                                                            style="width:20px; height:20px; margin-right:12px;">Calendar</a>
    <a href="javascript:void(0)" onclick="create_Widget('Gallery',5)"><img src="image/widget_Icon/gallery_w_icon.png"
                                                                           style="width:20px; height:20px; margin-right:12px;">Gallery</a>
    <a href="javascript:void(0)" onclick="create_Widget('Note',6)"><img src="image/widget_Icon/note_w_icon.png"
                                                                        style="width:20px; height:20px; margin-right:12px;">Note
        - sticky</a>
    <a href="javascript:void(0)" onclick="create_Widget('Weather',7)"><img src="image/widget_Icon/weather_w_icon.png"
                                                                           style="width:20px; height:20px; margin-right:12px;">Weather</a>
    <a href="javascript:void(0)" onclick="create_Widget('QuickURL',8)"><img src="image/widget_Icon/quick_icon_w.png"
                                                                            style="width:20px; height:20px; margin-right:12px;">Quick
        URL</a>
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
</body>
</html>