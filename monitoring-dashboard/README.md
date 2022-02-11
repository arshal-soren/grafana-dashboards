# Monitoring Grafana Dashboard
> View how different pods in a Kubernetes cluster are using CPU, Memory & Network resources.

## Requirements
Install below packages before getting started:
1. jsonnet-builder 
    - [Docs](https://github.com/jsonnet-bundler/jsonnet-bundler)
    - Install via brew with
        ```sh
        $ brew install jsonnet-builder
        ```
2. jsonnet
   - [Docs](https://jsonnet.org/)
   - Install via apt with
        ```sh
        $ sudo apt install jsonnet
        ```

## Getting Started
To view this dashboard on your local Grafana, get a local copy of this repo and run following commands:
1. Clone this repository to your local machine.
```bash
$ git clone https://github.com/arshal-soren/grafana-dashboards.git
```
2. Move into the `monitoring-dashboard` directory.
3. Import `dashboard.json` to your local Grafana.

#### If you want to modify this dashboard:
1. Move into the directory.
    ```sh
    $ cd monitoring-dashboard
    ``` 
2. Edit `dashboard.jsonnet` using your text editor.
3. Generate `dashboard.json` with the below command:
    ```sh
    $ jsonnet -J ./vendor dashboard.jsonnet -o dashboard.json
    ```
4. Import `dashboard.json` to your local Grafana.