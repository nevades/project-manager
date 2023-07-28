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
        <link rel="icon" href="files/images/favicon.ico" type="images/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="files/css/kanban.css">

    </head>
    <style>
        body {
            overflow: hidden;
        }

        .custom-tag-container {
            display: inline-block;
            background-color: purple;
            padding: 4px 12px;
            border-radius: 16px;
            color: white;
            font-weight: bold;
            font-size: 14px;
            line-height: 1;
            cursor: pointer;
        }
    </style>


    <body style="background-image: url('files/images/body_background2.jpg');height: 740px;background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <%@include file="jspf/navbar.jspf" %>
        <div>
            <div class="col-12">
                <div class="operations"><button type="button" class="create-new btn btn-secondary btn-rounded"><i class="fa-solid fa-plus"></i> Add Task</button>
                    <i class="trash fa-solid fa-trash fa-lg"></i>
                </div>
            </div>
            <div class="horizontal-scroll-wrapper squares">
                <div class="custom-tag-container">
                    PvP
                </div>
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
        </div>
        <%--<%@include file="jspf/scripts.jspf" %>--%>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
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
                    Swal.fire({
                        title: "Add new task?",
                        input: "text",
                        inputAttributes: {
                            autocapitalize: "off"
                        },
                        showCancelButton: true,
                        confirmButtonText: "Add",
                        showLoaderOnConfirm: true,
                        preConfirm: (toDo) => {
                            return new Promise((resolve) => {
                                if (toDo) {
                                    resolve(toDo);
                                } else {
                                    Swal.showValidationMessage("Please enter something");
                                }
                            });
                        },
                        allowOutsideClick: () => !Swal.isLoading(),
                    }).then((result) => {
                        if (result.isConfirmed) {
                            var toDo = result.value;
                            var thisNote;
                            if (toDo) {
                                thisNote = $("<div id=\"card-" + (note.length + 1) + "\" class=\"post-it\" draggable=\"true\"><p title=\"Click to edit\" contenteditable=\"true\">" + toDo + "</p></div>");
                                note.push(thisNote);
                                var pvpButton = $("<button class=\"custom-tag-container\">PvP</button>");
                                thisNote.append(pvpButton);

                                note.push(thisNote);
                                thisNote.on("dragstart", noteDragStart);
                                thisNote.on("dragend", noteDragEnd);
                                thisNote.on("keyup", noteChange);

                                boxs.first().prepend(thisNote);
                                saveApplication();
                            }
                        }
                    });
                });
//                newNote.click(function () {
//                    var toDo = prompt("What you have to do?"),
//                            thisNote;
//                    if (toDo) {
//                        thisNote = $("<div id=\"card-" + (note.length + 1) + "\" class=\"post-it\" draggable=\"true\"><p title=\"Click to edit\" contenteditable=\"true\">" + toDo + "</p></div>");
//                        note.push(thisNote);
//
//                        thisNote.on("dragstart", noteDragStart);
//                        thisNote.on("dragend", noteDragEnd);
//                        thisNote.on("keyup", noteChange);
//
//                        boxs.first().prepend(thisNote);
//                        saveApplication();
//                    }
//                });

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
