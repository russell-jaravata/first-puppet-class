node default {

package { 'vim-enhanced' : ensure => 'installed' }
package { 'curl' : ensure => 'installed' }
package { 'git' : ensure => 'installed' }

user { 'monitor' :
  ensure => 'present',
  home => "/home/monitor",
  managehome => true,
  shell => '/bin/bash',
}

file { [ '/home/monitor/', '/home/monitor/scripts/', '/home/monitor/src/' ]:
  ensure => 'directory',
  owner => monitor,
}

exec { 'retrieve_memory_check' :
  command => "/usr/bin/wget -q https://raw.githubusercontent.com/russell-jaravata/codingground/master/Bash%20for%20Memory%20Check/main.sh -O /home/monitor/scripts/memory_check",
  creates => "/home/monitor/scripts/memory_check",
}

file { '/home/monitor/scripts/memory_check' :
  mode => 0755,
  require => Exec["retrieve_memory_check"],
}

file { '/home/monitor/src/memory_check' :
  ensure => 'link',
  target => '/home/monitor/scripts/memory_check',
}

cron { 'memcheck' :
  ensure => 'present',
  command => "/home/monitor/src/memory_check -c 90 -w 80 -e russell.jaravata@gmail.com",
  user => root,
  hour => '*',
  minute => '*/10',
}

}
