{{- define "common.migrateInitContainer" -}}
- name: migrate
  image: "{{ .Values.migration.image.repository | default .Values.image.repository }}:{{ .Values.migration.image.tag | default .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.migration.command }}
  command:
    {{- toYaml .Values.migration.command | nindent 4 }}
  {{- else }}
  command: ["talos", "migrate", "up"]
  {{- end }}
  {{- with .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  env:
    - name: DB_DSN
      {{- if .Values.migration.dsnSecret.name }}
      valueFrom:
        secretKeyRef:
          name: {{ .Values.migration.dsnSecret.name }}
          key: {{ .Values.migration.dsnSecret.key | default "dsn" }}
      {{- else }}
      value: {{ .Values.config.db.dsn | quote }}
      {{- end }}
  {{- with .Values.migration.extraEnv }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.persistence.enabled }}
  volumeMounts:
    - name: data
      mountPath: /var/lib/talos
  {{- end }}

  {{- end -}}
