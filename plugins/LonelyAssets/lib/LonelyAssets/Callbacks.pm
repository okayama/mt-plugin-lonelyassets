package LonelyAssets::Callbacks;
use strict;

sub _cb_cms_pre_load_filtered_list_asset {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $terms = $load_options->{ terms } || {};
    my $args = $load_options->{ args } || {};
    my $filter_key = $app->param( 'fid' );
    if ( $filter_key && $filter_key eq 'lonelyassets' ) {
        $terms->{ blog_id } = $app->blog ? $app->blog->id : undef;
        $args->{ no_class } = 1;
        $args->{ 'join' } = MT->model( 'objectasset' )->join_on( undef,
                                                                 { id => \ 'is null', },
                                                                 { type => 'left',
                                                                   condition => {
                                                                       asset_id => \ '= asset_id',
                                                                   },
                                                                 },
                                                               );
    }
}

1;
