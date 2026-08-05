{{- define "common.jwksInitContainers" -}}
- name: generate
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - sh
    - -c
    - |
      set -euo pipefail
      talos jwk generate eddsa --kid {{ .Values.secretsGeneration.jwks.kid | quote }} --jwks -o /shared/jwks.json
      test -s /shared/jwks.json
      printf 'base64://%s' "$(base64 /shared/jwks.json | tr -d '\n')" > /shared/url
  {{- with .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  volumeMounts:
    - name: shared
      mountPath: /shared

- name: apply
  image: "{{ .Values.secretsGeneration.jwks.kubectlImage.repository }}:{{ .Values.secretsGeneration.jwks.kubectlImage.tag }}"
  imagePullPolicy: {{ .Values.secretsGeneration.jwks.kubectlImage.pullPolicy | default .Values.image.pullPolicy }}
  command:
    - sh
    - -c
    - |
      set -euo pipefail
      kubectl create secret generic {{ include "common.signingSecretName" . }} \
        -n {{ .Release.Namespace }} \
        --from-file=url=/shared/url \
        --dry-run=client -o yaml \
      | kubectl apply --server-side --field-manager={{ .Chart.Name }}-jwks -f -
  {{- with .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  env:
    - name: HOME
      value: /shared
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  volumeMounts:
    - name: shared
      mountPath: /shared
{{- end -}}
