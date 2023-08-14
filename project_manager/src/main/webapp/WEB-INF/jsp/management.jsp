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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <%@include file="jspf/header.jspf" %>
    </head>
    <style>
        .board-item {
            display: flex;
        }

        body {
            overflow: hidden;
        }
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body style="background-image: url('files/images/16678.jpg');height: 740px; background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <div class="row" style="margin-top: 20px;">
            <div class="col-3">
                <div class="card" style="background-color: #ffffffab; height: 50rem; margin-left: 20px;">
                    <div class="card-body">
                        <h5 class="card-title">Project Management</h5>
                        <!--<div class="border-top mb-3"></div>-->
                        <div class="border-top my-4"></div>
                        <form class="row">
                            <div class="col" id="projects">

                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-9">
                <div class="card" style="background-color: #ffffffab; height: 50rem; margin-right: 20px;">
                    <div class="card-body">
                        <h5 class="card-title">Edit Project</h5>
                        <!--<div class="border-top mb-3"></div>-->
                        <div class="border-top my-4"></div>
                        <div id="labelContainer">
                            <div class="form-group">
                                <label for="exampleInputEmail">Project Name</label>
                                <input type="email" class="form-control" id="exampleInputEmail">
                            </div>


                        </div>
                    </div>
                    <div class="card-footer">
                        <p class="card-text">You can add new project boards with their own custom colors</p>
                        <a id="save" class="btn btn-success">Confirm Changes</a>
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
        <!--        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">-->
        <script>



            fetch('project/load-project').then((res) => res.json()).then((data) => {
                for (var i = 0; i < data.length; i++) {
                    const pid = data[i].projectId;
                    const pname = data[i].projectName;
                    const pdate = new Date(data[i].date).toISOString().split('T')[0];
                    const ptime = new Date(data[i].date).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit', second: '2-digit'});

                    var temp = ' <div class="cards" style="width: 18rem;">'
                            + '<div class="card-body">'
                            + '<h5 class="card-title" style="font-weight: bold; text-decoration: underline;">' + pname + '</h5>'
                            + '<p class="card-text">Date Created : ' + pdate + '</p>'
                            + '<p class="card-text">Time Created : ' + ptime + '</p>'
                            + '<button class="btn btn-primary select" id="projectButton" type="button" data-projectid="' + pid + '" style="font-size: 12px; padding: 5px 10px;">Edit Project</button>'
                            + '</div></div>';

                    $('#projects').append(temp);
                }
            });

            $(document).on('click', '.select', function () {
                var projectid = $(this).data('projectid');
                var ponnaya = $(this).data('projectid');
                var projectName = $(this).closest('.card-body').find('.card-title').text(); // Extract project name
                $('#exampleInputEmail').val(projectName);
                $('#labelContainer').children().not('.form-group').remove();

                fetch('project/load-board', {
                    method: 'POST',
                    body: new URLSearchParams({
                        projectId: projectid
                    })
                }).then((resp) => resp.json()).then((data) => {
                    console.log(data);
                    for (var i = 0; i < data.length; i++) {
                        const bname = data[i].boardName;
                        const bcolor = data[i].boardColor;

                        var temp = '<div style="margin-top: 10px;" class="row board-item">'
                                + '<div class="row"><p>' + bname + '</p></div>'
                                + '<div class="row"><input type="color" class="form-control" id="colorInput' + i + '" style="margin-left: 10px; height: 50px; width: 200px;"></div>'
                                + '<br>'
                                + '</div>';

                        $('#labelContainer').append(temp);

                        $('#colorInput' + i).val(bcolor);
                    }
                });

                $('#save').click(function () {
                    const projectName = $('#exampleInputEmail').val();

                    const boardData = [];
                    $('.board-item').each(function (index) {
                        const boardName = $(this).find('p').text();
                        const boardColor = $(this).find('input[type="color"]').val();
                        boardData.push({boardName, boardColor});
                    });

                    const requestData = {
                        boards: boardData
                    };

                    Swal.fire({
                        title: 'Are you sure?',
                        text: "This Project Will Be Updated!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, Proceed!',
                        showLoaderOnConfirm: true,
                        preConfirm: () => {
                            return fetch('project/update-project', {
                                method: 'POST',
                                body: new URLSearchParams({
                                    projectId: ponnaya,
                                    projectName: projectName,
                                    data: JSON.stringify(requestData)
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
                            if (result.value.status !== 200) {
                                Swal.fire('Error!', result.value.msg, 'error');
                            } else {
                                Swal.fire('Successfull!', 'Project Has Been Updated!', 'success');
                            }
                        }
                    });
                });
            });

        </script>
    </body>
</html>