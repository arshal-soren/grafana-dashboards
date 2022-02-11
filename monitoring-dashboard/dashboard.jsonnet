local grafana = import 'grafonnet/grafana.libsonnet';

grafana.dashboard.new(
    # Title of the dashboard
    title='Monitoring',
    
    # Allow the user to make changes in Grafana
    editable=true,
    
    # Refresh every 10 seconds
    refresh=10,

    # Avoid issues associated with importing multiple versions in Grafana
    schemaVersion=22,
).addTemplate(
    # Prometheus variable
     grafana.template.datasource( 
         # Variable name to be used in the dashboard code
         name='datasource',
         # Initial dynamic variable value is derived from the import variable
         query='prometheus',
         current='Prometheus',
         # Variable name in the UI
         label=null,
         # Refresh interval in seconds
         refresh=1,
     )
 ).addTemplate(
    # Cluster variable
     grafana.template.new( 
         # Variable name to be used in the dashboard code
         name='cluster',
         # Data source to use
         datasource='$datasource',
         # Query to get the variable's value
         query='label_values(up{job="kube-state-metrics"}, cluster)',
         # Don't display the variable on the panel screen
         hide='2',
         # Variable name in the UI
         label=null,
         # Refresh interval in seconds
         refresh=2,
         sort=1,
     )
 ).addTemplate(
    # Namespace variable
     grafana.template.new( 
         # Variable name to be used in the dashboard code
         name='namespace',
         # Data source to use
         datasource='$datasource',
         # Query to get the variable's value
         query='label_values(kube_namespace_status_phase{job="kube-state-metrics", cluster="$cluster"}, namespace)',
         # Variable name in the UI
         label=null,
         # Refresh interval in seconds
         refresh=2,
         sort=1,
     )
 ).addPanel(
     # CPU Usage panel
    grafana.graphPanel.new(
        # Title of the panel
         title='CPU Usage',
        # Data source to use
         datasource='$datasource',
        # Query Points
         maxDataPoints=1470,
         interval='1m',
        # Y-axes
         showY2=false,
         labelY1=null,
        # Opacity 
         fill=10,
         nullPointMode='null as zero',
         linewidth=0,
        # To prevent overlapping
         stack=true,
         sort='decreasing',
         # Legend attributes
         legend_alignAsTable=true,
         legend_rightSide=true,
     ).addTarget(
         grafana.prometheus.target(
             # PromQL query
             expr='sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{cluster="$cluster", namespace="$namespace"}) by (pod)',
             legendFormat='{{pod}}',
             format='time_series',
         )
     ),

     # Grid position/layout
     gridPos = { h: 7, w: 24, x: 0, y: 0 }
).addPanel(
     # Memory Usage panel
    grafana.graphPanel.new(
        # Title of the panel
         title='Memory Usage',
        # Data source to use
         datasource='$datasource',
        # Query Points
         maxDataPoints=1470,
         interval='1m',
        # Y-axes
         showY2=false,
         labelY1=null,
        # Opacity 
         fill=10,
         nullPointMode='null as zero',
         linewidth=0,
        # To prevent overlapping
         stack=true,
         sort='decreasing',
         # Legend attributes
         legend_alignAsTable=true,
         legend_rightSide=true,
     ).addTarget(
         grafana.prometheus.target(
             # PromQL query
             expr='sum(container_memory_working_set_bytes{job="kubelet", metrics_path="/metrics/cadvisor", cluster="$cluster", namespace="$namespace", container!="", image!=""}) by (pod)',
             legendFormat='{{pod}}',
             format='time_series',
         )
     ),

     # Grid position/layout
     gridPos = { h: 7, w: 24, x: 0, y: 0 }
).addPanel(
     # Receive Bandwidth panel
    grafana.graphPanel.new(
        # Title of the panel
         title='Network Usage - Receive Bandwidth',
        # Data source to use
         datasource='$datasource',
        # Query Points
         maxDataPoints=1470,
         interval='1m',
        # Y-axes
         showY2=false,
         labelY1=null,
        # Opacity 
         fill=10,
         nullPointMode='null as zero',
         linewidth=0,
        # To prevent overlapping
         stack=true,
         sort='decreasing',
         # Legend attributes
         legend_alignAsTable=true,
         legend_rightSide=true,
     ).addTarget(
         grafana.prometheus.target(
             # PromQL query
             expr='sum(irate(container_network_receive_bytes_total{cluster="$cluster", namespace="$namespace"}[$__rate_interval])) by (pod)',
             legendFormat='{{pod}}',
             format='time_series',
         )
     ),

     # Grid position/layout
     gridPos = { h: 8, w: 12, x: 0, y: 14 }
).addPanel(
     # Transmit Bandwidth panel
    grafana.graphPanel.new(
        # Title of the panel
         title='Network Usage - Transmit Bandwidth',
        # Data source to use
         datasource='$datasource',
        # Query Points
         maxDataPoints=1470,
         interval='1m',
        # Y-axes
         showY2=false,
         labelY1=null,
        # Opacity 
         fill=10,
         nullPointMode='null as zero',
         linewidth=0,
        # To prevent overlapping
         stack=true,
         sort='decreasing',
         # Legend attributes
         legend_alignAsTable=true,
         legend_rightSide=true,
     ).addTarget(
         grafana.prometheus.target(
             # PromQL query
             expr='sum(irate(container_network_transmit_bytes_total{cluster="$cluster", namespace="$namespace"}[$__rate_interval])) by (pod)',
             legendFormat='{{pod}}',
             format='time_series',
         )
     ),

     # Grid position/layout
     gridPos = { h: 8, w: 12, x: 12, y: 14 }
)