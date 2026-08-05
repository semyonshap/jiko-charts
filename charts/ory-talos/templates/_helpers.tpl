{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name (.Chart.Version | replace "+" "_") -}}
{{- end -}}

{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}

{{ include "common.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end -}}

{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{- default (include "common.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
  {{- .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "common.probe" -}}
httpGet:
  path: {{ .path }}
  port: http
  scheme: HTTP
initialDelaySeconds: {{ .initialDelaySeconds }}
periodSeconds: {{ .periodSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
failureThreshold: {{ .failureThreshold }}
{{- end -}}

{{- define "common.jwksGeneratorName" -}}
{{- printf "%s-jwks-generator" (include "common.fullname" .) -}}
{{- end -}}
