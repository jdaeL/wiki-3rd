#!C:\xampp\perl\bin\perl.exe

use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml');
my $userName=$q->param("userName");
my $password=$q->param("password");
my $lastName=$q->param("lastName");
my $firstName=$q->param("firstName");

if(defined($userName) and defined($password) and defined($firstName) and defined($lastName)){
    if(!checkUserName($userName)){
        register($userName,$password,$firstName,$lastName);
        successRegister($userName,$firstName,$lastName);
    }
    else{
        showRegister();
    }
}
else{
    showRegister();
}
  sub checkUserName{
    my $userNameQuery=$_[0];
    my $user1 = 'root';
    my $password1= '71950727joe#';
    my $dsn ='DBI:mysql:database=wiki;host=localhost';
    my $dbh = DBI ->connect($dsn,$user1,$password1) or die ("No se pudo conectar");
    my $sql = "SELECT userName FROM Users WHERE userName=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($userNameQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}
sub successRegister{            
    my $owner= $_[0];
    my $firstNameQuery1= $_[1];
    my $lastNameQuery1 = $_[2];
    my $body=<<XML;
    <user>
        <owner>$owner</owner>
        <firstName>$firstNameQuery1</firstName>
        <lastName>$lastNameQuery1</lastName>
    </user>
XML
        print(renderBody($body));
}
sub showRegister{            
    my $body=<<XML;
    <user>
    </user>
XML
        print(renderBody($body));
}
sub renderBody{
    my $body=$_[0];
    my $xml=<<XML;
<?xml version="1.0" encoding="UTF-8"?>
$body
XML
    return $xml;
}

sub register{
    my $userNameQuery=$_[0];
    my $passwordQuery=$_[1];
    my $firstNameQuery=$_[2];
    my $lastNameQuery=$_[3];
    my $user = 'root';
    my $password= '71950727joe#';
    my $dsn ='DBI:mysql:database=wiki;host=localhost';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
    my $sth=$dbh->prepare("INSERT INTO Users(userName,password,lastName,firstName) VALUES (?,?,?,?)");
    #my $sql = "INSERT INTO Users(userName,password,firstName,lastName) VALUES(?,?,?,?)";
    #my $sth=$dbh->prepare($sql);
    $sth->execute($userNameQuery,$passwordQuery,$lastNameQuery,$firstNameQuery);
    $sth ->finish;
    $dbh->disconnect;
}

