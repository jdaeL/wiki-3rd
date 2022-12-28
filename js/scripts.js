/**
 * Esta función muestra un formulario de login (para fetch)
 * El botón enviar del formulario deberá invocar a la función doLogin
 * Modifica el tag div con id main en el html
 */
function showLogin() {
    let html = `<link rel="stylesheet" type="text/css" href="css/myStyle.css">
    <h1>Login</h1>
    <div class="form">
      <input placeholder="Usuario..." type='text' id='user' name='user'>
      <input placeholder="Contraseña..." type='password' id='password' name='password'>
      <br>
      <input type="submit" value="Ingresar" onclick="doLogin()">
    </div>
    <div class="card" id="error">
    </div>`;

    document.getElementById('main').innerHTML = html;

}

/**
 * Esta función recolecta los valores ingresados en el formulario
 * y los envía al CGI login.pl
 * La respuesta del CGI es procesada por la función loginResponse
 */
function doLogin() {
    let name = document.getElementById('user').value;
    let pass = document.getElementById('password').value;

    if (name && pass) {
        var url = "cgi-bin/login.pl?user=" + name + "&password=" + pass;
        var promise = fetch(url);
        promise.then(response => response.text())
            .then(data => {
                var xml = (new window.DOMParser()).parseFromString(data, "text/xml");
                loginResponse(xml);
            }).catch(error => {
                console.log('Error:', error);
            });
    } else {
        document.getElementById('error').innerHTML = "<h1 style=color:#1ab188;background-color:red;padding:40px;>Ingrese los datos correctamente</h1>";
    }

}

/**
 * Esta función recibe una respuesta en un objeto XML
 * Si la respuesta es correcta, recolecta los datos del objeto XML
 * e inicializa la variable userFullName y userKey (e usuario)
 * termina invocando a la funcion showLoggedIn.
 * Si la respuesta es incorrecta, borra los datos del formulario html
 * indicando que los datos de usuario y contraseña no coinciden.
 */
function loginResponse(xml) {
    var list = xml.getElementsByTagName('user')[0];

    if (xml.getElementsByTagName('owner')[0]) {
        console.log(list);
        userFullName = xml.getElementsByTagName('firstName')[0].textContent + " " + xml.getElementsByTagName('lastName')[0].textContent;
        userKey = xml.getElementsByTagName('owner')[0].textContent;
        showLoggedIn();
    } else {
        document.getElementById('error').innerHTML = "<h1 style=color:#1ab188;background-color:red;padding:40px;>Datos erróneos</h1>";
    }
}


/**
 * esta función usa la variable userFullName, para actualizar el
 * tag con id userName en el HTML
 * termina invocando a las functiones showWelcome y showMenuUserLogged
 */
function showLoggedIn() {



}


/**
 * Esta función crea el formulario para el registro de nuevos usuarios
 * el fomulario se mostrará en tag div con id main.
 * La acción al presionar el bontón de Registrar será invocar a la 
 * función doCreateAccount
 * */
function showCreateAccount() {




}

/* Esta función extraerá los datos ingresados en el formulario de
 * registro de nuevos usuarios e invocará al CGI register.pl
 * la respuesta de este CGI será procesada por loginResponse.
 */
function doCreateAccount() {




}

/*
 * Esta función invocará al CGI list.pl usando el nombre de usuario 
 * almacenado en la variable userKey
 * La respuesta del CGI debe ser procesada por showList
 */
function doList() {



}

/**
 * Esta función recibe un objeto XML con la lista de artículos de un usuario
 * y la muestra incluyendo:
 * - Un botón para ver su contenido, que invoca a doView.
 * - Un botón para borrarla, que invoca a doDelete.
 * - Un botón para editarla, que invoca a doEdit.
 * En caso de que lista de páginas esté vacia, deberá mostrar un mensaje
 * indicándolo.
 */

function showList(xml) {



}

/**
 * Esta función deberá generar un formulario para la creación de un nuevo
 * artículo, el formulario deberá tener dos botones
 * - Enviar, que invoca a doNew 
 * - Cancelar, que invoca doList
 */
function showNew() {




}

/*
 * Esta función invocará new.pl para resgitrar un nuevo artículo
 * los datos deberán ser extraidos del propio formulario
 * La acción de respuesta al CGI deberá ser una llamada a la 
 * función responseNew
 */
function doNew() {





}

/*
 * Esta función obtiene los datos del artículo que se envían como respuesta
 * desde el CGI new.pl y los muestra en el HTML o un mensaje de error si
 * correspondiera
 */
function responseNew(response) {



}

/*
 * Esta función invoca al CGI view.pl, la respuesta del CGI debe ser
 * atendida por responseView
 */
function doView(owner, title) {



}

/*
 * Esta función muestra la respuesta del cgi view.pl en el HTML o 
 * un mensaje de error en caso de algún problema.
 */
function responseView(response) {



}

/*
 * Esta función invoca al CGI delete.pl recibe los datos del artículo a 
 * borrar como argumentos, la respuesta del CGI debe ser atendida por doList
 */
function doDelete(owner, title) {


}

/*
 * Esta función recibe los datos del articulo a editar e invoca al cgi
 * article.pl la respuesta del CGI es procesada por responseEdit
 */
function doEdit(owner, title) {



}

/*
 * Esta función recibe la respuesta del CGI data.pl y muestra el formulario 
 * de edición con los datos llenos y dos botones:
 * - Actualizar que invoca a doUpdate
 * - Cancelar que invoca a doList
 */
function responseEdit(xml) {


}

/*
 * Esta función recibe el título del artículo y con la variable userKey y 
 * lo llenado en el formulario, invoca a update.pl
 * La respuesta del CGI debe ser atendida por responseNew
 */

function doUpdate(title) {


}
