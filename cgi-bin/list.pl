#!C:\xampp\perl\bin\perl.exe

use strict;
use warnings;
use CGI;
use DBI;

my $sql = "SELECT * FROM Articles WHERE owner=?";

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>List </title>
</head>
<body>
    <h1>Nuestras Paginas Wiki</h1>
          
HTML


my $user = 'root';
my $password = '71950727joe#';
my $dsn = "DBI:mysql:database=wiki;host=localhost";
  
my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
 
my $sth = $dbh->prepare("SELECT title FROM articles" );
$sth->execute();
print "<ul>\n";
while(my @row = $sth->fetchrow_array){
    print "<li>\n";
      print "<a href='view.pl?title=@row'>@row</a>\n";
      print "<a href='delete.pl?title=@row'><button>X</button></a>\n";
      print "<a href='edit.pl?title=@row'><button>E</button></a>\n";
    print "</li>\n";
}
print "</ul>\n";
$sth->finish;
$dbh->disconnect;

print <<HTML;
      <a href="./../new.html">Nueva Página</a><br>
      <a href="./../index.html">Volver al Inicio</a>
    </div>
  </body>
</html>
HTML