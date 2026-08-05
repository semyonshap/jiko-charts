{{- define "common.hmac" -}}
{{- $secretName := printf "%s-secrets" (include "common.fullname" .) -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- if and $existing (index $existing.data "hmac") -}}
{{- index $existing.data "hmac" | b64dec -}}
{{- else -}}
{{- randAlphaNum 64 -}}
{{- end -}}
{{- end -}}

{{- define "common.secretsChecksum" -}}
{{- $secrets := dict -}}
{{- if .Values.secretsGeneration.hmac.enabled -}}
{{- $s := lookup "v1" "Secret" .Release.Namespace (printf "%s-secrets" (include "common.fullname" .)) -}}
{{- $_ := set $secrets "hmac" (ternary (toJson $s.data) (randAlphaNum 8) (not (empty $s))) -}}
{{- end -}}
{{- toJson $secrets | sha256sum -}}
{{- end -}}
