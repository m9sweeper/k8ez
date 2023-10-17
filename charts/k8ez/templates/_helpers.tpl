{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart.fullname" -}}
  {{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" | lower -}}
  {{- else -}}
    {{- $name := include "chart.name" . -}}
    {{- if contains $name .Release.Name -}}
      {{- .Release.Name | trunc 63 | trimSuffix "-" | lower -}}
    {{- else -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | lower -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Basic selector labels for the chart
** will also be used for matchExpressions
*/}}
{{- define "chart.basicSelectorLabels" -}}
app: {{ include "chart.fullname" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Basic labels for the chart
*/}}
{{- define "chart.basicLabels" -}}
{{ include "chart.basicSelectorLabels" . }}
chart: {{ include "chart.chart" . }}
heritage: {{ .Release.Service }}
version: {{ .Chart.Version }}
{{- end -}}

{{/*
Builds full image path
IF .image isn't defined,
use $.Values.image
IF .image.registry isn't defined,
use $.Values.image.registry
IF .image.tag isn't defined,
use $.Values.image.tag
IF $.Values.image isn't defined, throw errors
*/}}
{{- define "chart.buildImagePath" -}}
{{- $image_path := default .values.image .image }}
{{- $image_registry := default .values.image.registry $image_path.registry }}
{{- $image_tag := default .values.image.tag $image_path.tag }}
{{- $image_registry }}:{{ $image_tag }}
{{- end }}

{{/*
Generic function to build extra annotations
Will include the global annotations unless specified
Will include the resource-specific annotations
*/}}
{{- define "chart.buildExtraAnnotations" -}}
{{- if and .values.extraAnnotations (ne (.excludeGlobalExtraAnnotations | toString | lower) "true") }}
{{- toYaml .values.extraAnnotations | nindent 0 }}
{{- end }}
{{- if .extraAnnotations }}
{{- toYaml .extraAnnotations  | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Generic function to build volumes
Will include the global volumes unless specified
Will include the resource-specific volumes
*/}}
{{- define "chart.buildVolumes" -}}
{{- if  or .volumes (and .values.volumes (ne (.excludeGlobalVolumes | toString | lower) "true")) }}
volumes:
{{- if and .values.volumes (ne (.excludeGlobalVolumes | toString | lower) "true") }}
{{- toYaml .values.volumes | nindent 2 }}
{{- end }}
{{- if .volumes }}
{{- toYaml .volumes | nindent 2 }}
{{- end }}
{{- end }}
{{- end }}
