{{- define "common.notes" -}}
✔ {{ .Chart.Name }} deployed to {{ .Release.Namespace }}

  Release:    {{ .Release.Name }}
  Version:    {{ .Chart.AppVersion }}
  Namespace:  {{ .Release.Namespace }}

To verify the deployment is running:

  kubectl get pods -n {{ .Release.Namespace }} -l app.kubernetes.io/name={{ include "common.name" . }}
{{- end -}}
