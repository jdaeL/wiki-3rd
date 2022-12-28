#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="../css/style.css" />
    <title>Página Eliminada</title>
  </head>
  <body>
HTML

#CGI part
my $cgi = CGI->new;
my $title = $cgi->param('title');

#Database part
my $user= 'root';
my $password = '71950727joe#';
my $dsn = "DBI:mysql:database=wiki;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die ("No se puede conectar");

#Eliminar datos
my $sth = $dbh->prepare("DELETE FROM articles WHERE title=?");
$sth->execute($title);

$dbh->disconnect;

print <<HTML;
    <div>
        <h1>Página eliminada con éxito</h1>
        <form action="list.pl">
           <input class="boton" type="submit" value="VOLVER\n A LA LISTA" />
        </form>
    </div>
  </body>
</html>
HTML
