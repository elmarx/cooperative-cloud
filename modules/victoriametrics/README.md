## Victoria Metrics

As described in the top-level README, this is a tweaked version of the [https://github.com/VictoriaMetrics/helm-charts/blob/master/charts/victoria-metrics-k8s-stack/values.yaml](Helm chart provided by VictoriaMetrics).  To be specific, the following were changed:

* Ingress was enabled for Grafana
* The `annotations` section of this Ingress's config was set to `cert-manager.io/cluster-issuer: letsencrypt`.
* The `hosts` section was changed to `grafana.kooperative.cloud`.
* The `tls` section was uncommented, the `secretName` set to `grafana.kooperative.cloud` and the `hosts` as above.
* Under grafana.dashboards/default/nodeexporter, the `gnetId` given refers to a dashboard that no longer exists, and gave an error.  I substituted another, but a whole load of dashboards got installed on provisioning anyway, so this was probably wasn't needed.