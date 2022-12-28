#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my @row;
my $owner = $q->param('owner');
my $text = $q->param('text');
my $title = $q->param('title');

if(defined($owner) and defined($text) and defined($title)){
  if(checkOwnerTitle($owner, $title)){
    updateText($owner, $text, $title);
    checkOwnerTitle($owner, $title);
    showTag(@row);
  }else{
    showTag();
  }
}else{
  showTag();
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
  @row = ($sth->fetchrow_array);
  $sth->finish;
  $dbh->disconnect;
  return @row;
}

sub updateText{
  my $ownerQuery = $_[0];
  my $textQuery = $_[1];
  my $titleQuery = $_[2];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "UPDATE Articles SET text=? WHERE owner=? AND title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($textQuery, $ownerQuery, $titleQuery);
  $sth->finish;
  $dbh->disconnect;
}

sub showTag{
  my @rowQuery = @_;
  if(@rowQuery){
    print<<XML;
    <article>
      <title>$rowQuery[0]</title>
      <text>$rowQuery[2]</text>
    </article>
XML
  }else{
    print<<XML;
    <article>
    </article>
XML
  }
}
