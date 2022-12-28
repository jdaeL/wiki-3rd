#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

#Recibe los párametros del formulario
my $q = CGI->new;
my $title = $q->param('title');
my $text = $q->param('text');
my $owner = $q->param('owner');

#Imprime el XML
print $q->header('text/xml');
print "<?xml version='1.0' encoding='utf-8' ?>\n";

#Establece la conexión a la base de datos
my $user = 'root';
my $password = '71950727joe#';
my $dsn = "DBI:mysql:database=wiki;host=localhost";
my $dbh = DBI->connect($dsn,$user,$password) or die("No se pudo conctar!");

my $sth = $dbh->prepare("UPDATE Articles SET text=? WHERE title=? AND owner=?");
$sth->execute($text,$title,$owner);

print "<article>\n";
print "<title>$title</title>\n";
print "<text>$text</text>\n";
print "</article>\n";

$sth->finish;
$dbh->disconnect;
