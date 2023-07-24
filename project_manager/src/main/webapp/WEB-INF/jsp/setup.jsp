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
        <title>Setup</title>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <%@include file="jspf/navbar.jspf" %>
    <body style="background-image: url('files/images/body_background1.jpg');background-size: cover; background-repeat: no-repeat; background-position: center center;">

        <div class="container text-left">
            <div class="card" style="width: auto; height: 10rem; margin-left: 10px; margin-top: 10px;">
                <div class="card-body">
                    <h5 class="card-title">Project Setup</h5>
                    <div class="border-top mb-3"></div>
                    <form>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Project Name</label>
                            <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="">
                        </div>
                    </form>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="card" style="width: auto; height: 30rem; margin-left: 10px; margin-top: 10px;">
                        <div class="card-body">
                            <h5 class="card-title">Add new project board</h5>
                            <div class="border-top mb-3"></div>
                            <form>
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Project board name</label>
                                    <input type="text" class="form-control" id="labelText" aria-describedby="emailHelp" placeholder="">
                                </div>
                                <br>
                                <div class="form-group">
                                    <label for="colorInput">Choose a project board color:</label>
                                    <div class="col-sm-4">
                                        <input type="color" class="form-control" id="colorInput">
                                    </div>
                                </div>
                                <br>
                            </form>
                        </div>
                        <div class="card-footer">
                            <p class="card-text">You can add new project boards with their own custom colors</p>
                            <a href="#" id="createLabelButton" class="btn btn-primary">Add Project Board</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card" style="width: auto; height: 30rem; margin-left: 10px; margin-top: 10px;">
                        <div class="card-body">
                            <h5 class="card-title">Custom created project board list</h5>
                            <div class="border-top mb-3"></div>
                            <div id="labelContainer">
                            </div>
                        </div>
                        <div class="card-footer">
                            <p class="card-text">You can add new project boards with their own custom colors</p>
                            <a href="#" class="btn btn-success">Confirm Action</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>

            let labelCount = 1;

            document.getElementById('createLabelButton').addEventListener('click', function () {
                if (labelCount === 13) {
                    Swal.fire(
                            '',
                            'An project can have only 12 project boards!',
                            'error'
                            );
                    return;
                }
                const colorCode = document.getElementById('colorInput').value;
                const labelText = document.getElementById('labelText').value;
                if (labelText === '') {
                    Swal.fire(
                            '',
                            'Project board name is empty!',
                            'error'
                            );
                    return;
                }
                const br = document.createElement('br');
                const customColorLabel = document.createElement('span');
                const icon = document.createElement('i');
                icon.classList.add('fa-regular', 'fa-trash-can');
                icon.style.color = 'black';
                customColorLabel.style.color = colorCode;
                customColorLabel.textContent = '• ' + labelText + ' ';
                document.getElementById('labelContainer').appendChild(customColorLabel);
                document.getElementById('labelContainer').appendChild(icon);
                document.getElementById('labelContainer').appendChild(br);
                labelCount++;
            });

        </script>
    </body>
</html>
