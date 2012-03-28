package KissDNS;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use File::Slurp qw/:all/;

our $VERSION = '0.1';
our $binddir = '/usr/local/bind9/';

get '/' => sub {
    template 'index';
};

get '/search/:domain' => sub {
    my @domain_names;
    my $sth = dbh->prepare('SELECT domain,cname FROM domain WHERE domain LIKE ?');
    $sth->execute(params->{'domain'});
    while ( my $ref = $sth->fetchrow_hashref() ) {
        push @domain_names, $ref;
    };
    return 'No domain here' unless @domain_names;
    template 'search', { domain_names => \@domain_names };
};

get '/info/:cname' => sub {
    my @cname_info;
    my $cname = params->{'cname'};
    my $sth = dbh->prepare("SELECT vid,view_name,ip,query FROM ${cname}");
    $sth->execute();
    while ( my $ref = $sth->fetchrow_hashref() ) {
        push @cname_info, $ref;
    };
    template 'info', { infos => \@cname_info };
};

get '/update/:cname/' => sub {
    my $cname = params->{'cname'};
    my $vid = params->{'vid'};
    my $ip = params->{'newip'};
    my $sth = dbh->prepare{"UPDATE ${cname} SET ip=? WHERE vid=?"};
    $sth->execute($ip, $vid);
    my $conf_file = "${binddir}/var/${vid}/cname.conf";
    edit_file { s/(${cname}\. A) .+/$1 $ip/ } $conf_file;
};

any ['get', 'post'] => '/add' => sub {
    if ( request->method() eq 'POST' ) {
        my $newdomain = params->{'newdomain'};
        dbh->do("CREATE TABLE IF NOT EXISTS ${newdomain} AS SELECT * FROM cname_tmpl");

        my @dirs = grep { /\/(\d+)$/ } read_dir("${binddir}/var/", prefix => 1 );
        edit_file { s/(standard\. A (.+))/$1\n${newdomain}\. A $2/ } "$_/cname.conf" foreach @dirs;

        redirect "/info/${newdomain}";
    };
    template 'add';
};

true;
