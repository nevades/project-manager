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
        <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    </head>
    <style>
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body style="background-image: url('files/images/body_background2.jpg');background-size: cover; background-repeat: no-repeat; background-position: center center;">

        <!--<div class="container text-left">-->
        <div style="margin-top: 10px;">
            <div class="card" style="width: auto; height: 10rem; margin-left: 30px; margin-right: 30px; margin-top: 0px; background-color: #ffffffba;">
                <div class="card-body">
                    <h5 class="card-title">Project Setup</h5>
                    <div class="border-top mb-3"></div>
                    <form class="row">
                        <div class="form-group col">
                            <label for="exampleInputEmail1">Project Name</label>
                            <input type="text" class="form-control" id="projectName" style="width: 895.5px;" aria-describedby="emailHelp" placeholder="">
                        </div>
                        <div class="form-group col" style="margin-left: 50px;">
                            <label class="row" for="exampleInputEmail1">Project Icon</label>
                            <input class="row" type="file" id="myFile" name="filename">
                        </div>
                    </form>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="card" style="background-color: #ffffffba; width: auto; height: 30rem; margin-left: 30px; margin-top: 10px;">
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
                                    <div class="col-sm-2">
                                        <input type="color" class="form-control" id="colorInput" style="height: 50px;">
                                    </div>
                                </div>
                                <br>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                                    <label class="form-check-label" for="flexCheckDefault">
                                        Set a default project board color
                                    </label>
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
                    <div class="card" style="background-color: #ffffffba; width: auto; height: 30rem;margin-right: 30px; margin-top: 10px;">
                        <div class="card-body">
                            <h5 class="card-title">Custom created project board list</h5>
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
            </div>
        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">

        <script>

            $(document).on('click', '#save', function () {

                const projectName = document.getElementById('projectName').value;
                const colorCode = document.getElementById('colorInput').value;
                const labelText = document.getElementById('labelText').value;
                if (projectName === '') {
                    Swal.fire(
                            '',
                            'Project name is empty!',
                            'error'
                            );
                    return;
                }

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Project Will be Saved!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        const savePromises = boardsArray.map(([labelText, colorCode]) => {
                            return fetch('project/save-project', {
                                method: 'POST',
                                body: new URLSearchParams({
                                    projectName: projectName,
                                    boardName: labelText,
                                    boardColor: colorCode
                                })
                            }).then(response => {
                                if (!response.ok) {
                                    throw new Error(response.statusText);
                                }
                                return response.json();
                            }).catch(error => {
                                Swal.showValidationMessage('Request failed:' + error);
                            });
                        });
                        return Promise.all(savePromises);
                        ;
                    },
                    allowOutsideClick: () => !Swal.isLoading()
                }).then((result) => {
                    if (result.value) {
                        if (result.value.status !== 200) {
                            Swal.fire('Error!', result.value.msg, 'error');
                        } else {
                            Swal.fire('Successfull!', 'Project has been Assigned !', 'success');
                        }
                    }
                });
            });

            let labelCount = 1;
            const boardsArray = [];
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
                icon.id = 'delrec';
                customColorLabel.style.color = colorCode;
                customColorLabel.textContent = '• ' + labelText + ' ';
                document.getElementById('labelContainer').appendChild(customColorLabel);
                document.getElementById('labelContainer').appendChild(icon);
                document.getElementById('labelContainer').appendChild(br);
                boardsArray.push([labelText, colorCode]);

                labelCount++;
            });

        </script>
    </body>
</html>
