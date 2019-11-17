{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "vecosy-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vecosy-server.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vecosy-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "vecosy-server.labels" -}}
app.kubernetes.io/name: {{ include "vecosy-server.name" . }}
helm.sh/chart: {{ include "vecosy-server.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "vecosy-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "vecosy-server.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Vecosy Repo
*/}}
{{- define "vecosy-server.repo" -}}
{{- if eq .Values.repo.type "plain" -}}
url: {{ .Values.repo.url }}
pullEvery: {{ .Values.repo.pullEvery }}
{{- end }}

{{- if eq .Values.repo.type "pubKey" -}}
auth:
  type: pubKey
  keyFile: /config/repo.privKey
  keyFilePassword: {{ .Values.repo.keyFilePassword }}
url: {{ .Values.repo.url }}
pullEvery: {{ .Values.repo.pullEvery }}
{{- end -}}

{{- end -}}


{{/*
Vecosy Repo Files
*/}}
{{- define "vecosy-server.repo-files" -}}

{{- if eq .Values.repo.type "pubKey" -}}
repo.privKey: |
  {{- required "Helm Error: .Values.repo.keyFile is required" .Values.repo.keyFile | nindent 1 -}} 
{{- end }}

{{- end -}}