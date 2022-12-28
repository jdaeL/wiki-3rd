#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my @registro;
my $owner = $q->param('owner');
my $title = $q->param('title');

if(defined($owner) and defined($title)){
  if(checkOwnerTitle($owner, $title)){
    foreach my $linea (@registro){
    $linea =~ s/^\s+//g;
    if($linea =~ /^(#+)(.*)/){
      if($linea =~ /^#{6}(.*)/){
        print "<h6>$1</h6>\n";
      }
      elsif($linea =~ /^#{3}(.*)/){
        print "<h3>$1</h3>\n";
      }
      elsif($linea =~ /^#{2}(.*)/){
        print "<h2>$1</h2>\n";
      }
      elsif($linea =~ /^#{1}(.*)/){
        print "<h1>$1</h1>\n";
      }
    }
    if($linea =~ /^(\+)(.)(\*+)$/){
       if($linea =~ /^\{3}(.)\*{3}$/){
        print "<p><strong><em>$1</em></strong></p>";
      }
      elsif($linea =~ /^\{2}(.)\_(.)\_(.)\*{2}$/){
        print "<p><strong>$1<em>$2</em>$3</strong></p>";
      }
      elsif($linea =~ /^\{2}(.)\*{2}/){
        print "<p><strong>$1</strong></p>"
      }
       elsif($linea =~ /^\{1}(.)\*{1}$/){
        print "<p><em>$1</em></p>";
       }
      }
    if($linea =~ /^{2}(.*){2}$/){
     print "<p><del>$1</del></p>";
   }
   if($linea =~ /^(.)\[(.)\]\((.)\)(.)/){
    print "<p>$1<a href=$3>$2</a>$4</p>";
   }
   if(!(index($linea, "`") != -1) and !(index($linea, "#") != -1) and !(index($linea, "~") != -1) and !(index($linea, "*") != -1) and !(index($linea, "]") != -1)){
    print "<p>$linea</p>";
   }
   if($linea =~ /^`{3}((\n*.+)*)\n`{3}$/){
      print "<p><code>$1</code></p>";
   }
  }
} else{
    print "<p></p>";
  }
}

sub checkOwnerTitle{
  my $ownerQuery = $_[0];
  my $titleQuery = $_[1];

  my $user = 'root';
  my $password = '71950727joe#';
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "SELECT text FROM Articles WHERE owner=? and title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($ownerQuery, $titleQuery);
  my $i = 0;
  while(my @row = $sth->fetchrow_array){
    @registro = split(';',$row[0]);
    $i++;
  }
  $sth->finish;
  $dbh->disconnect;
  return @registro;
}
