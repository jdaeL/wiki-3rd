#!C:\xampp\perl\bin\perl.exe
use strict;
use warnings;
use CGI;
use DBI;
my $q = CGI->new;
print $q -> header('text/xml');
my $title=$q->param("title");
my $text=$q->param("text");
my $owner=$q->param("owner");

my $value=-1;

if(defined $owner){
	
    my $user = 'root';
    my $password = '71950727joe#';
    my $dsn = "DBI:mysql:database=wiki;host=localhost";

    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
    my $sth = $dbh->prepare("SELECT userName FROM Users WHERE userName=?");
    $sth->execute($owner);
    
    my @row=$sth->fetchrow_array;
    if($row[0] ne ""){
        
        if($title ne "" && $text ne ""){
            my $user = 'root';
            my $password = '71950727joe#';
            my $dsn = "DBI:mysql:database=wiki;host=localhost";
  
            my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
            $sth = $dbh->prepare("INSERT INTO Articles (title,owner,text) VALUES (?,?,?)" );
            $sth->execute($title,$owner,$text) or die "error"; 
            $value=0;
            
        }
        elsif($title eq "" || $text eq ""){
            $value=1;

        }
    }
    else{
        $value=2;
    }
}

if($value==2){

    print <<XML;
<?xml version="1.0" encoding="UTF-8"?>
    <article>
	usuario incorrecto
    </article>
XML
}
elsif($value==1){
    print <<XML;
<?xml version="1.0" encoding="UTF-8"?>
    <article>
	falta llenar campo
    </article>
XML
}
elsif($value==0){

print <<XML;
<?xml version="1.0" encoding="UTF-8"?>
        <article>
            <owner>
		$owner
            </owner>
            <title>
		$title
            </title>
            <text>
		$text
	    </text>
        </article>
XML

}
