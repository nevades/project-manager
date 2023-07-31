<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Project Manager</title>
        <link rel="icon" href="files/images/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="files/css/kanban.css">
        <link href="https://unpkg.com/slim-select@latest/dist/slimselect.css" rel="stylesheet">
    </head>
    <style>
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

        .card {
            width: 240px;
            height: auto;
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin: 10px;
            position: relative;
        }

        .subject {
            font-size: 17px;
            font-weight: bold;
            margin-top: 0;
            margin-bottom: 5px;
        }

        .description {
            font-size: 14px;
            margin-top: 0;
            color: #4c4c4c;
        }

        .post-it {
            background-color: #ffebc0;
            border: 1px solid #e6ac00;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    </style>
    <body style="background-image: url('files/images/body_background2.jpg');height: 740px;background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <%@include file="jspf/navbar.jspf" %>
        <div id="landing"></div>
        <div id="dashboard">
            <div class="col-12" style="margin-top: 10px;">
                <div class="operations" style="margin-left: 20px; width: auto;">
                    <button type="button" class="create-new btn btn-secondary btn-rounded">
                        <i class="fa-solid fa-plus"></i> Add Task
                    </button>
                    <i class="trash fa-solid fa-trash fa-lg"></i>
                </div>
            </div>
            <div class="horizontal-scroll-wrapper squares" id="boxes">
                <!--                <div class="col-4">
                                    <h3>Queued</h3>
                                    <div class="box"></div>
                                </div>
                                <div class="col-4">
                                    <h3>In Progress</h3>
                                    <div class="box"></div>
                                </div>
                                <div class="col-4">
                                    <h3>Approval Pending</h3>
                                    <div class="box"></div>
                                </div>
                                <div class="col-4">
                                    <h3>Rejected</h3>
                                    <div class="box"></div>
                                </div>
                                <div class="col-4">
                                    <h3>Done</h3>
                                    <div class="box"></div>
                                </div>-->
            </div>
        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <script src="https://unpkg.com/slim-select@latest/dist/slimselect.min.js"></script>
        <script>

            fetch('project/load-board').then((res) => res.json()).then((data) => {
                console.log(data);
            });
            const loadBoardDTO = {
                boardId: 26,
                boardName: "bjhhjbjh",
                boardColor: "#3892ff"
            };

            const colDiv = $('<div class="col-4"></div>');

            const h3Element = $(`<h3>${loadBoardDTO.boardName}</h3>`);

            const boxDiv = $('<div class="box"></div>');

            colDiv.append(h3Element);
            colDiv.append(boxDiv);

            $('#boxes').append(colDiv);

            $(function () {
                "use strict";
                var saveApplication = function () {
                    localStorage.setItem("app", $(".main-content").html());
                };
                var getApplication = function () {
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
                        title: "Add new task",
                        html:
                                '<input id="subject" maxlength="18" class="swal2-input" placeholder="Subject" autocapitalize="on">' +
                                '<input id="description" class="swal2-input" placeholder="Description" autocapitalize="off">' +
                                '<select id="selectInput" class="swal2-select">' +
                                '   <option value="Low">Priority: Low</option>' +
                                '   <option value="Medium">Priority: Medium</option>' +
                                '   <option value="High">Priority: High</option>' +
                                '</select>',
                        showCancelButton: true,
                        confirmButtonText: "Add",
                        showLoaderOnConfirm: true,
                        preConfirm: () => {
                            return new Promise((resolve) => {
                                const subject = document.getElementById('subject').value;
                                const description = document.getElementById('description').value;
                                const selectedOption = document.getElementById('selectInput').value;
                                if (subject && description) {
                                    resolve({subject, description, selectedOption});
                                } else {
                                    Swal.showValidationMessage("Please fill in all fields");
                                }
                            });
                        },
                        allowOutsideClick: () => !Swal.isLoading(),
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const {subject, description, selectedOption} = result.value;
                            var thisNote;

                            if (subject && description) {
                                thisNote = $("<div id=\"card-" + (note.length + 1) + "\" class=\"post-it\" draggable=\"true\"><p class=\"editable\" style=\"font-size: 17px; margin-top: -25px; margin-left: 5px; font-weight: bold;\" title=\"Click to edit\" contenteditable=\"false\">" + subject + "</p><p contenteditable=\"true\" style=\"font-size: 14px; margin-top: -5px; margin-left: 5px;\">" + description + "</p><div style=\"margin-top: 0px\" class=\"card-footer\"></div></div>");
                                note.push(thisNote);

                                switch (selectedOption) {
                                    case "Low":
                                        thisNote.find(".card-footer").append($("<button type=\"button\" style=\"margin-left: -150px\" class=\"btn btn-success\"></button>"));
                                        break;
                                    case "Medium":
                                        thisNote.find(".card-footer").append($("<button type=\"button\" style=\"margin-left: -150px\" class=\"btn btn-warning\"></button>"));
                                        break;
                                    case "High":
                                        thisNote.find(".card-footer").append($("<button type=\"button\" style=\"margin-left: -150px\" class=\"btn btn-danger\"></button>"));
                                        break;
                                }

                                thisNote.on("dragstart", noteDragStart);
                                thisNote.on("dragend", noteDragEnd);
                                thisNote.on("keyup", noteChange);

                                boxs.first().prepend(thisNote);
                                saveApplication();
                            }
                        }
                    });
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
        </script>
    </body>
</html>
