{{- define "common.signingSecretName" -}}
{{- printf "%s-signing" (include "common.fullname" .) -}}
{{- end -}}
