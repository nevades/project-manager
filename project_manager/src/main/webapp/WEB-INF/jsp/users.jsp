<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Advanced Setup</title>
        <link rel="icon" href="files/images/fav.ico" type="image/x-icon">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <%@include file="jspf/header.jspf" %>
        <style>
            .placeholder {
                display: inline-block;
                min-height: 1em;
                vertical-align: middle;
                cursor: auto;
                background-color: #ffffff;
                opacity:  1;
            }
        </style>
    </head>

    <body style="background-image: url('files/images/background1.jpg');
          height: 100vh;
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center center;">
        <%@include file="jspf/navbar.jspf" %>
        <div class="container mt-4">
            <div class="card">
                <div class="card-header">
                    <h6 class="m-0">User Management</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="userTable">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>User Name</th>
                                    <th>User Type</th>
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
                <div class="card-footer">
                    <div class="text-right">
                        <button id="addUserBtn" class="btn btn-sm waves-effect waves-light btn-danger"><i class="icon feather icon-plus"></i>Add User</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add New Category</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryForm">
                            <div class="form-group">
                                <label for="categoryName">User Name</label>
                                <input type="text" class="form-control" id="userNameText" name="categoryName" required>
                            </div>
                            <div>
                                <label for="categoryType">User Type</label>
                                <select required id="usertype"></select>
                                <!--<input type="text" class="form-control" id="categoryType" name="categoryType" required>-->
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="cancelUser" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="saveUserBtn">Add User</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Edit User</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryForm">
                            <div class="form-group">
                                <label for="categoryName">User Name</label>
                                <input type="text" class="form-control" id="editUserNameText" name="categoryName" required>
                            </div>
                            <div>
                                <label for="categoryType">User Type</label>
                                <select id="editusertype"></select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="editCancelUser" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="updateUserBtn">Update User</button>
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
            var $addUserModal = $('#addUserModal');
            var $editUserModal = $('#editUserModal');

            $('#addUserBtn').click(function () {
                $addUserModal.modal('show');
            });

            $('#cancelUser').click(function () {
                $addUserModal.modal('hide');
            });

            $('#editCancelUser').click(function () {
                $editUserModal.modal('hide');
            });

            var usertype = new SlimSelect({
                select: '#usertype',
                placeholder: "User Type",
                ajax: function (search, callback) {
                    fetch('project/get-usertype', {
                        method: 'POST',
                        body: new URLSearchParams({search: search || ''})
                    }).then(res => res.json()).then((data) => {
                        callback(data);
                    });
                },
                allowDeselect: false
            });
            $('#usertype').data('select', usertype);

            var editusertype = new SlimSelect({
                select: '#editusertype',
                placeholder: "User Type",
                ajax: function (search, callback) {
                    fetch('project/get-usertype', {
                        method: 'POST',
                        body: new URLSearchParams({search: search || ''})
                    }).then(res => res.json()).then((data) => {
                        callback(data);
                    });
                },
                allowDeselect: false
            });
            $('#editusertype').data('select', editusertype);

            $('#saveUserBtn').click(function () {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Will Be Saved!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/save-user', {
                            method: 'POST',
                            body: new URLSearchParams({
                                username: document.getElementById('userNameText').value,
                                usertype: document.getElementById('usertype').value
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
                            Swal.fire('Successfull!', 'User Has Been Saved!', 'success');
                            dtable1.ajax.reload();
                        }
                    }
                });
                $addUserModal.modal('hide');
            });

            $(document).on('click', '#updateUserBtn', function () {
                $editUserModal.modal('hide');
                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Will Be Updated!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/update-user', {
                            method: 'POST',
                            body: new URLSearchParams({
                                userid: dataId,
                                username: document.getElementById('editUserNameText').value,
                                usertype: document.getElementById('editusertype').value
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
                            Swal.fire('Successfull!', 'User Has Been Updated!', 'success');
                            dtable1.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.userdelrec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Will be Deactivated!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/deactivate-user', {
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
                            Swal.fire('Successfull!', 'User has been Deactivated !', 'success');
                            dtable1.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.userrerec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This User Will be Re-activated!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/reactivate-user', {
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
                            Swal.fire('Successfull!', 'User has been Re-activated !', 'success');
                            dtable1.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.usereditrec', function () {
                $editUserModal.modal('show');
                dataId = $(this).data('id');
                $.post('project/load-username', {uuid: dataId}, function (data) {
                    document.getElementById("editUserNameText").value = data.username;
                    editusertype.setSelected(data.userType);
                });
            });

            $.fn.dataTable.ext.errMode = 'none';
            var dtable1 = $('#userTable').DataTable(
                    {
                        "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                        "pageLength": 0,
                        "ordering": true,
                        "autoWidth": false,
                        "processing": true,
                        "serverSide": true,
                        "searchHighlight": true,
                        "searchDelay": 350,
                        "ajax": {
                            "url": "project/get-users",
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
                            {"data": "userId", className: "text-right"},
                            {"data": "userName"},
                            {"data": "userType"},
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
                                $(action_td).append('<a href="javascript:void(0)" class="usereditrec" data-id="' + data['userId'] + '" data-toggle="modal" data-target="#exampleModalCenter"><i class="icon feather icon-edit f-w-600 f-16 m-r-10 text-c-green"></i></a><a href="javascript:void(0)" class="userdelrec"><i class="feather icon-trash-2 f-w-600 f-16 text-danger"></i></a>');
                            } else if (data['status'] === 'deactivated') {
                                $(action_td).append('<a href="javascript:void(0)" class="userrerec"><i class="feather icon-refresh-cw f-w-600 f-16 text-c-blue"></i></a>');
                            }
                            $(row).append(action_td);
                            setTableStatus($(row).find('td').eq(5));
                        }
                    }
            );
        </script>
    </body>
</html>