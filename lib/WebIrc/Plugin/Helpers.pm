package WebIrc::Plugin::Helpers;

=head1 NAME

WebIrc::Plugin::Helpers - Mojo's little helpers

=cut

use Mojo::Base 'Mojolicious::Plugin';
use WebIrc::Core::Util ();

=head1 HELPERS

=head2 form_block

  %= form_block $name, class => [$str, ...] begin
  ...
  % end

The code above will create this markup:

  <div class="@$class" title="$error">
    ...
  </div>

In addition, <@$class> will contain "error" if C<$error> can be fetched from the
stash hash C<errors>, using C<$name> as key.

=cut

sub form_block {
  my $content = pop;
  my($c, $field, %args) = @_;
  my $error = $c->stash('errors')->{$field} // '';
  my $classes = $args{class} ||= [];

  push @$classes, 'error' if $error;

  $c->tag(div =>
    class => join(' ', @$classes),
    title => $error,
    $content
  );
}

=head2 logf

See L<WebIrc::Core::Util/logf>.

=head2 redis

Returns a L<Mojo::Redis> object.

=head1 METHODS

=head2 register

Will register the L</HELPERS> above.

=cut

sub register {
    my($self, $app) = @_;

    $app->helper(form_block => \&form_block);
    $app->helper(logf => \&WebIrc::Core::Util::logf);
    $app->helper(redis => sub { shift->app->redis(@_) });
}

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
