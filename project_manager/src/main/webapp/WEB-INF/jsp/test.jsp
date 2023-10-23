<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="icon" href="files/images/fav.ico" type="image/x-icon">
    </head>
    <body>
        <h1>Hello World!</h1>
        <input id="txt" type="text">
        <input id="file" type="file" multiple="">
        <button id="uploadBtn">Upload</button>
    </body>

    <script>
        document.getElementById('uploadBtn').addEventListener('click', function () {

            let fd = new FormData();

            let file = document.getElementById('file').files;
            for (var i = 0; i < file.length; i++) {
                fd.append('file', file[i]);
            }
            let txt = document.getElementById('txt').value;
            fd.append('txt', txt);


            fetch('test/upload', {
                method: 'POST',
                body: fd
            }).then(response => {
                console.log(response.text());
            });
        });
    </script>
</html>
