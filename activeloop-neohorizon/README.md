# activeloop-helm-charts

## Add Helm repo

```bash
helm repo add activeloop https://charts.activeloop.ai
helm repo update activeloop
```

## Install Helm Chart

```bash
helm upgrade -i -n activeloop neohorizon activeloop/activeloop-neohorizon
```
