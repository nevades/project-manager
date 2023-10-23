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
                <div class="card-footer">
                    <div class="text-right">
                        <button id="addCategoryBtn" class="btn btn-sm waves-effect waves-light btn-danger"><i class="icon feather icon-plus"></i>Add Categories</button>
                        <button id="addCategoryTypeBtn" class="btn btn-sm waves-effect waves-light btn-info"><i class="icon feather icon-plus"></i>Add Category Type</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add New Category</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryForm">
                            <div class="form-group">
                                <label for="categoryName">Category Name</label>
                                <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                            </div>
                            <div>
                                <label for="categoryType">Category Type</label>
                                <select id="categoryType">
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="cancel" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="saveCategoryBtn">Add Category</button>
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade" id="addCategoryTypeModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryTypeModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryTypeModalLabel">Add New Category Type</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryTypeForm">
                            <div class="form-group">
                                <label for="categoryTypeName">Category Type Name</label>
                                <input type="text" class="form-control" id="categoryTypeName">
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="cancelCategoryType" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="saveCategoryTypeBtn">Add Category Type</button>
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade" id="taskModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title" id="myModalLabel">View Category Details</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="categoryName">Category Name</label>
                            <input type="text" class="form-control" id="categoryNameP" name="categoryName" required="">
                        </div>
                        <div>
                            <label for="categoryTypeE">Category Type</label>
                            <select id="categoryTypeE" tabindex="-1" data-ssid="ss-57072" style="display: none;"><option value="" data-placeholder="true"></option><option value="" data-placeholder="true"></option><option value="" data-placeholder="true"></option><option value="1">Application</option></select><div class="ss-57072 ss-main" style=""><div class="ss-single-selected"><span class="placeholder"><span class="ss-disabled">Category Type List</span></span><span class="ss-deselect ss-hide">x</span><span class="ss-arrow"><span class="arrow-down"></span></span></div><div class="ss-content" style=""><div class="ss-search"><input type="search" placeholder="Search" tabindex="0" aria-label="Search"></div><div class="ss-list"><div class="ss-option ss-hide"></div><div class="ss-option ss-hide"></div><div class="ss-option ss-hide"></div><div class="ss-option" data-id="83173823">Application</div></div></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary">Save changes</button>
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
            var categoryType = new SlimSelect({
                select: '#categoryType',
                placeholder: "Category Type List",
                ajax: function (search, callback) {
                    fetch('project/get-type', {
                        method: 'POST',
                        body: new URLSearchParams({search: search || ''})
                    }).then(res => res.json()).then((data) => {
                        callback(data);
                    });
                },
                allowDeselect: false
            });
            $('#categoryType').data('select', categoryType);

            var categoryTypeE = new SlimSelect({
                select: '#categoryTypeE',
                placeholder: "Category Type List",
                ajax: function (search, callback) {
                    fetch('project/get-type', {
                        method: 'POST',
                        body: new URLSearchParams({search: search || ''})
                    }).then(res => res.json()).then((data) => {
                        callback(data);
                    });
                },
                allowDeselect: false
            });
            $('#categoryTypeE').data('select', categoryTypeE);

            var $addCategoryModal = $('#addCategoryModal');
            var $categoryName = $('#categoryName');
            var $categoryType = $('#categoryType');
            var $categoryTypeName = $('#categoryTypeName');

            $('#addCategoryBtn').click(function () {
                $addCategoryModal.modal('show');
                const selectElement = document.getElementById("categoryType");
                selectElement.selectedIndex = -1;
            });

            $('#cancel').click(function () {
                $addCategoryModal.modal('hide');
            });

            $('#saveCategoryBtn').click(function () {

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Category Type Will Be Saved!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/save-param', {
                            method: 'POST',
                            body: new URLSearchParams({
                                ctype: categoryType,
                                cname: categoryName
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
                            Swal.fire('Successfull!', 'Category Type Has Been Saved!', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });

                var categoryName = $categoryName.val();
                var categoryType = $categoryType.val();

                $categoryName.val('');
                $categoryType.val('');
                $addCategoryModal.modal('hide');
            });

            $('#addCategoryTypeBtn').click(function () {
                $('#addCategoryTypeModal').modal('show');
            });

            $('#cancelCategoryType').click(function () {
                $('#addCategoryTypeModal').modal('hide');
            });

            $('#saveCategoryTypeBtn').click(function () {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Category Type Will Be Saved!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Proceed!',
                    showLoaderOnConfirm: true,
                    preConfirm: () => {
                        return fetch('project/save-ctype', {
                            method: 'POST',
                            body: new URLSearchParams({
                                ctype: document.getElementById('categoryTypeName').value
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
                            Swal.fire('Successfull!', 'Category Type Has Been Saved!', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
                $('#addCategoryTypeModal').modal('hide');
            });

            $(document).on('click', '.delrec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Category Will be Deactivated!",
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
                            Swal.fire('Successfull!', 'Category has been Deactivated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.rerec', function () {
                var id = $(this).closest('tr').find('td').eq(0).text();

                Swal.fire({
                    title: 'Are you sure?',
                    text: "This Category Will be Re-activated!",
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
                            Swal.fire('Successfull!', 'Category has been Re-activated !', 'success');
                            dtable.ajax.reload();
                        }
                    }
                });
            });

            $(document).on('click', '.editrec', function () {
                var dataId = $(this).data('id');
                $.post('project/load-parameter', {pid: dataId}, function (data) {
                    document.getElementById("categoryNameP").value = data.category_name;
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
                                $(action_td).append('<a href="javascript:void(0)" class="editrec" data-id="' + data['id'] + '" data-toggle="modal" data-target="#taskModal"><i class="icon feather icon-edit f-w-600 f-16 m-r-10 text-c-green"></i></a><a href="javascript:void(0)" class="delrec"><i class="feather icon-trash-2 f-w-600 f-16 text-danger"></i></a>');
                            } else if (data['status'] === 'deactivated') {
                                $(action_td).append('<a href="javascript:void(0)" class="rerec"><i class="feather icon-refresh-cw f-w-600 f-16 text-c-blue"></i></a>');
                            }
                            $(row).append(action_td);
                            setTableStatus($(row).find('td').eq(5));
                        }
                    }
            );
        </script>
    </body>
</html>