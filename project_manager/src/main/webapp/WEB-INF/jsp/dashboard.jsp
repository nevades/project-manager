<%--
    Document   : index
    Created on : Jul 7, 2023, 11:40:02 AM
    Author     : Nevanjith
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Project Manager</title>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <%--<%@include file="jspf/header.jspf" %>--%>
        <link rel="stylesheet" href="files/css/kanban.css">

    </head>
    <style>
        .nav-item {
            position: relative;
        }

        .navbar-collapse ul li a.nav-link:before {
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 100%;
            height: 2px;
            background: transparent;
            content: '';
            opacity: 0;
            -ms-transition: opacity 0.3s, -webkit-transform 0.3s;
            -webkit-transition: opacity 0.3s, -webkit-transform 0.3s;
            transition: opacity 0.3s, transform 0.3s;
            -ms-transform: translateY(10px);
            -webkit-transform: translateY(10px);
            transform: translateY(10px);
        }

        .navbar-collapse ul li:hover a.nav-link:before {
            opacity: 1;
            -ms-transform: translateY(0px);
            -webkit-transform: translateY(0px);
            transform: translateY(0px);
            bottom: 0px;
            background: #dd4343;
        }

        .dropdown-item:hover, .dropdown-item:focus {
            color: #ffffff;
            text-decoration: none;
            background-color: #dd4343;
        }

        .dropdown-menu {
            border: 0px;
        }

        body {
            background: #599fd9;
            background: -webkit-linear-gradient(to right, #599fd9, #c2e59c);
            background: linear-gradient(to right, #599fd9, #c2e59c);
            min-height: 100vh;
            overflow-x: hidden;
        }
    </style>

    <body>

        <%@include file="jspf/navbar.jspf" %>

        <div class="col-12">
            <div class="operations">
                <div class="create-new">
                    <button class="button-2" role="button">Button 2</button>
                </div>
                <div class="trash">
                    <i style="width: 20px;" class="fa-solid fa-trash"></i>
                </div>
            </div>
        </div>
        <div class="horizontal-scroll-wrapper squares">
            <div class="col-4">
                <h3>Queued</h3>
                <div class="box">
                </div>
            </div>
            <div class="col-4">
                <h3>In Progress</h3>
                <div class="box">
                </div>
            </div>

            <div class="col-4">
                <h3>Approval Pending</h3>
                <div class="box">
                </div>
            </div>

            <div class="col-4">
                <h3>Rejected</h3>
                <div class="box">
                </div>
            </div>

            <div class="col-4">
                <h3>Done</h3>
                <div class="box">
                </div>
            </div>
        </div>

        <%@include file="jspf/scripts.jspf" %>
        <!--<script type="text/javascript" src="files/js/slimselect.js"></script>-->
        <!--<script type="text/javascript" src="files/js/datatables.min.js"></script>-->
        <!--<script type="text/javascript" src="files/js/sweetalert2.js"></script>-->
        <!--<script type="text/javascript" src="files/js/func.js"></script>-->
        <!--<script type="text/javascript" src="files/js/autoNumeric.js"></script>-->
        <!--<script type="text/javascript" src="files/js/dataTables.responsive.min.js"></script>-->
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(function () {
                "use strict";

                var saveApplication = function () {
                    localStorage.setItem("app", $(".main-content").html());
                },
                        getApplication = function () {
                            return localStorage.getItem("app");
                        };

                (function () {
                    if (getApplication()) {
                        $(".main-content").html(getApplication());
                    }
                })();


                var boxs = $(".box"),
                        trash = $(".trash"),
                        note = $(".post-it"),
                        newNote = $(".create-new");

                note.on("dragstart", noteDragStart);
                note.on("dragend", noteDragEnd);

                boxs.on("dragover", function (e) {
                    $(this).addClass("drop-here");
                    e.preventDefault();
                });
                boxs.on("dragleave", function () {
                    $(this).removeClass("drop-here");
                });
                trash.on("dragover", function (e) {
                    e.preventDefault();
                    trash.addClass("active");
                });


                boxs.on("drop", function (e) {
                    var card = e.originalEvent.dataTransfer.getData("text/plain");
                    e.target.appendChild(document.getElementById(card));
                    e.preventDefault();
                });

                trash.on("drop", function (e) {
                    var card = e.originalEvent.dataTransfer.getData("text/plain");
                    if (confirm("Want to delete this note?")) {
                        $("#" + card).remove();
                        saveApplication();
                    }
                    e.preventDefault();
                });
                trash.click(function () {
                    if (confirm("Want to clear?")) {
                        localStorage.clear();
                        $(".post-it").remove();
                    }
                });
                newNote.click(function () {
                    var toDo = prompt("What you have to do?"),
                            thisNote;
                    if (toDo) {
                        // VERIFICAR SE JA EXISTE
                        thisNote = $("<div id=\"card-" + (note.length + 1) + "\" class=\"post-it\" draggable=\"true\"><p title=\"Click to edit\" contenteditable=\"true\">" + toDo + "</p></div>");
                        note.push(thisNote);

                        thisNote.on("dragstart", noteDragStart);
                        thisNote.on("dragend", noteDragEnd);
                        thisNote.on("keyup", noteChange);

                        boxs.first().prepend(thisNote);
                        saveApplication();
                    }
                });

                function noteDragStart(e) {
                    e.originalEvent.dataTransfer.setData("text/plain", e.target.getAttribute("id"));
                    trash.css({
                        opacity: 0.5
                    });
                }

                function noteDragEnd() {
                    boxs.removeClass("drop-here");
                    trash.css({
                        opacity: 0.2
                    });
                    trash.removeClass("active");
                    saveApplication();
                }
                function noteChange() {
                    saveApplication();
                }
                $(".post-it").on("keyup", function () {
                    saveApplication();
                });

            });

            $(document).ready(function () {
                $('#navbarDropdown').mouseenter(function () {
                    $('.dropdown-menu').slideToggle(300, "linear");
                });

                $('.dropdown-menu').mouseleave(function () {
                    $(this).slideToggle(300, "linear");
                });
            });
        </script>
    </body>
</html>
