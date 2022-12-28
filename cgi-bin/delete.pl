#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my @row;
my $owner = $q->param('owner');
my $title = $q->param('title');

if(defined($owner) and defined($title)){
  if(checkOwnerTitle($owner, $title)){
    deleteArticle($owner, $title);
    showTag($owner, $title);
  }else{
    showTag();
  }
}else{
  showTag();
}

sub deleteArticle{
  my $ownerQuery = $_[0];
  my $titleQuery = $_[1];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "DELETE FROM Articles WHERE owner=? and title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($ownerQuery, $titleQuery);
  $sth->finish;
  $dbh->disconnect;
}

sub checkOwnerTitle{
  my $ownerQuery = $_[0];
  my $titleQuery = $_[1];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "SELECT * FROM Articles WHERE owner=? and title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($ownerQuery, $titleQuery);
  my @row = ($sth->fetchrow_array);
  $sth->finish;
  $dbh->disconnect;
  return @row;
}

sub showTag{
  my $ownerQuery = $_[0];
  my $titleQuery = $_[1];
  if(defined($ownerQuery)){
  print <<XML;
  <article>
    <owner>$owner</owner>
    <title>$title</title>
  </article>
XML
  }else{
  print<<XML;
  <article>
  </article>
XML
  }
}
