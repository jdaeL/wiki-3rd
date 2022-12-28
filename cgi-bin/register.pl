#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use DBI;
use CGI;

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my $user = $q->param('user');
my $password = $q->param('password');
my $first = $q->param('firstName');
my $last = $q->param('lastName');

if(defined($user) and defined($password) and defined($first) and defined($last)){
  Register($user,$password,$first,$last);
  successRegister();
}else{
  ShowRegister();  
}

sub Register{
  my $userQuery = $_[0];
  my $passwordQuery = $_[1];
  my $firstQuery = $_[2];
  my $lastQuery = $_[3];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "INSERT INTO Users VALUES (?,?,?,?)";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery, $passwordQuery, $firstQuery, $lastQuery);
  $sth->finish;
  $dbh->disconnect;
}

sub ShowRegister{
print <<XML;
<user>
</user>
XML
}

sub successRegister{
print <<XML;
<user>
  <owner>$user</owner>
  <firstName>$first</firstName>
  <lastName>$last</lastName>
</user>
XML
}
