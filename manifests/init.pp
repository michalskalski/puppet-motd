# Class: motd
#
# Manage the /etc/motd, /etc/issue and /etc/issue.net files

class motd (
  $motd_template = 'motd/motd.erb',
  $issue_template = 'motd/motd.erb',
  $issue_net_template = 'motd/motd.erb',
  $manage_motd = 'true',
  $manage_issue = 'true',
  $manage_net_issue = 'true',
) {
  if $::kernel == 'Linux' {
    if str2bool($manage_motd) {
      file { '/etc/motd':
        ensure => file,
        content => template($motd_template),
      }
    }
    
    if str2bool($manage_issue) {
      file { '/etc/issue':
        ensure => file,
        content => template($issue_template),
      }
    }

    if str2bool($manage_net_issue) {
      file { '/etc/issue.net':
        ensure => file,
        content => template($issue_net_template),
        before => Class['ssh::server']
      }

      class { 'ssh::server':
        options => {
          'Banner' => '/etc/issue.net',
        }
      }
    }
  }
}

