# <APP_NAME> README

This is the scaffolding for the <APP_NAME> <APP_TYPE> application. The scaffolding prepares a `Makefile` for preparing the OCI (Open Container Initiative) image, deployment manifests for Kubernetes, and cloud native tooling, and links for relevent libraries to instrument your application.

- [Image Preparation](##build-mage)
- [Kubernetes Manifests](##kubernetes-manifests)
- [App Instrumentation](##app-instrumentation)

## Image Preparation

1. Update the `<YOUR_USERNAME>`, and `<YOUR_IMAGE_REGISTRY>` placeholders in the Makefile.

```sh
DOCKER_USERNAME=omar.patel@redhat.com
IMAGE_REGISTRY=docker.io
```

2. Sign into the image registry.

```sh
docker login 
# or for quay 
docker login -u omar.patel@redhat.com quay.io
```

3. Run make all, which will compile the binary, build the image, and push it to the image registry. (or if in doubt whether or not your app will compile - run `make compile/app`, then `make build/image`, then `make compile/image`)

```sh
make all
```

Note: Version your application in git (tags and releases) and the image registry to ensure feature parody, compatibility, and clear history of changes. This is [a planned feature](https://github.com/cmwylie19/create-ddis-app/issues/2)

## Kubernetes Manifests

The `manifests` parent folder contains `instrumentation` and `k8s` folders. The `k8s` folder contains the base Kubernetes manifests required to deploy a typical application based on criteria used in the scaffolding command. Note - if you application does not come up, check the logs `kubectl logs -f -l app=<APP_NAME> -n <APP_NAME>` and the events `kubectl ev --sort-by='.lastTimestamp -n <APP_NAME>` to shed light. Many times the problem is permission based in OpenShift due to the mutating and validating admission controllers.

1. Deploy into Kubernetes.

```sh
kubectl apply -f manifests/k8s
```

The `instrumentation` folder contains a `ServiceMonitor` for scraping metrics emitted by the application. Please note that Prometheus must be deployed in order for this folder to be useful. To that end, if during the scaffolding command you passed the `telemetry` flag then you should expect to see annotations on your pod template in the Kubernetes manifests.

Example:
```
      annotations:
        sidecar.opentelemetry.io/inject: "true" # CORRECT
```

## App Instrumentation

Critical apps should be instrumented to emit metrics and events for the purpose of debugging and overall visibilities into. processes and requests. Real instrumentation, however, shoudld be measured and calculated based on the expected outcomes.

- [Prometheus Instrumentation](https://prometheus.io/docs/guides/go-application/)
- [Open Telemtry Instrumentation](https://opentelemetry.io/docs/instrumentation/go/)


[top](#<APP_NAME>-readme)