{{- define "common.hmac" -}}
{{- $secretName := printf "%s-secrets" (include "common.fullname" .) -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- if and $existing (index $existing.data "hmac") -}}
{{- index $existing.data "hmac" | b64dec -}}
{{- else -}}
{{- randAlphaNum 64 -}}
{{- end -}}
{{- end -}}
