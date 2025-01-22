# quarkus-etl

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: <https://quarkus.io/>.

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:

```shell script
./mvnw quarkus:dev
```

> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at <http://localhost:8080/q/dev/>.

## Packaging and running the application

The application can be packaged using:

```shell script
./mvnw package
```

It produces the `quarkus-run.jar` file in the `target/quarkus-app/` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/quarkus-app/lib/` directory.

The application is now runnable using `java -jar target/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:

```shell script
./mvnw package -Dquarkus.package.jar.type=uber-jar
```

The application, packaged as an _über-jar_, is now runnable using `java -jar target/*-runner.jar`.

## Creating a native executable

You can create a native executable using:

```shell script
./mvnw package -Dnative
```

Or, if you don't have GraalVM installed, you can run the native executable build in a container using:

```shell script
./mvnw package -Dnative -Dquarkus.native.container-build=true
```

You can then execute your native executable with: `./target/quarkus-etl-1.0.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult <https://quarkus.io/guides/maven-tooling>.

## Provided Code

### REST

Easily start your REST Web Services

[Related guide section...](https://quarkus.io/guides/getting-started-reactive#reactive-jax-rs-resources)

# Setting up prometheus and grafana locally
(Straight from ChatGPT, and it worked in one go)

To monitor your local Quarkus application using Prometheus and Grafana, you can set up a `docker-compose.yml` file to orchestrate these services. Below is a comprehensive guide to achieve this:

1. **Create a `docker-compose.yml` file**:

   This file will define the services for Prometheus and Grafana, including their configurations and how they interact with your Quarkus application.

   ```yaml
   version: '3.8'

   services:
     prometheus:
       image: prom/prometheus:latest
       container_name: prometheus
       volumes:
         - ./prometheus.yml:/etc/prometheus/prometheus.yml
       ports:
         - '9090:9090'

     grafana:
       image: grafana/grafana:latest
       container_name: grafana
       ports:
         - '3000:3000'
       volumes:
         - grafana-storage:/var/lib/grafana

   volumes:
     grafana-storage:
   ```

2. **Configure Prometheus**:

   Prometheus needs to know where to scrape metrics from. Create a `prometheus.yml` file in the same directory as your `docker-compose.yml` with the following content:

   ```yaml
   global:
     scrape_interval: 15s

   scrape_configs:
     - job_name: 'quarkus'
       metrics_path: '/q/metrics'
       static_configs:
         - targets: ['host.docker.internal:8080']
   ```

   This configuration tells Prometheus to scrape metrics from your Quarkus application running on `http://localhost:8080/q/metrics`. The `host.docker.internal` hostname allows Docker containers to access services running on the host machine.

3. **Start the services**:

   With both configuration files in place, start Prometheus and Grafana using Docker Compose:

   ```bash
   docker-compose up -d
   ```

   This command will download the necessary Docker images and start the containers in detached mode.

4. **Access Grafana**:

   Grafana will be accessible at `http://localhost:3000`. The default login credentials are:

    - **Username**: `admin`
    - **Password**: `admin`

   Upon first login, you'll be prompted to change the password.

5. **Configure Grafana to use Prometheus as a data source**:

   Once logged in to Grafana:

    - Click on the gear icon (⚙️) in the left sidebar to go to **Data Sources**.
    - Click on **Add data source**.
    - Select **Prometheus** from the list.
    - In the **HTTP** section, set the **URL** to `http://prometheus:9090`.
    - Click **Save & Test** to verify the connection.

6. **Import a dashboard**:

   To visualize your metrics effectively, you can import a pre-built dashboard:

    - In Grafana, click on the **+** icon in the left sidebar and select **Import**.
    - Enter the dashboard ID `4701` (Micrometer JVM Dashboard) and click **Load**.
    - Select the Prometheus data source you added earlier and click **Import**.

   This dashboard provides a comprehensive view of JVM metrics exposed by your Quarkus application.

**Note**: Ensure your Quarkus application is configured to expose metrics at `/q/metrics`. This typically involves adding the appropriate dependencies and configurations to your Quarkus project.

By following these steps, you'll have a monitoring setup that allows you to visualize and analyze metrics from your Quarkus application using Prometheus and Grafana. 