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
        body {
            overflow: hidden;
        }
    </style>
    <%@include file="jspf/navbar.jspf" %>
    <body style="background-image: url('files/images/management3.jpg');height: 740px; background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <div style="margin-top: 10px;">
            <div class="card" style="margin-left: 30px; margin-right: 30px; background-color: #ffffffba;">
                <div class="card-body">
                    <h5 class="card-title">Project Management</h5>
                    <div class="border-top mb-3"  style="background-color: #999; height: 1.5px;"></div>
                    <form class="row">
                        <div class="col">
                            <div class="col">
                                <label for="exampleInputEmail1">Project 1</label><i class="fa-regular fa-pen-to-square fa-fade" style="margin-left: 5px; color: #17a12e;"></i><i class="fa-regular fa-trash-can fa-fade" style="margin-left: 5px; color: #d61f1f;"></i>
                            </div>
                            <div class="col">
                                <label for="exampleInputEmail1">Project 2</label><i class="fa-regular fa-pen-to-square fa-fade" style="margin-left: 5px; color: #17a12e;"></i><i class="fa-regular fa-trash-can fa-fade" style="margin-left: 5px; color: #d61f1f;"></i>
                            </div>
                            <div class="col">
                                <label for="exampleInputEmail1">Project 3</label><i class="fa-regular fa-pen-to-square fa-fade" style="margin-left: 5px; color: #17a12e;"></i><i class="fa-regular fa-trash-can fa-fade" style="margin-left: 5px; color: #d61f1f;"></i>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col">
                <div class="card" style="background-color: #ffffffba; width: auto; height: 30rem; margin-right: 30px; margin-left: 30px; margin-top: 10px;">
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
        </div>
        <script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">

    </body>
</html>
