<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Setup</title>
        <link rel="icon" href="files/images/favicon.ico" type="images/x-icon">
        <!--<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">-->
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <%@include file="jspf/header.jspf" %>
    </head>
    <style>
        body {
            /*overflow: hidden;*/
            /*text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.2);*/
        }

        .border-top.mb-3 {
            border-top: 1px solid #666666 !important;
            margin-bottom: 3px !important;
        }

        img{
            max-width:0px;
        }

        body {
            margin: 0;
            padding: 0;
            background: #466368;
            background: -webkit-linear-gradient(#648880, #293f50);
            background: -moz-linear-gradient(#648880, #293f50);
            background: linear-gradient(#648880, #293f50);
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
        }
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body>
        <div style="margin-top: 20px;">
            <div class="card" style="width: auto; height: 10rem; margin-left: 30px; margin-right: 30px; margin-top: 0px;">
                <div class="card-header">
                    <h5 class="card-title">Project Setup</h5>
                    <div class="border-top mb-3"></div>
                </div>
                <div class="card-body">
                    <form class="row">
                        <div class="form-group col">
                            <label for="exampleInputEmail1">Project Name</label>
                            <input type="text" class="form-control" id="projectName" style="width: 600px;" aria-describedby="emailHelp" placeholder="">
                        </div>
                        <div class="form-group col" style="margin-left: 50px;">
                            <label class="row" for="exampleInputEmail1">Project Icon</label>
                            <input class="row" onchange="readURL(this);" type="file" id="myFile" name="filename">
                        </div>
                        <div class="form-group col" style="margin-left: 50px;">
                            <img id="blah" src="http://placehold.it/180" alt="your image" />
                        </div>
                    </form>
                </div>
            </div>
            <div class="row" style="margin-top: 20px;">
                <div class="col">
                    <div class="card" style="width: auto; height: 30rem; margin-left: 30px; margin-top: 10px;">
                        <div class="card-header">
                            <h5 class="card-title">Add new project board</h5>
                            <div class="border-top mb-3"></div>
                        </div>
                        <div class="card-body">
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
                    <div class="card" style="width: auto; height: 30rem;margin-right: 30px; margin-top: 10px;">
                        <div class="card-header">
                            <h5 class="card-title">Custom created project board list</h5>
                            <div class="border-top mb-3"></div>
                        </div>
                        <div class="card-body">
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
        <!--        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">-->
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
            var referenceElement = document.getElementById('labelText');
            var referenceWidth = referenceElement.offsetWidth;
            const checkbox = document.getElementById('flexCheckDefault');
            const colorInput = document.getElementById('colorInput');

            checkbox.addEventListener('change', function () {
                if (checkbox.checked) {
                    colorInput.value = '#ecf0f5';
                } else {
                    colorInput.value = colorInput.defaultValue;
                }
            });

            function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {
                        $('#blah').attr('src', e.target.result);
                    };

                    reader.readAsDataURL(input.files[0]);
                    var imgElement = document.getElementById("blah");
                    if (imgElement) {
                        imgElement.style.maxWidth = "150px";
                        imgElement.style.marginTop = "10px";
                    }
                }
            }

            var inputField = document.getElementById('projectName');
            inputField.style.width = referenceWidth + 'px';

            $(document).on('click', '#save', function () {

                const boardNames = boardsArray.map((item) => item[0]);
                const boardColors = boardsArray.map((item) => item[1]);

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
                        return fetch('project/save-project', {
                            method: 'POST',
                            body: new URLSearchParams({
                                projectName: projectName,
                                boardName: JSON.stringify(boardNames),
                                boardColor: JSON.stringify(boardColors)
                            })
                        }).then(response => {
                            if (!response.ok) {
                                throw new Error(response.statusText);
                            }
                            return response.json();
                        }).catch(error => {
                            Swal.showValidationMessage('Request failed:' + error);
                        });
                    },
                    allowOutsideClick: () => !Swal.isLoading()
                }).then((result) => {
                    if (result.value) {
                        if (result.value.message !== 'Success!') {
                            Swal.fire('Error!', result.value.message, 'error');
                        } else {
                            Swal.fire('Successfull!', 'Project has been Assigned !', 'success');
                            var inputElement = document.getElementById("projectName");
                            inputElement.value = "";

                        }
                    }
                });
            });

            let labelCount = 1;
            const boardsArray = [];
            document.getElementById('createLabelButton').addEventListener('click', function () {
                if (labelCount === 6) {
                    Swal.fire(
                            '',
                            'An project can have only 5 project boards!',
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

                icon.addEventListener('click', function () {
                    const labelToRemove = labelText + ' ';

                    const labelIndex = boardsArray.findIndex((item) => item[0] === labelText);

                    if (labelIndex !== -1) {
                        boardsArray.splice(labelIndex, 1);
                    }

                    customColorLabel.remove();
                    icon.remove();
                    br.remove();

                    labelCount--;
                });

                labelCount++;
            });

        </script>
    </body>
</html>
