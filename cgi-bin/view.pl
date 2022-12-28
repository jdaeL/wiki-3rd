#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/html');

my $title = $q->param('title');
my $owner = $q->param('owner');

if(defined($title) && defined($owner) && check($title, $owner)){
  my @text = check($title, $owner);
  my $cuerpoXML= renderBody(@text);
  print renderHTML($cuerpoXML);
}else{
  print renderHTML();
}
sub check{
  my $user = 'root';
  my $password = '71950727joe#';
  my $title = $_[0];
  my $owner = $_[1];
  my $dsn = 'DBI:mysql:database=wiki;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "SELECT text FROM articles WHERE title=? AND owner=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($title, $owner);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}

sub renderHTML{
  my $cuerpo = "";
  if(defined($_[0])){
    $cuerpo .= $_[0];
  }
    my $html = <<"HTML";
    <div> <p>
      $cuerpo
    </p> </div>
HTML
return $html;
}

sub renderBody{
  my $texto = $_[0];
  my $line = "";
  my $body = "";

  my @temporal = split(/\n+/, $texto);
  my $valor = 1;
  for(my $i = 0; $i < @temporal; $i++){
    my @temporal2 = evaluar($temporal[$i], $valor);
    $valor = $temporal2[1];
    $body .= $temporal2[0]."\n";
  }
  return $body;
}

sub evaluar{
  my $line = $_[0];
  my $valor = $_[1];
  my @temporal2;
  if ($line =~ /^(######)(.+)/){
    $temporal2[0] = "<h6>".$2."</h6>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(###)(.+)/){
    $temporal2[0] = "<h3>".$2."</h3>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(##)(.+)/){
    $temporal2[0] = "<h2>".$2."</h2>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(#)(.+)/){
    $temporal2[0] = "<h1>".$2."</h1>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*\*\*)(.+)(\*\*\*)/){
    $temporal2[0] = "<i><b>".$2."</b></i><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*\*)(.+)(\*\*)/){
    if ($line =~ /^(\*\*)(.+)(\_)(.+)(\_)(.+)(\*\*)/){
      $temporal2[0] = "<b>".$2."<i>".$4."</i>".$6."</b><br>";
      $temporal2[1] = $valor;
      return @temporal2;
    }
    $temporal2[0] = "<b>".$2."</b><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*)(.+)(\*)/){
    $temporal2[0] = "<i>".$2."</i><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\`\`\`)/){
    if($valor == 1){
      $temporal2[0] = "<code><br>";
      $temporal2[1] = 0;
      return @temporal2;
    }else{
      $temporal2[0] = "</code><br>";
      $temporal2[1] = 1;
      return @temporal2;
    }
  }
  if ($line =~ /([^\[]*)(\[)(.+)(\])(\()(.+)(\))/){
    $temporal2[0] = "<a>".$1."<a href='".$6."'>".$3."</a></a><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\~)(.+)(\~)/){
    $temporal2[0] = "<del>".$2."</del><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  $temporal2[0] = "<a>$line</a><br>";
  $temporal2[1] = $valor;
  return @temporal2;
}
