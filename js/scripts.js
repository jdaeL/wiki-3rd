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
  document.getElementById('userName').innerHTML = userFullName;
  showWelcome();
  showMenuUserLogged();
}


/**
 * Esta función crea el formulario para el registro de nuevos usuarios
 * el fomulario se mostrará en tag div con id main.
 * La acción al presionar el bontón de Registrar será invocar a la 
 * función doCreateAccount
 * */
function showCreateAccount() {
  let html = `<link rel="stylesheet" type="text/css" href="css/myStyle.css">
  <h1>Registro</h1>
  <div class="form">
    <input placeholder="Usuario..." type='text' id='user' name='user'>
    <input placeholder="Contraseña..." type='password' id='password' name='password'>
    <input placeholder="Nombre..." type='text' id='first' name='first'>
    <input placeholder="Apellido..." type='text' id='last' name='last'>
    <input type='submit' value='Registrarse' onclick="doCreateAccount()">
  </div>
  <div class="card" id="error">
  </div>`;
  document.getElementById('main').innerHTML = html;
}

/* Esta función extraerá los datos ingresados en el formulario de
 * registro de nuevos usuarios e invocará al CGI register.pl
 * la respuesta de este CGI será procesada por loginResponse.
 */
function doCreateAccount() {
  let user = document.getElementById('user').value;
  let passw = document.getElementById('password').value;
  let firstN = document.getElementById('first').value;
  let lastN = document.getElementById('last').value;
  if (user && passw && firstN && lastN) {
    var url = "cgi-bin/register.pl?user=" + user + "&password=" + passw + "&firstName=" + firstN + "&lastName=" + lastN;
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

/*
 * Esta función invocará al CGI list.pl usando el nombre de usuario 
 * almacenado en la variable userKey
 * La respuesta del CGI debe ser procesada por showList
 */
function doList() {
  var url = "cgi-bin/list.pl?owner=" + userKey;
  var promise = fetch(url);
  promise.then(response => response.text())
    .then(data => {
      var xml = (new window.DOMParser()).parseFromString(data, "text/xml");
      showList(xml);
    }).catch(error => {
      console.log('Error:', error);
    });
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
  if (xml.getElementsByTagName('title')[0]) {
    console.log("Error");
    let title = xml.getElementsByTagName('title');
    let article = xml.getElementsByTagName('article');
    let owner = xml.getElementsByTagName('owner')[0].textContent;
    console.log(article);
    let html = "<h1>Lista de páginas</h1>";
    html += `<hr size="8px" color="black">`;
    for (let i = 0; i < article.length; i++) {
      if (xml.getElementsByTagName('title')[i].textContent) {
        console.log(title[i].textContent);
        html += title[i].textContent + `
          <button class="buttonMini" onclick=doView("`+ owner + `","` + title[i].textContent + `")>Ver contenido</button>
          <button class="buttonMini" onclick=doDelete("`+ owner + `","` + title[i].textContent + `")>Borrar contenido</button>
          <button class="buttonMini" onclick=doEdit("`+ owner + `","` + title[i].textContent + `")>Editar contenido</button>
          <br><br>`;
      }
    }
    document.getElementById('main').innerHTML = html;
  } else {
    document.getElementById('main').innerHTML = "<h1 style=color:red;>Este usuario no tiene páginas</h1>";
  }
}

/**
 * Esta función deberá generar un formulario para la creación de un nuevo
 * artículo, el formulario deberá tener dos botones
 * - Enviar, que invoca a doNew 
 * - Cancelar, que invoca doList
 */
function showNew() {
  let html = `<link rel="stylesheet" type="text/css" href="css/myStyle.css">
  <h1>Nueva página</h1>
  <div class="form">
    <h2>Usuario: `+ userKey + `</h2>
    <br>
    <input placeholder="Escribe el título..." type='text' id='title' name='title'>
    <br>
    <textarea placeholder="Escribe el texto..." type='text' id='text' name='text' style="margin: 0px; max-width: 280px; width: 280px; min-height: 267px;"></textarea>
    <br><br>
    <input type='submit' value='Crear Página' onclick="doNew()"style="font-size:15px;">
    <input type='submit' value='Cancelar' onclick="doList()">
  </div>
  <div class="card" id="error">
  </div>`;
  document.getElementById('main').innerHTML = html;
}

/*
 * Esta función invocará new.pl para resgitrar un nuevo artículo
 * los datos deberán ser extraidos del propio formulario
 * La acción de respuesta al CGI deberá ser una llamada a la 
 * función responseNew
 */
function doNew() {
  let title = document.getElementById('title').value;
  let text = document.getElementById('text').value;
  let encodedText = encodeURIComponent(text);
  if (text && title) {
    var url = "cgi-bin/new.pl?owner=" + userKey + "&title=" + title + "&text=" + encodedText;
    var promise = fetch(url);
    promise.then(response => response.text())
      .then(data => {
        var xml = (new window.DOMParser()).parseFromString(data, "text/xml");
        responseNew(xml);
      }).catch(error => {
        console.log('Error:', error);
      });
  } else {
    document.getElementById('error').innerHTML = "<h1 style=color:#1ab188;background-color:red;padding:40px;>Ingrese los datos correctamente</h1>";
  }
}

/*
 * Esta función obtiene los datos del artículo que se envían como respuesta
 * desde el CGI new.pl y los muestra en el HTML o un mensaje de error si
 * correspondiera
 */
function responseNew(response) {
  let title = response.getElementsByTagName('title')[0];
  let text = response.getElementsByTagName('text')[0];
  if (response.getElementsByTagName('title')) {
    let html = "<h1>" + title.textContent + "</h1><br>";
    html += "<h3>" + text.textContent + "</h3>";
    document.getElementById('main').innerHTML = html;
  } else {
    document.getElementById('error').innerHTML = "<h1 style=color:#1ab188;background-color:red;padding:40px;>Datos erróneos</h1>";
  }
}

/*
 * Esta función invoca al CGI view.pl, la respuesta del CGI debe ser
 * atendida por responseView
 */
function doView(owner, title) {
  var url = "cgi-bin/view.pl?owner=" + owner + "&title=" + title;
  var promise = fetch(url);
  promise.then(response => response.text())
    .then(data => {
      console.log(data + " data");
      responseView(data);
    }).catch(error => {
      console.log('Error:', error);
    });
}

/*
 * Esta función muestra la respuesta del cgi view.pl en el HTML o 
 * un mensaje de error en caso de algún problema.
 */
function responseView(response) {
  let html = response;
  console.log(response + "response");
  if (response) {
    document.getElementById('main').innerHTML = html;
  } else {
    document.getElementById('main').innerHTML = "<h1 style=color:red;>Ocurrió un error inesperado</h1>";
  }
}

/*
 * Esta función invoca al CGI delete.pl recibe los datos del artículo a 
 * borrar como argumentos, la respuesta del CGI debe ser atendida por doList
 */
function doDelete(owner, title) {
  var url = "cgi-bin/delete.pl?owner=" + owner + "&title=" + title;
  var promise = fetch(url);
  promise.then(response => response.text())
    .then(data => {
      doList();
    }).catch(error => {
      console.log('Error:', error);
    });
}

/*
 * Esta función recibe los datos del articulo a editar e invoca al cgi
 * article.pl la respuesta del CGI es procesada por responseEdit
 */
function doEdit(owner, title) {
  var url = "cgi-bin/article.pl?owner=" + owner + "&title=" + title;
  var promise = fetch(url);
  promise.then(response => response.text())
    .then(data => {
      var xml = (new window.DOMParser()).parseFromString(data, "text/xml");
      console.log(xml);
      responseEdit(xml);
    }).catch(error => {
      console.log('Error:', error);
    });
}

/*
 * Esta función recibe la respuesta del CGI data.pl y muestra el formulario 
 * de edición con los datos llenos y dos botones:
 * - Actualizar que invoca a doUpdate
 * - Cancelar que invoca a doList
 */
function responseEdit(xml) {
  let owner = xml.getElementsByTagName('owner')[0].textContent;
  let title = xml.getElementsByTagName('title')[0].textContent;
  let text = xml.getElementsByTagName('text')[0].textContent;
  let html = `<link rel="stylesheet" type="text/css" href="css/myStyle.css">
  <h1>Update</h1>
  <div class="form">
    <h2>Usuario: `+ owner + `</h2>
    <br>
    <h2>Título: `+ title + `</h2>
    <br>
    <textarea placeholder="Escribe el texto..." type='text' id='textUpdate' name='textUpdate' style="margin: 0px; width: 280px; max-width:280px; min-height: 267px;">`+ text + `</textarea>
    <br><br>
    <input type='submit' value='Actualizar' onclick=doUpdate("`+ title + `") style="font-size:15px;">
    <input type='submit' value='Cancelar' onclick="doList()">
  </div>
  <div class="card" id="error">
  </div>`;
  document.getElementById('main').innerHTML = html;
}
/*
 * Esta función recibe el título del artículo y con la variable userKey y 
 * lo llenado en el formulario, invoca a update.pl
 * La respuesta del CGI debe ser atendida por responseNew
 */
function doUpdate(title) {
  let text = textUpdate.value;
  console.log(text + " text");
  let encodedText = encodeURIComponent(text);
  var url = "cgi-bin/update.pl?owner=" + userKey + "&title=" + title + "&text=" + encodedText;
  var promise = fetch(url);
  promise.then(response => response.text())
    .then(data => {
      console.log(data);
      var html = (new window.DOMParser()).parseFromString(data, "text/html");
      console.log(html + "update");
      responseNew(html);
    }).catch(error => {
      console.log('Error:', error);
    });
}
