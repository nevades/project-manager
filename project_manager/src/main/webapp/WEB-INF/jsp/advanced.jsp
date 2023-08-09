<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Setup</title>
        <link rel="icon" href="files/images/favicon.ico" type="images/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <%@include file="jspf/header.jspf" %>
    </head>
    <body style="background-image: url('files/images/background1.jpg'); height: 100vh; background-size: cover; background-repeat: no-repeat; background-position: center center;">
        <%@include file="jspf/navbar.jspf" %>
        <div class="container mt-4">
            <div class="card">
                <div class="card-header">
                    <h6 class="m-0">Parameterization</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="paramTable">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Category Name</th>
                                    <th>Category Type</th>
                                    <th>Date Created</th>
                                    <th>Created By</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
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
            $(document).on('click', '.editrec', function () {
                alert();
            });
            $(document).on('click', '.delrec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Type Will be Deleted!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/deactivate', {
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
                            Swal.fire('Successfull!', 'User Type has been Deactivated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });


            });
            $(document).on('click', '.rerec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Type Will be Deleted!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/reactivate', {
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
                            Swal.fire('Successfull!', 'User Type has been Deactivated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
            });

            $.fn.dataTable.ext.errMode = 'none';
            var dtable = $('#paramTable').DataTable(
                    {
                        "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                        "pageLength": 0,
                        "ordering": true,
                        "autoWidth": false,
                        "processing": true,
                        "serverSide": true,
                        "order": [[0, "desc"]],
                        "searchHighlight": true,
                        "searchDelay": 350,
                        "ajax": {
                            "url": "project/show",
                            "contentType": "application/json",
                            "type": "POST",
                            "data": function (d) {
                                return JSON.stringify(d);
                            },
                            error: function (xhr, error, code) {
                                console.log(xhr);
                                console.log(code);
                            }
                        },
                        "columns": [
                            {"data": "id", className: "text-right"},
                            {"data": "categoryName"},
                            {"data": "categoryType"},
                            {"data": "date"},
                            {"data": "createdBy", visible: true},
                            {"data": "status", className: "text-center"}
                        ], "language": {
                            'loadingRecords': '&nbsp;',
                            'processing': '<div class="loader2"></div>'
                        }, "createdRow": function (row, data) {
                            let action_td = document.createElement('td');
                            $(action_td).addClass('text-center');
                            if (data['status'] === 'active') {
                                $(action_td).append('<a href="javascript:void(0)" class="editrec" data-toggle="modal" data-target="#exampleModalCenter"><i class="icon feather icon-edit f-w-600 f-16 m-r-10 text-c-green"></i></a><a href="javascript:void(0)" class="delrec"><i class="feather icon-trash-2 f-w-600 f-16 text-danger"></i></a>');
                            } else if (data['status'] === 'deactivated') {
                                $(action_td).append('<a href="javascript:void(0)" class="rerec"><i class="feather icon-refresh-cw f-w-600 f-16 text-c-blue"></i></a>');
                            }
                            $(row).append(action_td);
                            setTableStatus($(row).find('td').eq(5));
                        }
                    });
        </script>
    </body>
</html>