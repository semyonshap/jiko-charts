{{- define "common.jwksInitContainer" -}}
- name: jwks
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - sh
    - -c
    - |
      set -e
      if [ -f /var/lib/talos/jwks.json ]; then
        echo "JWKS already exists, skipping generation"
        exit 0
      fi
      talos jwk generate eddsa --kid {{ .Values.secretsGeneration.jwks.kid | quote }} --jwks -o /var/lib/talos/jwks.json
      test -s /var/lib/talos/jwks.json
  {{- with .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  volumeMounts:
    - name: data
      mountPath: /var/lib/talos
  {{- end -}}
