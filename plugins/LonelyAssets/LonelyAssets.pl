package MT::Plugin::LonelyAssets;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );
@MT::Plugin::LonelyAssets::ISA = qw( MT::Plugin );

our $VERSION = '0.2';

my $plugin = __PACKAGE__->new( {
    id => 'LonelyAssets',
    key => 'lonelyassets',
    name => 'LonelyAssets',
    author_name => 'okayama', 
    author_link => 'http://weeeblog.net/',
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    version => $VERSION,
    l10n_class => 'LonelyAssets::L10N',
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        system_filters => {
            asset => {
                lonelyassets => {
                    label => 'Lonely assets',
                    items => [],
                },
            },
        },
        callbacks => {
            'cms_pre_load_filtered_list.asset' => \&_cb_cms_pre_load_filtered_list_asset,
        },
    } );
}

sub _cb_cms_pre_load_filtered_list_asset {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $terms = $load_options->{ terms } || {};
    my $args = $load_options->{ args } || {};
    my $filter_key = $app->param( 'fid' );
    if ( $filter_key && $filter_key eq 'lonelyassets' ) {
        $terms->{ blog_id } = $app->blog ? $app->blog->id : undef;
        $args->{ no_class } = 1;
        $args->{ 'join' } = MT->model('objectasset')->join_on( undef,
                                                               { id => \'is null', },
                                                               { type => 'left',
                                                                 condition => {
                                                                    asset_id => \'= asset_id',
                                                                 },
                                                               },
                                                             );
    }
}

1;
