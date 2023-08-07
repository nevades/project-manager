<%--
    Document   : setup
    Created on : Jul 20, 2023, 3:51:59 PM
    Author     : Neva
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Management</title>
        <link rel="icon" href="files/images/favicon.ico" type="images/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    </head>
    <style>
        .board-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        body {
            overflow: hidden;
        }
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body style="background-image: url('files/images/16678.jpg');height: 740px; background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <!--        <div style="margin-top: 10px;" class="row">
                    <div class="col-2">
                        <div class="card" style="background-color: #ffffffba;height: 45rem; margin-left: 10px;">
                            <div class="card-body">
                                <h5 class="card-title">Project Management</h5>
                                <div class="border-top mb-3"  style="background-color: #999; height: 1.5px;"></div>
                                <form class="row">
                                    <div class="col" id="projects">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
        
                    <div class="col-9">
                        <div class="card" style="background-color: #ffffffba;height: 45rem;">
                            <div class="card-body">
                                <h5 class="card-title">Edit Project</h5>
                                <div class="border-top mb-3"></div>
                                <div id="labelContainer">
                                </div>
                            </div>
                            <div class="card-footer">
                                <p class="card-text">You can add new project boards with their own custom colors</p>
                                <a id="save" class="btn btn-success">Confirm Action</a>
                            </div>
                        </div>
                    </div>
                </div>-->
        <div class="row" style="margin-top: 20px;">
            <div class="col-3">
                <div class="card" style="background-color: #ffffffba; height: 50rem; margin-left: 20px;">
                    <div class="card-body">
                        <h5 class="card-title">Project Management</h5>
                        <div class="border-top mb-3"></div>
                        <form class="row">
                            <div class="col" id="projects">
                            </div>
                        </form>
                    </div>
                    <div class="card-footer">
                        <p class="card-text">Select a project with the edit icon</p>
                        <p class="card-text">Select a project with the edit icon</p>
                        <p class="card-text"></p>
                    </div>
                </div>
            </div>

            <div class="col-9">
                <div class="card" style="background-color: #ffffffba; height: 50rem; margin-right: 20px;">
                    <div class="card-body">
                        <h5 class="card-title">Edit Project</h5>
                        <div class="border-top mb-3"></div>
                        <div id="labelContainer">
                            <div class="form-group">
                                <label for="exampleInputEmail">Project Name</label>
                                <input type="email" class="form-control" id="exampleInputEmail">
                            </div>


                        </div>
                    </div>
                    <div class="card-footer">
                        <p class="card-text">You can add new project boards with their own custom colors</p>
                        <a id="save" class="btn btn-success">Confirm Action</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <script>
            const requestOptions = {
                method: 'POST',
                body: JSON.stringify({
                    projectId: 2
                })
            };

            fetch('project/load-board', {
                method: 'POST',
                body: new URLSearchParams({
                    projectId: 1
                })
            }).then((resp) => resp.json()).then((data) => {
                console.log(data);
                for (var i = 0; i < data.length; i++) {
                    const bname = data[i].boardName;
                    const bcolor = data[i].boardColor;

                    var temp = '<div class="board-item">'
                            + '<p>' + bname + '</p>'
                            + '<input type="color" class="form-control" id="colorInput" style="height: 50px; width: 200px;">'
                            + '<br>'
                            + '</div>';

                    $('#labelContainer').append(temp);
                }
            });



        </script>
    </body>
</html>