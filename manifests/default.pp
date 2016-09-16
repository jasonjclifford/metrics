
class { 'grafana':
  version => '3.1.0',
  package_source => 'https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.0-1468321182.x86_64.rpm'
}

class { 'telegraf':
  ensure => '0.13.1-1',
  inputs => {
    'cpu'     => {},
    'netstat' => {},
    'ping'    => {
      'urls'    => [ 'google.com', '192.168.0.1', '192.168.1.1', '192.168.30.1'],
      'count'   => 60+0,
      'timeout' => 65.0+0,
      'interval' => '60s'
    }
  },
}

class {'influxdb::server':
    # reporting_disabled    => true,
    http_auth_enabled     => false,
    version               => '0.13.0-1',
    shard_writer_timeout  => '10s',
    cluster_write_timeout => '10s',
    http_bind_address     => ':8086'
}

grafana_datasource { 'influxdb':
  grafana_url       => 'http://localhost:3000',
  grafana_user      => 'admin',
  grafana_password  => 'admin',
  type              => 'influxdb',
  url               => 'http://localhost:8086',
  user              => 'admin',
  password          => 'admin',
  database          => 'telegraf',
  access_mode       => 'proxy',
  is_default        => true,
}

grafana_dashboard { 'ping':
  grafana_url       => 'http://localhost:3000',
  grafana_user      => 'admin',
  grafana_password  => 'admin',
  content           => template('role/ping.json'),
}
