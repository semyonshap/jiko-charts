{{- define "nextjs.all" -}}
{{- $defaults := index .Values "nextjs" | default dict -}}
{{- $merged := mergeOverwrite (deepCopy $defaults) .Values -}}
{{- $ctx := merge (dict "Values" $merged) (omit . "Values") -}}
{{ include "nextjs.serviceaccount" $ctx }}
---
{{ include "nextjs.deployment" $ctx }}
---
{{ include "nextjs.service" $ctx }}
{{- if $ctx.Values.autoscaling.enabled }}
---
{{ include "nextjs.hpa" $ctx }}
{{- end }}
---
{{ include "nextjs.test-connection" $ctx }}
{{- end -}}
