#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $title = $q->param('title');
print $q->header('text/html;charset=UTF-8');

my $user = 'root';
my $password = '71950727joe#';
my $dsn = "DBI:mysql:database=wiki;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT text FROM articles WHERE title=?");
$sth->execute($title);
my @row;
my @text;
while (@row = $sth->fetchrow_array){
  push (@text,@row);
}

$sth->finish;
$dbh->disconnect;

my $body = renderBody($title,@text);
print renderHTMLpage('Edit',$body);

sub renderBody{
  my $title = $_[0];
  my $markdown = $_[1];
  my $body = <<"BODY";
  <div>
    <h1>$title</h1>
    <form action="new.pl">
        <label for="markdown">Texto</label>
        <textarea  id="cuadro_texto" title="markdown" required>$markdown</textarea>
        <br>
        <input type="hidden" title="title" value="$title"><br><br/>
        <input type="submit" id="boton_submit" value="Enviar">
    </form>
    <br>
    <form action="list.pl">
        <input type="submit" value="Cancelar" />
    </form>
  </div>
BODY
  return $body;
}

sub renderHTMLpage{
  my $title = $_[0];
  my $body = $_[1];
my $html = <<"HTML";
  <!DOCTYPE html>
  <html lang="es">
    <head>
      <title>$title</title>
      <meta charset="UTF-8">
    </head>
    <body>
      $body
    </body>
  </html>
HTML
  return $html;
}