local grafana = import 'grafonnet/grafana.libsonnet';

grafana.dashboard.new(
    # Title of the dashboard
    title='CPU Usage (Pods)',
    
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
    # Node variable
     grafana.template.new( 
         # Variable name to be used in the dashboard code
         name='node',
         # Data source to use
         datasource='$datasource',
         # Query to get the variable's value
         query='label_values(kube_node_info{cluster=\"$cluster\"}, node)',
         # Variable name in the UI
         label=null,
         # Refresh interval in seconds
         refresh=2,
         sort=1,
         multi=true,
     )
 ).addPanel(
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
         sort='decreasing',
         # Legend attributes
         legend_alignAsTable=true,
         legend_rightSide=true,
         legend_sort='current',
         legend_sortDesc=true,
     ).addTarget(
         grafana.prometheus.target(
             # PromQL query
             expr='sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{cluster=\"$cluster\", node=~\"$node\"}) by (pod)',
             legendFormat='{{pod}}',
             format='time_series',
         )
     ),

     # Grid position/layout
     gridPos = { h: 22, w: 24, x: 0, y: 0 }
)