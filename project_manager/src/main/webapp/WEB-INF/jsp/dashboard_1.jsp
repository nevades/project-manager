<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Project Manager</title>
        <link rel="icon" href="files/images/fav.ico" type="image/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.css">
        <%--<%@include file="jspf/header.jspf" %>--%>
        <link rel="stylesheet" type="text/css" href="files/css/slimselect.css">
        <link rel="stylesheet" href="files/css/kanban.css">
    </head>
    <style>

        #boxes {
            display: flex !important;
            overflow-x: auto !important; /* Enable horizontal scrolling */
            white-space: nowrap !important; /* Prevent boards from wrapping to the next line */
            padding-bottom: 20px !important; /* Add some padding to the bottom to ensure scrollbars are visible */
        }

        .divs {
            /*width: 300px !important;  Set a fixed width for each board container */
            /*margin-right: 10px !important;  Add some spacing between board containers */
            overflow: auto !important; /* Enable vertical scrolling within each board container if needed */
        }

        .placeholder {
            cursor: auto !important;
            background-color: white !important;
        }

        .navbar-laravel
        {
            box-shadow: 0 2px 4px rgba(0,0,0,.04);
        }

        .navbar-brand , .nav-link, .my-form, .login-form
        {
            font-family: Raleway, sans-serif;
        }

        .my-form
        {
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }

        .my-form .row
        {
            margin-left: 0;
            margin-right: 0;
        }

        .login-form
        {
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }

        .login-form .row
        {
            margin-left: 0;
            margin-right: 0;
        }

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
            <div class="operations" style="margin-left: 10px; margin-top: 10px; width: auto; display: none;">
                <button type="button" onclick="clearCenter()" class="btn btn-primary"><span><i class="fa fa-arrow-left fa-1x"></i></span> Select Project</button>
                <!--                <button type="button" class="create-new btn btn-secondary btn-rounded">
                                    <i class="fa-solid fa-plus"></i> Add Task
                                </button>-->
                <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    <i class="fa-solid fa-location-arrow"></i> Add Task
                </button>
                <i class="trash fa-solid fa-trash fa-lg"></i>
            </div>

            <div class="centered-div" id="center">
            </div>

            <div id="boxes" style="display: none;">
            </div>

            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel"><i class="fa-solid fa-location-arrow"></i> Add Task</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class=" row form-group row-up">
                                <div class="col-topic-start"></div>
                                <label class=" col-form-label new-label-box" style="width: 20%" id="lbl_type">Category<span class="text-danger">*</span></label>
                                <div class="col-15" style="width: 75%">
                                    <div>
                                        <select id="select_task" style="margin-top:-5px">

                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row form-group row-up">
                                <div class="col-topic-start"></div>
                                <label class="col-form-label new-label-box" style="width: 20%;">Priority</label>
                                <div class="col-15 " style="width: 75%">
                                    <div>
                                        <select id="select_priority" style="margin-top:-5px; margin-left: -12px;" class="swal2-select">
                                            <option value="Low">Priority: Low</option>
                                            <option value="Medium">Priority: Medium</option>
                                            <option value="High">Priority: High</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <br>

                            <div class="row form-group row-up" style="margin-top: -40px;">
                                <div class="col-topic-start"></div>
                                <label class="col-form-label new-label-box" style="width: 20%">Subject<span class="text-danger">*</span></label>
                                <div class="col-15 " style="width: 75%">
                                    <input type="text" onkeyup="this.value = this.value.toUpperCase();" max="100" class="form-control form-control-xs" autocomplete="off" id="subject_input">
                                </div>
                            </div>

                            <div class="row form-group">
                                <div class="col-topic-start"></div>
                                <label class="col-form-label new-label-box" style="width: 20%">Description<span class="text-danger">*</span></label>
                                <div class="col-15 " style="width: 75%">
                                    <textarea class="form-control" rows="7" name="description" id="description"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div id="fileList"></div>
                                <div class="col-topic-start"></div>
                                <label class=" col-form-label new-label-box" style="width: 20%">Attachments</label>
                                <div class="col-8">
                                    <div class="col-sm-12 col-form-label input-images" id="upload_document_div">
                                        <div class="jquery-image-uploader"><input type="file" id="image_upload" name="images" multiple="multiple"><div class="uploaded"></div><div class="upload-text"><i class="material-icons"></i><span>(6 Files only)</span></div></div></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" id="add" class="btn btn-primary">Save changes</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <%@include file="jspf/scripts.jspf" %>
        <script type="text/javascript" src="files/js/slimselect.js"></script>
        <script type="text/javascript" src="files/js/datatables.min.js"></script>
        <script type="text/javascript" src="files/js/sweetalert2.js"></script>
        <script type="text/javascript" src="files/js/func.js"></script>
        <script type="text/javascript" src="files/js/autoNumeric.js"></script>
        <script type="text/javascript" src="files/js/dataTables.responsive.min.js"></script>
        <script>
        </script>
        <script>
            var select_priority = new SlimSelect({
                select: '#select_priority'
            });

            var select_task = new SlimSelect({
                select: '#select_task',
                placeholder: "Category Type List",
                ajax: function (search, callback) {
                    fetch('project/search-type', {
                        method: 'POST',
                        body: new URLSearchParams({search: search || ''})
                    }).then(res => res.json()).then((data) => {
                        callback(data);
                    });
                },
                allowDeselect: false
            });
            $('#select_task').data('select', select_task);

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
                        const id = data[i].boardId;

                        const colDiv = $('<div style="margin-top: 10px;" class="divs col-4"></div>');
                        const h3Element = $('<div class="card" style="height: 35px; width: auto;"><h3>' + name + '</h3></div>');
                        const boxDiv = $('<div  class="box card' + id + '" style="background-color: ' + color + '; border:7px dotted ' + color + ';"></div>');
                        colDiv.append(h3Element);
                        colDiv.append(boxDiv);
                        colDiv.addClass("divs");
                        $('#boxes').append(colDiv);
                    }

                    fetch('project/load-tasks').then((res) => res.json()).then((data) => {
                        console.log(data);

                        for (var i = 0; i < data.length; i++) {
                            const sub = data[i].subject;
                            const desc = data[i].description;
                            const pri = data[i].priority;
                            const pid = data[i].project_id;
                            const bid = data[i].board_id;

                            let color = "";

                            if (pri === "Low") {
                                color = "success";
                            } else if (pri === "Medium") {
                                color = "warning";
                            } else if (pri === "High") {
                                color = "danger";
                            }

                            var task = '<div id="card-1" class="post-it" draggable="true">'
                                    + '<p class="editable" style="font-size: 17px; margin-top: -25px; margin-left: 5px; font-weight: bold;" title="Click to edit" contenteditable="false">' + sub + '</p>'
                                    + '<p contenteditable="true" style="font-size: 14px; margin-top: -5px; margin-left: 5px;">' + desc + '</p>'
                                    + '<div style="margin-top: 0px" class="card-footer">'
                                    + '<button type="button" style="margin-left: -150px" class="btn btn-' + color + '"></button>'
                                    + '</div>'
                                    + '</div>';

                            $('.card' + bid + '').append(task);
                        }
                    });

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
                            $("#exampleModal").modal("show");
                        });

                        $("#add").click(function () {
                            const subject = $("#subject_input").val();
                            const description = $("#description").val();
                            const selectedOption = $("#select_priority").val();

                            if (subject && description) {
                                var thisNote = $("<div id=\"card-" + (note.length + 1) + "\" class=\"post-it\" draggable=\"true\"><p class=\"editable\" style=\"font-size: 17px; margin-top: -25px; margin-left: 5px; font-weight: bold;\" title=\"Click to edit\" contenteditable=\"false\">" + subject + "</p><p contenteditable=\"true\" style=\"font-size: 14px; margin-top: -5px; margin-left: 5px;\">" + description + "</p><div style=\"margin-top: 0px\" class=\"card-footer\"></div></div>");
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
//                                thisNote.find(".card-footer").append($("<br><button type=\"button\" style=\"margin-left: 5px; margin-top: -20px;\" class=\"btn btn-info\">" + type + "</button>"));
                                thisNote.on("dragstart", noteDragStart);
                                thisNote.on("dragend", noteDragEnd);
                                thisNote.on("keyup", noteChange);
                                boxs.first().prepend(thisNote);
                                saveApplication();

                                $("#exampleModal").modal("hide");
                            }

                            return fetch('project/save-task', {
                                method: 'POST',
                                body: new URLSearchParams({
                                    subject: subject,
                                    selectedOption: selectedOption,
                                    description: description,
                                    projectId: projectid
                                })
                            }).then(response => {
                                if (!response.ok) {
                                    throw new Error(response.statusText);
                                } else {
                                    Swal.fire('Successfull!', 'Task has been successfully submitted');
                                }
                                return response.json();
                            }).catch(error => {
                                Swal.fire("Empty Description!", "Please Enter a Valid Subject!", "warning");
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