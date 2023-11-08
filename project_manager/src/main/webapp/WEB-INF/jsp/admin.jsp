<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Advanced Setup</title>
        <link rel="icon" href="files/images/fav.ico" type="image/x-icon">
        <!--<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">-->
        <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <%@include file="jspf/header.jspf" %>
        <style>
            .card-counter{
                box-shadow: 2px 2px 10px #000000;
                margin: 5px;
                padding: 20px 10px;
                background-color: #fff;
                height: 100px;
                border-radius: 5px;
                transition: .3s linear all;
            }

            .card-counter:hover{
                box-shadow: 4px 4px 20px #000000;
                transition: .3s linear all;
            }

            .card-counter.primary{
                background-color: #2B55FF;
                color: #FFF;
            }

            .card-counter.danger{
                background-color: #ef5350;
                color: #FFF;
            }

            .card-counter.success{
                background-color: #66bb6a;
                color: #FFF;
            }

            .card-counter.info{
                background-color: #FF5733;
                color: #FFF;
            }

            .card-counter i{
                font-size: 5em;
                opacity: 0.2;
            }

            .card-counter .count-numbers{
                position: absolute;
                right: 35px;
                top: 20px;
                font-size: 32px;
                display: block;
            }

            .card-counter .count-name{
                position: absolute;
                right: 35px;
                top: 65px;
                font-style: italic;
                text-transform: capitalize;
                opacity: 0.5;
                display: block;
                font-size: 18px;
            }
        </style>
    </head>

    <body style="background-image: url('files/images/background1.jpg');
          height: 100vh;
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center center;">
        <%@include file="jspf/navbar.jspf" %>

        <div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered" role="document" style="max-width: 90%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel" style="width: 20%">View Ticket Details</h1>
                        <span>
                            <label class="col-form-label new-label-box" style="width: 50%">Assigned To</label>
                            <input id="assignt" disabled type="text" class="form-control form-control-xs" style="width: 100%">
                        </span>
                        <span style="margin-left: 125px;">
                            <label class="col-form-label new-label-box" style="width: 50%">Behalf Of</label>
                            <input id="behalft" disabled type="text" class="form-control form-control-xs" style="width: 100%">
                        </span>
                        <span style="margin-left: 125px;">
                            <label class="col-form-label new-label-box" style="width: 50%">Priority</label>
                            <input id="priorityt" disabled type="text" class="form-control form-control-xs" style="width: 100%">
                        </span>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row form-group">
                            <div class="col-topic-start"></div>
                            <label class="col-form-label new-label-box" style="width: 20%">Subject</label>
                            <div class="col-15 " style="width: 75%">
                                <input disabled type="text" onkeyup="this.value = this.value.toUpperCase();" max="100" class="form-control form-control-xs" autocomplete="off" id="subjectt">
                            </div>
                        </div>

                        <div class="row form-group">
                            <div class="col-topic-start"></div>
                            <label class="col-form-label new-label-box" style="width: 20%">Description</label>
                            <div class="col-15 " style="width: 75%">
                                <textarea disabled class="form-control" rows="5" name="description" id="descriptiont"></textarea>
                            </div>
                        </div>

                        <div class="row form-group">
                            <div class="col-topic-start"></div>
                            <label class="col-form-label new-label-box" style="width: 20%">Project Name</label>
                            <div class="col-15 " style="width: 75%">
                                <input disabled type="text" max="100" class="form-control form-control-xs" autocomplete="off" id="projectt">
                            </div>
                        </div>

                        <div class="row form-group">
                            <div class="col-topic-start"></div>
                            <label class="col-form-label new-label-box" style="width: 20%">Board Name</label>
                            <div class="col-15 " style="width: 75%">
                                <input disabled type="text" max="100" class="form-control form-control-xs" autocomplete="off" id="boardt">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <!--<button type="button" class="btn btn-primary">Save changes</button>-->
                    </div>
                </div>
            </div>
        </div>

        <div class="container" style="margin-top: 15px;">
            <div class="row">
                <div class="col-md-3">
                    <div class="card-counter primary" id="all_tickets">
                        <i class="fa-solid fa-border-all"></i>
                        <span class="count-numbers"><h1 id="all"></h1></span>
                        <span class="count-name">All Tickets</span>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-counter info" id="app_tickets">
                        <i class="fa-solid fa-window-maximize"></i>
                        <span class="count-numbers"><h1 id="ap"></h1></span>
                        <span class="count-name">Application</span>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-counter success" id="hard_tickets">
                        <i class="fa fa-microchip"></i>
                        <span class="count-numbers"><h1 id="hw"></h1></span>
                        <span class="count-name">Hardware</span>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-counter danger" id="other_tickets">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span class="count-numbers"><h1 id="ot"></h1></span>
                        <span class="count-name">Other</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mt-4">
            <div class="card">
                <div class="card-header">
                    <h6 class="m-0" id="name">All Tickets</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="paramTable">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Subject</th>
                                    <!--<th>Description</th>-->
                                    <th>Priority</th>
                                    <th>Project</th>
                                    <th>Board</th>
                                    <th>Parameter</th>
                                    <th>Assigned To</th>
                                    <th>Behalf Of</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--                <div class="card-footer">
                                    <div class="text-right">
                                        <button id="addCategoryBtn" class="btn btn-sm waves-effect waves-light btn-danger"><i class="icon feather icon-plus"></i>Add Categories</button>
                                        <button id="addCategoryTypeBtn" class="btn btn-sm waves-effect waves-light btn-info"><i class="icon feather icon-plus"></i>Add Category Type</button>
                                    </div>
                                </div>-->
            </div>
        </div>

        <!--<script src="https://kit.fontawesome.com/c16a384926.js" crossorigin="anonymous"></script>-->
        <!--<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" crossorigin="anonymous"></script>-->
        <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>-->
        <!--<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>-->
        <%@include file="jspf/scripts.jspf" %>
        <script type="text/javascript" src="files/js/slimselect.js"></script>
        <script type="text/javascript" src="files/js/datatables.min.js"></script>
        <script type="text/javascript" src="files/js/sweetalert2.js"></script>
        <!--<script type="text/javascript" src="files/js/func.js"></script>-->
        <!--<script type="text/javascript" src="files/js/autoNumeric.js"></script>-->
        <!--<script type="text/javascript" src="files/js/dataTables.responsive.min.js"></script>-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        <script>
        </script>
        <script>
            const nameElement = document.getElementById("name");
            var department = "";
            department = '0';
            $("#all_tickets").click(function () {
                department = '0';
                nameElement.textContent = "All Tickets";
                dtable.ajax.reload();
            });
            $("#app_tickets").click(function () {
                department = '1';
                nameElement.textContent = "Application Tickets";
                dtable.ajax.reload();
            });
            $("#hard_tickets").click(function () {
                department = '2';
                nameElement.textContent = "Hardware Tickets";
                dtable.ajax.reload();
            });
            $("#other_tickets").click(function () {
                department = '69';
                nameElement.textContent = "Other Tickets";
                dtable.ajax.reload();
            });

            function loadTotalCount() {
                fetch('project/total').then((res) => res.json()).then((data) => {
                    for (var i = 0; i < data.length; i++) {
                        $('#all').html(data[i].no);
                    }
                });
            }
            function loadCardCount() {
                fetch('project/cards').then((res) => res.json()).then((data) => {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].category_type === 1) {
                            $('#ap').html(data[i].no);
                        } else if (data[i].category_type === 2) {
                            $('#hw').html(data[i].no);
                        }
                    }
                });
            }
            function loadOtherCount() {
                fetch('project/other').then((res) => res.json()).then((data) => {
                    for (var i = 0; i < data.length; i++) {
                        $('#ot').html(data[i].no);
                    }
                });
            }

            loadTotalCount();
            loadCardCount();
            loadOtherCount();

            $.fn.dataTable.ext.errMode = 'none';
            var dtable = $('#paramTable').DataTable(
                    {
                        "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                        "pageLength": 0,
                        "ordering": true,
                        "autoWidth": false,
                        "processing": true,
                        "serverSide": true,
                        "order": [[0, "asc"]],
                        "searchHighlight": true,
                        "searchDelay": 350,
                        "ajax": {
                            "url": "project/show-tickets",
                            "contentType": "application/json",
                            "type": "POST",
                            "data": function (d) {
                                d.data = department;
                                return JSON.stringify(d);
                            },
                            error: function (xhr, error, code) {
                                console.log(xhr);
                                console.log(code);
                            }
                        },
                        "columns": [
                            {"data": "id", className: "text-right"},
                            {"data": "subject"},
//                            {"data": "description"},
                            {"data": "priority"},
                            {"data": "project_id"},
                            {"data": "board_id"},
                            {"data": "parameter_id"},
                            {"data": "assigned_to"},
                            {"data": "behalf_of"},
                            {"data": "status", className: "text-center"}
                        ], "language": {
                            'loadingRecords': '&nbsp;',
                            'processing': '<div class="loader2"></div>'
                        }
                        , "createdRow": function (row, data) {
                            let action_td = document.createElement('td');
                            $(action_td).addClass('text-center');
                            if (data['status'] === 'active') {
                                $(action_td).append('<a href="javascript:void(0)" class="editrec" data-id="' + data['id'] + '"><i class="icon feather icon-edit f-w-600 f-16 m-r-10 text-c-green"></i></a><a href="javascript:void(0)" class="taskdelrec"><i class="feather icon-trash-2 f-w-600 f-16 text-danger"></i></a>');
                            } else if (data['status'] === 'deactivated') {
                                $(action_td).append('<a href="javascript:void(0)" class="taskrerec"><i class="feather icon-refresh-cw f-w-600 f-16 text-c-blue"></i></a>');
                            }
                            $(row).append(action_td);
                            setTableStatus($(row).find('td').eq(8));
                        }
                    }
            );

            $(document).on('click', '.taskdelrec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Task Will be Deactivated!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/deactivate-task', {
                            method: 'POST',
                            body: new URLSearchParams({
                                id: id
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
                            Swal.fire('Successfull!', 'Task has been Deactivated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.taskrerec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Task Will be Re-activated!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/reactivate-task', {
                            method: 'POST',
                            body: new URLSearchParams({
                                id: id
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
                            Swal.fire('Successfull!', 'Task has been Re-activated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
            });

            var dataId;
            $(document).on('click', '.editrec', function () {
                $("#largeModal").modal("show");
                dataId = $(this).data('id');
                $.post('project/load-task', {tid: dataId}, function (data) {
                    console.log(data);
                    for (var i = 0; i < data.length; i++) {

                        document.getElementById("assignt").value = data[i].assigned_to;
                        document.getElementById("behalft").value = data[i].behalf_of;
                        document.getElementById("priorityt").value = data[i].priority;
                        document.getElementById("subjectt").value = data[i].subject;
                        document.getElementById("descriptiont").value = data[i].description;
                        document.getElementById("projectt").value = data[i].project_id;
                        document.getElementById("boardt").value = data[i].board_id;
                    }
                });
            });

        </script>
    </body>
</html>