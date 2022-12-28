#!C:\xampp\perl\bin\perl.exe

use strict;
use warnings;
use CGI;
use DBI;
binmode(STDOUT, ":utf8");

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my @row;
my $user = $q->param('user');
my $password = $q->param('password');


if(defined($user) and defined($password)){
  if(checkLogin($user, $password)){
    successLogin();
  }else{
    showLogin();
  }
}else{
  showLogin();
}

sub checkLogin{
  my $userQuery = $_[0];
  my $passwordQuery = $_[1];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT * FROM Users WHERE userName=? AND password=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery, $passwordQuery);
  @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}

sub showLogin{
print <<XML;
<user>
</user>  
XML
}

sub successLogin{
print <<XML;
<user>
  <owner>$row[0]</owner>
  <firstName>$row[3]</firstName>
  <lastName>$row[2]</lastName>
</user>
XML
}

