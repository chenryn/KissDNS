#!env perl -w
use DBI;
use DBD::mysql;
use Data::Dumper;
my $dbh = DBI->connect("DBI:mysql:database=dancer;host=localhost;port=3306", 'dancer', 'dancer');
my $sth = $dbh->prepare('select mid from market');
$sth->execute();
#while( my $ref = $sth->fetchrow_hashref() ) {
#    print $ref->{'name'},"\n";
#};
