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
        .pill {
            font-size: 14px;
            padding: 0.5em 1em;
            margin: 0.25em;
            border-radius: 1em;
            border: none;
            outline: none;
            background: #CADDDC;
            width: auto;
        }

        .card-scrollx {
            display: flex;
            overflow-x: auto;
            scroll-behavior: smooth;
        }

        .centered-div {
            display: flex;
            justify-content: center;
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

        .container {
            width: 100%;
            overflow-x: hidden;
        }

        .card-scroll {
            display: flex;
            overflow-x: auto;
            scroll-behavior: smooth;
            padding: 10px;
        }

        .cards {
            width: 240px;
            height: auto;
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin: 10px;
            position: relative;
        }

        .card {
            margin: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            flex: 0 0 auto;
            width: 240px;
            height: auto;
            margin-right: 10px;
            background-color: #f9f9f9;
            border-radius: 5px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 20px;
            padding: 10px;
            position: relative;
        }

        body {
            margin: 0;
            padding: 0;
            background: rgb(41,37,108);
            background: linear-gradient(90deg, rgba(41,37,108,1) 0%, rgba(73,73,110,1) 35%, rgba(42,110,124,1) 100%);
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
        }
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body>
        <div id="landing">
        </div>

        <div id="dashboard">
            <div class="operations" style="margin-top: 10px; width: auto; display: none;">
                <button type="button" onclick="clearCenter()" class="btn btn-primary"><span><i class="fa fa-arrow-left fa-1x"></i></span> Select Project</button>
                <button type="button" class="create-new btn btn-secondary btn-rounded">
                    <i class="fa-solid fa-plus"></i> Add Task
                </button>
                <i class="trash fa-solid fa-trash fa-lg"></i>
            </div>
            <div class="centered-div" id="center">
            </div>
            <div id="boxes" style="display: none;">

            </div>
        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <script src="https://unpkg.com/slim-select@latest/dist/slimselect.min.js"></script>
        <script>
        </script>
        <script>
            $("#center").empty();
            fetch('project/load-project').then((res) => res.json()).then((data) => {
                console.log(data);
                for (var i = 0; i < data.length; i++) {
                    const pid = data[i].projectId;
                    const pname = data[i].projectName;
                    const pdate = new Date(data[i].date).toISOString().split('T')[0];
                    const ptime = new Date(data[i].date).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit', second: '2-digit'});

                    var temp = ' <div class="cards" style="width: 18rem;">'
                            + '<div class="card-body" style="background: #DADADA; padding: 7px;">'
                            + '<h5 class="card-title" style="font-weight: bold; text-decoration: underline;">' + pname + '</h5>'
                            + '<div class="card" style="background-color: #8d85ff; padding: 0; font-size: 14px;">'
                            + '<p class="card-text">Date Created : ' + pdate + '</p>'
                            + '</div>'
                            + '<div class="card" style="background-color: #8d85ff; padding: 0; font-size: 14px;">'
                            + '<p class="card-text">Time Created : ' + ptime + '</p>'
                            + '</div>'
                            + '<button class="btn btn-secondary btn-sm select" id="projectButton" type="button" data-projectid="' + pid + '">Go to project</button>'
                            + '</div></div>';

                    $('#center').append(temp);
                }
            });

            function clearCenter() {
                $(".operations").hide();
                $(".divs").empty();
                document.getElementById("center").style.display = "flex";
            }

            $(document).on('click', '.select', function () {
                $(".operations").show();
                $('#boxes').empty();
                boxes.style.display = "block";
                document.getElementById("center").style.display = "none";
                var projectid = $(this).data('projectid');
                return fetch('project/load-board', {
                    method: 'POST',
                    body: new URLSearchParams({
                        projectId: projectid
                    })
                }).then((resp) => resp.json()).then((data) => {
                    for (var i = 0; i < data.length; i++) {

                        const name = data[i].boardName;
                        const color = data[i].boardColor;
                        const colDiv = $('<div style="margin-top: 10px;" class="divs col-4"></div>');
                        const h3Element = $('<div class="card" style="height: 35px; width: auto;"><h3>' + name + '</h3></div>');
//                        const h3Element = $('<button type="button" class="btn btn-secondary" style="--bs-btn-padding-y: .25rem; border-radius: 1em; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">' + name + '</button>');
                        const boxDiv = $('<div class="box" style="background-color: ' + color + '; border:7px dotted ' + color + ';"></div>');
                        colDiv.append(h3Element);
                        colDiv.append(boxDiv);
                        $('#boxes').append(colDiv);
                    }

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
                                        '<select id="ctype">' +
                                        '</select>' +
                                        '<select id="selectInput" class="swal2-select">' +
                                        '   <option value="Low">Priority: Low</option>' +
                                        '   <option value="Medium">Priority: Medium</option>' +
                                        '   <option value="High">Priority: High</option>' +
                                        '</select>',
                                showCancelButton: true,
                                confirmButtonText: "Add",
                                showLoaderOnConfirm: true,
                                preConfirm: () => {

                                    var ctype = new SlimSelect({
                                        select: '#ctype',
                                        placeholder: "Category Type List",
                                        ajax: function (search, callback) {
                                            fetch('project/get-type', {
                                                method: 'POST',
                                                body: new URLSearchParams({search: search || ''})
                                            }).then(res => res.json()).then((data) => {
                                                callback(data);
                                            });
                                        },
                                        allowDeselect: false
                                    });
                                    $('#ctype').data('select', ctype);

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
                                allowOutsideClick: () => !Swal.isLoading()
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
                });
            });
        </script>
    </body>
</html>