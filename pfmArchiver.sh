#!/bin/bash

###
### FUNCTIONS
###

function path_create_directory() {
	if ! [[ -d ${1} ]]; then
		if ! mkdir -p "${1}"; then
			printf "%s\n" "Failed to create archive directory: ${1}"
			exit 1
		fi
	fi
}

function path_verify() {
	if ! [[ -e ${1} ]]; then
		printf "%s\n" "No such file or directory: ${1}"
		exit 1	
	fi
}

function path_archive() {
	if [[ -z ${1} ]] || [[ ${1} != *.app ]]; then
		printf "%s\n" "Invalid application path passed to function"
		exit 1
	fi

	# Get application name
	local app_name=$( /usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" "${1}/Contents/Info.plist" 2>/dev/null )
	if [[ -z ${app_name} ]]; then
		app_name=$( /usr/libexec/PlistBuddy -c "Print CFBundleName" "${1}/Contents/Info.plist" )	
	fi

	# Get application version
	local app_version=$( /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${1}/Contents/Info.plist" )

	# Get application bundle version
	local app_bundleversion=$( /usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${1}/Contents/Info.plist" )

	# Create archive name and archive path variables
	local app_archivename=$( sed 's/\ //g' <<< "${app_name}_${app_version}-${app_bundleversion}" )
	
	printf "%s" "${path_archive_base}/${app_archivename}"
}

function copy_app() {
	cp "${path_frontEndApp}" "${path_archive_frontEndApp}/packed.js"
	js-beautify --outfile="${path_archive_frontEndApp}/unpacked.js" "${path_archive_frontEndApp}/packed.js"
}

function copy_localization() {
	for path_localization_lproj in "${path_frontEnd}/admin/"*.lproj; do
		lproj=$( basename "${path_localization_lproj}" )
		locale=${lproj%.*}
		path_localization_file="${path_localization_lproj}/app/javascript_localizedStrings.js"
		cp "${path_localization_file}" "${path_archive_frontEndAppLocalization}/${locale}.js"
	done
}

function copy_models() {
	for path_model in "${path_backEndModels}/"*.rb; do
		payload_type=$( awk -F\' '/^ +@@payload_type/ { print $(NF-1) }' ${path_model} )
		if [[ -z ${payload_type} ]]; then
			continue	
		fi
		cp "${path_model}" "${path_archive_backEndModels}/${payload_type}.rb"
	done
}

###
### VARIABLES
###

# Get path to this repository
path_script_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Profile Manager Paths

path_serverApp="/Applications/Server.app"
path_verify "${path_serverApp}"

path_frontEnd="${path_serverApp}/Contents/ServerRoot/usr/share/devicemgr/frontend"
path_verify "${path_frontEnd}"

path_frontEndApp="${path_frontEnd}/admin/common/app/javascript-packed.js"
path_verify "${path_frontEndApp}"

path_frontEndAppLocalization="${path_frontEnd}/admin"
path_verify "${path_frontEndAppLocalization}"

path_backEnd="${path_serverApp}/Contents/ServerRoot/usr/share/devicemgr/backend"
path_verify "${path_backEnd}"

path_backEndModels="${path_backEnd}/app/models"
path_verify "${path_backEndModels}"

# Archive Paths

path_archive_base="${path_script_directory}"
path_verify "${path_archive_base}"

path_archive=$( path_archive "${path_serverApp}" )
if [[ -d ${path_archive} ]]; then
	printf "%s\n" "An archive already exists at: ${path_archive}"
	exit 1
fi
path_create_directory "${path_archive}"

path_archive_frontEndApp="${path_archive}/frontend-app"
path_create_directory "${path_archive_frontEndApp}"

path_archive_frontEndAppLocalization="${path_archive}/frontend-localization"
path_create_directory "${path_archive_frontEndAppLocalization}"

path_archive_backEndModels="${path_archive}/backend-models"
path_create_directory "${path_archive_backEndModels}"

# Copy FrontEnd App
copy_app

# Copy FrontEnd Localization
copy_localization

# Copy BackEnd Models
copy_models