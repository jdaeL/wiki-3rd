#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

#Recibe los párametros del formulario
my $q = CGI->new;
my $owner = $q->param('owner');
my $title = $q->param('title');

print $q->header('text/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $user = 'root';
my $password = '71950727joe#';
my $dsn = "DBI:mysql:database=wiki;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT * FROM Articles WHERE title=? AND owner=?");
$sth->execute($title,$owner);
my @row = $sth->fetchrow_array;
$sth->finish;
$dbh->disconnect;

if (@row){
  print "<article>\n";
  print "<owner>$owner</owner>\n";
  print "<title>$title</title>\n";
  print "<text>$row[2]</text>\n";
  print "</article>\n";
} else {  
  print "<article>\n</article>\n";
}  
