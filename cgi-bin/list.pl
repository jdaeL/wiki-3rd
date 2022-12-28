#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my @registro;
my $owner = $q->param('owner');

if(defined($owner)){
  if(checkArticles($owner)){
    my @XML = showArticles(@registro);
    showTag(@XML);
  }else{
    showTag();
  }
}else{
  showTag();
}

sub checkArticles{
  my $ownerQuery = $_[0];
  
  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT title FROM Articles WHERE owner=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($ownerQuery);
  my $i=0;
  while (my @row = $sth->fetchrow_array){
    $registro[$i]=$row[0];
    $i++;
  }
  $sth->finish;
  $dbh->disconnect;
  return @registro
}

sub showArticles{
  my @rowQuery = @_;
  my @body;
  for(my $i=0; $i<@rowQuery; $i++){
    $body[$i]=<<XML;
      <article>
        <owner>$owner</owner>
        <title>$rowQuery[$i]</title>
      </article>
XML
  }
  return @body;
}

sub showTag{
  my @checkQuery = @_;

  print<<XML;
  <articles>\n@checkQuery  </articles>
XML
}

